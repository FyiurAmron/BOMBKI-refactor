#!/usr/bin/env python3
"""Run interactive PTY tests against output or a pyte-rendered screen."""

from __future__ import annotations

import argparse
import errno
import fcntl
import json
import os
import pty
import re
import selectors
import signal
import struct
import subprocess
import termios
import time
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("executable", type=Path,
                        help="host-native executable or terminal-mode emulator")
    parser.add_argument("scenario", type=Path, help="JSON expect/send scenario")
    parser.add_argument("--log", type=Path, required=True,
                        help="JSONL transcript path; records exact input/output bytes")
    parser.add_argument("--timeout", type=float, default=20.0,
                        help="seconds allowed for each expected output (default: 20)")
    parser.add_argument("--pyte", action="store_true",
                        help="match against a pyte-rendered terminal screen")
    parser.add_argument("--cols", type=int, default=80,
                        help="PTY width in --pyte mode (default: 80)")
    parser.add_argument("--rows", type=int, default=25,
                        help="PTY height in --pyte mode (default: 25)")
    args = parser.parse_args()

    screen = stream = None
    if args.pyte:
        if args.cols < 1 or args.rows < 1:
            parser.error("--cols and --rows must be positive")
        try:
            import pyte
        except ImportError:
            parser.error("--pyte requires the optional 'pyte' package")
        screen = pyte.Screen(args.cols, args.rows)
        stream = pyte.Stream(screen)

    executable = args.executable.expanduser().resolve()
    scenario_path = args.scenario.expanduser().resolve()
    log_path = args.log.expanduser().resolve()
    scenario = json.loads(scenario_path.read_text(encoding="utf-8"))
    steps = scenario.get("steps")
    encoding = scenario.get("encoding", "cp437")
    if not isinstance(steps, list) or not steps:
        parser.error("scenario must contain a nonempty 'steps' array")
    if not executable.is_file():
        parser.error(f"executable does not exist: {executable}")

    log_path.parent.mkdir(parents=True, exist_ok=True)
    log = log_path.open("w", encoding="utf-8", newline="\n")
    started = time.monotonic()

    def record(kind: str, **fields: object) -> None:
        event = {"seconds": round(time.monotonic() - started, 6),
                 "event": kind, **fields}
        line = json.dumps(event, ensure_ascii=False)
        log.write(line + "\n")
        log.flush()
        print(line, flush=True)

    master, slave = pty.openpty()
    if args.pyte:
        fcntl.ioctl(slave, termios.TIOCSWINSZ,
                    struct.pack("HHHH", args.rows, args.cols, 0, 0))
    process: subprocess.Popen[bytes] | None = None
    selector = selectors.DefaultSelector()
    pending = ""
    try:
        command = [str(executable), *scenario.get("args", [])]
        # The game writes its save file (pliki.tpu) into the working
        # directory, so default to a per-scenario scratch dir under
        # the ignored build/ directory instead of the caller's cwd.
        working_directory = scenario.get("cwd")
        if working_directory is None:
            project_root = Path(__file__).resolve().parents[1]
            working_directory = (project_root / "build" / "pty-native"
                                 / scenario_path.stem)
            working_directory.mkdir(parents=True, exist_ok=True)
        record("START", command=command, scenario=str(scenario_path),
               cwd=str(working_directory))
        environment = os.environ.copy()
        if args.pyte:
            environment["TERM"] = scenario.get("term", "xterm")
        process = subprocess.Popen(
            command, stdin=slave, stdout=slave, stderr=slave,
            cwd=working_directory, env=environment, start_new_session=True,
        )
        os.close(slave)
        slave = -1
        os.set_blocking(master, False)
        selector.register(master, selectors.EVENT_READ)
        for index, step in enumerate(steps, 1):
            label = step.get("label", f"step {index}")
            if step.get("expect_exit"):
                if "send" in step:
                    raise ValueError(
                        f"step {index} combines expect_exit with send")
                deadline = time.monotonic() + args.timeout
                while True:
                    if process.poll() is not None:
                        record("EXIT", step=index, label=label,
                               returncode=process.returncode)
                        break
                    remaining = deadline - time.monotonic()
                    if remaining <= 0:
                        raise TimeoutError(
                            f"step {index} ({label}) timed out waiting for exit"
                        )
                    ready = selector.select(remaining)
                    if not ready:
                        continue
                    try:
                        raw = os.read(master, 4096)
                    except OSError as error:
                        if error.errno == errno.EIO:
                            raw = b""
                        else:
                            raise
                    if not raw:
                        record("EXIT", step=index, label=label,
                               returncode=process.poll())
                        break
                    record("OUTPUT", step=index, label=label,
                           text=raw.decode(encoding, errors="replace"),
                           raw_hex=raw.hex())
                continue
            pattern_text = step.get("expect")
            if not isinstance(pattern_text, str):
                raise ValueError(f"step {index} is missing its expect regex")
            pattern = re.compile(pattern_text)
            label = step.get("label", f"step {index}")
            deadline = time.monotonic() + args.timeout
            # Do not match prompt text that was already visible before the
            # preceding input. A fresh occurrence may appear elsewhere on the
            # screen even while the old prompt remains in the scroll area.
            stale_matches = {
                (match.start(), match.end(), match.group(0))
                for match in pattern.finditer(pending)
            } if args.pyte else set()
            while True:
                matches = pattern.finditer(pending)
                match = next(
                    (candidate for candidate in matches
                     if (candidate.start(), candidate.end(), candidate.group(0))
                     not in stale_matches),
                    None,
                )
                if match:
                    fields = {"step": index, "label": label,
                              "regex": pattern_text, "matched": match.group(0)}
                    if args.pyte:
                        fields["screen"] = pending
                    record("MATCH", **fields)
                    if args.pyte:
                        stale_matches.add(
                            (match.start(), match.end(), match.group(0))
                        )
                    else:
                        pending = pending[match.end():]
                    break
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    raise TimeoutError(
                        f"step {index} ({label}) timed out waiting for /{pattern_text}/"
                    )
                ready = selector.select(remaining)
                if not ready:
                    if process.poll() is not None:
                        raise RuntimeError(
                            f"child exited with status {process.returncode} while waiting "
                            f"for step {index} ({label})"
                        )
                    continue
                try:
                    raw = os.read(master, 4096)
                except OSError as error:
                    if error.errno == errno.EIO:
                        raw = b""
                    else:
                        raise
                if not raw:
                    raise RuntimeError(
                        f"child closed its PTY while waiting for step {index} ({label})"
                    )
                text = raw.decode(encoding, errors="replace")
                if args.pyte:
                    screen_text = raw.decode(
                        scenario.get("screen_encoding", "utf-8"), errors="replace"
                    )
                    stream.feed(screen_text)
                    pending = "\n".join(screen.display)
                else:
                    pending += text
                record("OUTPUT", step=index, label=label,
                       text=text, raw_hex=raw.hex())

            if "send" in step:
                value = step["send"]
                if not isinstance(value, str):
                    raise ValueError(f"step {index} send value must be a string")
                payload = value.encode("utf-8")
                append_newline = step.get("append_newline", True)
                line_ending = None
                if append_newline:
                    line_ending = scenario.get(
                        "line_ending", "\r" if args.pyte else "\n"
                    )
                    if not isinstance(line_ending, str) or line_ending not in (
                        "\n", "\r", "\r\n"
                    ):
                        raise ValueError("scenario line_ending must be LF, CR, or CRLF")
                    payload += line_ending.encode("ascii")
                record("INPUT", step=index, label=label, text=value,
                       append_newline=append_newline, line_ending=line_ending,
                       raw_hex=payload.hex())
                os.write(master, payload)

        record("SCENARIO_COMPLETE", steps=len(steps))
        return 0
    except (OSError, ValueError, RuntimeError, TimeoutError, re.error) as error:
        fields = {"message": str(error)}
        if args.pyte:
            fields["screen"] = pending
        record("FAIL", **fields)
        return 1
    finally:
        if process is not None:
            if process.poll() is None:
                try:
                    os.killpg(process.pid, signal.SIGTERM)
                    process.wait(timeout=2)
                except subprocess.TimeoutExpired:
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
            record("PROCESS_EXIT", returncode=process.returncode)
            while selector.get_map():
                ready = selector.select(0)
                if not ready:
                    break
                try:
                    raw = os.read(master, 4096)
                except OSError as error:
                    if error.errno == errno.EIO:
                        break
                    raise
                if not raw:
                    break
                text = raw.decode(encoding, errors="replace")
                record("SHUTDOWN_OUTPUT", text=text, raw_hex=raw.hex())
        selector.close()
        if slave >= 0:
            os.close(slave)
        try:
            os.close(master)
        except OSError:
            pass
        log.close()


if __name__ == "__main__":
    raise SystemExit(main())
