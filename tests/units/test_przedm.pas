program test_przedm;
{Unit tests for PRZEDM: the deterministic procedures
(state machines, stat arithmetic, item handling,
combat stat arithmetic). Each test sets up the
PRZEDM globals it reads, so the tests are
order-independent and safe to run one per process.}
uses pastest, Game;

{Write the given lines (separated by '|') to a temp
 file and redirect standard input to it, so the
 procedures that ReadLn from the terminal can be
 driven deterministically. Reassigning input works
 in FPC TP mode and is safe to repeat per test.}
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

procedure TestMode;
begin
  Session.Room := 42;
  EnterTrance;
  CheckEqual(42, Session.OuterRoom, 'MODE saves MIECHO into MIECHO2');
  CheckEqual(1000, Session.Room, 'MODE switches MIECHO to 1000');
end;

procedure TestKomendy;
begin
  Command := 'PN'; ExpandAbbrev;
  CheckStrEqual('POLNOC', Command, 'PN expands to POLNOC');
  Command := 'PD'; ExpandAbbrev;
  CheckStrEqual('POLODNIE', Command, 'PD expands to POLODNIE');
  Command := 'W'; ExpandAbbrev;
  CheckStrEqual('WSCHOD', Command, 'W expands to WSCHOD');
  Command := 'Z'; ExpandAbbrev;
  CheckStrEqual('ZACHOD', Command, 'Z expands to ZACHOD');
  Command := 'G'; ExpandAbbrev;
  CheckStrEqual('GORA', Command, 'G expands to GORA');
  Command := 'D'; ExpandAbbrev;
  CheckStrEqual('DOL', Command, 'D expands to DOL');
  Command := 'E'; ExpandAbbrev;
  CheckStrEqual('EXIT', Command, 'E expands to EXIT');
  Command := 'M'; ExpandAbbrev;
  CheckStrEqual('MODE', Command, 'M expands to MODE');
  Command := 'POLNOC'; ExpandAbbrev;
  CheckStrEqual('POLNOC', Command, 'full command passes through KOMENDY');
end;

procedure TestTrainSila;
begin
  Player.Stats[Strength] := 10; Player.Stats[MaxStrength] := 20; Player.Practice := 10; Command := 'TRENUJ SILA';
  HandleTrain;
  CheckEqual(11, Player.Stats[Strength], 'TRENUJ SILA raises SIL by one');
  CheckEqual(7, Player.Practice, 'TRENUJ SILA spends three PRA');
end;

procedure TestTrainZrecznosc;
begin
  Player.Stats[Dexterity] := 10; Player.Stats[MaxDexterity] := 20; Player.Practice := 10; Command := 'TRENUJ ZRECZNOSC';
  HandleTrain;
  CheckEqual(11, Player.Stats[Dexterity], 'TRENUJ ZRECZNOSC raises ZRE by one');
  CheckEqual(8, Player.Practice, 'TRENUJ ZRECZNOSC spends two PRA');
end;

procedure TestTrainMadrosc;
begin
  Player.Stats[Wisdom] := 10; Player.Stats[MaxWisdom] := 20; Player.Practice := 10; Command := 'TRENUJ MADROSC';
  HandleTrain;
  CheckEqual(11, Player.Stats[Wisdom], 'TRENUJ MADROSC raises MAD by one');
  CheckEqual(7, Player.Practice, 'TRENUJ MADROSC spends three PRA');
end;

procedure TestTrainNeedsPracticePoints;
begin
  Player.Stats[Strength] := 10; Player.Stats[MaxStrength] := 20; Player.Practice := 2; Command := 'TRENUJ SILA';
  HandleTrain;
  CheckEqual(10, Player.Stats[Strength], 'TRENUJ SILA refuses with two PRA');
  CheckEqual(2, Player.Practice, 'TRENUJ SILA spends nothing with two PRA');
end;

procedure TestTrainCapsAtMaximum;
begin
  Player.Stats[Strength] := 20; Player.Stats[MaxStrength] := 20; Player.Practice := 10; Command := 'TRENUJ SILA';
  HandleTrain;
  CheckEqual(20, Player.Stats[Strength], 'TRENUJ SILA stops at MAXSIL');
  CheckEqual(10, Player.Practice, 'TRENUJ SILA spends nothing at MAXSIL');
end;

procedure TestPotworyRanges;
begin
  SpawnMonsters;
  { Random(38) + 20 redrawn until above 32: [33, 57]. }
  CheckRange('BAKTERIA', World.Monsters[Bacterium], 33, 57);
  CheckRange('SLIMAK', World.Monsters[Snail], 33, 57);
  CheckRange('ZUK', World.Monsters[Beetle], 33, 57);
  CheckRange('KARALUCH', World.Monsters[Cockroach], 33, 57);
  CheckRange('MROWKA', World.Monsters[Ant], 33, 57);
  CheckRange('PAJAK', World.Monsters[Spider], 33, 57);
  CheckRange('DZIK', World.Monsters[Boar], 33, 57);
  CheckRange('LIS', World.Monsters[Fox], 33, 57);
  CheckRange('SZCZUR', World.Monsters[Rat], 33, 57);
  CheckRange('KUROPATWA', World.Monsters[Partridge], 33, 57);
  CheckRange('SARNA', World.Monsters[Deer], 33, 57);
  CheckRange('ORZEL', World.Monsters[Eagle], 33, 57);
  CheckRange('ZAJAC', World.Monsters[Hare], 33, 57);
  CheckRange('WILCZUR', World.Monsters[Mongrel], 33, 57);
  CheckRange('KORNIK', World.Monsters[Woodworm], 33, 57);
  CheckRange('MUCHA', World.Monsters[Fly], 33, 57);
  CheckRange('SLON', World.Monsters[Elephant], 33, 57);
  CheckRange('LEW', World.Monsters[Lion], 33, 57);
  CheckRange('ZYRAFA', World.Monsters[Giraffe], 33, 57);
  CheckRange('WIELBLAD', World.Monsters[Camel], 33, 57);
  CheckRange('STRUS', World.Monsters[Ostrich], 33, 57);
  CheckRange('BOA', World.Monsters[Boa], 33, 57);
  CheckRange('WILK', World.Monsters[Wolf], 33, 57);
  CheckRange('BIZON', World.Monsters[Bison], 33, 57);
  CheckRange('PANTERA', World.Monsters[Panther], 33, 57);
  CheckRange('GLADIATOR', World.Monsters[Gladiator], 33, 57);
  CheckRange('WOJOWNIK', World.Monsters[Warrior], 33, 57);
  CheckRange('TRENER', World.Monsters[Tamer], 33, 57);
  { Random(7) + 60 redrawn until above 60: [61, 66]. }
  CheckRange('DZIECKO', World.Monsters[Kid], 61, 66);
  CheckRange('REPORTER', World.Monsters[Reporter], 61, 66);
  { Random(8) + 60 redrawn until above 60: [61, 67]. }
  CheckRange('WARIAT', World.Monsters[Lunatic], 61, 67);
  CheckRange('SLUCHACZ', World.Monsters[Listener], 61, 67);
  CheckRange('FAN', World.Monsters[Fan], 61, 67);
  CheckRange('CZLOWIEK', World.Monsters[Man], 61, 67);
  CheckRange('DZIADEK', World.Monsters[OldMan], 61, 67);
  { Random(9) + 60 redrawn until above 60: [61, 68]. }
  CheckRange('POLICJANT', World.Monsters[Policeman], 61, 68);
  CheckRange('OCHRONIARZ', World.Monsters[Bouncer], 61, 68);
  CheckRange('GORYL', World.Monsters[Gorilla], 61, 68);
  { Random(3) + 70, drawn once: [70, 72]. }
  CheckRange('GITARZYSTA', World.Monsters[Guitarist], 70, 72);
  CheckRange('PERKUSISTA', World.Monsters[Drummer], 70, 72);
  CheckRange('ORGANISTA', World.Monsters[Keyboardist], 70, 72);
  CheckRange('LIROY', World.Monsters[Liroy], 70, 72);
  { Fixed constants from POTWORY. }
  CheckEqual(67, World.Monsters[Minibarman], 'MINIBARMAN is 67');
  CheckEqual(67, World.Monsters[Fatso], 'GRUBAS is 67');
  CheckEqual(69, World.Monsters[DJ], 'DJ is 69');
  CheckEqual(76, World.Monsters[Pedal], 'PEDAL is 76');
  CheckEqual(76, World.Monsters[Couple], 'PARA is 76');
  CheckEqual(76, World.Monsters[Maciek], 'MACIEK is 76');
  CheckEqual(1, World.Door, 'DRZWI is 1');
  CheckEqual(1, World.OldElf, 'STARUCH is 1');
  { Random(7) + 20, condition always true: [20, 26]. }
  CheckRange('JAMNIK', World.Monsters[Dachshund], 20, 26);
  CheckRange('OWCZAREK', World.Monsters[Shepherd], 20, 26);
  CheckRange('PIESEK', World.Monsters[Pooch], 20, 26);
  CheckRange('SPANIEL', World.Monsters[Spaniel], 20, 26);
  CheckRange('PUDEL', World.Monsters[Poodle], 20, 26);
  CheckRange('TAKSOWKARZ', World.Monsters[Cabman], 20, 26);
  CheckRange('SPRZEDAWCA', World.Monsters[Vendor], 20, 26);
  CheckRange('ZAMIATACZ', World.Monsters[Sweeper], 20, 26);
  CheckRange('PIJAK', World.Monsters[Drunkard], 20, 26);
  CheckRange('ZEBRAK', World.Monsters[SickMan], 20, 26);
  { Random(8) + 77 redrawn until below 84: [77, 83]. }
  CheckRange('SZCZAW', World.Monsters[Sorrel], 77, 83);
  CheckRange('STOKROTKA', World.Monsters[Daisy], 77, 83);
  CheckRange('KONICZYNKA', World.Monsters[Clover], 77, 83);
  CheckRange('MLECZ', World.Monsters[SowThistle], 77, 83);
  CheckRange('DMUCHAWIEC', World.Monsters[Dandelion], 77, 83);
  CheckRange('ROZA', World.Monsters[Rose], 77, 83);
  CheckRange('OSET', World.Monsters[Thistle], 77, 83);
  CheckRange('MALINA', World.Monsters[Raspberry], 77, 83);
  { Random(8) + 77, not in the until condition: [77, 84]. }
  CheckRange('AGREST', World.Monsters[Gooseberry], 77, 84);
  CheckRange('JEZYNA', World.Monsters[Blackberry], 77, 84);
  CheckRange('TRAWA', World.Monsters[Grass], 77, 84);
  CheckRange('DUNCAN', World.Monsters[Duncan], 77, 84);
