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

    b = (SOURCES / "BOMBKI.PAS").read_text().split("\n")

    def scan(lines, lo, hi, proc_rooms=None, want_text=False):
        cur = None
        for n, l in enumerate(lines, 1):
            if not (lo <= n <= hi):
                continue
            m = re.match(r"\s*if MIECHO = (\d+) then begin", l)
            if m:
                cur = int(m.group(1))
                add(cur, None, None)
                continue
            if proc_rooms:
                m = re.match(r"procedure (\w+)", l)
                if m:
                    name = m.group(1)
                    cur = proc_rooms.get(name) if name in proc_rooms else None
                    if cur is not None:
                        add(cur, None, None)
            m = re.match(r"\s*if wpisz = '(\w+)' then MIECHO := (\d+);", l)
            if m and cur is not None:
                add(cur, m.group(1), int(m.group(2)))
            if want_text and cur is not None and cur not in texts \
                    and "WriteLn('" in l:
                mm = re.search(r"WriteLn\('([^']{8,})'\)", l.strip())
                if mm:
                    texts[cur] = mm.group(1)[:38]

    bprocs = {"Pokoj2": 2, "Pokoj3": 3, "Pokoj9": 9, "Pokoj12": 12}
    for r in range(61, 73):
        add(r, None, None)
    # Each range is scanned with its own room context so a
    # procedure that is not a room cannot inherit the previous one.
    scan(b, 1, 1445, bprocs, want_text=True)
    scan(b, 961, 1275, {}, want_text=True)
    scan(b, 1446, len(b), None, want_text=True)

    s = (SOURCES / "SWIAT.PAS").read_text().split("\n")
    room = None
    for l in s:
        m = re.match(r"^procedure (POKOJ\w+)", l)
        if m:
            mm = re.match(r"POKOJ(\d+)$", m.group(1))
            room = int(mm.group(1)) if mm else None
            if room is not None:
                add(room, None, None)
            continue
        m = re.search(r"until MIECHO <> (\d+);", l)
        if m:
            room = int(m.group(1))
            add(room, None, None)
        # POKOJE guards each of its rooms with "if MIECHO = N", and
        # that guard precedes the movements, so the trailing "until"
        # alone would attribute them to the previous room.
        m = re.match(r"\s*if MIECHO = (\d+) then begin", l)
        if m:
            room = int(m.group(1))
            add(room, None, None)
        m = re.match(r"\s*if wpisz = '(\w+)' then MIECHO := (\d+);", l)
        if m and room is not None:
            add(room, m.group(1), int(m.group(2)))
        if room is not None and room not in texts and "WriteLn('" in l:
            mm = re.search(r"WriteLn\('([^']{8,})'\)", l.strip())
            if mm:
                texts[room] = mm.group(1)[:38]
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
    # "if wpisz = ... then MIECHO := N" scan cannot see. The
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
