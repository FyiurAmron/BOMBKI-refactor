#!/usr/bin/env python3
"""Measure line coverage of the host-native FPC build with Callgrind.

There is no gcov-equivalent coverage tool for Free Pascal (gcov/lcov
need GCC instrumentation, Delphi coverage tools are Windows/Delphi
only). This script instead builds the reconstructed units with DWARF
debug info, runs every tests/scenarios/*.json scenario under Valgrind
Callgrind through the existing PTY harness, and runs the tests/units
Pascal unit-test programs under Callgrind as well. It maps executed
instruction addresses back to Pascal source lines using the DWARF line
tables read via readelf. Callgrind dumps its profile even when the
harness terminates the still-running game with SIGTERM.

Coverage is reported per source file against all lines that have
generated code. Exit status is nonzero when a scenario or a unit-test
program fails or when total line coverage is below --fail-under (the
project goal is 100%).
"""

from __future__ import annotations

import argparse
import bisect
import os
import re
import shlex
import shutil
import subprocess
import sys
from collections import defaultdict
from pathlib import Path


PROJECT = Path(__file__).resolve().parents[1]
SOURCES = PROJECT / "src"
TESTS = PROJECT / "tests"
SCENARIO_DIR = TESTS / "scenarios"
UNIT_TEST_DIR = TESTS / "units"
UNIT_NAMES = ("MONSTRA", "PRZEDM", "SWIAT")
PROGRAM_NAME = "BOMBKI"
DEBUG_FLAGS = ("-g",)
UNCOVERED_PREVIEW = 40
DELAYSTUB = UNIT_TEST_DIR / "delaystub.c"
DELAY_SYMBOL = "CRT_$$_DELAY$WORD"
RANDSTUB = UNIT_TEST_DIR / "randstub.c"
# The System PRNG entry points, as FPC mangles them (see nm on a
# linked build). Wrapping them makes a run reproducible.
RAND_SYMBOLS = (
    "SYSTEM_$$_RANDOMIZE",
    "SYSTEM_$$_RANDOM$LONGINT$$LONGINT",
    "SYSTEM_$$_RANDOM$INT64$$INT64",
    "SYSTEM_$$_RANDOM$$EXTENDED",
)
SUMMARY = re.compile(r"tests: (\d+), failures: (\d+)")
# Procedures the original binary never calls. They are absent
# from their unit interface, so no test can reach them and they
# would otherwise pin the unit below full coverage. The
# reconstructed sources stay untouched (CONTRIBUTING.md requires
# them to match the original .TPU files), so the exclusion lives
# here instead; their lines are reported separately.
DEAD_PROCEDURES = {"PRZEDM": ("SMIERC",)}


def dead_code_lines(unit: str, names: tuple[str, ...]) -> set[int]:
    """Return the source lines of the named procedures of a unit.

    The body range is found by scanning the reconstructed source
    so the exclusion survives unrelated line shifts."""
    path = SOURCES / f"{unit}.PAS"
    lines = path.read_text(encoding="utf-8").splitlines()
    dead: set[int] = set()
    for name in names:
        start = None
        for number, line in enumerate(lines, start=1):
            if start is None:
                if re.match(rf"^procedure {name}\s*;", line):
                    start = number
            elif line.rstrip() == "end;":
                dead.update(range(start, number + 1))
                start = None
        if start is not None:
            raise RuntimeError(f"unterminated procedure {name} in {path}")
    return dead


def find_executable(name: str) -> str:
    resolved = shutil.which(name)
    if not resolved:
        raise FileNotFoundError(f"{name} not found in PATH")
    return resolved


