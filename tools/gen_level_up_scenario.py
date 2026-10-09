#!/usr/bin/env python3
"""Generate the level-up scenario for BOMBKI.PAS's ZdobadzPoziom.

ZdobadzPoziom runs once per main-loop pass, at the top of the
repeat block, before the room handlers. A room handler loops on
ReadLn until MIECHO changes, so commands typed inside one room
never start a new pass. MODE then UNMODE is enough to force
exactly one more pass without leaving the room: MODE sets
MIECHO2 to the current room and MIECHO to 1000, which ends the
room's loop and drops into the ground block; UNMODE restores
MIECHO from MIECHO2, so the ground block ends, the loop
restarts, ZdobadzPoziom runs, and the room dispatches again.

DAWAJ KUNSZT lives only in room 86, which sits behind the
DRZWI, so the prefix has to cross that door once. It escapes
rather than fights them: WALKA waits two seconds per round, so
winning costs about eighty rounds while fleeing costs a
handful. UFOK is used because CWICZ UCIEKAC needs MAD > 10 and
ZRE > 10, and UFOK reaches both cheaply; ZWIEJ sets WIMP, which
the flee check needs (ENERGIA < WIMP) and which defaults to
zero.

The thresholds are read from the reconstructed source rather
than hard-coded, so the route always matches the code.
"""
import json
import re
from pathlib import Path

PROJECT = Path(__file__).resolve().parents[1]
OUT = PROJECT / "tests" / "scenarios"
PROMPT = r"[0-9]+%\.-?[0-9]+>"

DOOR = "DO DOBRA WYGLADA TO NA JAKIS DOM"
DARK = "DOBRA JESTES W SRODKU BRAK OSWIETLENIA"
BANNER = "ZDOBYLES LEVEL"
TWELFTH = "HURRRA TO JUZ DWUNASTY POZIOM"


def thresholds() -> dict[int, int]:
    """KUNSZT needed to advance from each level, read from source.

    These come from the level threshold constants in BOMBKI.PAS,
    not from the KUNSZT subtraction in the body: the two differ
    (level one gates at 700 but subtracts 725).
    """
    src = (PROJECT / "src" / "BOMBKI.PAS").read_text()

    def const(name: str) -> int:
        found = re.search(rf"^\s*{name} = (\d+);", src, re.M)
        if found is None:
            raise RuntimeError(f"constant {name} not found in BOMBKI.PAS")
        return int(found.group(1))

    gate_one = const("Lvl1_Threshold")
    gate_two = const("Lvl2_Threshold")
    gate_three = const("Lvl3_Threshold")
    base = const("Lvl4_Base")
    base_high = const("Lvl9_Base")

    def need(level: int) -> int:
        if level == 1:
            return gate_one
        if level == 2:
            return gate_two
        if level == 3:
            return gate_three
        if level < 9:
            return base + level
        return base_high + level + level
    return {n: need(n) for n in range(1, 30)}


def route_graph() -> tuple[dict, dict]:
    """The room graph and per-room intro text, from the sources.

    Reused from gen_tour_scenarios so the cave route here cannot
    drift from the code or from the other generated tours.
    """
    from gen_tour_scenarios import extract
    return extract()