end;

procedure TestTarczaAppliesShield;
begin
  { PRO at 100 forces the Random(100) roll to succeed. }
  Combat.Damage := 50; Gear.Values[WornCount] := 30; Gear.Values[Armor] := 100;
  ShieldBlock;
  CheckEqual(20, Combat.Damage, 'TARCZA subtracts ILOSC from WPYSK');
end;

procedure TestTarczaClampsAtZero;
begin
  Combat.Damage := 10; Gear.Values[WornCount] := 30; Gear.Values[Armor] := 100;
  ShieldBlock;
  CheckEqual(0, Combat.Damage, 'TARCZA clamps WPYSK at zero');
end;

{ WALKA: the pre-loop MINIKUNSZT arithmetic (PAS
  612-693) and the victory adjustments (869-877) are
  deterministic. A dead enemy (WROGEN = 0) makes the
  combat loop run exactly one iteration and end in the
  victory path, so KUNSZT after WALKA is the stat
  arithmetic plus the one iteration bonus; the MAXE
  pair is then driven by MAXE alone. A live
  enemy (MAXE behind) also ends in the victory path,
  but the number of combat rounds depends on the
  Random damage sequence, so those cases assert a
  range. Cases with ZRE <> WROGZRE enter the dodge
  blocks, whose Random-based dodges can skip the
  per-iteration bonus, so they assert the arithmetic
  plus zero or one bonus. The fukscroll stays zero:
  a fukroll redraw window of one damage value can
  loop forever (the original FUKSROLL = 590 design
  hung until SIGKILL), so the tests never enable
  it. }
procedure WalkaSetup(aMaxE, aWrogE, aSil, aWrogSil,
  aZre, aWrogZre, aPar, aKop: Integer);
begin
  Player.Energy := 100;
  Skills.Values[Parry] := aPar;
  Skills.Values[Kick] := aKop;
  Skills.Values[KickMinMana] := 0;
  Skills.Values[KickMaxEnergy] := 0;
  Player.Mana := 0;
  Combat.FireballCharges := 0;
  Combat.PoisonCharges := 0;
  Combat.PoisonRounds := 0;
  Skills.Values[Fleeing] := 0;
  Skills.Values[FleeEnergy] := 0;
  Combat.Fled := 0;
  Player.Experience := 0;
  Gear.Values[LuckRoll] := 0;
  Gear.Values[Armor] := 0;
  Gear.Values[WornCount] := 0;
  Player.MaxEnergy := aMaxE;
  Combat.EnemyEnergy := aWrogE;
  Player.Stats[Strength] := aSil;
  Combat.EnemyStrength := aWrogSil;
  Player.Stats[Dexterity] := aZre;
  Combat.EnemyDexterity := aWrogZre;
end;

procedure RunWalka(aMaxE, aWrogE, aSil, aWrogSil,
  aZre, aWrogZre, aPar, aKop: Integer;
  ExpectedKunszt: Longint; const What: string);
begin
  WalkaSetup(aMaxE, aWrogE, aSil, aWrogSil,
    aZre, aWrogZre, aPar, aKop);
  DoFight;
  CheckEqual(ExpectedKunszt, Player.Experience, What);
end;

procedure RunWalkaRange(aMaxE, aWrogE, aSil, aWrogSil,
  aZre, aWrogZre, aPar, aKop: Integer;
  KunsztLo, KunsztHi: Longint; const What: string);
begin
  WalkaSetup(aMaxE, aWrogE, aSil, aWrogSil,
    aZre, aWrogZre, aPar, aKop);
  DoFight;
  CheckRange(What, Player.Experience, KunsztLo, KunsztHi);
end;

procedure TestWalkaEqualStats;
begin
  RunWalka(0, 0, 1, 1, 10, 10, 0, 0, 34,
    'WALKA equal stats credit 33 plus one iteration');
end;

procedure TestWalkaMaxePlusOne;
begin
  RunWalka(1, 0, 1, 1, 10, 10, 0, 0, 33,
    'WALKA MAXE ahead by one credits 10+11+11+1');
end;

procedure TestWalkaMaxePlusThreeOverlap;
begin
  RunWalka(3, 0, 1, 1, 10, 10, 0, 0, 42,
    'WALKA MAXE ahead by three overlaps the 10 and 9 bands');
end;

procedure TestWalkaMaxePlusFive;
begin
  RunWalka(5, 0, 1, 1, 10, 10, 0, 0, 32,
    'WALKA MAXE ahead by five credits 9+11+11+1');
end;

procedure TestWalkaMaxePlusEleven;
begin
  RunWalka(11, 0, 1, 1, 10, 10, 0, 0, 30,
    'WALKA MAXE ahead by eleven credits 7+11+11+1');
end;

procedure TestWalkaMaxePlusTwenty;
begin
  RunWalka(20, 0, 1, 1, 10, 10, 0, 0, 27,
    'WALKA MAXE ahead by twenty credits 4+11+11+1');
end;

procedure TestWalkaMaxePlusTwentyNine;
begin
  RunWalka(29, 0, 1, 1, 10, 10, 0, 0, 24,
    'WALKA MAXE ahead by twenty-nine credits 1+11+11+1');
end;

procedure TestWalkaMaxePlusThirtyOne;
begin
  RunWalka(31, 0, 1, 1, 10, 10, 0, 0, 23,
    'WALKA MAXE ahead by thirty-one is past every band');
end;

procedure TestWalkaMaxeBandAdjustment;
begin
  RunWalka(76, 0, 1, 1, 10, 10, 0, 0, 21,
    'WALKA victory with MAXE 76 loses two KUNSZT');
end;

procedure TestWalkaMaxeHugeAdjustment;
begin
  RunWalka(116, 0, 1, 1, 10, 10, 0, 0, 18,
    'WALKA victory with MAXE 116 loses five KUNSZT');
end;

procedure TestWalkaMaxeMinusTwo;
begin
  RunWalkaRange(0, 2, 61, 1, 10, 10, 0, 0, 24, 26,
    'WALKA MAXE behind by two credits 12+0+11 plus rounds');
end;

procedure TestWalkaMaxeMinusTen;
begin
  RunWalkaRange(0, 10, 61, 1, 10, 10, 0, 0, 28, 31,
    'WALKA MAXE behind by ten credits 16+0+11 plus rounds');
end;

procedure TestWalkaMaxeMinusTwentyOne;
begin
  RunWalkaRange(0, 21, 61, 1, 10, 10, 0, 0, 33, 36,
    'WALKA MAXE behind by twenty-one credits 21+0+11 plus rounds');
end;

procedure TestWalkaSilPlusOne;
begin
  RunWalka(0, 0, 11, 10, 10, 10, 0, 0, 33,
    'WALKA SIL ahead by one credits 11+10+11+1');
end;

procedure TestWalkaSilPlusTen;
begin
  RunWalka(0, 0, 20, 10, 10, 10, 0, 0, 24,
    'WALKA SIL ahead by ten credits 11+1+11+1');
end;

procedure TestWalkaSilMinusOne;
begin
  RunWalka(0, 0, 9, 10, 10, 10, 0, 0, 35,
    'WALKA SIL behind by one credits 11+12+11+1');
end;

procedure TestWalkaSilMinusTen;
begin
  RunWalka(0, 0, 1, 11, 10, 10, 0, 0, 44,
    'WALKA SIL behind by ten credits 11+21+11+1');
end;

procedure TestWalkaParAdjustments;
begin
  RunWalka(0, 0, 1, 1, 10, 10, 96, 0, 29,
    'WALKA victory with PAR 96 loses five KUNSZT');
end;

procedure TestWalkaKopAdjustments;
begin
  RunWalka(0, 0, 1, 1, 10, 10, 0, 96, 27,
    'WALKA victory with KOP 96 loses seven KUNSZT');
end;

procedure TestWalkaZrePlusOne;
begin
  RunWalkaRange(0, 0, 1, 1, 11, 10, 0, 0, 32, 33,
    'WALKA ZRE ahead by one credits 11+11+10 plus zero or one');
end;

procedure TestWalkaZrePlusTwelve;
begin
  RunWalkaRange(0, 0, 1, 1, 22, 10, 0, 0, 27, 28,
    'WALKA ZRE ahead by twelve credits 11+11+5 plus zero or one');
end;

procedure TestWalkaZreMinusOne;
begin
  RunWalkaRange(0, 0, 1, 1, 9, 10, 0, 0, 34, 35,
    'WALKA ZRE behind by one credits 11+11+12 plus zero or one');