def build_game(fpc: str, game_dir: Path) -> Path:
    """Build the host-native executable with DWARF line information.

    crt.Delay is wrapped to a no-op for the program link, and the
    System PRNG entry points are wrapped to a seeded generator, the
    same way the unit-test binaries stub Delay. Coverage measures
    which lines execute, not how long they sleep, and the real
    two-second combat delay would add minutes per fight-heavy
    scenario. Seeding matters here too: the game samples the clock,
    so a roll-dependent branch may or may not be taken on a given
    run and the reported coverage would drift. This is the modded
    development build; full-fidelity timing and the original PRNG are
    exercised separately by the DOSEMU2 gate (see AGENTS.md).
    """
    game_dir.mkdir(parents=True, exist_ok=True)
    stub = build_delay_stub(game_dir)
    rand_stub = build_rand_stub(game_dir)
    link_args = [f"-k--wrap={DELAY_SYMBOL}", f"-k{stub}"]
    link_args += [f"-k--wrap={symbol}" for symbol in RAND_SYMBOLS]
    link_args.append(f"-k{rand_stub}")
    for name in (*UNIT_NAMES, PROGRAM_NAME):
        source = SOURCES / f"{name}.PAS"
        command = [
            fpc, "-B", "-Mtp", "-Tlinux", "-Px86_64", *DEBUG_FLAGS,
            f"-Fu{SOURCES}", f"-Fu{game_dir}",
            f"-FU{game_dir}", f"-FE{game_dir}",
        ]
        if name == PROGRAM_NAME:
            command.extend(link_args)
        command.append(str(source))
        print("+", subprocess.list2cmdline(command))
        subprocess.run(command, cwd=game_dir, check=True)
    binary = game_dir / PROGRAM_NAME
    if not binary.is_file() or not binary.stat().st_size:
        raise RuntimeError(f"FPC did not produce a nonempty {binary}")
    return binary


def write_wrapper(wrapper: Path, binary: Path) -> None:
    """Write the valgrind launcher used as the harness executable."""
    wrapper.write_text(
        "#!/bin/sh\n"
        "exec valgrind --tool=callgrind --dump-instr=yes "
        f'--callgrind-out-file="$CG_OUT_FILE" {shlex.quote(str(binary))} "$@"\n',
        encoding="utf-8",
    )
    wrapper.chmod(0o755)


def run_scenarios(wrapper: Path, out_dir: Path, timeout: float,
                  scenario_paths: list[Path]) -> list[dict]:
    """Run every scenario under Callgrind; return per-scenario results."""
    results = []
    for scenario in scenario_paths:
        scenario = scenario.expanduser().resolve()
        run_dir = out_dir / "runs" / scenario.stem
        run_dir.mkdir(parents=True, exist_ok=True)
        profile = run_dir / "callgrind.out"
        log = run_dir / "transcript.jsonl"
        environment = os.environ.copy()
        environment["CG_OUT_FILE"] = str(profile)
        command = [
            sys.executable, str(TESTS / "expect_pty.py"),
            str(wrapper), str(scenario),
            "--log", str(log), "--timeout", str(timeout),
        ]
        print("+", subprocess.list2cmdline(command))
        completed = subprocess.run(command, cwd=run_dir, env=environment,
                                   capture_output=True, text=True)
        passed = (completed.returncode == 0 and profile.is_file()
                  and profile.stat().st_size > 0)
        results.append({"scenario": scenario.name, "passed": passed,
                        "profile": profile})
        if not passed:
            print(f"! scenario {scenario.name} failed "
                  f"(exit {completed.returncode})", file=sys.stderr)
            if completed.stderr.strip():
                print(completed.stderr.strip(), file=sys.stderr)
    return results


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


def build_rand_stub(build_dir: Path) -> Path:
    """Compile the seeded-PRNG stub so the link can --wrap Random."""
    cc = shutil.which("cc") or shutil.which("gcc")
    if cc is None:
        raise RuntimeError("no C compiler (cc or gcc) for the PRNG stub")
    obj = build_dir / "randstub.o"
    command = [cc, "-c", str(RANDSTUB), "-o", str(obj)]
    print("+", subprocess.list2cmdline(command))
    subprocess.run(command, check=True)
    return obj


