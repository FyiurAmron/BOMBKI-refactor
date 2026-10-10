# AGENTS.md — AI working notes

ALWAYS ASK IF UNSURE!

`CONTRIBUTING.md` is the project rules — read it in full before starting and
comply. This file is the operational layer for non-human contributors: the
concrete checks and procedures, not a restatement of the rules.

## Project shape

The project refactors the game sources in `src/` for code quality while
preserving behavior *exactly* (bugs included). Byte-identity with the
original binaries is NOT a goal and is checked nowhere; only behavioral
identity is preserved. FPC (TP mode) is the working toolchain. TP7
compatibility is wanted, but it is restored and verified only at the final
stage of the project, gated and fixed if needed then - not during refactor
work.

`_reference/` holds the frozen reconstruction: read-only ground truth,
never staged (`.githooks/pre-commit` enforces it).

## Check tiers

The host-native FPC build is the daily driver: compile, conformance,
unit-test, and scenario checks all run against it, and their results are
enough to keep working. DOSEMU2 runtime checks belong to the final-stage
gate; do not run them during refactor work.

## Language

Always use English for communication. Tolerate input in other languages, but
respond and contribute entirely in English.

In documentation and user-facing text or output, prefer plain ASCII whenever
possible. Never use an em dash; write a regular ASCII hyphen-minus (`-`)
instead, except when reproducing a direct quotation verbatim.

## Task-start sequence

1. Read `README.md` for the project overview and documented build/test commands.
2. Read `CONTRIBUTING.md` in full to learn the project conventions and scope.
3. Establish the working baseline on the `dev` branch (branch and worktree
   status), then identify the files and behavior relevant to the task.
4. Refresh your view of any in-scope document changed during the task before
   relying on its updated contents.

## End-of-task verification

- Run the applicable Pascal conformance/compile checks and `git diff --check`;
  report only checks that actually ran.
- On Linux, prefer running the required compiler and checks directly. Do not
  use Docker or Podman when the needed functionality is available locally.
- For actual behavior tests, prefer a host-native executable when available.
  Drive it through an interactive PTY with expect-style synchronization: wait
  for expected output before sending each response. For example, wait for
  startup `TICK` before sending the race, then wait for the player-name prompt
  before sending the name. This complete sequence is illustrative only, not a
  required scenario; tailor the steps and output markers to the behavior under
  test. Synchronize on expected output rather than using fixed sleeps, blind
  input batches, or repeated polling.
- For DOSBox-X or DOSEMU2 runtime tests, track each process started by the
  session and bound its runtime. Before yielding or finishing, close every such
  instance and verify it has exited. Never leave an emulator running for the
  user or kill unrelated pre-existing instances; orphaned/repeated instances
  can crash WSL.
- Leave game sound enabled when it is useful for runtime diagnosis, but do not
  leave a DOSEMU2 game on its intro screen for long.
- Verify the worktree, then commit on `dev` and push it when the current
  task is complete; `main` moves per Branch workflow only.

## Running tests

- Test runners must explicitly emit the names of the
  failed tests (not only a failure count), so a single
  run shows exactly which tests broke and why.
- Always redirect a test run's full output to a file
  under `build/tmp/` and inspect that file (read or
  grep it) to see the results and failures. Never
  rerun a test suite merely to view its output; rerun
  only to reproduce a failure after changing code.
- **Never run more than one scenario at a time.** One
  scenario per invocation, serially, never a loop and
  never in parallel. Scenarios are interactive PTY
  sessions against a real game process; running several
  at once starves the machine (each one is
  latency-sensitive, so timing-sensitive steps fail
  spuriously) and makes CPU and wall-clock cost
  unpredictable. If several scenarios need checking,
  run them one after another, one command at a time.

## Save format test

`tests/save_format_test.py` validates that the emitted `pliki.tpu` save
file matches the reference format stored in `tests/reference_saves/pliki.tpu.ref`
byte-for-byte. Run it after any change that might affect the save file format:

```sh
python3 tests/save_format_test.py
```

The test runs a save scenario against the native dev build and compares
the emitted `pliki.tpu` byte-for-byte against the stored reference.
The reference file is updated only when a deliberate format change is
approved. The test must pass on the refactored native build; when the
original binary is available via DOSEMU2, the same test should be run
against it to ensure format parity.

## Scenarios

`tests/scenarios/*.json` drives the game through a PTY: each
step waits for an `expect` regex and then sends a command.
Naming carries no meaning beyond that, so keep it plain and
consistent:

