# Contributing to the BOMBKI refactor

Behavior-preserving refactor of the reconstructed 1999 BOMBKI game sources.

## Ground truth and work areas

* `_reference/` - the frozen byte-accurate reconstruction snapshot;
  read-only, never staged (enforced by `.githooks/pre-commit`).
* `src/` - the game sources under refactor; all code changes happen here.

## Functional dir layout
* `tests\` - all things related to running tests
* `tests\scenarios` - test scenarios
* `tools\` - helpers, utils and toolings
* `build\` - ephemeral build directory
* `build\tmp` - project-scoped temp directory
* `docker\` - Dockers for CI and local runs


## Source fidelity and reconstructed names

- Byte-identity with the original binaries is history: `_reference/` is the
  last byte-matched snapshot, kept as provenance. What is preserved in
  `src/` is behavior only; machine-code equivalence is explicitly not a goal.
- Invented identifiers use ordinary Pascal capitalization with Polish names
  (e.g. `WybierzRase`, `PunktKontrolny`, `ZdobadzPoziom`), ALLCAPS is used only
  for names fully available in reference data.

## Commits

One line, conventional prefix (`docs: feat: fix: refactor: ci:` etc.),
no bodies. Concise and short messages.
Work lands on `dev`, one commit per functional change/subject. `main` is
fast-forwarded from `dev` only after maintainer confirmation; `main`
history is rewritten only on explicit demand.

## Text

LF, UTF-8, Polish diacritics preserved.
Files always end with a newline; enforced locally by `.githooks/pre-commit`
(`git config core.hooksPath .githooks`).

## String immutability & behavior preservation

**Strings are fixed.** No user-visible text (WriteLn messages, prompts,
item names, monster descriptions, level names, combat logs, etc.) may be
changed, reworded, reordered, or reformatted. The exact byte sequence of
every string literal in `src/` is part of the behavioral contract.

**Behavior is immutable.** The refactor must produce *identical* observable
behavior for every possible input sequence:
- Terminal output (exact strings, order, formatting, timing-agnostic)
- Game state transitions (room changes, stat modifications, inventory)
- RNG-dependent outcomes (seeded via `BOMBKI_SEED` for reproducibility)
- Save/load round-trips (identical `pliki.tpu` content)

**Save file format preservation.** The binary save file (`pliki.tpu`) format
must remain byte-identical to the reference format stored in
`tests/reference_saves/pliki.tpu.ref`. A dedicated test
`tests/save_format_test.py` validates this by running a save scenario
and comparing the emitted `pliki.tpu` byte-for-byte against the stored
reference. This test must pass on both the refactored native build and,
when available, the original binary via DOSEMU2.

Refactoring is restricted to *internal* structure: control flow,
helper extraction, variable renaming, dead-code removal, constant
folding, and algorithmic simplification that does not alter any
observable result. Any change that causes a scenario or unit test to
diverge is a bug and must be reverted.
