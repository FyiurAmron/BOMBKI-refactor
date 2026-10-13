#!/usr/bin/env python3
"""Guard the extracted string catalogs against drift.

The union of string literals in the game source and the text catalog
(src/texts.inc) must stay byte-identical to the reference set in
tests/reference_strings.txt. Extraction moves literals between the code
and the catalog; a deliberate restructuring (splitting composed texts
into parts) also shifts the set - both update the reference in the same
commit. What the guard pins is that nothing changes silently.
"""
import sys
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
SOURCES = PROJECT / "src"
REFERENCE = PROJECT / "tests" / "reference_strings.txt"


def tokenize(text):
    """Yield (kind, chunk) with kind in {'code', 'str', 'comment'}.

    Mirrors the extraction tooling: '...' string literals (with ''
    escapes), {..} and (*..*) comments, everything else code.
    """
    out = []
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if c == "'":
            j = i + 1
            while j < n:
                if text[j] == "'":
                    if j + 1 < n and text[j + 1] == "'":
                        j += 2
                        continue
                    break
                j += 1
            out.append(('str', text[i:j + 1]))
            i = j + 1
        elif c == '{':
            j = text.find('}', i + 1)
            if j == -1:
                j = n
            out.append(('comment', text[i:j + 1]))
            i = j + 1
        elif c == '(' and text[i:i + 2] == '(*':
            j = text.find('*)', i + 2)
            if j == -1:
                j = n
            out.append(('comment', text[i:j + 2]))
            i = j + 2
        elif c.isalpha() or c == '_':
            j = i
            while j < n and (text[j].isalnum() or text[j] == '_'):
                j += 1
            out.append(('code', text[i:j]))
            i = j
        else:
            j = i
            while j < n and not (text[j].isalpha() or text[j] == "_"
                                 or text[j] in "'{"):
                if text[j:j + 2] == '(*':
                    break
                j += 1
            out.append(('code', text[i:j]))
            i = j
    return out


def collect():
    strings = set()
    files = [SOURCES / "Game.pas", SOURCES / "Rooms.pas"] \
        + sorted(SOURCES.glob("Texts*.inc"))
    for path in files:
        text = path.read_text(encoding='utf-8', newline='')
        for kind, chunk in tokenize(text):
            if kind == 'str':
                strings.add(chunk)
    return strings, [p.name for p in files]


def main():
    baseline = set(REFERENCE.read_text(encoding='utf-8', newline='').splitlines())
    current, files = collect()
    missing = sorted(baseline - current)
    added = sorted(current - baseline)
    if missing or added:
        print("FAIL strings-match-reference")
        for s in missing:
            print("  missing:", s)
        for s in added:
            print("  added:  ", s)
        return 1
    print("PASS strings-match-reference (%d strings across %s)"
          % (len(current), ', '.join(files)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
