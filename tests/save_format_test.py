#!/usr/bin/env python3
"""Test that save file format matches the reference exactly."""

import subprocess
import tempfile
import json
import os
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
REF_SAVE = PROJECT_ROOT / "tests" / "reference_saves" / "pliki.tpu.ref"

def run_native_save_test():
    """Run the native build and capture the save file."""
    exe = PROJECT_ROOT / "build" / "tmp" / "dev-game" / "BOMBKI"
    if not exe.exists():
        print("Building native dev game...")
        result = subprocess.run(['python3', 'tools/build_dev_game.py'],
                               capture_output=True, text=True, cwd=PROJECT_ROOT)
        if result.returncode != 0:
            print(f"BUILD FAILED: {result.stderr}")
            return None

    # Fixed working dir: the game writes pliki.tpu in its cwd, so pin it
    # to the directory the save is read from; an explicit "cwd" keeps
    # expect_pty.py from deriving one from a random temp-file name.
    work_dir = PROJECT_ROOT / "build" / "pty-native" / "test_save_load"
    work_dir.mkdir(parents=True, exist_ok=True)
    scenario = {
        "cwd": str(work_dir),
        "steps": [
            {"expect": "TICK !!!", "send": ""},
            {"expect": "NAPISZ SWA RASE", "send": "POL-ELF"},
            {"expect": "PODAJE SWE IMIE", "send": "TESTER"},
            {"expect": "ABY SIE PATRZEC UZYJ KOMENDY PATRZ", "send": ""},
            {"expect": "TU ZACZYNA SIE GRE", "send": "POLNOC"},
            {"expect": "JESTES W OKROGLYM SALONIE[\\s\\S]*?[0-9]+%\\.-?[0-9]+>", "send": "MODE"},
            {"expect": "[0-9]+%\\.-?[0-9]+>", "send": "PAMIETAJ"},
            {"expect": "W SUMIE MASZ[\\s\\S]*?TWOJE PARAMETRY : SILA - [0-9]+/[0-9]+[\\s\\S]*?FUKSROLL-[0-9]+[\\s\\S]*?[0-9]+%\\.-?[0-9]+>", "send": "UNMODE"},
            {"expect": "JESTES W OKROGLYM SALONIE[\\s\\S]*?[0-9]+%\\.-?[0-9]+>", "send": "WYJSCIE"}
        ]
    }

    with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as f:
        json.dump(scenario, f)
        scenario_file = f.name

    log_file = str(PROJECT_ROOT / "build" / "pty-native" / "save_format_plain.jsonl")
    env = os.environ.copy()
    env['BOMBKI_SEED'] = '0x9E3779B97F4A7C15'
    result = subprocess.run(
        ['python3', 'tests/expect_pty.py', str(exe), scenario_file, '--log', log_file],
        capture_output=True, text=True, timeout=60, env=env, cwd=PROJECT_ROOT
    )

    if result.returncode != 0:
        print(f"SCENARIO FAILED: {result.stderr}")
        return None

    save_dir = work_dir
    save_path = save_dir / "pliki.tpu"
    if save_path.exists():
        return save_path.read_bytes()
    return None

def main():
    if not REF_SAVE.exists():
        print(f"Reference save file not found: {REF_SAVE}")
        return 1

    ref_content = REF_SAVE.read_bytes()
    print(f"Reference save size: {len(ref_content)} bytes")

    print("Running native build save test...")
    test_content = run_native_save_test()
    if test_content is None:
        print("FAILED: Could not generate save file")
        return 1

    print(f"Test save size: {len(test_content)} bytes")

    if test_content == ref_content:
        print("SUCCESS: Save file matches reference exactly!")
        return 0
    else:
        print("FAILED: Save file differs from reference!")
        print(f"Reference ({len(ref_content)} bytes): {ref_content[:100]}...")
        print(f"Test ({len(test_content)} bytes): {test_content[:100]}...")

        # Show detailed diff
        ref_lines = ref_content.decode('utf-8', errors='replace').split('\n')
        test_lines = test_content.decode('utf-8', errors='replace').split('\n')
        for i, (r, t) in enumerate(zip(ref_lines, test_lines)):
            if r != t:
                print(f"  Line {i}: ref={r} vs test={t}")
        if len(ref_lines) != len(test_lines):
            print(f"Line count mismatch: ref={len(ref_lines)} vs test={len(test_lines)}")
        return 1

if __name__ == '__main__':
    sys.exit(main())
