#!/usr/bin/env python3
"""Generate navigation-tour scenarios from the reconstructed sources.

The room graph, each room's identifying intro line, and each
room's movement commands are all derived from the reconstructed
units, so a tour cannot drift from the code. Waypoints are
listed explicitly and the legs between them are shortest paths,
which keeps every generated walk legal: the room graph has dead
ends (the cage corridor at 11 is only escapable through 17 to the
teleport room 18), so a naive depth-first tour would emit moves
the player cannot make.
"""
import json
import re
from collections import deque
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
SOURCES = PROJECT / "src"
OUT = PROJECT / "tests" / "scenarios"
PROMPT = r"[0-9]+%\.-?[0-9]+>"
# Rooms that print no prompt, so no command can be sent there.
NO_PROMPT = {18}


def extract():
    graph, texts = {}, {}

    def add(r, d, t):
        graph.setdefault(r, {})[d] = t

    g = (SOURCES / "Game.PAS").read_text().split("\n")

    # merge wrapped MoveWhen calls onto their opening line so the
    # per-line edge scan sees the whole constructor
    merged, buf = [], None
    for l in g:
        if buf is not None:
            buf = buf.rstrip() + ' ' + l.strip()
            if l.rstrip().endswith(';'):
                merged.append(buf)
                buf = None
        elif re.search(r"MoveWhen(?:OrExit|OrQuit)?\(\[", l) \
                and not l.rstrip().endswith(';'):
            buf = l
        elif re.search(r"BasicRoom(?:Quit)?(?:Simple|Poster|Generic)?\(\w", l) \
                and not l.rstrip().endswith(';'):
            buf = l
        else:
            merged.append(l)
    if buf is not None:
        merged.append(buf)
    g = merged

    # Display texts live in the strings catalog: a room's intro line is
    # either a remaining literal or a catalog identifier reference.
    catalog = {}
    arrays = {}
    rooms = {}
    cat_text = (SOURCES / "texts.inc").read_text()
    for mm in re.finditer(r"^\s*(\w+) = (-?\d+);$",
                          (SOURCES / "rooms.inc").read_text(), re.M):
        rooms[mm.group(1)] = int(mm.group(2))

    def room_num(token):
        if token.isdigit():
            return int(token)
        return rooms.get(token)
    for mm in re.finditer(r"^\s*(\w+) = (.+);$", cat_text, re.M):
        catalog[mm.group(1)] = mm.group(2)
    for mm in re.finditer(
            r"^\s*(\w+): array\[\d+\.\.\d+\] of string = \(([^)]*)\);",
            cat_text, re.M):
        arrays[mm.group(1)] = [a.strip() for a in mm.group(2).split(",")]

    def catalog_word(name):
        value = catalog.get(name, "")
        return value[1:-1] if value.startswith("'") else None

    def strip_quote(value):
        if value.startswith("'") and value.endswith("'"):
            return value[1:-1]
        return None

    def write_text(line):
        mm = re.search(r"WriteLn\('([^']{8,})'\)", line)
        if mm:
            return mm.group(1)
        mm = re.search(r"WriteLines\((\w+)\)", line)
        if mm:
            elements = arrays.get(mm.group(1), [])
            if elements:
                first = strip_quote(catalog.get(elements[0], ""))
                if first is not None and len(first) >= 8:
                    return first
        mm = re.search(r"WriteLn\(([^()]+)\)", line)
        if mm:
            parts = [a.strip() for a in mm.group(1).split(",")]
            if all(a in catalog for a in parts):
                texts_ = [strip_quote(catalog[a]) for a in parts]
                if None not in texts_ and sum(len(t) for t in texts_) >= 8:
                    return "".join(texts_)
        return None

    def slice_between(start_marker, end_marker=None):
        a = next(i for i, l in enumerate(g) if l.strip() == start_marker)
        if end_marker is None:
            return g[a:]
        b = next(i for i, l in enumerate(g) if l.strip() == end_marker)
        return g[a:b]

    # The merged unit no longer carries fold-seam comments, so the
    # two scans are bounded by code lines instead. The former SWIAT
    # unit is the block of plain uppercase-style rooms between
    # Room5 and FightExpForEnergy; scanning it with the until-based
    # state machine keeps the original two-file semantics (the
    # lowercase RoomN rooms' "until Room <> N;" lines would
    # otherwise poison that tracking). Everything else is scanned
    # with the procedure-name state machine.
    bomb = g
    swi = slice_between("procedure Room5;",
                        "function FightExpForEnergy(diff: Integer): Integer;")

    def scan(lines, lo, hi, proc_rooms=None, want_text=False):
        cur = None
        for n, l in enumerate(lines, 1):
            if not (lo <= n <= hi):
                continue
            mm = re.match(r"\s*if Session\.Room = (\w+) then begin", l)
            if mm:
                rid = room_num(mm.group(1))
                if rid is not None:
                    cur = rid
                    add(cur, None, None)
                    continue
            if proc_rooms:
                m = re.match(r"procedure (\w+)", l)
                if m:
                    name = m.group(1)
                    cur = proc_rooms.get(name) if name in proc_rooms else None
                    if cur is not None:
                        add(cur, None, None)
            mm = re.search(r"MoveWhen(?:OrExit|OrQuit)?\(\[([^]]+)\]", l)
            if mm and cur is not None:
                for m3 in re.finditer(r"Go\((\w+), (\w+)\)", mm.group(1)):
                    word = catalog_word(m3.group(1))
                    dest = room_num(m3.group(2))
                    if word and dest is not None:
                        add(cur, word, dest)
            mb = re.search(r"BasicRoom(?:Quit)?(?:Simple|Poster|Generic)?\(\w+, ", l)
            if mb and cur is not None:
                for m3 in re.finditer(r"Go\((\w+), (\w+)\)", l):
                    word = catalog_word(m3.group(1))
                    dest = room_num(m3.group(2))
                    if word and dest is not None:
                        add(cur, word, dest)
                if cur not in texts:
                    rest = l[mb.end():]
                    if rest.startswith("["):
                        intro_text = rest[1:rest.index("]")]
                    else:
                        intro_text = rest.split(",")[0].strip()
                    for el in [a.strip() for a in intro_text.split(",")]:
                        if el in arrays:
                            found = write_text("WriteLines(%s);" % el)
                        else:
                            found = write_text("WriteLn(%s);" % el.replace(" + ", ", "))
                        if found:
                            texts[cur] = found[:38]
                            break
            mt = re.search(r"TranceItemLine\([^,]+, (.*)\);", l)
            if mt and cur is not None and cur not in texts:
                found = write_text("WriteLn(%s);" % mt.group(1).replace(" + ", ", "))
                if found:
                    texts[cur] = found[:38]
            mt2 = re.match(r"\s*\(item: @Bag\.\w+; line: (.+)\),?$", l)
            if mt2 and cur is None and 1000 not in texts:
                found = write_text("WriteLn(%s);" % mt2.group(1).replace(" + ", ", "))
                if found:
                    texts[1000] = found[:38]
            m = re.match(
                r"\s*if Command = (?:'(\w+)'|(Txt\w+|Cmd\w+)) then"
                r" Session\.Room := (\w+);", l)
            if m and cur is not None:
                word = m.group(1) or catalog_word(m.group(2))
                dest = room_num(m.group(3))
                if word and dest is not None:
                    add(cur, word, dest)
            if want_text and cur is not None and cur not in texts:
                found = write_text(l.strip())
                if found:
                    texts[cur] = found[:38]

    proc_rooms = {}
    for l in bomb:
        m = re.match(r"procedure Room(\d+);", l)
        if m:
            proc_rooms["Room%s" % m.group(1)] = int(m.group(1))
    for r in range(61, 73):
        add(r, None, None)
    scan(bomb, 1, len(bomb), proc_rooms, want_text=True)

    s = swi
    room = None
    for l in s:
        m = re.match(r"^procedure (Room\w+)", l)
        if m:
            mm = re.match(r"Room(\d+)$", m.group(1))
            room = int(mm.group(1)) if mm else None
            if room is not None:
                add(room, None, None)
            continue
        m = re.search(r"until Session\.Room <> (\w+);", l)
        if m:
            rid = room_num(m.group(1))
            if rid is not None:
                room = rid
                add(room, None, None)
        # PlainRooms guards each of its rooms with "if Room = N", and
        # that guard precedes the movements, so the trailing "until"
        # alone would attribute them to the previous room.
        m = re.match(r"\s*if Session\.Room = (\w+) then begin", l)
        if m:
            rid = room_num(m.group(1))
            if rid is not None:
                room = rid
                add(room, None, None)
        mm = re.search(r"MoveWhen(?:OrExit|OrQuit)?\(\[([^]]+)\]", l)
        if mm and room is not None:
            for m3 in re.finditer(r"Go\((\w+), (\w+)\)", mm.group(1)):
                word = catalog_word(m3.group(1))
                dest = room_num(m3.group(2))
                if word and dest is not None:
                    add(room, word, dest)
        m = re.match(
            r"\s*if Command = (?:'(\w+)'|(Txt\w+|Cmd\w+)) then"
            r" Session\.Room := (\w+);", l)
        if m and room is not None:
            word = m.group(1) or catalog_word(m.group(2))
            dest = room_num(m.group(3))
            if word and dest is not None:
                add(room, word, dest)
        if room is not None and room not in texts:
            found = write_text(l.strip())
            if found:
                texts[room] = found[:38]
    for rid, d in [(6, "WSCHOD"), (8, "POLNOC"), (7, "POLODNIE"),
                   (10, "GORA")]:
        add(rid, d, 5)
    for r in (6, 7, 8, 10):
        texts[r] = "JESTES W DOSYC CIASNYM POKOJU"
    texts[0] = "TU ZACZYNA SIE GRE"
    # Entering room 18 teleports to room 1 with no command, so the
    # edge carries a pseudo-direction that is never sent.
    graph.setdefault(18, {})["TELEPORT"] = 1
    # Room 86 is only reachable from 85 through a conditional edge
    # ("ZACHOD" and the tree is gone), which the plain
    # "if Command = ... then Room := N" scan cannot see. The
    # caller must chop the tree first, so the edge is added here
    # and the scenario sends ZABIJ DRZWI on arrival at 85.
    graph.setdefault(85, {}).setdefault("ZACHOD", 86)
    return ({k: {d: t for d, t in v.items() if d}
             for k, v in graph.items() if v}, texts)


