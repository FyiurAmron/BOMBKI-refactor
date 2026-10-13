#!/usr/bin/env python3
"""Normalize the blank lines around top-level declarations in the
Pascal sources under src/.

The rule: exactly one blank line before every top-level procedure
or function definition, and no run of two or more blank lines
anywhere.  Every blank line above a definition is removed first
and then a single one is re-inserted, so a definition never
touches its predecessor and no refactor leftovers survive.

Two cases keep the blank line from landing between a comment and
the declaration it documents:

- A documentation comment sitting directly on top of a definition
  stays attached to it; the single blank line goes above the
  comment block.
- A run of forward declarations is one declaration list: one
  blank line above the run, none between its members.

Compiler directives ({$...}) are not comments, so a blank line
between a directive group and the next definition stays in place.

Usage: normalize_blank_lines.py [file.pas ...]
Default: src/Game.pas src/Rooms.pas src/BOMBKI.pas

The script verifies its own result and refuses to write anything
if a run of blank lines or a definition without its blank line
survives.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
DEFAULT_FILES = ("src/Game.pas", "src/Rooms.pas", "src/BOMBKI.pas")

HEADER = re.compile(r"^(?:procedure|function) \w")
FORWARD = re.compile(r"^(?:procedure|function) \w+; forward;$")


def strip_strings(line: str) -> str:
    """Blank out Pascal string literals so braces in text do not
    confuse the comment scanner."""
    return re.sub(r"'(?:[^']|'')*'", "''", line)


def comment_marks(lines: list[str]) -> list[str]:
    """Per line: 'comment', 'directive', or 'code'."""
    marks = []
    in_comment = False
    for line in lines:
        s = strip_strings(line)
        stripped = s.strip()
        if in_comment:
            marks.append("comment")
            if "}" in s:
                in_comment = False
            continue
        if stripped.startswith("{$"):
            marks.append("directive")
            continue
        if stripped.startswith("{"):
            marks.append("comment")
            if "}" not in s:
                in_comment = True
            continue
        if "{" in s:
            if "}" not in s[s.index("{"):]:
                in_comment = True
        marks.append("code")
    return marks


def collapse(lines: list[str]) -> list[str]:
    """One blank line at most, anywhere."""
    out: list[str] = []
    blank = 0
    for line in lines:
        if line.strip() == "":
            blank += 1
            continue
        if blank:
            out.append("")
            blank = 0
        out.append(line)
    return out


def one_blank_before_definitions(lines: list[str]) -> list[str]:
    """Exactly one blank line above every top-level definition."""
    marks = comment_marks(lines)
    res: list[str] = []
    for i, line in enumerate(lines):
        if i > 0 and HEADER.match(line):
            j = i - 1
            while j >= 0 and lines[j].strip() == "":
                j -= 1
            if j >= 0 and FORWARD.match(lines[j]):
                # a forward-declaration list: no blank between members
                while res and res[-1].strip() == "":
                    res.pop()
                res.append(line)
                continue
            # find the contiguous non-blank block above the definition
            b = j
            while b >= 0 and lines[b].strip() != "":
                b -= 1
            b += 1
            attached = j >= 0 and all(
                marks[k] == "comment" for k in range(b, j + 1))
            block = lines[b:j + 1]
            if attached and block:
                body = res[:len(res) - len(block)]
                while body and body[-1].strip() == "":
                    body.pop()
                res = body + [""] + block
            else:
                while res and res[-1].strip() == "":
                    res.pop()
                res.append("")
            res.append(line)
            continue
        res.append(line)
    return res


def verify(lines: list[str]) -> list[str]:
    """Report any surviving blank-line violation."""
    problems = []
    for k in range(len(lines) - 1):
        if lines[k].strip() == "" and lines[k + 1].strip() == "":
            problems.append("line %d: double blank line" % (k + 1))
    marks = comment_marks(lines)
    for k, line in enumerate(lines):
        if not HEADER.match(line) or k == 0:
            continue
        if FORWARD.match(lines[k - 1]):
            continue  # forward-declaration list member
        top = k
        while top > 0 and lines[top - 1].strip() != "" and \
                marks[top - 1] == "comment":
            top -= 1
        if lines[top - 1].strip() != "":
            problems.append("line %d: no blank line above %r"
                            % (top, line.strip()[:40]))
        elif top >= 2 and lines[top - 2].strip() == "":
            problems.append("line %d: extra blank line above %r"
                            % (top, line.strip()[:40]))
    return problems


def main(argv: list[str]) -> int:
    paths = argv or [PROJECT / name for name in DEFAULT_FILES]
    failed = False
    for path in paths:
        path = Path(path)
        text = path.read_text()
        if not text.endswith("\n"):
            print("FAIL %s: no newline at end of file" % path.name)
            failed = True
            continue
        lines = text.split("\n")
        while lines and lines[-1] == "":
            lines.pop()
        fixed = one_blank_before_definitions(collapse(lines))
        problems = verify(fixed)
        if problems:
            for problem in problems:
                print("FAIL %s: %s" % (path.name, problem))
            failed = True
            continue
        new_text = "\n".join(fixed) + "\n"
        if new_text != text:
            path.write_text(new_text)
            print("normalized %s (%d lines)" % (path.name, len(fixed)))
        else:
            print("clean      %s (%d lines)" % (path.name, len(fixed)))
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
