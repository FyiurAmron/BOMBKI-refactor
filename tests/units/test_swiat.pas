program test_swiat;
{Unit tests for SWIAT: the room procedures. Each room loops
 on ReadLn until MIECHO leaves the room, so every test sets
 MIECHO to the room id first (so the loop runs) and feeds the
 room's commands in through standard input. Each command
 string ends with a command that leaves the room (a movement,
 MODE, or WYJSCIE) so the loop terminates instead of spinning
 at EOF.}
uses pastest, MONSTRA, PRZEDM, SWIAT;

{Write the given lines (separated by '|') to a temp file and
 redirect standard input to it, so the room procedures that
 ReadLn from the terminal can be driven deterministically.
 Reassigning input works in FPC TP mode and is safe to repeat
 per test.}
procedure FeedStdin(const lines: string);
var
  f: text;
  i, start: integer;
begin
  assign(f, 'build/tmp/stdin.txt');
  rewrite(f);
  start := 1;
  for i := 1 to Length(lines) + 1 do
    if (i > Length(lines)) or (lines[i] = '|') then
    begin
      WriteLn(f, Copy(lines, start, i - start));
      start := i + 1;
    end;
  close(f);
  assign(input, 'build/tmp/stdin.txt');
  reset(input);
end;

procedure RoomSetup;
begin
  {The rooms print energy and skill in their prompt and can
   start combats, so give the player a full pool, no parry or
   flee skill (which would change the combat flow), and clear
   the leftover markers that alter the room or loot text.}
  ENERGIA := 30000; KUNSZT := 100; SIL := 127; ZRE := 127;
  PASZOL := 0; ZWIEJ := 0; WIMP := 0; MANA := 0; PAR := 0;
  FIREBALL := 0; POISON := 0; ILEPOI := 0; POTRAWKI := 0;
  KOP := 0; KOPM := 0; KOPHP := 0; PRO := 0; ILOSC := 0;
  FUKSROLL := 0; MONSTRA.MAXE := 50; MONSTRA.SILNY := 0;
  PRZED := 0; QUEST := 0; QUESTWYK := 0; FORSA := 0;
  PRZEPUSTKA := 0; DYPLOM := 0; FAJKA := 0; PRA := 1;
end;

{Visit one guarded room: set MIECHO, pipe the commands, run.}
procedure PokojAt(const cmds: string; miechoVal: integer);
begin
  MIECHO := miechoVal;
  FeedStdin(cmds);
  case miechoVal of
    4: POKOJ4;
    11: POKOJ11;
    13: POKOJ13;
    30: POKOJ30;
    60: POKOJ60;
    75: POKOJ75;
    83: POKOJ83;
    100: POKOJ100;
  else
    POKOJE;
  end;
end;

procedure TestPokoj5Poster;
begin
  {POKOJ5 lists seven exits and reads a poster on the wall.}
  RoomSetup;
  MIECHO := 5;
  FeedStdin('EXIT|PATRZ PLAKAT|WYJSCIE');
  POKOJ5;
  CheckEqual(5, MIECHO, 'POKOJ5 WYJSCIE leaves without moving');
end;

procedure TestPokoj1Poster;
begin
  {POKOJ1 lists six exits and prints the long poster text.}
  RoomSetup;
  MIECHO := 1;
  FeedStdin('EXIT|PATRZ PLAKAT|WYJSCIE');
  POKOJ1;
  CheckEqual(1, MIECHO, 'POKOJ1 WYJSCIE leaves without moving');
end;

procedure TestPokoj4Poster;
begin
  {POKOJ4 lists two exits and reads the notice on the wall.}
  RoomSetup;
  PokojAt('EXIT|PATRZ AFISZ|WYJSCIE', 4);
  CheckEqual(4, MIECHO, 'POKOJ4 WYJSCIE leaves without moving');
end;

procedure TestPokoj13Loot;
var
  i: Integer;
  sword, shield, heart: Boolean;
begin
  {Killing the room-13 monster can drop the sword, the small
   shield, or the heart, each an independent low-probability
   draw, so keep clearing the monster and fighting until all
   three have dropped at least once.}
  RoomSetup;
  MMIECZ := 0; MTARCZA := 0; SERCE := 0;
  sword := false; shield := false; heart := false;
  for i := 1 to 80 do begin
    ENERGIA := 30000; KUNSZT := 100; SIL := 127; ZRE := 127;
    PASZOL := 0; ZWIEJ := 0; WIMP := 0; MANA := 0; PAR := 0;
    FIREBALL := 0; POISON := 0; ILEPOI := 0; POTRAWKI := 0;
    KOP := 0; KOPM := 0; KOPHP := 0; FUKSROLL := 0;
    MONSTRA.SILNY := 13;
    PokojAt('ZABIJ POTWOR|WYJSCIE', 13);
    if MMIECZ <> 0 then sword := true;
    if MTARCZA <> 0 then shield := true;
    if SERCE <> 0 then heart := true;
    if sword and shield and heart then
      Break;
  end;
  CheckTrue(sword, 'the room-13 monster drops the sword');
  CheckTrue(shield, 'the room-13 monster drops the small shield');
  CheckTrue(heart, 'the room-13 monster drops the heart');