end;

procedure TestWalkaZreMinusTwelve;
begin
  RunWalkaRange(0, 0, 1, 1, 1, 13, 0, 0, 39, 40,
    'WALKA ZRE behind by twelve credits 11+11+17 plus zero or one');
end;

{ WALKA special moves. The helper zeroes the combat stats,
  so the tests that need a special stat set it again after
  the setup call. }

procedure TestWalkaPoisoned;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Combat.PoisonRounds := 10;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy while poisoned');
  CheckTrue(Player.Energy > 0, 'WALKA survives the poison damage');
end;

procedure TestWalkaFireball;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Combat.FireballCharges := 1;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy under fireball');
  CheckTrue((Combat.FireballCharges = 0) or (Combat.FireballCharges = 1),
    'WALKA spends the fireball or keeps it');
end;

procedure TestWalkaPoison;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Combat.PoisonCharges := 1;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy under poison');
  CheckTrue((Combat.PoisonCharges = 0) or (Combat.PoisonCharges = 1),
    'WALKA spends the poison or keeps it');
end;

procedure TestWalkaParry;
begin
  WalkaSetup(0, 0, 1, 20, 10, 10, 139, 0);
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy through parry');
  CheckTrue(Player.Energy > 0, 'WALKA survives the parried attack');
end;

procedure TestWalkaParryLight;
begin
  WalkaSetup(0, 10, 3, 3, 10, 10, 139, 0);
  Player.Energy := 10000;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy through light parry');
  CheckTrue(Player.Energy > 0, 'WALKA survives the light parry');
end;

procedure TestWalkaSpecials;
begin
  WalkaSetup(0, 20, 3, 20, 10, 10, 139, 0);
  Player.Energy := 10000;
  Combat.FireballCharges := 1;
  Combat.PoisonCharges := 1;
  Combat.PoisonRounds := 10;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy in the long fight');
  CheckTrue(Player.Energy > 0, 'WALKA survives the long fight');
end;

procedure TestWalkaSuperKopHit;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 100);
  Player.Mana := 100; Skills.Values[KickMaxEnergy] := 100; Player.Energy := 50;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy with the super kop');
  CheckTrue(Player.Mana < 100, 'WALKA spends mana on the super kop');
end;

procedure TestWalkaSuperKopHitAgain;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 100);
  Player.Mana := 100; Skills.Values[KickMaxEnergy] := 100; Player.Energy := 50;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy with the kop again');
  CheckTrue(Player.Mana < 100, 'WALKA spends mana on the kop again');
end;

procedure TestWalkaSuperKopChybia;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 11);
  Player.Mana := 100; Skills.Values[KickMaxEnergy] := 100; Player.Energy := 50;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy when the kop misses');
  CheckTrue(Player.Mana < 100, 'WALKA spends mana on the kop attempt');
end;

procedure TestWalkaFlee;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Skills.Values[Fleeing] := 100; Skills.Values[FleeEnergy] := 100; Player.Energy := 50; Player.Mana := 100;
  DoFight;
  CheckTrue(Combat.Fled = 1, 'WALKA flees the battle');
end;

procedure TestWalkaFleeChybia;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Skills.Values[Fleeing] := 1; Skills.Values[FleeEnergy] := 100; Player.Energy := 50; Player.Mana := 100;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1,
    'WALKA finishes the enemy when the flee fails');
end;

procedure TestWalkaPotrawki;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Skills.Values[Cooking] := 99; Bag.Items[Bigos] := 50; Bag.Count := 0;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the enemy for the potrawki');
  CheckTrue((Bag.Count = 0) or (Bag.Count = 1),
    'WALKA cooks the bigos or not');
end;

procedure TestWalkaDeath;
begin
  WalkaSetup(0, 0, 1, 61, 10, 10, 0, 0);
  Player.Energy := 1;
  DoFight;
  CheckTrue((Player.Energy < 1) or (Combat.EnemyEnergy < 1),
    'WALKA ends the fight by death or victory');
end;

procedure TestWalkaFukroll;
begin
  WalkaSetup(0, 10, 2, 1, 10, 10, 0, 0);
  Gear.Values[LuckRoll] := 1;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1,
    'WALKA defeats the enemy through the fukroll');
end;

procedure EncounterSetup;
begin
  WalkaSetup(127, 0, 127, 1, 127, 1, 0, 0);
  Bag.Items[SmallShield] := 0; Skills.Values[Cooking] := 0; Combat.FireballCharges := 0; Combat.PoisonCharges := 0;
  Combat.PoisonRounds := 0; Bag.Items[Heart] := 0;
end;

procedure TestEncounters;
begin
  EncounterSetup;
  Command := 'ZABIJ MROWKA';
  Fight(WeakEnemy);
  CheckTrue(Combat.EnemyEnergy < 1, 'SLABO defeats the mrowka');
  EncounterSetup;
  FightDog;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKAPIES defeats the pies');
  EncounterSetup;
  Fight(WeakishEnemy);
  CheckTrue(Combat.EnemyEnergy < 1, 'MNIEJSLABO defeats the enemy');
  EncounterSetup;
  Fight(MediumEnemy);
  CheckTrue(Combat.EnemyEnergy < 1, 'SREDNIO defeats the enemy');
  EncounterSetup;
  Fight(HardEnemy);
  CheckTrue(Combat.EnemyEnergy < 1, 'TRUDNO defeats the enemy');
  EncounterSetup;
  Fight(VeryEasyEnemy);
  CheckTrue((Combat.EnemyEnergy < 1) and (Player.Energy > 0),
    'VEASY defeats the enemy and survives');
  EncounterSetup;
  Fight(EasyEnemy);
  CheckTrue((Combat.EnemyEnergy < 1) and (Player.Energy > 0),
    'EASY defeats the enemy and survives');
  EncounterSetup;
  Fight(NotEasyEnemy);
  CheckTrue((Combat.EnemyEnergy < 1) and (Player.Energy > 0),
    'NEASY defeats the enemy and survives');
  EncounterSetup;
  Fight(VeryHardEnemy);
  CheckTrue(Combat.EnemyEnergy < 1, 'BTRUDNO defeats the enemy');
end;

procedure TestWalkaDodge;
begin
  WalkaSetup(0, 30, 3, 1, 0, 2, 0, 0);
  Player.Energy := 100;
  DoFight;
  CheckTrue(Combat.EnemyEnergy < 1, 'WALKA defeats the dodging enemy');
  CheckTrue(Player.Energy > 0, 'WALKA survives the dodged combat');
end;

procedure TestBraniePicksUpSword;
begin
  Session.OuterRoom := 7; Bag.Items[OldSword] := 7; Bag.Count := 0; Command := 'BIERZ STARY';
  TakeDrop;
  CheckEqual(-10, Bag.Items[OldSword], 'BIERZ STARY stores the sword as -10');
  CheckEqual(1, Bag.Count, 'BIERZ STARY counts one item');
end;

procedure TestBranieDropsSword;
begin
  Session.OuterRoom := 7; Bag.Items[OldSword] := -10; Bag.Count := 1; Command := 'ODRZUC STARY';
  TakeDrop;
  CheckEqual(7, Bag.Items[OldSword], 'ODRZUC STARY restores the sword marker');
  CheckEqual(0, Bag.Count, 'ODRZUC STARY uncounts the item');
end;

procedure TestBranieIgnoresMissingSword;
begin
  Session.OuterRoom := 7; Bag.Items[OldSword] := 0; Bag.Count := 0; Command := 'BIERZ STARY';
  TakeDrop;
  CheckEqual(0, Bag.Items[OldSword], 'BIERZ STARY needs the sword marker');
  CheckEqual(0, Bag.Count, 'BIERZ STARY counts nothing without the sword');
end;

procedure TestBraniePicksUpBluszczItems;
begin
  Session.OuterRoom := 7;
  Bag.Items[SmallShield] := 7; Bag.Items[Heart] := 7; Bag.Items[Diploma] := 7; Bag.Items[Pipe] := 7;
  Bag.Count := 0; Player.Stats[Wisdom] := 0; Player.Stats[MaxWisdom] := 5; Player.MaxEnergy := 50;
  Command := 'BIERZ MALA'; TakeDrop;
  Command := 'BIERZ SERCE'; TakeDrop;
  Command := 'BIERZ DYPLOM'; TakeDrop;
  Command := 'BIERZ FAJKA'; TakeDrop;
  CheckEqual(-10, Bag.Items[SmallShield], 'BIERZ MALA stores the shield as -10');
  CheckEqual(-10, Bag.Items[Heart], 'BIERZ SERCE stores the heart as -10');
  CheckEqual(-10, Bag.Items[Diploma], 'BIERZ DYPLOM stores the diploma as -10');
  CheckEqual(-10, Bag.Items[Pipe], 'BIERZ FAJKA stores the pipe as -10');
  CheckEqual(4, Bag.Count, 'four BRANIE picks count four items');
  CheckEqual(55, Player.MaxEnergy, 'BIERZ DYPLOM adds five max energy');
  CheckEqual(1, Player.Stats[Wisdom], 'BIERZ FAJKA adds one wisdom under the cap');
end;

