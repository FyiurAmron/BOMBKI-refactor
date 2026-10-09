#!/usr/bin/env python3
"""Run the behavior-pinning scenarios against the native dev build.

Each scenario is a pass/fail test: expect_pty.py exits nonzero when
an expect regex times out, and every regex in these scenarios only
matches the original-game behavior. Scenarios run one at a time,
serially, as required by AGENTS.md.
"""

import json
import os
import re
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SCENARIOS = [
    "level-up-deduction",
    "level-zero",
    "shop-item-display",
    "shop-repeat-buy",
]

# The original deducts 725 KUNSZT when leveling 1 -> 2 (reference
# _reference/BOMBKI.PAS: "if POZIOM = 1 then KUNSZT := KUNSZT - 725"),
# while the sheet reports the remaining gap to level 2 (725). With X
# the prompt KUNSZT on the leveling pass and R the reported residue,
# X + R == 2 * 725 holds exactly when the deduction is 725; the
# regression this pins computed 700 instead. Asserting the relation
# (rather than an absolute residue) keeps the check immune to the
# route's own KUNSZT drift.
LEVEL2_DEDUCTION = 725


def check_level_up_deduction(log: Path) -> str | None:
    """Assert the observed 1 -> 2 deduction equals LEVEL2_DEDUCTION."""
    before = residue = None
    for line in log.read_text(encoding="utf-8").splitlines():
        event = json.loads(line)
        if event.get("event") != "MATCH":
            continue
        label = event.get("label", "")
        matched = event.get("matched", "")
        prompt = re.search(r"[0-9]+%\.(-?[0-9]+)>", matched)
        gap = re.search(r"BRAKUJE CI (-?[0-9]+) KUNSZTU", matched)
        if prompt and "UNMODE to force the pass" in label:
            before = int(prompt.group(1))
        if gap and "sheet shows the level-2 line" in label:
            residue = int(gap.group(1))
    if before is None or residue is None:
        return ("transcript lacks the leveling prompt or the "
                "level-2 sheet line")
    observed = before + residue - LEVEL2_DEDUCTION
    if observed != LEVEL2_DEDUCTION:
        return (f"prompt KUNSZT {before} + sheet residue {residue} "
                f"implies a {observed} deduction at level 1, "
                f"expected {LEVEL2_DEDUCTION}")
    return None


CHECKS = {
    "level-up-deduction": check_level_up_deduction,
}


def build_dev_game() -> Path:
    exe = PROJECT_ROOT / "build" / "tmp" / "dev-game" / "BOMBKI"
    if not exe.exists():
        result = subprocess.run(['python3', 'tools/build_dev_game.py'],
                                capture_output=True, text=True,
                                cwd=PROJECT_ROOT)
        if result.returncode != 0:
            print(f"BUILD FAILED: {result.stderr}")
            sys.exit(2)
    return exe


def main() -> int:
    exe = build_dev_game()
    env = os.environ.copy()
    env['BOMBKI_SEED'] = '0x9E3779B97F4A7C15'
    failed = []
    for name in SCENARIOS:
        scenario = PROJECT_ROOT / "tests" / "scenarios" / f"{name}.json"
        if not scenario.exists():
            print(f"FAIL {name}: scenario file not found")
            failed.append(name)
            continue
        log = PROJECT_ROOT / "build" / "pty-native" / f"{name}.jsonl"
        result = subprocess.run(
            ['python3', 'tests/expect_pty.py', str(exe), str(scenario),
             '--log', str(log)],
            capture_output=True, text=True, env=env, cwd=PROJECT_ROOT)
        if result.returncode != 0:
            print(f"FAIL {name}")
            failed.append(name)
            continue
        checker = CHECKS.get(name)
        if checker is not None:
            reason = checker(log)
            if reason is not None:
                print(f"FAIL {name}: {reason}")
                failed.append(name)
                continue
        print(f"PASS {name}")
    if failed:
        print(f"FAILED SCENARIOS: {', '.join(failed)}")
        return 1
    print("ALL SCENARIOS PASS")
    return 0


if __name__ == '__main__':
    sys.exit(main())