end;

procedure TestPokoj13Flee;
begin
  {With a flee skill the player runs instead of winning, so
   the monster stays and the procedure clears the flee flag.}
  RoomSetup;
  MONSTRA.SILNY := 13;
  ENERGIA := 50; WIMP := 100; MANA := 20; ZWIEJ := 100;
  PokojAt('ZABIJ POTWOR|WYJSCIE', 13);
  CheckEqual(13, MONSTRA.SILNY,
    'fleeing the room-13 monster leaves it alive');
  CheckEqual(0, PASZOL, 'the flee flag is cleared after the fight');
end;

procedure TestPokoj13Poster;
begin
  {With the monster gone the room notes the circling remains;
   MODE sets MIECHO to 1000, which ends the loop.}
  RoomSetup;
  MONSTRA.SILNY := 0;
  PokojAt('EXIT|MODE', 13);
  CheckEqual(1000, MIECHO, 'MODE ends the room-13 loop');
end;

procedure TestPokojeSmallRooms;
const
  {POKOJE guards four rooms: 6, 8, 7, and 10. Room 9 is not
   one of them, so walk the list rather than a range.}
  Rooms: array[1..4] of Integer = (6, 8, 7, 10);
var
  i: Integer;
begin
  {Each room lists one exit and honours MODE, so visit every
   room twice: once for EXIT and MODE, once for WYJSCIE.}
  for i := 1 to 4 do begin
    RoomSetup;
    PokojAt('EXIT|MODE', Rooms[i]);
    CheckEqual(1000, MIECHO, 'MODE ends the small room loop');
    RoomSetup;
    PokojAt('WYJSCIE', Rooms[i]);
    CheckEqual(Rooms[i], MIECHO, 'WYJSCIE leaves the small room in place');
  end;
end;

procedure TestPokoj11Poster;
begin
  {POKOJ11 lists the cage block and reads its poster.}
  RoomSetup;
  PokojAt('EXIT|PATRZ PLAKAT|WYJSCIE', 11);
  CheckEqual(11, MIECHO, 'POKOJ11 WYJSCIE leaves without moving');
end;

procedure TestPokoj30Exits;
begin
  RoomSetup;
  PokojAt('EXIT|WYJSCIE', 30);
  CheckEqual(30, MIECHO, 'POKOJ30 WYJSCIE leaves without moving');
end;

procedure TestPokoj60Exits;
begin
  RoomSetup;
  PokojAt('EXIT|WYJSCIE', 60);
  CheckEqual(60, MIECHO, 'POKOJ60 WYJSCIE leaves without moving');
end;

procedure TestPokoj75Exits;
begin
  RoomSetup;
  PokojAt('EXIT|WYJSCIE', 75);
  CheckEqual(75, MIECHO, 'POKOJ75 WYJSCIE leaves without moving');
end;

procedure TestPokoj83Exits;
begin
  {POKOJ83 runs KOMENDY and FIGHTBLUSZCZ on every command
   before the room dispatch, so this also exercises those two
   calls from the room loop.}
  RoomSetup;
  PokojAt('EXIT|WYJSCIE', 83);
  CheckEqual(83, MIECHO, 'POKOJ83 WYJSCIE leaves without moving');
end;

procedure TestPokoj100QuestMaster;
begin
  {The quest master's road: the exits depend on the pass, and
   killing the master lowers it. FORSA covers the easy quest
   purchase and the fight covers the pass discount.}
  RoomSetup;
  FORSA := 10000; PRZEPUSTKA := 0;
  PokojAt('EXIT|LISTA|ZABIJ QUEST-MASTER|KUP LATWY QUEST|WYJSCIE', 100);
  CheckEqual(1, QUEST, 'the easy quest is taken');
  CheckEqual(75, QUESTWYK, 'the easy quest needs 75 kills');
  CheckEqual(9800, FORSA, 'the easy quest costs 200');
  CheckEqual(-10, PRZEPUSTKA, 'killing the master lowers the pass');
end;

procedure TestPokoj100BlockedRoad;
begin
  {With no pass the west road is refused, so MIECHO stays in
   the room and the loop keeps going until WYJSCIE.}
  RoomSetup;
  PRZEPUSTKA := 0;
  PokojAt('ZACHOD|WYJSCIE', 100);
  CheckEqual(100, MIECHO, 'the blocked west road keeps the player');