procedure TestBranieDropsBluszczItems;
begin
  Session.OuterRoom := 7;
  Bag.Items[SmallShield] := -10; Bag.Items[Heart] := -10; Bag.Items[Diploma] := -10; Bag.Items[Pipe] := -10;
  Bag.Count := 4; Player.Stats[Wisdom] := 1; Player.MaxEnergy := 55;
  Command := 'ODRZUC FAJKA'; TakeDrop;
  Command := 'ODRZUC MALA'; TakeDrop;
  Command := 'ODRZUC SERCE'; TakeDrop;
  Command := 'ODRZUC DYPLOM'; TakeDrop;
  CheckEqual(7, Bag.Items[SmallShield], 'ODRZUC MALA restores the shield marker');
  CheckEqual(7, Bag.Items[Heart], 'ODRZUC SERCE restores the heart marker');
  CheckEqual(7, Bag.Items[Diploma], 'ODRZUC DYPLOM restores the diploma marker');
  CheckEqual(7, Bag.Items[Pipe], 'ODRZUC FAJKA restores the pipe marker');
  CheckEqual(0, Bag.Count, 'four ODRZUC drops uncount four items');
  CheckEqual(50, Player.MaxEnergy, 'ODRZUC DYPLOM removes five max energy');
  CheckEqual(0, Player.Stats[Wisdom], 'ODRZUC FAJKA removes one wisdom');
end;

procedure TestUzywaSerce;
begin
  Bag.Items[Heart] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ SERCE';
  UseItems;
  CheckEqual(0, Bag.Items[Heart], 'UZYJ SERCE consumes the heart');
  CheckEqual(15, Player.Energy, 'UZYJ SERCE restores five energy');
  CheckEqual(0, Bag.Count, 'UZYJ SERCE uncounts the item');
end;

procedure TestUzywaSerceClampsAtMaxE;
begin
  Bag.Items[Heart] := -10; Player.Energy := 48; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ SERCE';
  UseItems;
  CheckEqual(50, Player.Energy, 'UZYJ SERCE clamps energy at MAXE');
end;

procedure TestUzywaKomplet;
begin
  Bag.Items[Tracksuit] := -10; Gear.WornGarment := ''; Gear.Values[Armor] := 0; Gear.Values[Wearing] := 0;
  Command := 'UZYJ KOMPLET';
  UseItems;
  CheckEqual(7, Gear.Values[Armor], 'UZYJ KOMPLET adds seven defense');
  CheckEqual(1, Gear.Values[Wearing], 'UZYJ KOMPLET marks the body dressed');
  CheckStrEqual('SYF', Gear.WornGarment, 'UZYJ KOMPLET remembers the suit');
  Command := 'ODLORZ KOMPLET';
  UseItems;
  CheckEqual(0, Gear.Values[Armor], 'ODLORZ KOMPLET removes the defense');
  CheckEqual(0, Gear.Values[Wearing], 'ODLORZ KOMPLET marks the body bare');
  CheckStrEqual('', Gear.WornGarment, 'ODLORZ KOMPLET forgets the suit');
end;

procedure TestUzywaKompletWorn;
begin
  Bag.Items[Tracksuit] := -10; Gear.WornGarment := 'SYF'; Gear.Values[Armor] := 0; Gear.Values[Wearing] := 1;
  Command := 'UZYJ KOMPLET';
  UseItems;
  CheckEqual(0, Gear.Values[Armor], 'UZYJ KOMPLET refuses while a suit is worn');
  CheckEqual(1, Gear.Values[Wearing], 'UZYJ KOMPLET keeps the body dressed');
  CheckStrEqual('SYF', Gear.WornGarment, 'UZYJ KOMPLET keeps the worn suit');
end;

procedure TestUzywaGarnitur;
begin
  Bag.Items[SpikedSuit] := -10; Gear.WornGarment := ''; Gear.Values[WornCount] := 0; Gear.Values[Armor] := 0; Gear.Values[LuckRoll] := 0;
  Command := 'UZYJ GARNITUR';
  UseItems;
  CheckEqual(10, Gear.Values[Armor], 'UZYJ GARNITUR adds ten defense');
  CheckEqual(1, Gear.Values[WornCount], 'UZYJ GARNITUR counts one armor layer');
  CheckEqual(15, Gear.Values[LuckRoll], 'UZYJ GARNITUR adds fifteen resistance');
  CheckStrEqual('GARNITUR', Gear.WornGarment, 'UZYJ GARNITUR remembers the suit');
  Command := 'ODLORZ GARNITUR';
  UseItems;
  CheckEqual(0, Gear.Values[Armor], 'ODLORZ GARNITUR removes the defense');
  CheckEqual(0, Gear.Values[WornCount], 'ODLORZ GARNITUR uncounts the armor layer');
  CheckEqual(0, Gear.Values[LuckRoll], 'ODLORZ GARNITUR removes the resistance');
  CheckStrEqual('', Gear.WornGarment, 'ODLORZ GARNITUR forgets the suit');
end;

procedure TestUzywaButelkaMany;
begin
  Bag.Items[ManaBottle] := -10; Player.Mana := 10; Player.MaxMana := 50; Bag.Count := 1;
  Command := 'UZYJ MALA BUTELKA MANY';
  UseItems;
  CheckEqual(40, Player.Mana, 'UZYJ MALA BUTELKA MANY restores thirty mana');
  CheckEqual(0, Bag.Count, 'UZYJ MALA BUTELKA MANY uncounts the item');
end;

procedure TestUzywaButelkaManyClampsAtMaxMana;
begin
  Bag.Items[ManaBottle] := -10; Player.Mana := 45; Player.MaxMana := 50; Bag.Count := 1;
  Command := 'UZYJ MALA BUTELKA MANY';
  UseItems;
  CheckEqual(50, Player.Mana, 'UZYJ MALA BUTELKA MANY clamps mana at MAXMANA');
end;

procedure TestNiszczyPrzepustke;
begin
  Bag.Permit := -10; Bag.Count := 0; Command := 'ZNISZCZ PRZEPUSTKA';
  UseItems;
  CheckEqual(0, Bag.Permit, 'ZNISZCZ PRZEPUSTKA burns the pass');
  CheckEqual(1, Bag.Count, 'ZNISZCZ PRZEPUSTKA counts one item');
end;

procedure TestPatrzPrzepustke;
begin
  Bag.Permit := -10; Bag.Count := 0; Command := 'PATRZ PRZEPUSTKA';
  UseItems;
  CheckEqual(-10, Bag.Permit, 'PATRZ PRZEPUSTKA keeps the pass');
  CheckEqual(0, Bag.Count, 'PATRZ PRZEPUSTKA counts nothing');
end;

procedure TestUzywaDyplom;
begin
  Bag.Items[Diploma] := -10; Command := 'UZYJ DYPLOM';
  UseItems;
  CheckEqual(-10, Bag.Items[Diploma], 'UZYJ DYPLOM keeps the diploma');
end;

procedure TestUzywaPaczek;
begin
  Bag.Items[Doughnut] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ PACZEK';
  UseItems;
  CheckEqual(0, Bag.Items[Doughnut], 'UZYJ PACZEK consumes the paczek');
  CheckEqual(18, Player.Energy, 'UZYJ PACZEK restores eight energy');
  CheckEqual(0, Bag.Count, 'UZYJ PACZEK uncounts the item');
end;

procedure TestUzywaCiastko;
begin
  Bag.Items[Cookie] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ CIASTKO';
  UseItems;
  CheckEqual(0, Bag.Items[Cookie], 'UZYJ CIASTKO consumes the ciastko');
  CheckEqual(22, Player.Energy, 'UZYJ CIASTKO restores twelve energy');
end;

procedure TestUzywaSuchaRacja;
begin
  Bag.Items[DryRation] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ SUCHA RACJA';
  UseItems;
  CheckEqual(0, Bag.Items[DryRation], 'UZYJ SUCHA RACJA consumes the racja');
  CheckEqual(26, Player.Energy, 'UZYJ SUCHA RACJA restores sixteen energy');
end;

procedure TestUzywaBulka;
begin
  Bag.Items[BreadRoll] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ BULKA';
  UseItems;
  CheckEqual(0, Bag.Items[BreadRoll], 'UZYJ BULKA consumes the bulka');
  CheckEqual(30, Player.Energy, 'UZYJ BULKA restores twenty energy');
end;

procedure TestUzywaChleb;
begin
  Bag.Items[Bread] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ CHLEB';
  UseItems;
  CheckEqual(0, Bag.Items[Bread], 'UZYJ CHLEB consumes the chleb');
  CheckEqual(36, Player.Energy, 'UZYJ CHLEB restores twenty-six energy');
end;

procedure TestUzyjaWeka;
begin
  Bag.Items[Sausage] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ WEKA';
  UseItems;
  CheckEqual(0, Bag.Items[Sausage], 'UZYJ WEKA consumes the weka');
  CheckEqual(44, Player.Energy, 'UZYJ WEKA restores thirty-four energy');
end;

procedure TestUzywaBigos;
begin
  Bag.Items[Bigos] := -10; Player.Energy := 10; Player.MaxEnergy := 50; Bag.Count := 1;
  Command := 'UZYJ BIGOS';
  UseItems;
  CheckEqual(0, Bag.Items[Bigos], 'UZYJ BIGOS consumes the bigos');
  CheckEqual(30, Player.Energy, 'UZYJ BIGOS restores twenty energy');
end;

procedure TestUzywaPigulkaLow;
begin
  Bag.Items[TeleportPill] := -10; Player.Stats[Wisdom] := 5; Player.MaxEnergy := 50; Player.Energy := 40; Player.Experience := 100;
  Command := 'UZYJ PIGULKA';
  UseItems;
  CheckEqual(0, Bag.Items[TeleportPill], 'UZYJ PIGULKA consumes the pigulka');
  CheckEqual(1, Player.Energy, 'UZYJ PIGULKA with low MAD drains energy to one');
  CheckEqual(49, Player.MaxEnergy, 'UZYJ PIGULKA with low MAD lowers max energy');
  CheckEqual(50, Player.Experience, 'UZYJ PIGULKA with low MAD lowers kunszt');
