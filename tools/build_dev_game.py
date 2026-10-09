#!/usr/bin/env python3
"""Build the deterministic-PRNG development game binary.

The game seeds Random from the clock (BOMBKI.PAS calls Randomize at
start-up), so every run draws a different sequence and any scenario
whose outcome depends on a roll is intermittent. This build links
tests/units/randstub.c over the four System PRNG entry points, so
the sequence is reproducible and a scenario can pin the seed it
depends on by passing BOMBKI_SEED through the environment.

Only the development build is affected. The fidelity build, which
tests/dosemu_scenarios.py drives, keeps the original clock seeding.
"""
import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
SOURCES = PROJECT / "src"
STUB = PROJECT / "tests" / "units" / "randstub.c"
DELAY_STUB = PROJECT / "tests" / "units" / "delaystub.c"
DELAY_SYMBOL = "CRT_$$_DELAY$WORD"

# The System PRNG entry points to redirect, matching the symbols FPC
# emits (see nm on a linked build).
RAND_SYMBOLS = (
    "SYSTEM_$$_RANDOMIZE",
    "SYSTEM_$$_RANDOM$LONGINT$$LONGINT",
    "SYSTEM_$$_RANDOM$INT64$$INT64",
    "SYSTEM_$$_RANDOM$$EXTENDED",
)


def build(out_dir: Path, fpc: str) -> Path:
    out_dir.mkdir(parents=True, exist_ok=True)
    cc = shutil.which("cc") or shutil.which("gcc")
    if cc is None:
        raise RuntimeError("no C compiler for the PRNG stub")
    for source in (STUB, DELAY_STUB):
        subprocess.run([cc, "-c", str(source), "-o",
                        str(out_dir / f"{source.stem}.o")], check=True)
    command = [
        fpc, "-B", "-Mtp", "-Tlinux", "-Px86_64", "-g",
        f"-Fu{SOURCES}", f"-Fu{out_dir}",
        f"-FU{out_dir}", f"-FE{out_dir}",
    ]
    command += [f"-k--wrap={symbol}" for symbol in RAND_SYMBOLS]
    command.append(f"-k--wrap={DELAY_SYMBOL}")
    command += [f"-k{out_dir / 'randstub.o'}", f"-k{out_dir / 'delaystub.o'}"]
    command.append(str(SOURCES / "BOMBKI.PAS"))
    print("+", subprocess.list2cmdline(command), file=sys.stderr)
    subprocess.run(command, cwd=out_dir, check=True)
    return out_dir / "BOMBKI"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fpc", default=os.environ.get("FPC", "fpc"))
    parser.add_argument("--out-dir", type=Path,
                        default=PROJECT / "build" / "tmp" / "dev-game")
    args = parser.parse_args()
    binary = build(args.out_dir, args.fpc)
    print(binary)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
