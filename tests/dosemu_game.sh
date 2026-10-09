#!/bin/sh
# Run the BOMBKI DOS game under DOSEMU2's terminal frontend, so a PTY
# harness (tests/expect_pty.py) can drive it like the host-native
# build. Usage: dosemu_game.sh <game-dir> [exe-name]
#
# The terminal frontend (-t) is required: the Pascal CRT unit writes
# video memory directly, which -dumb cannot relay. Character sets map
# the game's CP437 output to the host terminal's UTF-8.
set -eu
GAME_DIR=$1
EXE=${2:-BOMBKI.EXE}
exec dosemu -q -t \
  -I '$_cpu_vm = "emulated"' \
  -I '$_cpu_vm_dpmi = "emulated"' \
  -I '$_cpuemu = (1)' \
  -I '$_external_char_set = "utf8"' \
  -I '$_internal_char_set = "cp437"' \
  -K "$GAME_DIR" -E "$EXE"