end;

procedure TestUzywaPigulkaMid;
begin
  Bag.Items[TeleportPill] := -10; Player.Stats[Wisdom] := 12; Player.Energy := 100; Player.Experience := 100;
  Command := 'UZYJ PIGULKA';
  UseItems;
  CheckEqual(60, Player.Energy, 'UZYJ PIGULKA with mid MAD drains forty energy');
  CheckEqual(70, Player.Experience, 'UZYJ PIGULKA with mid MAD lowers kunszt');
end;

procedure TestUzywaPigulkaHigh;
begin
  Bag.Items[TeleportPill] := -10; Player.Stats[Wisdom] := 20; Player.Energy := 100; Player.Experience := 100;
  Command := 'UZYJ PIGULKA';
  UseItems;
  CheckEqual(0, Bag.Items[TeleportPill], 'UZYJ PIGULKA with high MAD consumes the pigulka');
  CheckEqual(100, Player.Energy, 'UZYJ PIGULKA with high MAD keeps energy');
  CheckEqual(100, Player.Experience, 'UZYJ PIGULKA with high MAD keeps kunszt');
end;

procedure TestGarniturZyskInvariant;
begin
  Bag.Items[SpikedSuit] := 50; Bag.Count := 0;
  SuitGain;
  CheckTrue((Bag.Items[SpikedSuit] = 50) or (Bag.Items[SpikedSuit] = 40),
    'GARNITURZYSK drops GARNITUR by ten or not at all');
  CheckTrue((Bag.Count = 0) or (Bag.Count = 1),
    'GARNITURZYSK counts at most one item');
end;

procedure TestPigulkaZyskInvariant;
begin
  Bag.Items[TeleportPill] := 50; Bag.Count := 0;
  PillGain;
  CheckTrue((Bag.Items[TeleportPill] = 50) or (Bag.Items[TeleportPill] = 40),
    'PIGULKAZYSK drops PIGULKA by ten or not at all');
  CheckTrue((Bag.Count = 0) or (Bag.Count = 1),
    'PIGULKAZYSK counts at most one item');
end;

procedure TestKasetaZyskInvariant;
begin
  Bag.Items[Cassette] := 50; Player.MaxEnergy := 0; Gear.Values[Armor] := 0; Bag.Count := 0; Player.Stats[Dexterity] := 0;
  Session.Room := 20;
  CassetteGain;
  CheckTrue((Bag.Items[Cassette] = 50) or (Bag.Items[Cassette] = 40),
    'KASETAZYSK drops the cassette by ten or not at all');
  CheckTrue((Player.MaxEnergy = 0) or (Player.MaxEnergy = 5),
    'KASETAZYSK raises MAXE by five or not at all');
  CheckTrue((Gear.Values[Armor] = 0) or (Gear.Values[Armor] = -8),
    'KASETAZYSK lowers PRO by eight or not at all');
  CheckTrue((Bag.Count = 0) or (Bag.Count = 1),
    'KASETAZYSK counts at most one item');
  CheckTrue((Player.Stats[Dexterity] = 0) or (Player.Stats[Dexterity] = 1),
    'KASETAZYSK raises ZRE by one or not at all');
end;

procedure TestListekZyskInvariant;
begin
  Bag.Items[LuckyLeaf] := 50; Bag.Count := 0; Player.MaxMana := 0; Session.Room := 20;
  LeafGain;
  CheckTrue((Bag.Items[LuckyLeaf] = 50) or (Bag.Items[LuckyLeaf] = 40),
    'LISTEKZYSK drops the leaf by ten or not at all');
  CheckTrue((Bag.Count = 0) or (Bag.Count = 1),
    'LISTEKZYSK counts at most one item');
  CheckTrue((Player.MaxMana = 0) or (Player.MaxMana = 40),
    'LISTEKZYSK raises MAXMANA by forty or not at all');
end;

procedure TestScrollPorZyskInvariant;
begin
  Bag.Items[CompareScroll] := 50; Bag.Count := 0; Session.Room := 20;
  ScrollGain;
  CheckTrue((Bag.Items[CompareScroll] = 50) or (Bag.Items[CompareScroll] = 40),
    'SCROLLPORZYSK drops the scroll by ten or not at all');
  CheckTrue((Bag.Count = 0) or (Bag.Count = 1),
    'SCROLLPORZYSK counts at most one item');
end;

{ The rare-gain branches of the loot procedures only
  trigger on a low Random roll, so the tests repeat
  the procedure until the first gain, which makes the
  result a single deterministic gain. }

procedure TestGarniturZyskGain;
var i: Integer;
begin
  Bag.Items[SpikedSuit] := 100; Bag.Count := 0;
  i := 0;
  while (Bag.Count = 0) and (i < 2000) do begin
    SuitGain;
    i := i + 1;
  end;
  CheckTrue(Bag.Count > 0, 'GARNITURZYSK gains the suit');
  CheckEqual(90, Bag.Items[SpikedSuit],
    'GARNITURZYSK drops GARNITUR by ten');
end;

procedure TestPigulkaZyskGain;
var i: Integer;
begin
  Bag.Items[TeleportPill] := 100; Bag.Count := 0;
  i := 0;
  while (Bag.Count = 0) and (i < 2000) do begin
    PillGain;
    i := i + 1;
  end;
  CheckTrue(Bag.Count > 0, 'PIGULKAZYSK gains the pill');
  CheckEqual(90, Bag.Items[TeleportPill],
    'PIGULKAZYSK drops PIGULKA by ten');
end;

procedure TestKasetaZyskGain;
var i: Integer;
begin
  Bag.Items[Cassette] := 100; Player.MaxEnergy := 0; Gear.Values[Armor] := 0; Bag.Count := 0;
  Player.Stats[Dexterity] := 0; Session.Room := 20;
  i := 0;
  while (Bag.Count = 0) and (i < 2000) do begin
    CassetteGain;
    i := i + 1;
  end;
  CheckTrue(Bag.Count > 0, 'KASETAZYSK gains the cassette');
  CheckEqual(90, Bag.Items[Cassette],
    'KASETAZYSK drops the cassette by ten');
  CheckEqual(5, Player.MaxEnergy, 'KASETAZYSK raises MAXE by five');
  CheckEqual(-8, Gear.Values[Armor], 'KASETAZYSK lowers PRO by eight');
  CheckEqual(1, Player.Stats[Dexterity], 'KASETAZYSK raises ZRE by one');
end;

procedure TestListekZyskGain;
var i: Integer;
begin
  Bag.Items[LuckyLeaf] := 100; Bag.Count := 0; Player.MaxMana := 0; Session.Room := 20;
  i := 0;
  while (Bag.Count = 0) and (i < 2000) do begin
    LeafGain;
    i := i + 1;
  end;
  CheckTrue(Bag.Count > 0, 'LISTEKZYSK gains the leaf');
  CheckEqual(90, Bag.Items[LuckyLeaf],
    'LISTEKZYSK drops the leaf by ten');
  CheckEqual(40, Player.MaxMana,
    'LISTEKZYSK raises MAXMANA by forty');
end;

procedure TestScrollPorZyskGain;
var i: Integer;
begin
  Bag.Items[CompareScroll] := 100; Bag.Count := 0; Session.Room := 20;
  i := 0;
  while (Bag.Count = 0) and (i < 2000) do begin
    ScrollGain;
    i := i + 1;
  end;
  CheckTrue(Bag.Count > 0, 'SCROLLPORZYSK gains the scroll');
  CheckEqual(90, Bag.Items[CompareScroll],
    'SCROLLPORZYSK drops the scroll by ten');
end;

procedure TestScenaMessages;
begin
  Session.Room := 1;
  World.Monsters[Guitarist] := 1; World.Monsters[Drummer] := 1; World.Monsters[Keyboardist] := 1; World.Monsters[Liroy] := 1;
  DescribeStage;
  CheckEqual(1, Session.Room, 'SCENA leaves MIECHO unchanged');
end;

procedure TestTlumMessages;
begin
  Session.Room := 1;
  World.Monsters[Kid] := 1; World.Monsters[Lunatic] := 1; World.Monsters[Listener] := 1; World.Monsters[Fan] := 1;
  World.Monsters[Man] := 1; World.Monsters[Policeman] := 1; World.Monsters[Bouncer] := 1; World.Monsters[Gorilla] := 1;
  World.Monsters[OldMan] := 1; World.Monsters[Reporter] := 1;
  DescribeCrowd;
  CheckEqual(1, Session.Room, 'TLUM leaves MIECHO unchanged');
end;

procedure TestKtoMessages;
begin
  Session.Room := 1;
  World.Monsters[Woodworm] := 1; World.Monsters[Fly] := 1; World.Monsters[Bacterium] := 1; World.Monsters[Snail] := 1; World.Monsters[Beetle] := 1;
  World.Monsters[Cockroach] := 1; World.Monsters[Ant] := 1; World.Monsters[Spider] := 1; World.Monsters[Boar] := 1; World.Monsters[Rat] := 1;
  World.Monsters[Fox] := 1; World.Monsters[Partridge] := 1; World.Monsters[Hare] := 1; World.Monsters[Mongrel] := 1; World.Monsters[Eagle] := 1;
  World.Monsters[Deer] := 1; World.Monsters[Elephant] := 1; World.Monsters[Lion] := 1; World.Monsters[Giraffe] := 1; World.Monsters[Camel] := 1;
  World.Monsters[Ostrich] := 1; World.Monsters[Boa] := 1; World.Monsters[Wolf] := 1; World.Monsters[Bison] := 1; World.Monsters[Panther] := 1;
  World.Monsters[Gladiator] := 1; World.Monsters[Warrior] := 1; World.Monsters[Tamer] := 1;
  DescribeBeasts;
  CheckEqual(1, Session.Room, 'KTO leaves MIECHO unchanged');