def path(graph, frm, to):
    """Shortest list of (direction, destination) moves from frm to to."""
    prev, q = {frm: None}, deque([frm])
    while q:
        r = q.popleft()
        if r == to:
            break
        for d, t in sorted(graph.get(r, {}).items()):
            if t not in prev:
                prev[t] = (r, d)
                q.append(t)
    if to not in prev:
        return None
    legs, cur = [], to
    while prev[cur] is not None:
        p, d = prev[cur]
        legs.append((d, cur))
        cur = p
    legs.reverse()
    return legs


def build(graph, texts, waypoints, extra=None, race="POL-ELF",
          prelude=None):
    """Build scenario steps: walk the waypoints, running each exit list."""
    extra = extra or {}
    seq = [(0, None), (1, "POLNOC")]
    cur = 1
    for w in waypoints:
        legs = path(graph, cur, w)
        if legs is None:
            raise RuntimeError(f"no path from {cur} to {w}")
        for d, dest in legs:
            seq.append((dest, d))
        cur = w
    steps = [
        {"label": "intro tick", "expect": "TICK !!!", "send": ""},
        {"label": "race prompt", "expect": "NAPISZ SWA RASE",
         "send": race},
        {"label": "player-name prompt", "expect": "PODAJE SWE IMIE",
         "send": "TESTER"},
        {"label": "startup key read",
         "expect": "ABY SIE PATRZEC UZYJ KOMENDY PATRZ", "send": ""},
    ]
    if prelude:
        steps.extend(prelude(graph, texts))
    done = set()
    for i, (room, _) in enumerate(seq):
        if room in NO_PROMPT:
            continue
        # Shop commands run first, then the exit listing is asked
        # for fresh so the movement step can match it. Asking for
        # the listing before the shop commands would consume it.
        cmds = []
        if room not in done:
            done.add(room)
            cmds = extra.get(room, [])
        first = cmds[0] if cmds else "EXIT"
        steps.append({"label": f"room {room} ({texts.get(room, '?')[:20]})",
                      "expect": f"{texts[room]}[\\s\\S]*?{PROMPT}",
                      "send": first})
        for cmd in cmds[1:]:
            steps.append({"label": f"room {room}: {cmd}",
                          "expect": f"[\\s\\S]*?{PROMPT}", "send": cmd})
        if cmds:
            steps.append({"label": f"room {room} exits",
                          "expect": f"[\\s\\S]*?{PROMPT}", "send": "EXIT"})
        nxt = seq[i + 1] if i + 1 < len(seq) else None
        if nxt and nxt[1] is not None:
            steps.append({"label": f"room {room} exits -> {nxt[0]}",
                          "expect": f"DOSTEPNE WYJSCI[\\s\\S]*?{PROMPT}",
                          "send": nxt[1]})
    return steps