def build_unit_tests(fpc: str, build_dir: Path) -> list[Path]:
    """Compile the framework and every tests/units program with -g."""
    build_dir.mkdir(parents=True, exist_ok=True)
    stub = build_delay_stub(build_dir)
    link_args = [f"-k--wrap={DELAY_SYMBOL}", f"-k{stub}"]
    unit_sources = [UNIT_TEST_DIR / "pastest.pas"]
    unit_sources.extend(SOURCES / f"{name}.PAS" for name in UNIT_NAMES)
    for source in unit_sources:
        command = [
            fpc, "-B", "-Mtp", "-Tlinux", "-Px86_64", *DEBUG_FLAGS,
            f"-Fu{SOURCES}", f"-Fu{build_dir}", f"-Fu{UNIT_TEST_DIR}",
            f"-FU{build_dir}", f"-FE{build_dir}", str(source),
        ]
        print("+", subprocess.list2cmdline(command))
        subprocess.run(command, cwd=build_dir, check=True)
    for source in sorted(UNIT_TEST_DIR.glob("test_*.pas")):
        command = [
            fpc, "-B", "-Mtp", "-Tlinux", "-Px86_64", *DEBUG_FLAGS,
            f"-Fu{SOURCES}", f"-Fu{build_dir}", f"-Fu{UNIT_TEST_DIR}",
            f"-FU{build_dir}", f"-FE{build_dir}", *link_args, str(source),
        ]
        print("+", subprocess.list2cmdline(command))
        subprocess.run(command, cwd=build_dir, check=True)
    binaries = []
    for source in sorted(UNIT_TEST_DIR.glob("test_*.pas")):
        binary = build_dir / source.stem
        if not binary.is_file() or not binary.stat().st_size:
            raise RuntimeError(f"FPC did not produce a nonempty {binary}")
        binaries.append(binary)
    if not binaries:
        raise RuntimeError(f"no test programs found in {UNIT_TEST_DIR}")
    return binaries


def run_unit_programs(binaries: list[Path], out_dir: Path,
                      timeout: float) -> list[dict]:
    """Run every unit-test program under Callgrind; return results."""
    results = []
    for binary in binaries:
        run_dir = out_dir / "runs" / "unit-tests" / binary.name
        run_dir.mkdir(parents=True, exist_ok=True)
        profile = run_dir / "callgrind.out"
        wrapper = run_dir / "run-valgrind.sh"
        write_wrapper(wrapper, binary)
        environment = os.environ.copy()
        environment["CG_OUT_FILE"] = str(profile)
        command = [str(wrapper)]
        print("+", subprocess.list2cmdline(command))
        completed = subprocess.run(command, cwd=PROJECT, env=environment,
                                   capture_output=True, text=True,
                                   errors="replace", timeout=timeout)
        summary = SUMMARY.search(completed.stdout)
        passed = (completed.returncode == 0 and summary is not None
                  and int(summary.group(2)) == 0
                  and profile.is_file() and profile.stat().st_size > 0)
        results.append({"program": binary.name, "passed": passed,
                        "profile": profile, "line_map": LineMap(binary)})
        if not passed:
            print(f"! unit tests {binary.name} failed "
                  f"(exit {completed.returncode})", file=sys.stderr)
            if completed.stdout.strip():
                print(completed.stdout.strip(), file=sys.stderr)
            if completed.stderr.strip():
                print(completed.stderr.strip(), file=sys.stderr)
    return results


def map_profile(profile: Path, line_map: LineMap,
                target_sources: set[Path],
                covered: dict[tuple[Path, int], int]
                ) -> tuple[int, int]:
    """Add a dump's covered lines to the totals; return stats."""
    mapped = 0
    mismatches = 0
    for address, profile_line, cost in parse_callgrind(profile):
        found = line_map.lookup(address)
        if found is None:
            continue  # runtime library code without debug info
        path, table_line = found
        if path not in target_sources:
            continue
        mapped += 1
        if profile_line != table_line:
            mismatches += 1
        covered[(path, table_line)] += cost
    return mapped, mismatches