end;

procedure TestUlSklepMessages;
begin
  Session.Room := 1;
  World.Monsters[Dachshund] := 1; World.Monsters[Shepherd] := 1; World.Monsters[Pooch] := 1;
  World.Monsters[Spaniel] := 1; World.Monsters[Poodle] := 1;
  World.Monsters[Cabman] := 1; World.Monsters[Vendor] := 1;
  World.Monsters[Sweeper] := 1; World.Monsters[Drunkard] := 1; World.Monsters[SickMan] := 1;
  DescribeStreet;
  CheckEqual(1, Session.Room, 'ULSKLEPIKOWA leaves MIECHO unchanged');
end;

procedure TestBluszczMessages;
begin
  Session.Room := 1;
  World.Monsters[Sorrel] := 1; World.Monsters[Daisy] := 1; World.Monsters[Clover] := 1; World.Monsters[SowThistle] := 1;
  World.Monsters[Dandelion] := 1; World.Monsters[Rose] := 1; World.Monsters[Thistle] := 1; World.Monsters[Blackberry] := 1;
  World.Monsters[Gooseberry] := 1; World.Monsters[Raspberry] := 1; World.Monsters[Grass] := 1; World.Monsters[Duncan] := 1;
  DescribePlants;
  CheckEqual(1, Session.Room, 'BLUSZCZ leaves MIECHO unchanged');
end;

procedure TestPierdolyTlo;
begin
  FeedStdin('1');
  Command := 'ZMIEN TLO';
  DisplayPrefs;
end;

procedure TestPorownanie;
begin
  Player.Mana := 10;
  FeedStdin('DZIK');
  CompareFoe;
end;

procedure MiniarenaSetup;
begin
  {Give every arena monster the same id (33) so the
   MIECHO = <monster> guard holds for each ZABIJ cmd.
   Raise ZRE so the enemy rarely dodges: each combat
   then ends in one or two rounds, keeping the arena
   tests cheap.}
  World.Monsters[Bacterium] := 33; World.Monsters[Snail] := 33; World.Monsters[Woodworm] := 33; World.Monsters[Fly] := 33;
  World.Monsters[Beetle] := 33; World.Monsters[Cockroach] := 33; World.Monsters[Ant] := 33; World.Monsters[Spider] := 33;
  World.Monsters[Boar] := 33; World.Monsters[Mongrel] := 33; World.Monsters[Rat] := 33; World.Monsters[Fox] := 33;
  World.Monsters[Partridge] := 33; World.Monsters[Hare] := 33; World.Monsters[Eagle] := 33; World.Monsters[Deer] := 33;
  World.Monsters[Elephant] := 33; World.Monsters[Lion] := 33; World.Monsters[Giraffe] := 33; World.Monsters[Wolf] := 33;
  World.Monsters[Camel] := 33; World.Monsters[Ostrich] := 33; World.Monsters[Boa] := 33; World.Monsters[Bison] := 33;
  World.Monsters[Panther] := 33; World.Monsters[Gladiator] := 33; World.Monsters[Warrior] := 33; World.Monsters[Tamer] := 33;
  Session.Room := 33;
  Player.Stats[Strength] := 127; Player.Stats[Dexterity] := 127; Player.Energy := 30000; Combat.Fled := 0;
end;

procedure TestMiniarenaSlabo;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ BAKTERIA|ZABIJ SLIMAK|ZABIJ KORNIK|ZABIJ MUCHA|' +
    'ZABIJ ZUK|ZABIJ KARALUCH|ZABIJ MROWKA|ZABIJ PAJAK|MODE');
  ArenaMaze;
end;

procedure TestMiniarenaMniejslabo;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ DZIK|ZABIJ WILCZUR|ZABIJ SZCZUR|ZABIJ LIS|' +
    'ZABIJ KUROPATWA|ZABIJ ZAJAC|ZABIJ ORZEL|ZABIJ SARNA|MODE');
  ArenaMaze;
end;

procedure TestMiniarenaSrednio;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ SLON|ZABIJ LEW|ZABIJ ZYRAFA|ZABIJ WILK|' +
    'ZABIJ WIELBLAD|ZABIJ STRUS|ZABIJ BOA|ZABIJ BIZON|' +
    'ZABIJ PANTERA|MODE');
  ArenaMaze;
end;

procedure TestMiniarenaTrudno;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ GLADIATOR|ZABIJ WOJOWNIK|ZABIJ TRENER|MODE');
  ArenaMaze;
end;

procedure MiniarenaAt(const cmd: string; miechoVal: integer);
begin
  Session.Room := miechoVal;
  FeedStdin(cmd);
  ArenaMaze;
end;

procedure TestMiniarenaExitNav;
begin
  {EXIT lists the available exits for the current room; each
   case runs its WriteLn bodies only for its own room id, so
   visit one room id per case. MODE then leaves the loop
   (EXIT alone does not change ARENA).}
  MiniarenaAt('EXIT|MODE', 33);
  MiniarenaAt('EXIT|MODE', 34);
  MiniarenaAt('EXIT|MODE', 35);
  MiniarenaAt('EXIT|MODE', 40);
  MiniarenaAt('EXIT|MODE', 41);
  MiniarenaAt('EXIT|MODE', 45);
  MiniarenaAt('EXIT|MODE', 46);
  MiniarenaAt('EXIT|MODE', 47);
  MiniarenaAt('EXIT|MODE', 56);
  MiniarenaAt('EXIT|MODE', 57);
  {Each navigation command sets ARENA := 0, so the arena loop
   leaves after one command, and every per-room if in the
   block is evaluated, covering the whole branch.}
  MiniarenaAt('POLODNIE', 33);
  MiniarenaAt('POLNOC', 33);
  MiniarenaAt('WSCHOD', 33);
  MiniarenaAt('ZACHOD', 33);
end;

procedure FightSetup;
begin
  {Give every musician and bluszcz-fight monster the same
   room id so each ZABIJ guard holds, and raise ZRE so the
   enemy rarely dodges: each combat then ends quickly.}
  Session.Room := 100;
  World.Monsters[Drummer] := 100; World.Monsters[Guitarist] := 100; World.Monsters[Keyboardist] := 100;
  World.Monsters[Liroy] := 100; World.Monsters[Duncan] := 100;
  World.Monsters[Sorrel] := 100; World.Monsters[Daisy] := 100; World.Monsters[Clover] := 100;
  World.Monsters[SowThistle] := 100; World.Monsters[Dandelion] := 100; World.Monsters[Rose] := 100;
  World.Monsters[Thistle] := 100; World.Monsters[Raspberry] := 100; World.Monsters[Gooseberry] := 100;
  World.Monsters[Blackberry] := 100; World.Monsters[Grass] := 100;
  Player.Stats[Strength] := 127; Player.Stats[Dexterity] := 127; Player.Energy := 30000; Combat.Fled := 0;
  World.DuncanQuest := 0; Player.Money := 10000; Bag.Permit := 100;
  Bag.Items[Backpack] := 100; World.Quest := 0; Player.Experience := 0;
end;

procedure TestFightscena;
begin
  FightSetup;
  Command := 'ZABIJ PERKUSISTA'; StageFights;
  Command := 'ZABIJ GITARZYSTA'; StageFights;
  Command := 'ZABIJ LIROY'; StageFights;
  Command := 'ZABIJ ORGANISTA'; StageFights;
end;

procedure TestFightbluszczZabij;
begin
  FightSetup;
  Command := 'ZABIJ DUNCAN'; PlantFights;
  Command := 'ZABIJ SZCZAW'; PlantFights;
  Command := 'ZABIJ STOKROTKA'; PlantFights;
  Command := 'ZABIJ KONICZYNKA'; PlantFights;
  Command := 'ZABIJ MLECZ'; PlantFights;
  Command := 'ZABIJ DMUCHAWIEC'; PlantFights;
  Command := 'ZABIJ ROZA'; PlantFights;
  Command := 'ZABIJ OSET'; PlantFights;
  Command := 'ZABIJ MALINA'; PlantFights;
  Command := 'ZABIJ AGREST'; PlantFights;
  Command := 'ZABIJ JEZYNA'; PlantFights;
  Command := 'ZABIJ TRAWA'; PlantFights;
end;

procedure TestFightbluszczShop;
begin
  FightSetup;
  Command := 'SECRET LISTA'; PlantFights;
  Command := 'KUP DOKUMENT'; PlantFights;
  Command := 'KUP PLECAK'; PlantFights;
end;

procedure TestFightbluszczDuncan;
begin
  FightSetup;
  World.DuncanQuest := 0;
  Command := 'ROZMAWIAJ DUNCAN'; PlantFights;
  World.DuncanQuest := -125;
  Command := 'ROZMAWIAJ DUNCAN'; PlantFights;
end;

procedure PorownanieAsk(const monster: string;
  aPoziom, aSil, aZre, aPar, aKop: Integer);