end;

procedure TestPokoj100OpenRoad;
begin
  {With a pass of ten or more the west road opens and lists
   its exit; the ZACHOD command then leaves the room, so it is
   the last command in the string.}
  RoomSetup;
  PRZEPUSTKA := -20;
  PokojAt('EXIT|ZACHOD', 100);
  CheckEqual(101, MIECHO, 'the pass opens the west road');
end;

procedure TestPokoj100QuestPrices;
begin
  RoomSetup;
  FORSA := 10000;
  PokojAt('KUP PRZECIETNY QUEST|KUP TRUDNY QUEST|WYJSCIE', 100);
  CheckEqual(3, QUEST, 'the hard quest is taken');
  CheckEqual(200, QUESTWYK, 'the hard quest needs 200 kills');
  CheckEqual(9850, FORSA, 'both quests are paid for');
end;

procedure TestPokoj100SellEasy;
begin
  RoomSetup;
  QUEST := 1; QUESTWYK := 0; PRZEPUSTKA := 0; KUNSZT := 100;
  PokojAt('SPRZEDAJ QUEST|WYJSCIE', 100);
  CheckEqual(0, QUEST, 'the sold quest is cleared');
  CheckEqual(0, QUESTWYK, 'the sold quest kill count is cleared');
  CheckEqual(-10, PRZEPUSTKA, 'selling lowers the pass');
  CheckEqual(200, KUNSZT, 'the easy quest pays 100 skill');
  CheckEqual(1, PRZED, 'the easy quest counts one item');
end;

procedure TestPokoj100SellMedium;
begin
  RoomSetup;
  QUEST := 2; QUESTWYK := 0; DYPLOM := -10; MONSTRA.MAXE := 50;
  PRZEPUSTKA := 0; KUNSZT := 100;
  PokojAt('SPRZEDAJ QUEST|WYJSCIE', 100);
  CheckEqual(0, QUEST, 'the sold quest is cleared');
  CheckEqual(0, DYPLOM, 'the diploma is handed over');
  CheckEqual(45, MONSTRA.MAXE, 'handing in the diploma costs max energy');
  CheckEqual(-10, PRZEPUSTKA, 'selling lowers the pass');
  CheckEqual(350, KUNSZT, 'the medium quest pays 250 skill');
end;

procedure TestPokoj100SellHard;
begin
  RoomSetup;
  QUEST := 3; QUESTWYK := 0; FAJKA := -10; PRA := 1;
  PRZEPUSTKA := 0; KUNSZT := 100; PRZED := 0; MAD := 5;
  PokojAt('SPRZEDAJ QUEST|WYJSCIE', 100);
  CheckEqual(0, QUEST, 'the sold quest is cleared');
  CheckEqual(0, FAJKA, 'the pipe is handed over');
  CheckEqual(0, PRA, 'one practice point is spent');
  CheckEqual(-10, PRZEPUSTKA, 'selling lowers the pass');
  CheckEqual(525, KUNSZT, 'the hard quest pays 425 skill');
  CheckEqual(-1, PRZED, 'the hard quest uncounts the pipe');
  CheckEqual(4, MAD, 'the hard quest costs one wisdom');
end;

begin
  RegisterTest('pokoj5-poster', TestPokoj5Poster);
  RegisterTest('pokoj1-poster', TestPokoj1Poster);
  RegisterTest('pokoj4-poster', TestPokoj4Poster);
  RegisterTest('pokoj13-loot', TestPokoj13Loot);
  RegisterTest('pokoj13-flee', TestPokoj13Flee);
  RegisterTest('pokoj13-poster', TestPokoj13Poster);
  RegisterTest('pokoje-small-rooms', TestPokojeSmallRooms);
  RegisterTest('pokoj11-poster', TestPokoj11Poster);
  RegisterTest('pokoj30-exits', TestPokoj30Exits);
  RegisterTest('pokoj60-exits', TestPokoj60Exits);
  RegisterTest('pokoj75-exits', TestPokoj75Exits);
  RegisterTest('pokoj83-exits', TestPokoj83Exits);
  RegisterTest('pokoj100-quest-master', TestPokoj100QuestMaster);
  RegisterTest('pokoj100-blocked-road', TestPokoj100BlockedRoad);
  RegisterTest('pokoj100-open-road', TestPokoj100OpenRoad);
  RegisterTest('pokoj100-quest-prices', TestPokoj100QuestPrices);
  RegisterTest('pokoj100-sell-easy', TestPokoj100SellEasy);
  RegisterTest('pokoj100-sell-medium', TestPokoj100SellMedium);
  RegisterTest('pokoj100-sell-hard', TestPokoj100SellHard);
  RunTests;
end.
