#!/usr/bin/env python3
"""Build and run the Pascal unit tests with FPC in TP mode.

The unit tests are plain Pascal programs under tests/units
that use the reconstructed units directly, so they exercise
unit internals that the PTY scenarios can only observe
through the game's terminal output. This script compiles
the framework unit and every test program with FPC -Mtp
(the same mode as the game build), runs each program
host-native, and reports pass/fail.

The test framework accepts a test name as its argument, so
the runner also executes every test in a fresh process: the
units keep global state, and a test must not depend on
whatever an earlier test left behind.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
SOURCES = PROJECT / "src"
UNIT_TESTS = PROJECT / "tests" / "units"
FRAMEWORK = "pastest"
UNIT_NAMES = ("MONSTRA", "PRZEDM", "SWIAT")
BUILD_DIR = PROJECT / "build" / "tmp" / "unit-tests"
DELAYSTUB = UNIT_TESTS / "delaystub.c"
DELAY_SYMBOL = "CRT_$$_DELAY$WORD"

TARGET_FLAGS = {
    "linux": ("-Tlinux", "-Px86_64"),
    "windows": ("-Twin64", "-Px86_64"),
}

SUMMARY = re.compile(r"tests: (\d+), failures: (\d+)")
# A test that prints a prompt with write() (no newline, e.g.
# MINIARENA) leaves the output mid-line, so the framework's
# next "RUN <name>" / "FAIL [...]" line is appended to that
# prompt. Match them anywhere in the line, not only at the
# start, so every test is counted and re-run in isolation.
RUN_LINE = re.compile(r"RUN (\S+)$", re.MULTILINE)
FAIL_LINE = re.compile(r"FAIL \[(\S+)\]", re.MULTILINE)


def resolve_executable(name: str) -> str:
    resolved = shutil.which(name)
    if resolved:
        return resolved
    path = Path(name).expanduser()
    if path.is_file():
        return str(path.resolve())
    raise FileNotFoundError(f"FPC executable not found: {name}")


def host_target() -> str:
    if sys.platform == "win32":
        return "windows"
    if sys.platform.startswith("linux"):
        return "linux"
    raise RuntimeError("run_unit_tests.py supports Linux and Windows hosts")


def compile_source(fpc: str, source: Path, build_dir: Path,
                   target: str,
                   link_args: list[str] | None = None) -> None:
    command = [
        fpc, "-B", "-Mtp", *TARGET_FLAGS[target],
        f"-Fu{SOURCES}", f"-Fu{build_dir}", f"-Fu{UNIT_TESTS}",
        f"-FU{build_dir}", f"-FE{build_dir}",
    ]
    if link_args:
        command.extend(link_args)
    command.append(str(source))
    print("+", subprocess.list2cmdline(command))
    subprocess.run(command, cwd=build_dir, check=True)


def build_delay_stub(build_dir: Path) -> Path:
    """Compile the Delay stub so the link can --wrap crt Delay."""
    cc = shutil.which("cc") or shutil.which("gcc")
    if cc is None:
        raise RuntimeError("no C compiler (cc or gcc) for the Delay stub")
    obj = build_dir / "delaystub.o"
    command = [cc, "-c", str(DELAYSTUB), "-o", str(obj)]
    print("+", subprocess.list2cmdline(command))
    subprocess.run(command, check=True)
    return obj


def build_tests(fpc: str, target: str) -> list[Path]:
    """Compile the framework, the units, and every test program."""
    BUILD_DIR.mkdir(parents=True, exist_ok=True)
    stub = build_delay_stub(BUILD_DIR)
    link_args = [f"-k--wrap={DELAY_SYMBOL}", f"-k{stub}"]
    compile_source(fpc, UNIT_TESTS / f"{FRAMEWORK}.pas", BUILD_DIR, target)
    for name in UNIT_NAMES:
        compile_source(fpc, SOURCES / f"{name}.PAS", BUILD_DIR, target)
    programs = []
    for source in sorted(UNIT_TESTS.glob("test_*.pas")):
        compile_source(fpc, source, BUILD_DIR, target, link_args)
        program = BUILD_DIR / source.stem
        if sys.platform == "win32":
            program = program.with_suffix(".exe")
        if not program.is_file() or not program.stat().st_size:
            raise RuntimeError(f"FPC did not produce a nonempty {program}")
        programs.append(program)
    if not programs:
        raise RuntimeError(f"no test programs found in {UNIT_TESTS}")
    return programs


def run_program(program: Path, argument: str | None,
                timeout: float) -> subprocess.CompletedProcess:
    # The units print raw CP437 bytes (e.g. quest'#162'w),
    # so decode leniently: only the framework's ASCII
    # summary lines are parsed.
    command = [str(program)]
    if argument:
        command.append(argument)
    return subprocess.run(command, cwd=PROJECT, capture_output=True,
                          text=True, errors="replace", timeout=timeout)


def parse_summary(stdout: str) -> tuple[int, int] | None:
    match = SUMMARY.search(stdout)
    if match is None:
        return None
    return int(match.group(1)), int(match.group(2))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fpc", default=os.environ.get("FPC", "fpc"),
                        help="FPC executable (default: FPC env var or fpc)")
    parser.add_argument("--timeout", type=float, default=240.0,
                        help="seconds allowed for each run "
                             "(default: 240; the Delay stub "
                             "makes the WALKA tests run in "
                             "milliseconds)")
    args = parser.parse_args()

    failed = False
    failed_tests: list[str] = []
    try:
        fpc = resolve_executable(args.fpc)
        version = subprocess.check_output(
            [fpc, "-iV"], text=True).strip()
        print(f"FPC: {version}")
        programs = build_tests(fpc, host_target())
        for program in programs:
            completed = run_program(program, None, args.timeout)
            summary = parse_summary(completed.stdout)
            names = [match.group(1) for match in RUN_LINE.finditer(
                completed.stdout)]
            ok = (completed.returncode == 0 and summary is not None
                  and summary[1] == 0)
            failures = summary[1] if summary else "?"
            print(f"{program.name}: {len(names)} tests, "
                  f"{failures} failures{' OK' if ok else ' FAILED'}")
            if not ok:
                failed = True
                # The whole-process run failed: recover the
                # failing test names from the FAIL lines the
                # framework already printed.
                failed_tests.extend(
                    f"{program.name} {name}"
                    for name in FAIL_LINE.findall(
                        completed.stdout))
                print(completed.stdout.strip(), file=sys.stderr)
                if completed.stderr.strip():
                    print(completed.stderr.strip(), file=sys.stderr)
                continue
            # Every test again in a fresh process, for state isolation.
            for name in names:
                isolated = run_program(program, name, args.timeout)
                isolated_summary = parse_summary(isolated.stdout)
                if (isolated.returncode == 0
                        and isolated_summary == (1, 0)):
                    continue
                failed = True
                failed_tests.append(f"{program.name} {name}")
                print(f"  {program.name} {name}: FAILED",
                      file=sys.stderr)
                print(isolated.stdout.strip(), file=sys.stderr)
                if isolated.stderr.strip():
                    print(isolated.stderr.strip(), file=sys.stderr)
        if failed_tests:
            print("failed tests: " + ", ".join(failed_tests),
                  file=sys.stderr)
    except (OSError, RuntimeError, subprocess.CalledProcessError,
            subprocess.TimeoutExpired) as error:
        print(f"run_unit_tests.py: {error}", file=sys.stderr)
        return 1
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