begin
  {Drive one POROWNANIE conversation. The prompt reads the
   monster name from stdin, and the reply branches key off
   OGOL (POZIOM + SIL plus the ZRE/PAR/KOP bonuses)
   and SIL, so both are set to reach each band.}
  FeedStdin(monster);
  Player.Mana := 10; Player.Level := aPoziom; Player.Stats[Strength] := aSil; Player.Stats[Dexterity] := aZre;
  Skills.Values[Parry] := aPar; Skills.Values[Kick] := aKop;
  CompareFoe;
end;

procedure TestPorownanieBeasts;
begin
  {The beasts group (DZIK and friends) warns below OGOL 16,
   again from 16 to 18, and above 18.}
  PorownanieAsk('DZIK', 0, 0, 0, 0, 0);
  PorownanieAsk('KUROPATWA', 0, 16, 0, 0, 0);
  PorownanieAsk('SARNA', 0, 19, 0, 0, 0);
  PorownanieAsk('DZIADEK', 0, 30, 0, 0, 0);
  CheckEqual(30, Player.Stats[Strength], 'POROWNANIE leaves the last SIL in place');
end;

procedure TestPorownanieBigBeasts;
begin
  {The big-beasts group (SLON and friends) uses OGOL 16 and
   SIL 16, 21, and 23 as its four band edges.}
  PorownanieAsk('SLON', 0, 0, 0, 0, 0);
  PorownanieAsk('LEW', 0, 16, 0, 0, 0);
  PorownanieAsk('ZYRAFA', 0, 21, 0, 0, 0);
  PorownanieAsk('REPORTER', 0, 23, 0, 0, 0);
end;

procedure TestPorownanieFighters;
begin
  {The fighters group (GLADIATOR and friends) bands on
   OGOL 15, 15 to 18, 18 to 23, 23 to 26, and above 26.}
  PorownanieAsk('GLADIATOR', 0, 0, 0, 0, 0);
  PorownanieAsk('WOJOWNIK', 0, 16, 0, 0, 0);
  PorownanieAsk('TRENER', 0, 20, 0, 0, 0);
  PorownanieAsk('POLICJANT', 0, 24, 0, 0, 0);
  PorownanieAsk('GORYL', 0, 27, 0, 0, 0);
  PorownanieAsk('OCHRONIARZ', 0, 30, 0, 0, 0);
end;

procedure TestPorownanieDrunks;
begin
  {The drunks group (MINI-BARMAN and friends) bands on
   OGOL 24, 24 to 26, 26 to 29, 29, and above 34.}
  PorownanieAsk('MINI-BARMAN', 0, 0, 0, 0, 0);
  PorownanieAsk('GRUBAS', 0, 25, 0, 0, 0);
  PorownanieAsk('D.J', 0, 27, 0, 0, 0);
  PorownanieAsk('GRUBAS', 0, 29, 0, 0, 0);
  PorownanieAsk('D.J', 0, 35, 0, 0, 0);
end;

procedure TestPorownanieMusicians;
begin
  {The musicians group (TAKSOWKARZ and friends) bands on
   OGOL 21, 23 to 28, and above 28.}
  PorownanieAsk('TAKSOWKARZ', 0, 0, 0, 0, 0);
  PorownanieAsk('GITARZYSTA', 0, 23, 0, 0, 0);
  PorownanieAsk('PERKUSISTA', 0, 26, 0, 0, 0);
  PorownanieAsk('ORGANISTA', 0, 29, 0, 0, 0);
  PorownanieAsk('ZEBRAK', 0, 30, 0, 0, 0);
end;

procedure TestPorownanieBluszcz;
begin
  {The bluszcz group (PEDAL and friends) bands on OGOL 20,
   20 to 26, 26 to 30, 30, and above 35. The ZRE 8 to 21
   bonus branches shift OGOL by four to ten, so they run
   here too.}
  PorownanieAsk('PEDAL', 0, 0, 0, 0, 0);
  PorownanieAsk('PARA', 0, 20, 0, 0, 0);
  PorownanieAsk('MACIEK', 0, 26, 0, 0, 0);
  PorownanieAsk('ROZA', 0, 30, 0, 0, 0);
  PorownanieAsk('MALINA', 0, 36, 0, 0, 0);
  PorownanieAsk('TRAWA', 0, 0, 9, 0, 0);
  PorownanieAsk('AGREST', 0, 0, 11, 0, 0);
  PorownanieAsk('JEZYNA', 0, 0, 13, 0, 0);
  PorownanieAsk('TRAWA', 0, 0, 15, 0, 0);
  PorownanieAsk('AGREST', 0, 0, 17, 0, 0);
  PorownanieAsk('JEZYNA', 0, 0, 19, 0, 0);
  PorownanieAsk('TRAWA', 0, 0, 21, 0, 0);
end;

procedure TestPorownanieLiroyAndDogs;
begin
  {LIROY bands on OGOL 28, 28 to 33, 33 to 44, 44 to 48,
   and above 48; POKRZYWA on 40 and above 40; the dog group
   always answers.}
  PorownanieAsk('LIROY', 0, 0, 0, 0, 0);
  PorownanieAsk('LIROY', 0, 28, 0, 0, 0);
  PorownanieAsk('LIROY', 0, 33, 0, 0, 0);
  PorownanieAsk('LIROY', 0, 44, 0, 0, 0);
  PorownanieAsk('LIROY', 0, 48, 0, 0, 0);
  PorownanieAsk('POKRZYWA', 0, 0, 0, 0, 0);
  PorownanieAsk('POKRZYWA', 0, 41, 0, 0, 0);
  PorownanieAsk('SPANIEL', 0, 0, 0, 0, 0);
  PorownanieAsk('OWCZAREK', 0, 0, 0, 0, 0);
  PorownanieAsk('PIESEK', 0, 0, 0, 0, 0);
  PorownanieAsk('JAMNIK', 0, 0, 0, 0, 0);
  PorownanieAsk('PUDEL', 0, 0, 0, 0, 0);
end;

procedure TestPorownanieBonusesAndBakteria;
begin
  {The PAR over 50 and over 75 plus the KOP over 10 and over
   70 bonuses add up to six to OGOL, and BAKTERIA restores
   five mana. ZRE 8 to 21 is covered by the bluszcz test.}
  PorownanieAsk('DZIK', 0, 10, 0, 51, 11);
  PorownanieAsk('DZIK', 0, 10, 0, 76, 71);
  FeedStdin('BAKTERIA');
  Player.Mana := 10;
  CompareFoe;
  CheckEqual(15, Player.Mana, 'BAKTERIA restores five mana');
end;

procedure LootSetup;
begin
  {The heart drops need SERCE clear (neither held nor on
   the floor) and the player still standing after the fight,
   so start with an empty SERCE, a healthy ENERGIA, and no
   flee skill, then call the encounter many times: each draw
   is independent, so the rare drop lands eventually. SERCE
   must be reset here: earlier tests leave it held, which
   would skip every drop.}
  Bag.Items[Heart] := 0;
  Player.Energy := 30000; Player.Stats[Strength] := 127; Player.Stats[Dexterity] := 127; Combat.Fled := 0;
  Skills.Values[Fleeing] := 0; Skills.Values[FleeEnergy] := 0; Player.Mana := 0; Combat.FireballCharges := 0;
  Combat.PoisonCharges := 0; Combat.PoisonRounds := 0; Skills.Values[Kick] := 0; Skills.Values[KickMinMana] := 0;
  Skills.Values[KickMaxEnergy] := 0; Gear.Values[Armor] := 0; Gear.Values[WornCount] := 0; Gear.Values[LuckRoll] := 0;
  Bag.Count := 0;
end;

procedure TestEncounterHeartVeasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if Bag.Items[Heart] = 0 then Fight(VeryEasyEnemy);
  CheckEqual(-10, Bag.Items[Heart], 'VEASY eventually drops the heart');
end;

procedure TestEncounterHeartEasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if Bag.Items[Heart] = 0 then Fight(EasyEnemy);
  CheckEqual(-10, Bag.Items[Heart], 'EASY eventually drops the heart');
end;

procedure TestEncounterHeartNeasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if Bag.Items[Heart] = 0 then Fight(NotEasyEnemy);
  CheckEqual(-10, Bag.Items[Heart], 'NEASY eventually drops the heart');
end;

procedure TestEncounterHeartTrudno;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 110 do
    if Bag.Items[Heart] = 0 then Fight(HardEnemy);
  CheckEqual(-10, Bag.Items[Heart], 'TRUDNO eventually drops the heart');
end;

procedure TestEncounterHeartBtrudno;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 150 do
    if Bag.Items[Heart] = 0 then Fight(VeryHardEnemy);
  CheckEqual(-10, Bag.Items[Heart], 'BTRUDNO eventually drops the heart');
end;

procedure TestWalkaPotrawkiLearn;
var
  i: Integer;
  learned: Boolean;
begin
  {The potrawki lesson needs the victory draw to come up
   zero, so fight many one-round battles: each victory draws
   independently, so the lesson lands eventually. POTRAWKI is
   reset per fight so the drop cannot saturate BIGOS.}
  learned := false;
  for i := 1 to 800 do begin
    WalkaSetup(0, 0, 127, 1, 127, 1, 0, 0);
    Player.Energy := 100; Skills.Values[Cooking] := 1; Bag.Items[Bigos] := 0;
    DoFight;
    if Skills.Values[Cooking] > 1 then
      learned := true;
  end;
  CheckTrue(learned, 'WALKA eventually teaches the potrawki skill');
end;

procedure TestWalkaParryLearn;
var
  i: Integer;