def main():
    graph, texts = extract()
    kill = "ZABIJ POTWOR"
    plans = {
        # Training rooms and the four bare rooms around the school.
        # Room 2 has a poster of its own: the three lines that name
        # the skills to train together. Room 3 shows the full skill
        # list instead.
        "school-tour.json": ([3, 2, 4, 5, 10, 7, 8, 6, 9],
                             {2: ["PATRZ PLAKAT"]}),
        # The cage corridor and its cages. Room 16 runs WALKA on
        # every command, so it is skipped here; the cage fights get
        # their own scenario. The corridor is left through 17 to the
        # teleport room 18, which returns to room 1.
        "cages-tour.json": ([11, 12, 14, 15, 13, 17, 1], {}),
        # City centre and the four shops (23 bakery, 24 armory,
        # 25 general store, 26 magic shop). POL-ELF starts with 30
        # coins, so only the cheapest food is affordable. The
        # armory poster and the general store advert are separate
        # texts from the four price lists.
        "shops-tour.json": ([21, 22, 25, 26, 23, 24],
                            {23: ["LISTA", "KUP PACZEK"],
                             24: ["LISTA", "PATRZ PLAKAT"],
                             25: ["LISTA", "PATRZ POSTER"],
                             26: ["LISTA"]}),
        # The concert hall: the street, the fun-fair valley, the
        # crowd block (rooms 61 to 72) and the arena approach. The
        # entrance poster and the dressing-room notice board are the
        # two texts the block adds to the bare room intros.
        "concert-tour.json": ([30, 31, 32, 60, 61, 62, 63, 64, 65, 66, 67, 68,
                               69, 70, 71, 72],
                              {61: ["PATRZ PLAKAT"], 68: ["PATRZ TABLICZKA"]}),
        # The dark street and the cave behind it. The bar sells a
        # drink list and answers a question about the name, and the
        # well room has a barely legible sign. Room 88 is the
        # twenty-times-bigger POKRZYWA boss: it fights on entry with
        # no way to decline, so it needs its own prepared scenario.
        "dark-street-tour.json": ([75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
                                   85, 87],
                                  {76: ["LISTA", "MAM 18 LAT"],
                                   80: ["PATRZ NAPIS"]}),
        # The quest-master's road, reached from the shopping street.
        "quest-road-tour.json": ([100], {}),
        # The cage fights. OLBRZYM has the highest starting SIL, so
        # the 20- and 40-energy monsters die in a few rounds. Room
        # 16 is left out because the earlier fights drain the
        # player and its fight on entry can then kill them, which
        # would make the tour's outcome depend on the clock-seeded
        # Random; it gets its own scenario with a full-energy
        # player. The corridor is left through 17 to the teleport.
        "cage-fights-tour.json": ([11, 12, 13, 14, 15, 17, 1],
                                  {12: [kill], 13: [kill], 14: [kill],
                                   15: [kill]}, "OLBRZYM"),
        # The arena approach: read its poster, which only exists at
        # room 32, before the crowd block.
        "arena-poster-tour.json": ([32], {32: ["PATRZ PLAKAT"]}),
    }

    for name, plan in plans.items():
        waypoints, extra = plan[0], plan[1]
        race = plan[2] if len(plan) > 2 else "POL-ELF"
        steps = build(graph, texts, waypoints, extra, race)
        (OUT / name).write_text(json.dumps({"steps": steps}, indent=2) + "\n",
                                encoding="utf-8")
        print(f"{name}: {len(steps)} steps (race {race})")


if __name__ == "__main__":
    main()