class LineMap:
    """Address-to-source mapping built from the binary's DWARF data."""

    def __init__(self, binary: Path):
        self.ranges: list[tuple[int, int, list[int], list[int], Path]] = []
        line_tables = self._line_tables(binary)
        for unit in self._compilation_units(binary):
            rows = line_tables.get(unit["path"].name)
            if not rows:
                continue
            rows.sort()
            self.ranges.append((unit["low_pc"], unit["high_pc"],
                                [row[0] for row in rows],
                                [row[1] for row in rows], unit["path"]))

    @staticmethod
    def _compilation_units(binary: Path) -> list[dict]:
        """Compile-unit name and code range per DWARF .debug_info CU."""
        output = subprocess.run(
            ["readelf", "--debug-dump=info", str(binary)],
            capture_output=True, text=True, check=True,
        ).stdout
        units: list[dict] = []
        current: dict | None = None
        in_unit = False
        for line in output.splitlines():
            if line.strip().startswith("Compilation Unit @ offset"):
                if current and "DW_AT_name" in current:
                    units.append(current)
                current = {}
                in_unit = False
            elif current is not None:
                if "DW_TAG_compile_unit" in line:
                    in_unit = True
                elif in_unit and "Abbrev Number" in line:
                    in_unit = False
                elif in_unit:
                    attribute = re.match(
                        r"\s*<[^>]+>\s+(DW_AT_\w+)\s*:\s*(.*?)\s*$", line)
                    if attribute:
                        current[attribute.group(1)] = attribute.group(2)
        if current and "DW_AT_name" in current:
            units.append(current)
        result = []
        for unit in units:
            name = unit.get("DW_AT_name", "")
            comp_dir = unit.get("DW_AT_comp_dir", "")
            low_pc = int(unit.get("DW_AT_low_pc", "0"), 16)
            high_pc = int(unit.get("DW_AT_high_pc", "0"), 16)
            if high_pc < low_pc:  # DWARF offset form: size, not address
                high_pc += low_pc
            path = Path(name)
            if not path.is_absolute() and comp_dir:
                path = Path(comp_dir) / path
            result.append({"path": path.resolve(), "low_pc": low_pc,
                           "high_pc": high_pc})
        return result

    @staticmethod
    def _line_tables(binary: Path) -> dict[str, list[tuple[int, int]]]:
        """(address, line) rows per compile-unit basename, per .debug_line."""
        output = subprocess.run(
            ["readelf", "--debug-dump=decodedline", str(binary)],
            capture_output=True, text=True, check=True,
        ).stdout
        tables: dict[str, list[tuple[int, int]]] = {}
        current: str | None = None
        for line in output.splitlines():
            stripped = line.strip()
            # readelf labels the CU section "CU: name:" for single-CU
            # dumps but prints the bare file name with multiple CUs.
            header = re.match(r"^CU: (.+):$", stripped)
            if header is None:
                header = re.match(r"^(\S+\.\S+):$", stripped)
            if header:
                current = Path(header.group(1)).name
                tables.setdefault(current, [])
                continue
            if current is None:
                continue
            row = re.match(r"^(\S+)\s+(\d+)\s+(0x[0-9a-fA-F]+)", line)
            if row:
                tables[current].append(
                    (int(row.group(3), 16), int(row.group(2))))
        return tables

    def lookup(self, address: int) -> tuple[Path, int] | None:
        """Source file and line containing address, or None."""
        for low_pc, high_pc, addresses, lines, path in self.ranges:
            if not low_pc <= address < high_pc:
                continue
            index = bisect.bisect_right(addresses, address) - 1
            if index < 0:
                return None
            return path, lines[index]
        return None


