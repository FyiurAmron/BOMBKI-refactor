# BOMBKI refactor

This is a test-backed refactor of the reconstructed original 1999' BOMBKI text
RPG game. The goal is to produce a behaviorally-identical game (including bugs)
while improving code quality enough for it to be viable for regular coding work
(bugfixing, language ports etc.)

It is based on extensive work done as part of collaboration on
https://github.com/rzuf79/bombki , with an explicit approval from the game's
original author, Mateusz Pawluczuk. The test setup is based on extensive work
done in https://github.com/FyiurAmron/BOMBKI-tests (historic reference only now).

tl;dr question:
>(...) uwaga, jest prosba o blogoslawienstwo \[projektu rekonstrukcyjnego\]!(...)

tl;dr answer:
>(...) Blogoslawienstwo (...) dane! (...) Pozdrawiam, Mateusz

## Setup

- Python 3 for the analysis, build, and conformance scripts.
- Optional `pyte` (`python3 -m pip install pyte`) for screen-aware PTY tests
  with `tests/expect_pty.py --pyte`.
- Free Pascal (FPC) for a host-native build and tests.
- For genuine TP7 builds, a Turbo Pascal 7 installation and DOSBox-X. Set
  `TP7_ROOT` to the TP7 directory if it is not in a standard location.
- DOSEMU2 is an optional DOS runtime. The following options disable KVM
  (to run in WSL2) and change the CPU emu to avoid Pascal CRT RE 200:

  ```ini
  $_cpu_vm = "emulated"
  $_cpu_vm_dpmi = "emulated"
  $_cpuemu = (1)
  ```

  Note that `-dumb` doesn't really work for Pascal because CRT writes to video
  memory directly, so no DOS/BIOS terminal access happens. Use `-t` instead.

Generated build products and test transcripts go under the ignored `build/`
directory.

DOSEMU2 is suggested for the runtime for behavior checks; DOSBox-X is best for
running TPC and machine-accuracy-oriented testing.

## Common commands

Build the native Linux executable:

```sh
python3 tools/build_fpc.py --target linux
```

Run the prompt-driven native MODE scenario (after building):

```sh
python3 tests/expect_pty.py build/fpc/BOMBKI-linux-x86_64 \
  tests/scenarios/mode.json \
  --log build/pty-native/mode.jsonl
```

Measure host-native FPC line coverage with Callgrind (all
scenarios; requires `valgrind` and `readelf`):

```sh
python3 tools/coverage_callgrind.py
```

The report lists per-file covered/total lines with uncovered line
numbers, summed over every scenario run and every unit-test
program run; `--fail-under 100` gates a
run on the 100% coverage goal. Coverage builds with DWARF info and
profiles the host-native executable, so it is not DOS behavior
evidence. Pass `--no-unit-tests` to measure the scenario runs
alone.

Run the Pascal unit tests (host-native FPC build):

```sh
python3 tests/run_unit_tests.py
```

The unit tests under `tests/units` are plain Pascal programs
that use the game units from `src/` directly, so they can assert
on unit internals (global state, deterministic procedures)
that the PTY scenarios only observe through the game's
terminal output. The framework `tests/units/pastest.pas` is
plain TP-compatible Pascal, so the same test sources can later
compile with genuine TP7. The runner builds them with FPC
`-Mtp` and executes every test in a fresh process, because
the units keep global state.

Run the TP7 executable in DOSEMU2's terminal frontend without opening a window:

```sh
dosemu -q -t \
  -I '$_cpu_vm = "emulated"' \
  -I '$_cpu_vm_dpmi = "emulated"' \
  -I '$_cpuemu = (1)' \
  -I '$_external_char_set = "utf8"' \
  -I '$_internal_char_set = "cp437"' \
  -K "$PWD/build/tp7" -E BOMBKI.EXE
```

(you might also place the above into your DOSEMU2 settings file of choice).