def prefix(race: str, escape: bool = False) -> list[dict]:
    """Steps from a fresh game to the old man's room, granting KUNSZT.

    With escape, the route trains the flee skill (UFOK reaches
    MAD > 10 and ZRE > 10 cheaply) and runs from the DRZWI,
    which costs a handful of rounds. Otherwise the DRZWI is
    fought through: slower, but no dice roll in it, so the
    scenario does not go flaky.
    """
    flee = escape
    graph, texts = route_graph()
    # A fleeing character needs ZWIEJ > 0 before the ZWIEJ command
    # will prompt for WIMP. CWICZ UCIEKAC needs MAD > 10 and
    # ZRE > 10, so UFOK trains ZRE once past that gate first.
    train: list[dict] = []
    if flee:
        train = [
            {"label": "in the salon, head for the strength room",
             "expect": f"{texts[1]}[\\s\\S]*?{PROMPT}", "send": "WSCHOD"},
            {"label": "strength room",
             "expect": f"{texts[2]}[\\s\\S]*?{PROMPT}", "send": "TRENUJ ZRECZNOSC"},
            {"label": "train agility to 10",
             "expect": f"TRENUJESZ ZRECZNOSC I MASZ 10 ZRECZNOSCI[\\s\\S]*?{PROMPT}",
             "send": "TRENUJ ZRECZNOSC"},
            {"label": "train agility to 11, past the ZRE > 10 gate",
             "expect": f"TRENUJESZ ZRECZNOSC I MASZ 11 ZRECZNOSCI[\\s\\S]*?{PROMPT}",
             "send": "ZACHOD"},
            {"label": "back to the salon",
             "expect": f"JESTES W OKROGLYM SALONIE[\\s\\S]*?{PROMPT}", "send": "DOL"},
            {"label": "meditation room",
             "expect": f"ZSZEDLES NA DOL GDZIE TRENUJE[\\s\\S]*?{PROMPT}",
             "send": "CWICZ UCIEKAC"},
            {"label": "learn fleeing",
             "expect": f"CWICZYSZ UCIEKANIE[\\s\\S]*?{PROMPT}", "send": "GORA"},
            {"label": "back at the salon",
             "expect": f"JESTES W OKROGLYM SALONIE[\\s\\S]*?{PROMPT}",
             "send": "POLNOC"},
        ]
    steps: list[dict] = [
        {"label": "intro tick", "expect": "TICK !!!", "send": ""},
        {"label": "race prompt", "expect": "NAPISZ SWA RASE", "send": race},
        {"label": "player-name prompt", "expect": "PODAJE SWE IMIE",
         "send": "TESTER"},
        {"label": "startup key read",
         "expect": "ABY SIE PATRZEC UZYJ KOMENDY PATRZ", "send": ""},
        {"label": "first room", "expect": f"TU ZACZYNA SIE GRE[\\s\\S]*?{PROMPT}",
         "send": "POLNOC"},
    ]
    steps += train
    # The training detour ends in the salon; the non-flee route is
    # already there. Both continue along the same cave route, which
    # is taken from the room graph rather than written out by hand:
    # salon -> city centre -> dark street -> bluszcz -> flowers ->
    # clearing -> cave -> living door.
    # The harness matches a step's expect against the output the
    # previous step's send produced, so a step's expect names the
    # room the player is standing in and its send is the movement
    # that leaves that room. Walking the graph from the salon,
    # assert each room and send the way onward.
    # Training ends by sending POLNOC, so a fleeing character is
    # already in the city centre; the others are still in the
    # salon. Start the cave route from wherever we stand.
    here = 20 if flee else 1
    onward = tuple(r for r in (20, 75, 77, 80, 83, 84) if r != here)
    for room in onward:
        direction = next(d for d, dest in graph[here].items() if dest == room)
        steps.append({"label": f"in room {here}",
                      "expect": f"{texts[here]}[\\s\\S]*?{PROMPT}",
                      "send": direction})
        here = room
    steps.append({"label": "in the cave entrance room 84",
                  "expect": f"{texts[84]}[\\s\\S]*?{PROMPT}", "send": "ZACHOD"})
    steps.append({"label": "living door, DRZWI bar the way",
                  "expect": f"{DOOR}[\\s\\S]*?TE DRZWI ZYJA[\\s\\S]*?"
                            f"NIE WPUSZCZE[\\s\\S]*?{PROMPT}",
                  "send": "MODE"})
    if flee:
        steps += [
            {"label": "ground prompt in the living-door room",
             "expect": PROMPT, "send": "ZWIEJ"},
            {"label": "flee threshold prompt",
             "expect": r"PONIZEJ ILU ENERGII CHCESZ UCIEKAC\?", "send": "500"},
            {"label": "threshold set above current energy", "expect": PROMPT,
             "send": "DAWAJ EN"},
            {"label": "energy topped to keep ENERGIA < WIMP", "expect": PROMPT,
             "send": "DAWAJ EN"},
            {"label": "energy 450", "expect": PROMPT, "send": "UNMODE"},
            {"label": "back at the living door",
             "expect": f"{DOOR}[\\s\\S]*?TE DRZWI ZYJA[\\s\\S]*?{PROMPT}",
             "send": "ZABIJ DRZWI"},
            {"label": "escape the fight",
             "expect": f"[\\s\\S]*?WSTYD !!! UCIEKLES Z POLA BITWY[\\s\\S]*?{PROMPT}",
             "send": "ZACHOD"},
        ]
    else:
        # No flee skill: top up energy so the undodgeable tree
        # fight stays winnable. Keep this small - DAWAJ EN adds 200
        # per command and the MAXE clamp only runs at the pass top,
        # so a long run in the ground block overflows the Integer.
        steps += [{"label": f"energy top-up {i + 1}",
                   "expect": PROMPT, "send": "DAWAJ EN"}
                  for i in range(3)]
        steps.append({"label": "back in the room", "expect": PROMPT,
                      "send": "UNMODE"})
        steps += [
            {"label": "back at the living door",
             "expect": f"{DOOR}[\\s\\S]*?TE DRZWI ZYJA[\\s\\S]*?{PROMPT}",
             "send": "ZABIJ DRZWI"},
            {"label": "defeat the DRZWI",
             "expect": f"[\\s\\S]*?ZABILES GO[\\s\\S]*?{PROMPT}", "send": "ZACHOD"},
        ]
    steps.append({"label": "past the DRZWI into the dark room",
                  "expect": f"{DARK}[\\s\\S]*?STARUCHA[\\s\\S]*?{PROMPT}",
                  "send": "DAWAJ KUNSZT"})
    return steps