def _subposition(token: str, current: int) -> int:
    if token == "*":
        return current
    if token.startswith("+"):
        return current + int(token[1:], 0)
    if token.startswith("-"):
        return current - int(token[1:], 0)
    return int(token, 0)


def parse_callgrind(path: Path):
    """Yield (address, line, cost) for every cost line of a dump."""
    current_address = 0
    current_line = 0
    with path.open("r", encoding="utf-8", errors="replace") as handle:
        for raw in handle:
            line = raw.strip()
            if not line or line.startswith("#"):
                continue
            if line.startswith(("fl=", "fi=", "fe=", "fn=", "cfi=", "cfl=",
                                "cfn=", "cob=", "ob=", "calls=", "jump=",
                                "jcnd=")):
                continue
            if re.match(r"^[A-Za-z_][A-Za-z0-9_]*:", line):
                continue  # header, desc, summary, or totals line
            tokens = line.split()
            if len(tokens) < 2:
                continue
            current_address = _subposition(tokens[0], current_address)
            current_line = _subposition(tokens[1], current_line)
            cost = int(tokens[2]) if len(tokens) > 2 else 0
            if cost > 0:
                yield current_address, current_line, cost


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Callgrind-based line coverage for the FPC build")
    parser.add_argument("--fpc", default=os.environ.get("FPC", "fpc"),
                        help="FPC executable (default: FPC env var or fpc)")
    parser.add_argument("--scenarios", nargs="+", type=Path,
                        help="scenario files (default: tests/scenarios/*.json)")
    parser.add_argument("--timeout", type=float, default=240.0,
                        help="seconds allowed for each expected output "
                             "(default: 240)")
    parser.add_argument("--fail-under", type=float, default=0.0,
                        help="required total line coverage in percent "
                             "(default: 0, report only; the goal is 100)")
    parser.add_argument("--no-unit-tests", action="store_true",
                        help="measure coverage from the scenarios only")
    parser.add_argument("--dump-uncovered", type=Path,
                        help="write the full uncovered line list "
                             "per source file to this path")
    args = parser.parse_args()

    try:
        for tool in ("valgrind", "readelf"):
            find_executable(tool)
        fpc = find_executable(args.fpc)
        out_dir = PROJECT / "build" / "coverage"
        out_dir.mkdir(parents=True, exist_ok=True)
        binary = build_game(fpc, PROJECT / "build" / "tmp" / "coverage-game")
        unit_results: list[dict] = []
        if not args.no_unit_tests:
            unit_binaries = build_unit_tests(
                fpc, PROJECT / "build" / "tmp" / "coverage-units")
            unit_results = run_unit_programs(
                unit_binaries, out_dir, args.timeout)
        wrapper = out_dir / "run-valgrind.sh"
        write_wrapper(wrapper, binary)
        scenario_paths = args.scenarios or sorted(SCENARIO_DIR.glob("*.json"))
        if not scenario_paths:
            parser.error("no scenario files found")
        results = run_scenarios(wrapper, out_dir, args.timeout, scenario_paths)

        line_maps = [LineMap(binary)]
        line_maps.extend(result["line_map"] for result in unit_results)
        target_sources = {
            (SOURCES / f"{name}.PAS").resolve()
            for name in (*UNIT_NAMES, PROGRAM_NAME)
        }
        totals: dict[Path, set[int]] = defaultdict(set)
        for line_map in line_maps:
            for _, _, _, lines, path in line_map.ranges:
                if path in target_sources:
                    totals[path].update(lines)

        covered: dict[tuple[Path, int], int] = defaultdict(int)
        mismatches = 0
        mapped = 0
        for result in results:
            if not result["profile"].is_file():
                continue  # failed run without a Callgrind dump
            result_mapped, result_mismatches = map_profile(
                result["profile"], line_maps[0], target_sources, covered)
            mapped += result_mapped
            mismatches += result_mismatches
        for result in unit_results:
            if not result["profile"].is_file():
                continue  # failed run without a Callgrind dump
            result_mapped, result_mismatches = map_profile(
                result["profile"], result["line_map"],
                target_sources, covered)
            mapped += result_mapped
            mismatches += result_mismatches

        covered_by_file: dict[Path, set[int]] = defaultdict(set)
        for (path, line) in covered:
            covered_by_file[path].add(line)

        dead_by_file: dict[Path, set[int]] = {}
        for unit, names in DEAD_PROCEDURES.items():
            path = (SOURCES / f"{unit}.PAS").resolve()
            if path in target_sources:
                dead_by_file[path] = dead_code_lines(unit, names)

        runs = f"{len(results)} scenario runs"
        if unit_results:
            runs += f" and {len(unit_results)} unit-test programs"
        print()
        print(f"Coverage from {runs} "
              f"({mapped} executed source positions)")
        if mismatches:
            print(f"WARNING: {mismatches} line mismatches between the "
                  "Callgrind profile and the DWARF line tables")
        overall_covered = 0
        overall_total = 0
        for path in sorted(target_sources):
            dead_lines = dead_by_file.get(path, set())
            # Dead code is left out of the denominator: it cannot
            # run, so it is not part of the reachable surface.
            all_lines = totals.get(path, set()) - dead_lines
            covered_lines = covered_by_file.get(path, set()) & all_lines
            percent = (100.0 * len(covered_lines) / len(all_lines)
                       if all_lines else 100.0)
            overall_covered += len(covered_lines)
            overall_total += len(all_lines)
            print(f"  {path.name:12} {len(covered_lines):5}"
                  f"/{len(all_lines):<5} {percent:6.2f}%")
            if dead_lines:
                names = DEAD_PROCEDURES[path.stem]
                listed = ", ".join(names)
                print(f"    excluding {len(dead_lines)} unreachable lines "
                      f"of the never-called {listed}")
            uncovered = sorted(all_lines - covered_lines)
            if uncovered:
                preview = ", ".join(str(line) for line
                                    in uncovered[:UNCOVERED_PREVIEW])
                more = "" if len(uncovered) <= UNCOVERED_PREVIEW else ", ..."
                print(f"    uncovered lines: {preview}{more}")
        overall = (100.0 * overall_covered / overall_total
                   if overall_total else 100.0)
        print(f"  {'TOTAL':12} {overall_covered:5}"
              f"/{overall_total:<5} {overall:6.2f}%")

        if args.dump_uncovered is not None:
            with open(args.dump_uncovered, "w",
                      encoding="utf-8") as dump:
                for path in sorted(target_sources):
                    dead_lines = dead_by_file.get(path, set())
                    all_lines = totals.get(path, set()) - dead_lines
                    covered_lines = covered_by_file.get(path,
                                                      set()) & all_lines
                    dump.write(f"{path.name}\n")
                    dump.write(", ".join(
                        str(line) for line
                        in sorted(all_lines - covered_lines)))
                    dump.write("\n")

        failed = [result for result in results if not result["passed"]]
        if failed:
            names = ", ".join(result["scenario"] for result in failed)
            print(f"failed scenarios: {names}", file=sys.stderr)
        failed_units = [result for result in unit_results
                        if not result["passed"]]
        if failed_units:
            names = ", ".join(result["program"] for result in failed_units)
            print(f"failed unit-test programs: {names}", file=sys.stderr)
        if overall < args.fail_under:
            print(f"line coverage {overall:.2f}% is below the required "
                  f"{args.fail_under:.2f}%", file=sys.stderr)
        return 1 if failed or failed_units or overall < args.fail_under else 0
    except (OSError, RuntimeError, subprocess.CalledProcessError,
            subprocess.TimeoutExpired) as error:
        print(f"coverage_callgrind.py: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