begin
  {The parry lesson needs the parry draw to come up zero, so
   run many long battles with a high PAR (the lesson stops
   once PAR reaches 100, which the loop detects).}
  for i := 1 to 60 do begin
    WalkaSetup(0, 3000, 127, 5, 127, 1, 99, 0);
    Player.Energy := 30000;
    DoFight;
    if Skills.Values[Parry] > 99 then
      Break;
  end;
  CheckTrue(Skills.Values[Parry] > 99, 'WALKA eventually teaches the parry skill');
end;

begin
  RegisterTest('mode', TestMode);
  RegisterTest('komendy', TestKomendy);
  RegisterTest('train-sila', TestTrainSila);
  RegisterTest('train-zrecznosc', TestTrainZrecznosc);
  RegisterTest('train-madrosc', TestTrainMadrosc);
  RegisterTest('train-needs-pra', TestTrainNeedsPracticePoints);
  RegisterTest('train-caps-at-max', TestTrainCapsAtMaximum);
  RegisterTest('potwory-ranges', TestPotworyRanges);
  RegisterTest('tarcza-shield', TestTarczaAppliesShield);
  RegisterTest('tarcza-clamp', TestTarczaClampsAtZero);
  RegisterTest('walka-equal-stats', TestWalkaEqualStats);
  RegisterTest('walka-maxe-plus-one', TestWalkaMaxePlusOne);
  RegisterTest('walka-maxe-plus-three-overlap',
    TestWalkaMaxePlusThreeOverlap);
  RegisterTest('walka-maxe-plus-five', TestWalkaMaxePlusFive);
  RegisterTest('walka-maxe-plus-eleven', TestWalkaMaxePlusEleven);
  RegisterTest('walka-maxe-plus-twenty', TestWalkaMaxePlusTwenty);
  RegisterTest('walka-maxe-plus-twenty-nine',
    TestWalkaMaxePlusTwentyNine);
  RegisterTest('walka-maxe-plus-thirty-one',
    TestWalkaMaxePlusThirtyOne);
  RegisterTest('walka-maxe-band-adjustment',
    TestWalkaMaxeBandAdjustment);
  RegisterTest('walka-maxe-huge-adjustment',
    TestWalkaMaxeHugeAdjustment);
  RegisterTest('walka-maxe-minus-two', TestWalkaMaxeMinusTwo);
  RegisterTest('walka-maxe-minus-ten', TestWalkaMaxeMinusTen);
  RegisterTest('walka-maxe-minus-twenty-one',
    TestWalkaMaxeMinusTwentyOne);
  RegisterTest('walka-sil-plus-one', TestWalkaSilPlusOne);
  RegisterTest('walka-sil-plus-ten', TestWalkaSilPlusTen);
  RegisterTest('walka-sil-minus-one', TestWalkaSilMinusOne);
  RegisterTest('walka-sil-minus-ten', TestWalkaSilMinusTen);
  RegisterTest('walka-par-adjustments', TestWalkaParAdjustments);
  RegisterTest('walka-kop-adjustments', TestWalkaKopAdjustments);
  RegisterTest('walka-zre-plus-one', TestWalkaZrePlusOne);
  RegisterTest('walka-zre-plus-twelve', TestWalkaZrePlusTwelve);
  RegisterTest('walka-zre-minus-one', TestWalkaZreMinusOne);
  RegisterTest('walka-zre-minus-twelve', TestWalkaZreMinusTwelve);
  RegisterTest('walka-poisoned', TestWalkaPoisoned);
  RegisterTest('walka-fireball', TestWalkaFireball);
  RegisterTest('walka-poison', TestWalkaPoison);
  RegisterTest('walka-parry', TestWalkaParry);
  RegisterTest('walka-parry-light', TestWalkaParryLight);
  RegisterTest('walka-specials', TestWalkaSpecials);
  RegisterTest('walka-super-kop-hit', TestWalkaSuperKopHit);
  RegisterTest('walka-super-kop-hit-again',
    TestWalkaSuperKopHitAgain);
  RegisterTest('walka-super-kop-chybia',
    TestWalkaSuperKopChybia);
  RegisterTest('walka-flee', TestWalkaFlee);
  RegisterTest('walka-flee-chybia', TestWalkaFleeChybia);
  RegisterTest('walka-potrawki', TestWalkaPotrawki);
  RegisterTest('walka-death', TestWalkaDeath);
  RegisterTest('walka-fukroll', TestWalkaFukroll);
  RegisterTest('walka-dodge', TestWalkaDodge);
  RegisterTest('encounters', TestEncounters);
  RegisterTest('branie-pickup', TestBraniePicksUpSword);
  RegisterTest('branie-drop', TestBranieDropsSword);
  RegisterTest('branie-ignores-missing', TestBranieIgnoresMissingSword);
  RegisterTest('branie-pickup-items', TestBraniePicksUpBluszczItems);
  RegisterTest('branie-drop-items', TestBranieDropsBluszczItems);
  RegisterTest('uzywa-serce', TestUzywaSerce);
  RegisterTest('uzywa-serce-clamp', TestUzywaSerceClampsAtMaxE);
  RegisterTest('uzywa-komplet', TestUzywaKomplet);
  RegisterTest('uzywa-komplet-worn', TestUzywaKompletWorn);
  RegisterTest('uzywa-garnitur', TestUzywaGarnitur);
  RegisterTest('uzywa-butelka-many', TestUzywaButelkaMany);
  RegisterTest('uzywa-butelka-many-clamp',
    TestUzywaButelkaManyClampsAtMaxMana);
  RegisterTest('niszczy-przepustke', TestNiszczyPrzepustke);
  RegisterTest('patrz-przepustke', TestPatrzPrzepustke);
  RegisterTest('uzywa-dyplom', TestUzywaDyplom);
  RegisterTest('uzywa-paczek', TestUzywaPaczek);
  RegisterTest('uzywa-ciastko', TestUzywaCiastko);
  RegisterTest('uzywa-sucha-racja', TestUzywaSuchaRacja);
  RegisterTest('uzywa-bulka', TestUzywaBulka);
  RegisterTest('uzywa-chleb', TestUzywaChleb);
  RegisterTest('uzyja-weka', TestUzyjaWeka);
  RegisterTest('uzywa-bigos', TestUzywaBigos);
  RegisterTest('uzywa-pigulka-low', TestUzywaPigulkaLow);
  RegisterTest('uzywa-pigulka-mid', TestUzywaPigulkaMid);
  RegisterTest('uzywa-pigulka-high', TestUzywaPigulkaHigh);
  RegisterTest('zysk-garnitur', TestGarniturZyskInvariant);
  RegisterTest('zysk-pigulka', TestPigulkaZyskInvariant);
  RegisterTest('zysk-kaseta', TestKasetaZyskInvariant);
  RegisterTest('zysk-listek', TestListekZyskInvariant);
  RegisterTest('zysk-scrollpor', TestScrollPorZyskInvariant);
  RegisterTest('zysk-garnitur-gain', TestGarniturZyskGain);
  RegisterTest('zysk-pigulka-gain', TestPigulkaZyskGain);
  RegisterTest('zysk-kaseta-gain', TestKasetaZyskGain);
  RegisterTest('zysk-listek-gain', TestListekZyskGain);
  RegisterTest('zysk-scrollpor-gain',
    TestScrollPorZyskGain);
  RegisterTest('scena-messages', TestScenaMessages);
  RegisterTest('tlum-messages', TestTlumMessages);
  RegisterTest('kto-messages', TestKtoMessages);
  RegisterTest('ulsklep-messages', TestUlSklepMessages);
  RegisterTest('bluszcz-messages', TestBluszczMessages);
  RegisterTest('pierdoly-tlo', TestPierdolyTlo);
  RegisterTest('porownanie', TestPorownanie);
  RegisterTest('miniarena-slabo', TestMiniarenaSlabo);
  RegisterTest('miniarena-mniejslabo', TestMiniarenaMniejslabo);
  RegisterTest('miniarena-srednio', TestMiniarenaSrednio);
  RegisterTest('miniarena-trudno', TestMiniarenaTrudno);
  RegisterTest('miniarena-exit-nav', TestMiniarenaExitNav);
  RegisterTest('fightscena', TestFightscena);
  RegisterTest('fightbluszcz-zabij', TestFightbluszczZabij);
  RegisterTest('fightbluszcz-shop', TestFightbluszczShop);
  RegisterTest('fightbluszcz-duncan', TestFightbluszczDuncan);
  RegisterTest('porownanie-beasts', TestPorownanieBeasts);
  RegisterTest('porownanie-big-beasts', TestPorownanieBigBeasts);
  RegisterTest('porownanie-fighters', TestPorownanieFighters);
  RegisterTest('porownanie-drunks', TestPorownanieDrunks);
  RegisterTest('porownanie-musicians', TestPorownanieMusicians);
  RegisterTest('porownanie-bluszcz', TestPorownanieBluszcz);
  RegisterTest('porownanie-liroy-dogs', TestPorownanieLiroyAndDogs);
  RegisterTest('porownanie-bonuses-bakteria',
    TestPorownanieBonusesAndBakteria);
  RegisterTest('encounter-heart-veasy', TestEncounterHeartVeasy);
  RegisterTest('encounter-heart-easy', TestEncounterHeartEasy);
  RegisterTest('encounter-heart-neasy', TestEncounterHeartNeasy);
  RegisterTest('encounter-heart-trudno', TestEncounterHeartTrudno);
  RegisterTest('encounter-heart-btrudno', TestEncounterHeartBtrudno);
  RegisterTest('walka-potrawki-learn', TestWalkaPotrawkiLearn);
  RegisterTest('walka-parry-learn', TestWalkaParryLearn);
  RunTests;
end.