def main() -> None:
    need = thresholds()
    target = 14
    steps = prefix("UFOK", escape=True)

    level = 1
    visit = 0
    twelfth_step = None
    while level < target:
        visit += 1
        threshold = need[level]
        grants = -(-threshold // 500)
        # Every visit's first grant is the previous visit's trailing
        # banner step (or the room entry for visit 1), so only the
        # remaining grants - 1 are emitted here.
        for index in range(1, grants):
            steps.append({"label": f"visit {visit}: grant {index + 1}/{grants}",
                          "expect": PROMPT, "send": "DAWAJ KUNSZT"})
        # MODE then UNMODE: one extra main-loop pass, so
        # ZdobadzPoziom re-reads the gate without leaving the room.
        #
        # The harness matches each step's expect against the output
        # of the *previous* step's send, so an expect lags its own
        # send by one. MODE's output is just the ground prompt, and
        # UNMODE's output is where the banner lands, so the banner
        # belongs on the step after UNMODE - which is the next
        # visit's first grant.
        steps.append({"label": f"visit {visit}: MODE to leave the room",
                      "expect": PROMPT, "send": "MODE"})
        steps.append({"label": f"visit {visit}: UNMODE to force the pass",
                      "expect": PROMPT, "send": "UNMODE"})
        banner_step = {
            "label": f"visit {visit}: level-up banner, "
                     f"then grant 1/{grants} for level {level + 1}",
            "expect": BANNER, "send": "DAWAJ KUNSZT"}
        # This pass takes the character from level 11 to 12, which
        # is where the level-12 block prints.
        if level == 11:
            twelfth_step = banner_step
        steps.append(banner_step)
        level += 1

    # The level-12 block prints inside the banner of the pass that
    # reaches level 12 (visit 12 levels 11 -> 12), so that step
    # asserts both. WYJSCIE ends the game, so it is the last send
    # and nothing follows it.
    if twelfth_step is not None:
        twelfth_step["label"] = ("visit 12: level-up banner with the "
                                 "twelfth-level block")
        twelfth_step["expect"] = f"{BANNER}[\\s\\S]*?{TWELFTH}[\\s\\S]*?MASZ TERAZ"
    steps.append({"label": "leave the room at the end",
                  "expect": PROMPT, "send": "WYJSCIE"})

    path = OUT / "level-up.json"
    path.write_text(json.dumps({"steps": steps}, indent=2) + "\n",
                    encoding="utf-8")
    print(f"{path.name}: {len(steps)} steps, {visit} visits, "
          f"levels 1..{target}, thresholds "
          f"{[need[n] for n in range(1, target)]}")

    # The level-up body deducts by the NEXT level's threshold, which
    # differs from the gate (level one gates at 700 but subtracts
    # 725). The route's own KUNSZT drift (the DRZWI escape costs 20)
    # makes an absolute residue fragile, so the scenario only drives
    # to the sheet; tests/behavior_test.py then asserts the relation
    # prompt KUNSZT + sheet residue == 2 * need(2), which holds
    # exactly when the deduction is need(2) = 725.
    deduction = prefix("UFOK", escape=True)
    deduction.append({"label": "second grant to 1000 KUNSZT",
                      "expect": PROMPT, "send": "DAWAJ KUNSZT"})
    deduction.append({"label": "MODE to leave the room",
                      "expect": PROMPT, "send": "MODE"})
    deduction.append({"label": "UNMODE to force the pass",
                      "expect": PROMPT, "send": "UNMODE"})
    deduction.append({"label": "level-up banner on the pass",
                      "expect": BANNER, "send": "MODE"})
    deduction.append({"label": "ground prompt",
                      "expect": PROMPT, "send": "JA"})
    deduction.append({
        "label": "sheet shows the level-2 line",
        "expect": "JESTES NA DRUGIM LEVELU A DO NASTEPNEGO BRAKUJE CI "
                  "-?[0-9]+ KUNSZTU",
        "send": "WYJSCIE"})
    path = OUT / "level-up-deduction.json"
    path.write_text(json.dumps({"steps": deduction}, indent=2) + "\n",
                    encoding="utf-8")
    print(f"{path.name}: {len(deduction)} steps; behavior_test.py "
          f"checks prompt KUNSZT + residue == 2 * {need[2]}")

    # POZIOM <= 0 never levels up (the gate falls through every
    # threshold check into the POZIOM <= 8 Exit), and the sheet
    # prints no level line for it. ZABIJ STARUCH drops POZIOM from
    # 1 to 0; with KUNSZT far above every threshold the pass must
    # not fire the banner, and the JA sheet must go straight from
    # the money line to the attribute line.
    zero = prefix("UFOK", escape=True)
    zero.append({"label": "staruch drops POZIOM to zero",
                 "expect": PROMPT, "send": "ZABIJ STARUCH"})
    zero.append({"label": "second grant to 1000 KUNSZT",
                 "expect": PROMPT, "send": "DAWAJ KUNSZT"})
    zero.append({"label": "MODE to leave the room",
                 "expect": PROMPT, "send": "MODE"})
    zero.append({"label": "UNMODE to force the pass",
                 "expect": PROMPT, "send": "UNMODE"})
    zero.append({"label": "no banner: the dark room redispatches",
                 "expect": PROMPT, "send": "MODE"})
    zero.append({"label": "ground prompt",
                 "expect": PROMPT, "send": "JA"})
    zero.append({
        "label": "no level line between money and attributes",
        "expect": r"PRAKTYK[\r\n]+TWOJE PARAMETRY",
        "send": "WYJSCIE"})
    path = OUT / "level-zero.json"
    path.write_text(json.dumps({"steps": zero}, indent=2) + "\n",
                    encoding="utf-8")
    print(f"{path.name}: {len(zero)} steps, POZIOM 0: no level-up, "
          f"no sheet line")

    # The level-12 block distributes MAXSIL/MAXZRE/MAXMAD by
    # comparing them, and each ordering of the three takes a
    # different branch. A single race only produces one ordering,
    # so one extra scenario per reachable ordering. The MAX values
    # below are read from WybierzRase and the 1415-1420 gates.
    variants = {
        # Starts 15/15/15; every gate adds the same amount, so all
        # three stay equal -> the "all +1" branch.
        "level-max-equal.json": ("CZLOWIEK", "all three MAX equal"),
        # Starts 20/20/7; MAXZRE ties MAXSIL on top -> the
        # "MAXSIL + 2 / MAXZRE + 1" branch.
        "level-max-zretie.json": ("OLBRZYM", "MAXZRE ties MAXSIL", True),
        # Starts 15/20/11; after the gates MAXZRE is strictly highest
        # -> the "MAXZRE + 3" branch. NIMFA rather than POL-ELF,
        # which also reaches it but has too little SIL to win the
        # DRZWI fight at level one.
        "level-max-zre-top.json": ("NIMFA", "MAXZRE on top"),
        # Starts 13/14/20; after the gates MAXMAD is strictly
        # highest -> the "MAXMAD + 3" branch, the last ordering in
        # the level-12 block that no other race reaches.
        "level-max-mad-top.json": ("UFOK", "MAXMAD on top", False, False),
    }
    for name, spec in variants.items():
        race, note = spec[0], spec[1]
        second_pass = spec[2] if len(spec) > 2 else False
        escape = spec[3] if len(spec) > 3 else False
        variant = prefix(race, escape=escape)
        # Level up to 12 so the MAX-ordering block runs. Only the
        # last pass before level 12 matters here, so the banner is
        # only asserted on that one, not on every level.
        level = 1
        while level < 12:
            threshold = need[level]
            grants = -(-threshold // 500)
            for index in range(1, grants):
                variant.append({"label": f"level {level + 1}: grant "
                                         f"{index + 1}/{grants}",
                                "expect": PROMPT, "send": "DAWAJ KUNSZT"})
            variant.append({"label": f"level {level + 1}: MODE",
                            "expect": PROMPT, "send": "MODE"})
            variant.append({"label": f"level {level + 1}: UNMODE",
                            "expect": PROMPT, "send": "UNMODE"})
            variant.append({
                "label": f"level {level + 1}: banner, then grant 1/{grants}",
                "expect": (f"{TWELFTH}[\\s\\S]*?MASZ TERAZ"
                           if level == 11 else BANNER),
                "send": "DAWAJ KUNSZT"})
            level += 1
        if second_pass:
            # The level-12 block runs every time POZIOM becomes 12,
            # and ZABIJ STARUCH in this same room drops POZIOM by
            # one, so a second trip through 12 re-runs the block on
            # MAX values the first pass already shifted. For
            # OLBRZYM the first pass takes the MAXZRE/MAXSIL tie
            # branch and leaves MAXZRE below MAXSIL, so the second
            # pass reports MAXSIL + 3 - an ordering no single pass
            # of any starting race produces.
            #
            # Each expect sees the previous step's output, so the
            # banner from a MODE/UNMODE pair lands on the step
            # after it.
            variant.append({"label": "staruch lowers POZIOM by one",
                            "expect": PROMPT, "send": "ZABIJ STARUCH"})
            variant.append({"label": "grant 1/2 back toward 12",
                            "expect": PROMPT, "send": "DAWAJ KUNSZT"})
            variant.append({"label": "grant 2/2 back toward 12",
                            "expect": PROMPT, "send": "MODE"})
            variant.append({"label": "UNMODE to force the pass",
                            "expect": PROMPT, "send": "UNMODE"})
            variant.append({
                "label": "second trip through 12, now with MAXSIL on top",
                "expect": f"{TWELFTH}[\\s\\S]*?MASZ TERAZ",
                "send": "DAWAJ KUNSZT"})
        variant.append({"label": "leave the room at the end",
                        "expect": PROMPT, "send": "WYJSCIE"})
        (OUT / name).write_text(json.dumps({"steps": variant}, indent=2) + "\n",
                                encoding="utf-8")
        print(f"{name}: {len(variant)} steps (race {race}, {note})")


if __name__ == "__main__":
    main()