- `<area>-tour.json` - a generated room-graph walk produced by
  `tools/gen_tour_scenarios.py`, which derives the route from
  the game sources in `src/`.
- `<what-it-covers>.json` - a targeted scenario, hand-written or
  produced by a generator such as `tools/gen_level_up_scenario.py`.

Do not add a `-smoke` suffix: it used to decorate a handful of
early scenarios, it does not distinguish anything, and it was
dropped from all of them.

## Test execution modes

Two separate ways to execute the tests. They have
different purposes; do not mix them up.

1. **Development runs (the default while working).**
   Fast, approximate execution of the modded FPC-based
   native executable. The native build stubs out `crt.Delay`
   (a link-time `--wrap` plus a no-op stub, as
   `tests/units/delaystub.c` does for the unit tests), so
   gameplay timing is compressed and individual scenarios
   finish in seconds instead of minutes. This is what to
   use while writing or debugging scenarios, and it is the
   only mode in which scenarios may be run repeatedly.
   Faster but not faithful: compressed timing can hide
   real-timing bugs and its timing-dependent branches do
   not always match the original.

   The development build also replaces the PRNG. The game seeds
   Random from the clock, so the executable draws a different
   sequence depending on when it starts; a scenario whose
   outcome depends on a roll then passes on one run and times
   out on the next. `tools/build_dev_game.py` links
   `tests/units/randstub.c` over the four System PRNG entry
   points, which makes the sequence reproducible and lets a
   scenario pin the one it depends on with the `BOMBKI_SEED`
   environment variable (decimal or `0x` hex). The generator
   keeps its state between calls, so draws still differ from
   each other. Reach for this whenever a scenario is flaky for
   reasons that are not a genuine bug in the game.

2. **Final-stage fidelity runs.** 100% machine-accurate
   execution: the genuine TP7 build under DOSEMU2
   (`tests/dosemu_game.sh`, `tests/expect_pty.py --pyte`),
   with the real `Delay` timing. This mode belongs to the
   project final stage, together with the TP7 conformance
   sweep - not to ordinary refactor work.

So: use the fast native mode for refactor iteration; the
DOSEMU2 + genuine-TP7 mode is reserved for the final-stage
gate. Report which mode a result came from.

## Autonomy

Do not stop after completing an intermediate task. Continue autonomously with
the next useful step. Only stop when the entire requested objective is
complete or you genuinely require information that cannot be obtained
independently.

Temporary build and analysis files belong under the project-local
`build/tmp/` directory. Do not use a shared/global `/tmp` location.

`_reference/` must never appear in a staged change (the single squashed
init commit that established it is the only recorded exception).

## Installing software

- On Windows, prefer portable / temp-only solutions (download-and-extract into
  a temp dir, then run from there) over system installs whenever possible.
- On Windows, always ask the human for approval before installing software on
  the machine (e.g. winget/choco installs).

## Branch workflow

- `dev` is the working branch: every commit lands on `dev`; never commit
  directly to `main`.
- Commit per functional change/subject, not per prompt: several commits for
  one complex prompt are expected; one commit bundling unrelated changes
  just because they arrived together is not acceptable.
- `main` advances only by fast-forward from `dev`, and only after explicit
  confirmation from the maintainer. No direct pushes to `main`, no merge
  commits, no squash-merges.
- `dev` history is rewritten freely: amends, squashes, fixups, and rebases
  are all pre-approved on `dev`, pushed or not; force-push with
  `--force-with-lease`. `main` history is rewritten only on the
  maintainer's explicit demand.
- Reviews happen on `dev`: push it and report. The maintainer reviews
  in-session or on GitHub and confirms each fast-forward to `main`.

## Committing

- Subject: one line, one idea, concise, ≤ 60 chars,
  prefix from the CONTRIBUTING list, no body.
- Stage explicit paths only (`git add <files>`), never `git add -A`.
- Pre-commit checks: file is LF-only (no CR bytes), no trailing whitespace,
  `git diff --check` clean.
- Hook: enable `.githooks/pre-commit` with `git config core.hooksPath .githooks`
  — enforces newline at EOF, LF-only, no trailing whitespace, and never staging
  `_reference/`.

## History rewrites

1. `dev`: amend, squash, fixup, and rebase freely; no per-change approval
   needed. `main`: rewritten only on the maintainer's explicit demand.
2. Reword only the intended commits (interactive rebase) or amend the tip.
3. Verify a message-only rewrite: `git diff <old-tip> <new-tip>` is empty.
4. Push rewritten branches with `--force-with-lease`.
