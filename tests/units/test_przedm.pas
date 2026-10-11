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
  Room := 42;
  EnterTrance;
  CheckEqual(42, OuterRoom, 'MODE saves MIECHO into MIECHO2');
  CheckEqual(1000, Room, 'MODE switches MIECHO to 1000');
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
  Strength := 10; MaxStrength := 20; Practice := 10; Command := 'TRENUJ SILA';
  HandleTrain;
  CheckEqual(11, Strength, 'TRENUJ SILA raises SIL by one');
  CheckEqual(7, Practice, 'TRENUJ SILA spends three PRA');
end;

procedure TestTrainZrecznosc;
begin
  Dexterity := 10; MaxDexterity := 20; Practice := 10; Command := 'TRENUJ ZRECZNOSC';
  HandleTrain;
  CheckEqual(11, Dexterity, 'TRENUJ ZRECZNOSC raises ZRE by one');
  CheckEqual(8, Practice, 'TRENUJ ZRECZNOSC spends two PRA');
end;

procedure TestTrainMadrosc;
begin
  Wisdom := 10; MaxWisdom := 20; Practice := 10; Command := 'TRENUJ MADROSC';
  HandleTrain;
  CheckEqual(11, Wisdom, 'TRENUJ MADROSC raises MAD by one');
  CheckEqual(7, Practice, 'TRENUJ MADROSC spends three PRA');
end;

procedure TestTrainNeedsPracticePoints;
begin
  Strength := 10; MaxStrength := 20; Practice := 2; Command := 'TRENUJ SILA';
  HandleTrain;
  CheckEqual(10, Strength, 'TRENUJ SILA refuses with two PRA');
  CheckEqual(2, Practice, 'TRENUJ SILA spends nothing with two PRA');
end;

procedure TestTrainCapsAtMaximum;
begin
  Strength := 20; MaxStrength := 20; Practice := 10; Command := 'TRENUJ SILA';
  HandleTrain;
  CheckEqual(20, Strength, 'TRENUJ SILA stops at MAXSIL');
  CheckEqual(10, Practice, 'TRENUJ SILA spends nothing at MAXSIL');
end;

procedure TestPotworyRanges;
begin
  SpawnMonsters;
  { Random(38) + 20 redrawn until above 32: [33, 57]. }
  CheckRange('BAKTERIA', Bacterium, 33, 57);
  CheckRange('SLIMAK', Snail, 33, 57);
  CheckRange('ZUK', Beetle, 33, 57);
  CheckRange('KARALUCH', Cockroach, 33, 57);
  CheckRange('MROWKA', Ant, 33, 57);
  CheckRange('PAJAK', Spider, 33, 57);
  CheckRange('DZIK', Boar, 33, 57);
  CheckRange('LIS', Fox, 33, 57);
  CheckRange('SZCZUR', Rat, 33, 57);
  CheckRange('KUROPATWA', Partridge, 33, 57);
  CheckRange('SARNA', Deer, 33, 57);
  CheckRange('ORZEL', Eagle, 33, 57);
  CheckRange('ZAJAC', Hare, 33, 57);
  CheckRange('WILCZUR', Mongrel, 33, 57);
  CheckRange('KORNIK', Woodworm, 33, 57);
  CheckRange('MUCHA', Fly, 33, 57);
  CheckRange('SLON', Elephant, 33, 57);
  CheckRange('LEW', Lion, 33, 57);
  CheckRange('ZYRAFA', Giraffe, 33, 57);
  CheckRange('WIELBLAD', Camel, 33, 57);
  CheckRange('STRUS', Ostrich, 33, 57);
  CheckRange('BOA', Boa, 33, 57);
  CheckRange('WILK', Wolf, 33, 57);
  CheckRange('BIZON', Bison, 33, 57);
  CheckRange('PANTERA', Panther, 33, 57);
  CheckRange('GLADIATOR', Gladiator, 33, 57);
  CheckRange('WOJOWNIK', Warrior, 33, 57);
  CheckRange('TRENER', Tamer, 33, 57);
  { Random(7) + 60 redrawn until above 60: [61, 66]. }
  CheckRange('DZIECKO', Kid, 61, 66);
  CheckRange('REPORTER', Reporter, 61, 66);
  { Random(8) + 60 redrawn until above 60: [61, 67]. }
  CheckRange('WARIAT', Lunatic, 61, 67);
  CheckRange('SLUCHACZ', Listener, 61, 67);
  CheckRange('FAN', Fan, 61, 67);
  CheckRange('CZLOWIEK', Man, 61, 67);
  CheckRange('DZIADEK', OldMan, 61, 67);
  { Random(9) + 60 redrawn until above 60: [61, 68]. }
  CheckRange('POLICJANT', Policeman, 61, 68);
  CheckRange('OCHRONIARZ', Bouncer, 61, 68);
  CheckRange('GORYL', Gorilla, 61, 68);
  { Random(3) + 70, drawn once: [70, 72]. }
  CheckRange('GITARZYSTA', Guitarist, 70, 72);
  CheckRange('PERKUSISTA', Drummer, 70, 72);
  CheckRange('ORGANISTA', Keyboardist, 70, 72);
  CheckRange('LIROY', Liroy, 70, 72);
  { Fixed constants from POTWORY. }
  CheckEqual(67, Minibarman, 'MINIBARMAN is 67');
  CheckEqual(67, Fatso, 'GRUBAS is 67');
  CheckEqual(69, DJ, 'DJ is 69');
  CheckEqual(76, Pedal, 'PEDAL is 76');
  CheckEqual(76, Couple, 'PARA is 76');
  CheckEqual(76, Maciek, 'MACIEK is 76');
  CheckEqual(1, Door, 'DRZWI is 1');
  CheckEqual(1, OldElf, 'STARUCH is 1');
  { Random(7) + 20, condition always true: [20, 26]. }
  CheckRange('JAMNIK', Dachshund, 20, 26);
  CheckRange('OWCZAREK', Shepherd, 20, 26);
  CheckRange('PIESEK', Pooch, 20, 26);
  CheckRange('SPANIEL', Spaniel, 20, 26);
  CheckRange('PUDEL', Poodle, 20, 26);
  CheckRange('TAKSOWKARZ', Cabman, 20, 26);
  CheckRange('SPRZEDAWCA', Vendor, 20, 26);
  CheckRange('ZAMIATACZ', Sweeper, 20, 26);
  CheckRange('PIJAK', Drunkard, 20, 26);
  CheckRange('ZEBRAK', SickMan, 20, 26);
  { Random(8) + 77 redrawn until below 84: [77, 83]. }
  CheckRange('SZCZAW', Sorrel, 77, 83);
  CheckRange('STOKROTKA', Daisy, 77, 83);
  CheckRange('KONICZYNKA', Clover, 77, 83);
  CheckRange('MLECZ', SowThistle, 77, 83);
  CheckRange('DMUCHAWIEC', Dandelion, 77, 83);
  CheckRange('ROZA', Rose, 77, 83);
  CheckRange('OSET', Thistle, 77, 83);
  CheckRange('MALINA', Raspberry, 77, 83);
  { Random(8) + 77, not in the until condition: [77, 84]. }
  CheckRange('AGREST', Gooseberry, 77, 84);
  CheckRange('JEZYNA', Blackberry, 77, 84);
  CheckRange('TRAWA', Grass, 77, 84);
  CheckRange('DUNCAN', Duncan, 77, 84);
end;

procedure TestTarczaAppliesShield;
begin
  { PRO at 100 forces the Random(100) roll to succeed. }
  Damage := 50; WornCount := 30; Armor := 100;
  ShieldBlock;
  CheckEqual(20, Damage, 'TARCZA subtracts ILOSC from WPYSK');
end;

procedure TestTarczaClampsAtZero;
begin
  Damage := 10; WornCount := 30; Armor := 100;
  ShieldBlock;
  CheckEqual(0, Damage, 'TARCZA clamps WPYSK at zero');
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
  Energy := 100;
  Parry := aPar;
  Kick := aKop;
  KickMinMana := 0;
  KickMaxEnergy := 0;
  Mana := 0;
  FireballCharges := 0;
  PoisonCharges := 0;
  PoisonRounds := 0;
  Fleeing := 0;
  FleeEnergy := 0;
  Fled := 0;
  Experience := 0;
  LuckRoll := 0;
  Armor := 0;
  WornCount := 0;
  MaxEnergy := aMaxE;
  EnemyEnergy := aWrogE;
  Strength := aSil;
  EnemyStrength := aWrogSil;
  Dexterity := aZre;
  EnemyDexterity := aWrogZre;
end;

procedure RunWalka(aMaxE, aWrogE, aSil, aWrogSil,
  aZre, aWrogZre, aPar, aKop: Integer;
  ExpectedKunszt: Longint; const What: string);
begin
  WalkaSetup(aMaxE, aWrogE, aSil, aWrogSil,
    aZre, aWrogZre, aPar, aKop);
  Fight;
  CheckEqual(ExpectedKunszt, Experience, What);
end;

procedure RunWalkaRange(aMaxE, aWrogE, aSil, aWrogSil,
  aZre, aWrogZre, aPar, aKop: Integer;
  KunsztLo, KunsztHi: Longint; const What: string);
begin
  WalkaSetup(aMaxE, aWrogE, aSil, aWrogSil,
    aZre, aWrogZre, aPar, aKop);
  Fight;
  CheckRange(What, Experience, KunsztLo, KunsztHi);
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
  PoisonRounds := 10;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy while poisoned');
  CheckTrue(Energy > 0, 'WALKA survives the poison damage');
end;

procedure TestWalkaFireball;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  FireballCharges := 1;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy under fireball');
  CheckTrue((FireballCharges = 0) or (FireballCharges = 1),
    'WALKA spends the fireball or keeps it');
end;

procedure TestWalkaPoison;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  PoisonCharges := 1;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy under poison');
  CheckTrue((PoisonCharges = 0) or (PoisonCharges = 1),
    'WALKA spends the poison or keeps it');
end;

procedure TestWalkaParry;
begin
  WalkaSetup(0, 0, 1, 20, 10, 10, 139, 0);
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy through parry');
  CheckTrue(Energy > 0, 'WALKA survives the parried attack');
end;

procedure TestWalkaParryLight;
begin
  WalkaSetup(0, 10, 3, 3, 10, 10, 139, 0);
  Energy := 10000;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy through light parry');
  CheckTrue(Energy > 0, 'WALKA survives the light parry');
end;

procedure TestWalkaSpecials;
begin
  WalkaSetup(0, 20, 3, 20, 10, 10, 139, 0);
  Energy := 10000;
  FireballCharges := 1;
  PoisonCharges := 1;
  PoisonRounds := 10;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy in the long fight');
  CheckTrue(Energy > 0, 'WALKA survives the long fight');
end;

procedure TestWalkaSuperKopHit;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 100);
  Mana := 100; KickMaxEnergy := 100; Energy := 50;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy with the super kop');
  CheckTrue(Mana < 100, 'WALKA spends mana on the super kop');
end;

procedure TestWalkaSuperKopHitAgain;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 100);
  Mana := 100; KickMaxEnergy := 100; Energy := 50;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy with the kop again');
  CheckTrue(Mana < 100, 'WALKA spends mana on the kop again');
end;

procedure TestWalkaSuperKopChybia;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 11);
  Mana := 100; KickMaxEnergy := 100; Energy := 50;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy when the kop misses');
  CheckTrue(Mana < 100, 'WALKA spends mana on the kop attempt');
end;

procedure TestWalkaFlee;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Fleeing := 100; FleeEnergy := 100; Energy := 50; Mana := 100;
  Fight;
  CheckTrue(Fled = 1, 'WALKA flees the battle');
end;

procedure TestWalkaFleeChybia;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Fleeing := 1; FleeEnergy := 100; Energy := 50; Mana := 100;
  Fight;
  CheckTrue(EnemyEnergy < 1,
    'WALKA finishes the enemy when the flee fails');
end;

procedure TestWalkaPotrawki;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  Cooking := 99; Bigos := 50; ItemCount := 0;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the enemy for the potrawki');
  CheckTrue((ItemCount = 0) or (ItemCount = 1),
    'WALKA cooks the bigos or not');
end;

procedure TestWalkaDeath;
begin
  WalkaSetup(0, 0, 1, 61, 10, 10, 0, 0);
  Energy := 1;
  Fight;
  CheckTrue((Energy < 1) or (EnemyEnergy < 1),
    'WALKA ends the fight by death or victory');
end;

procedure TestWalkaFukroll;
begin
  WalkaSetup(0, 10, 2, 1, 10, 10, 0, 0);
  LuckRoll := 1;
  Fight;
  CheckTrue(EnemyEnergy < 1,
    'WALKA defeats the enemy through the fukroll');
end;

procedure EncounterSetup;
begin
  WalkaSetup(127, 0, 127, 1, 127, 1, 0, 0);
  SmallShield := 0; Cooking := 0; FireballCharges := 0; PoisonCharges := 0;
  PoisonRounds := 0; Heart := 0;
end;

procedure TestEncounters;
begin
  EncounterSetup;
  Command := 'ZABIJ MROWKA';
  FightWeak;
  CheckTrue(EnemyEnergy < 1, 'SLABO defeats the mrowka');
  EncounterSetup;
  FightDog;
  CheckTrue(EnemyEnergy < 1, 'WALKAPIES defeats the pies');
  EncounterSetup;
  FightWeakish;
  CheckTrue(EnemyEnergy < 1, 'MNIEJSLABO defeats the enemy');
  EncounterSetup;
  FightMedium;
  CheckTrue(EnemyEnergy < 1, 'SREDNIO defeats the enemy');
  EncounterSetup;
  FightHard;
  CheckTrue(EnemyEnergy < 1, 'TRUDNO defeats the enemy');
  EncounterSetup;
  FightVeryEasy;
  CheckTrue((EnemyEnergy < 1) and (Energy > 0),
    'VEASY defeats the enemy and survives');
  EncounterSetup;
  FightEasy;
  CheckTrue((EnemyEnergy < 1) and (Energy > 0),
    'EASY defeats the enemy and survives');
  EncounterSetup;
  FightNotEasy;
  CheckTrue((EnemyEnergy < 1) and (Energy > 0),
    'NEASY defeats the enemy and survives');
  EncounterSetup;
  FightVeryHard;
  CheckTrue(EnemyEnergy < 1, 'BTRUDNO defeats the enemy');
end;

procedure TestWalkaDodge;
begin
  WalkaSetup(0, 30, 3, 1, 0, 2, 0, 0);
  Energy := 100;
  Fight;
  CheckTrue(EnemyEnergy < 1, 'WALKA defeats the dodging enemy');
  CheckTrue(Energy > 0, 'WALKA survives the dodged combat');
end;

procedure TestBraniePicksUpSword;
begin
  OuterRoom := 7; OldSword := 7; ItemCount := 0; Command := 'BIERZ STARY';
  TakeDrop;
  CheckEqual(-10, OldSword, 'BIERZ STARY stores the sword as -10');
  CheckEqual(1, ItemCount, 'BIERZ STARY counts one item');
end;

procedure TestBranieDropsSword;
begin
  OuterRoom := 7; OldSword := -10; ItemCount := 1; Command := 'ODRZUC STARY';
  TakeDrop;
  CheckEqual(7, OldSword, 'ODRZUC STARY restores the sword marker');
  CheckEqual(0, ItemCount, 'ODRZUC STARY uncounts the item');
end;

procedure TestBranieIgnoresMissingSword;
begin
  OuterRoom := 7; OldSword := 0; ItemCount := 0; Command := 'BIERZ STARY';
  TakeDrop;
  CheckEqual(0, OldSword, 'BIERZ STARY needs the sword marker');
  CheckEqual(0, ItemCount, 'BIERZ STARY counts nothing without the sword');
end;

procedure TestBraniePicksUpBluszczItems;
begin
  OuterRoom := 7;
  SmallShield := 7; Heart := 7; Diploma := 7; Pipe := 7;
  ItemCount := 0; Wisdom := 0; MaxWisdom := 5; MaxEnergy := 50;
  Command := 'BIERZ MALA'; TakeDrop;
  Command := 'BIERZ SERCE'; TakeDrop;
  Command := 'BIERZ DYPLOM'; TakeDrop;
  Command := 'BIERZ FAJKA'; TakeDrop;
  CheckEqual(-10, SmallShield, 'BIERZ MALA stores the shield as -10');
  CheckEqual(-10, Heart, 'BIERZ SERCE stores the heart as -10');
  CheckEqual(-10, Diploma, 'BIERZ DYPLOM stores the diploma as -10');
  CheckEqual(-10, Pipe, 'BIERZ FAJKA stores the pipe as -10');
  CheckEqual(4, ItemCount, 'four BRANIE picks count four items');
  CheckEqual(55, MaxEnergy, 'BIERZ DYPLOM adds five max energy');
  CheckEqual(1, Wisdom, 'BIERZ FAJKA adds one wisdom under the cap');
end;

procedure TestBranieDropsBluszczItems;
begin
  OuterRoom := 7;
  SmallShield := -10; Heart := -10; Diploma := -10; Pipe := -10;
  ItemCount := 4; Wisdom := 1; MaxEnergy := 55;
  Command := 'ODRZUC FAJKA'; TakeDrop;
  Command := 'ODRZUC MALA'; TakeDrop;
  Command := 'ODRZUC SERCE'; TakeDrop;
  Command := 'ODRZUC DYPLOM'; TakeDrop;
  CheckEqual(7, SmallShield, 'ODRZUC MALA restores the shield marker');
  CheckEqual(7, Heart, 'ODRZUC SERCE restores the heart marker');
  CheckEqual(7, Diploma, 'ODRZUC DYPLOM restores the diploma marker');
  CheckEqual(7, Pipe, 'ODRZUC FAJKA restores the pipe marker');
  CheckEqual(0, ItemCount, 'four ODRZUC drops uncount four items');
  CheckEqual(50, MaxEnergy, 'ODRZUC DYPLOM removes five max energy');
  CheckEqual(0, Wisdom, 'ODRZUC FAJKA removes one wisdom');
end;

procedure TestUzywaSerce;
begin
  Heart := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ SERCE';
  UseItems;
  CheckEqual(0, Heart, 'UZYJ SERCE consumes the heart');
  CheckEqual(15, Energy, 'UZYJ SERCE restores five energy');
  CheckEqual(0, ItemCount, 'UZYJ SERCE uncounts the item');
end;

procedure TestUzywaSerceClampsAtMaxE;
begin
  Heart := -10; Energy := 48; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ SERCE';
  UseItems;
  CheckEqual(50, Energy, 'UZYJ SERCE clamps energy at MAXE');
end;

procedure TestUzywaKomplet;
begin
  Tracksuit := -10; WornGarment := ''; Armor := 0; Wearing := 0;
  Command := 'UZYJ KOMPLET';
  UseItems;
  CheckEqual(7, Armor, 'UZYJ KOMPLET adds seven defense');
  CheckEqual(1, Wearing, 'UZYJ KOMPLET marks the body dressed');
  CheckStrEqual('SYF', WornGarment, 'UZYJ KOMPLET remembers the suit');
  Command := 'ODLORZ KOMPLET';
  UseItems;
  CheckEqual(0, Armor, 'ODLORZ KOMPLET removes the defense');
  CheckEqual(0, Wearing, 'ODLORZ KOMPLET marks the body bare');
  CheckStrEqual('', WornGarment, 'ODLORZ KOMPLET forgets the suit');
end;

procedure TestUzywaKompletWorn;
begin
  Tracksuit := -10; WornGarment := 'SYF'; Armor := 0; Wearing := 1;
  Command := 'UZYJ KOMPLET';
  UseItems;
  CheckEqual(0, Armor, 'UZYJ KOMPLET refuses while a suit is worn');
  CheckEqual(1, Wearing, 'UZYJ KOMPLET keeps the body dressed');
  CheckStrEqual('SYF', WornGarment, 'UZYJ KOMPLET keeps the worn suit');
end;

procedure TestUzywaGarnitur;
begin
  SpikedSuit := -10; WornGarment := ''; WornCount := 0; Armor := 0; LuckRoll := 0;
  Command := 'UZYJ GARNITUR';
  UseItems;
  CheckEqual(10, Armor, 'UZYJ GARNITUR adds ten defense');
  CheckEqual(1, WornCount, 'UZYJ GARNITUR counts one armor layer');
  CheckEqual(15, LuckRoll, 'UZYJ GARNITUR adds fifteen resistance');
  CheckStrEqual('GARNITUR', WornGarment, 'UZYJ GARNITUR remembers the suit');
  Command := 'ODLORZ GARNITUR';
  UseItems;
  CheckEqual(0, Armor, 'ODLORZ GARNITUR removes the defense');
  CheckEqual(0, WornCount, 'ODLORZ GARNITUR uncounts the armor layer');
  CheckEqual(0, LuckRoll, 'ODLORZ GARNITUR removes the resistance');
  CheckStrEqual('', WornGarment, 'ODLORZ GARNITUR forgets the suit');
end;

procedure TestUzywaButelkaMany;
begin
  ManaBottle := -10; Mana := 10; MaxMana := 50; ItemCount := 1;
  Command := 'UZYJ MALA BUTELKA MANY';
  UseItems;
  CheckEqual(40, Mana, 'UZYJ MALA BUTELKA MANY restores thirty mana');
  CheckEqual(0, ItemCount, 'UZYJ MALA BUTELKA MANY uncounts the item');
end;

procedure TestUzywaButelkaManyClampsAtMaxMana;
begin
  ManaBottle := -10; Mana := 45; MaxMana := 50; ItemCount := 1;
  Command := 'UZYJ MALA BUTELKA MANY';
  UseItems;
  CheckEqual(50, Mana, 'UZYJ MALA BUTELKA MANY clamps mana at MAXMANA');
end;

procedure TestNiszczyPrzepustke;
begin
  Permit := -10; ItemCount := 0; Command := 'ZNISZCZ PRZEPUSTKA';
  UseItems;
  CheckEqual(0, Permit, 'ZNISZCZ PRZEPUSTKA burns the pass');
  CheckEqual(1, ItemCount, 'ZNISZCZ PRZEPUSTKA counts one item');
end;

procedure TestPatrzPrzepustke;
begin
  Permit := -10; ItemCount := 0; Command := 'PATRZ PRZEPUSTKA';
  UseItems;
  CheckEqual(-10, Permit, 'PATRZ PRZEPUSTKA keeps the pass');
  CheckEqual(0, ItemCount, 'PATRZ PRZEPUSTKA counts nothing');
end;

procedure TestUzywaDyplom;
begin
  Diploma := -10; Command := 'UZYJ DYPLOM';
  UseItems;
  CheckEqual(-10, Diploma, 'UZYJ DYPLOM keeps the diploma');
end;

procedure TestUzywaPaczek;
begin
  Doughnut := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ PACZEK';
  UseItems;
  CheckEqual(0, Doughnut, 'UZYJ PACZEK consumes the paczek');
  CheckEqual(18, Energy, 'UZYJ PACZEK restores eight energy');
  CheckEqual(0, ItemCount, 'UZYJ PACZEK uncounts the item');
end;

procedure TestUzywaCiastko;
begin
  Cookie := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ CIASTKO';
  UseItems;
  CheckEqual(0, Cookie, 'UZYJ CIASTKO consumes the ciastko');
  CheckEqual(22, Energy, 'UZYJ CIASTKO restores twelve energy');
end;

procedure TestUzywaSuchaRacja;
begin
  DryRation := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ SUCHA RACJA';
  UseItems;
  CheckEqual(0, DryRation, 'UZYJ SUCHA RACJA consumes the racja');
  CheckEqual(26, Energy, 'UZYJ SUCHA RACJA restores sixteen energy');
end;

procedure TestUzywaBulka;
begin
  BreadRoll := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ BULKA';
  UseItems;
  CheckEqual(0, BreadRoll, 'UZYJ BULKA consumes the bulka');
  CheckEqual(30, Energy, 'UZYJ BULKA restores twenty energy');
end;

procedure TestUzywaChleb;
begin
  Bread := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ CHLEB';
  UseItems;
  CheckEqual(0, Bread, 'UZYJ CHLEB consumes the chleb');
  CheckEqual(36, Energy, 'UZYJ CHLEB restores twenty-six energy');
end;

procedure TestUzyjaWeka;
begin
  Sausage := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ WEKA';
  UseItems;
  CheckEqual(0, Sausage, 'UZYJ WEKA consumes the weka');
  CheckEqual(44, Energy, 'UZYJ WEKA restores thirty-four energy');
end;

procedure TestUzywaBigos;
begin
  Bigos := -10; Energy := 10; MaxEnergy := 50; ItemCount := 1;
  Command := 'UZYJ BIGOS';
  UseItems;
  CheckEqual(0, Bigos, 'UZYJ BIGOS consumes the bigos');
  CheckEqual(30, Energy, 'UZYJ BIGOS restores twenty energy');
end;

procedure TestUzywaPigulkaLow;
begin
  TeleportPill := -10; Wisdom := 5; MaxEnergy := 50; Energy := 40; Experience := 100;
  Command := 'UZYJ PIGULKA';
  UseItems;
  CheckEqual(0, TeleportPill, 'UZYJ PIGULKA consumes the pigulka');
  CheckEqual(1, Energy, 'UZYJ PIGULKA with low MAD drains energy to one');
  CheckEqual(49, MaxEnergy, 'UZYJ PIGULKA with low MAD lowers max energy');
  CheckEqual(50, Experience, 'UZYJ PIGULKA with low MAD lowers kunszt');
end;

procedure TestUzywaPigulkaMid;
begin
  TeleportPill := -10; Wisdom := 12; Energy := 100; Experience := 100;
  Command := 'UZYJ PIGULKA';
  UseItems;
  CheckEqual(60, Energy, 'UZYJ PIGULKA with mid MAD drains forty energy');
  CheckEqual(70, Experience, 'UZYJ PIGULKA with mid MAD lowers kunszt');
end;

procedure TestUzywaPigulkaHigh;
begin
  TeleportPill := -10; Wisdom := 20; Energy := 100; Experience := 100;
  Command := 'UZYJ PIGULKA';
  UseItems;
  CheckEqual(0, TeleportPill, 'UZYJ PIGULKA with high MAD consumes the pigulka');
  CheckEqual(100, Energy, 'UZYJ PIGULKA with high MAD keeps energy');
  CheckEqual(100, Experience, 'UZYJ PIGULKA with high MAD keeps kunszt');
end;

procedure TestGarniturZyskInvariant;
begin
  SpikedSuit := 50; ItemCount := 0;
  SuitGain;
  CheckTrue((SpikedSuit = 50) or (SpikedSuit = 40),
    'GARNITURZYSK drops GARNITUR by ten or not at all');
  CheckTrue((ItemCount = 0) or (ItemCount = 1),
    'GARNITURZYSK counts at most one item');
end;

procedure TestPigulkaZyskInvariant;
begin
  TeleportPill := 50; ItemCount := 0;
  PillGain;
  CheckTrue((TeleportPill = 50) or (TeleportPill = 40),
    'PIGULKAZYSK drops PIGULKA by ten or not at all');
  CheckTrue((ItemCount = 0) or (ItemCount = 1),
    'PIGULKAZYSK counts at most one item');
end;

procedure TestKasetaZyskInvariant;
begin
  Cassette := 50; MaxEnergy := 0; Armor := 0; ItemCount := 0; Dexterity := 0;
  Room := 20;
  CassetteGain;
  CheckTrue((Cassette = 50) or (Cassette = 40),
    'KASETAZYSK drops the cassette by ten or not at all');
  CheckTrue((MaxEnergy = 0) or (MaxEnergy = 5),
    'KASETAZYSK raises MAXE by five or not at all');
  CheckTrue((Armor = 0) or (Armor = -8),
    'KASETAZYSK lowers PRO by eight or not at all');
  CheckTrue((ItemCount = 0) or (ItemCount = 1),
    'KASETAZYSK counts at most one item');
  CheckTrue((Dexterity = 0) or (Dexterity = 1),
    'KASETAZYSK raises ZRE by one or not at all');
end;

procedure TestListekZyskInvariant;
begin
  LuckyLeaf := 50; ItemCount := 0; MaxMana := 0; Room := 20;
  LeafGain;
  CheckTrue((LuckyLeaf = 50) or (LuckyLeaf = 40),
    'LISTEKZYSK drops the leaf by ten or not at all');
  CheckTrue((ItemCount = 0) or (ItemCount = 1),
    'LISTEKZYSK counts at most one item');
  CheckTrue((MaxMana = 0) or (MaxMana = 40),
    'LISTEKZYSK raises MAXMANA by forty or not at all');
end;

procedure TestScrollPorZyskInvariant;
begin
  CompareScroll := 50; ItemCount := 0; Room := 20;
  ScrollGain;
  CheckTrue((CompareScroll = 50) or (CompareScroll = 40),
    'SCROLLPORZYSK drops the scroll by ten or not at all');
  CheckTrue((ItemCount = 0) or (ItemCount = 1),
    'SCROLLPORZYSK counts at most one item');
end;

{ The rare-gain branches of the loot procedures only
  trigger on a low Random roll, so the tests repeat
  the procedure until the first gain, which makes the
  result a single deterministic gain. }

procedure TestGarniturZyskGain;
var i: Integer;
begin
  SpikedSuit := 100; ItemCount := 0;
  i := 0;
  while (ItemCount = 0) and (i < 2000) do begin
    SuitGain;
    i := i + 1;
  end;
  CheckTrue(ItemCount > 0, 'GARNITURZYSK gains the suit');
  CheckEqual(90, SpikedSuit,
    'GARNITURZYSK drops GARNITUR by ten');
end;

procedure TestPigulkaZyskGain;
var i: Integer;
begin
  TeleportPill := 100; ItemCount := 0;
  i := 0;
  while (ItemCount = 0) and (i < 2000) do begin
    PillGain;
    i := i + 1;
  end;
  CheckTrue(ItemCount > 0, 'PIGULKAZYSK gains the pill');
  CheckEqual(90, TeleportPill,
    'PIGULKAZYSK drops PIGULKA by ten');
end;

procedure TestKasetaZyskGain;
var i: Integer;
begin
  Cassette := 100; MaxEnergy := 0; Armor := 0; ItemCount := 0;
  Dexterity := 0; Room := 20;
  i := 0;
  while (ItemCount = 0) and (i < 2000) do begin
    CassetteGain;
    i := i + 1;
  end;
  CheckTrue(ItemCount > 0, 'KASETAZYSK gains the cassette');
  CheckEqual(90, Cassette,
    'KASETAZYSK drops the cassette by ten');
  CheckEqual(5, MaxEnergy, 'KASETAZYSK raises MAXE by five');
  CheckEqual(-8, Armor, 'KASETAZYSK lowers PRO by eight');
  CheckEqual(1, Dexterity, 'KASETAZYSK raises ZRE by one');
end;

procedure TestListekZyskGain;
var i: Integer;
begin
  LuckyLeaf := 100; ItemCount := 0; MaxMana := 0; Room := 20;
  i := 0;
  while (ItemCount = 0) and (i < 2000) do begin
    LeafGain;
    i := i + 1;
  end;
  CheckTrue(ItemCount > 0, 'LISTEKZYSK gains the leaf');
  CheckEqual(90, LuckyLeaf,
    'LISTEKZYSK drops the leaf by ten');
  CheckEqual(40, MaxMana,
    'LISTEKZYSK raises MAXMANA by forty');
end;

procedure TestScrollPorZyskGain;
var i: Integer;
begin
  CompareScroll := 100; ItemCount := 0; Room := 20;
  i := 0;
  while (ItemCount = 0) and (i < 2000) do begin
    ScrollGain;
    i := i + 1;
  end;
  CheckTrue(ItemCount > 0, 'SCROLLPORZYSK gains the scroll');
  CheckEqual(90, CompareScroll,
    'SCROLLPORZYSK drops the scroll by ten');
end;

procedure TestScenaMessages;
begin
  Room := 1;
  Guitarist := 1; Drummer := 1; Keyboardist := 1; Liroy := 1;
  DescribeStage;
  CheckEqual(1, Room, 'SCENA leaves MIECHO unchanged');
end;

procedure TestTlumMessages;
begin
  Room := 1;
  Kid := 1; Lunatic := 1; Listener := 1; Fan := 1;
  Man := 1; Policeman := 1; Bouncer := 1; Gorilla := 1;
  OldMan := 1; Reporter := 1;
  DescribeCrowd;
  CheckEqual(1, Room, 'TLUM leaves MIECHO unchanged');
end;

procedure TestKtoMessages;
begin
  Room := 1;
  Woodworm := 1; Fly := 1; Bacterium := 1; Snail := 1; Beetle := 1;
  Cockroach := 1; Ant := 1; Spider := 1; Boar := 1; Rat := 1;
  Fox := 1; Partridge := 1; Hare := 1; Mongrel := 1; Eagle := 1;
  Deer := 1; Elephant := 1; Lion := 1; Giraffe := 1; Camel := 1;
  Ostrich := 1; Boa := 1; Wolf := 1; Bison := 1; Panther := 1;
  Gladiator := 1; Warrior := 1; Tamer := 1;
  DescribeBeasts;
  CheckEqual(1, Room, 'KTO leaves MIECHO unchanged');
end;

procedure TestUlSklepMessages;
begin
  Room := 1;
  Dachshund := 1; Shepherd := 1; Pooch := 1;
  Spaniel := 1; Poodle := 1;
  Cabman := 1; Vendor := 1;
  Sweeper := 1; Drunkard := 1; SickMan := 1;
  DescribeStreet;
  CheckEqual(1, Room, 'ULSKLEPIKOWA leaves MIECHO unchanged');
end;

procedure TestBluszczMessages;
begin
  Room := 1;
  Sorrel := 1; Daisy := 1; Clover := 1; SowThistle := 1;
  Dandelion := 1; Rose := 1; Thistle := 1; Blackberry := 1;
  Gooseberry := 1; Raspberry := 1; Grass := 1; Duncan := 1;
  DescribePlants;
  CheckEqual(1, Room, 'BLUSZCZ leaves MIECHO unchanged');
end;

procedure TestPierdolyTlo;
begin
  FeedStdin('1');
  Command := 'ZMIEN TLO';
  DisplayPrefs;
end;

procedure TestPorownanie;
begin
  Mana := 10;
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
  Bacterium := 33; Snail := 33; Woodworm := 33; Fly := 33;
  Beetle := 33; Cockroach := 33; Ant := 33; Spider := 33;
  Boar := 33; Mongrel := 33; Rat := 33; Fox := 33;
  Partridge := 33; Hare := 33; Eagle := 33; Deer := 33;
  Elephant := 33; Lion := 33; Giraffe := 33; Wolf := 33;
  Camel := 33; Ostrich := 33; Boa := 33; Bison := 33;
  Panther := 33; Gladiator := 33; Warrior := 33; Tamer := 33;
  Room := 33;
  Strength := 127; Dexterity := 127; Energy := 30000; Fled := 0;
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
  Room := miechoVal;
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
  Room := 100;
  Drummer := 100; Guitarist := 100; Keyboardist := 100;
  Liroy := 100; Duncan := 100;
  Sorrel := 100; Daisy := 100; Clover := 100;
  SowThistle := 100; Dandelion := 100; Rose := 100;
  Thistle := 100; Raspberry := 100; Gooseberry := 100;
  Blackberry := 100; Grass := 100;
  Strength := 127; Dexterity := 127; Energy := 30000; Fled := 0;
  DuncanQuest := 0; Money := 10000; Permit := 100;
  Backpack := 100; Quest := 0; Experience := 0;
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
  DuncanQuest := 0;
  Command := 'ROZMAWIAJ DUNCAN'; PlantFights;
  DuncanQuest := -125;
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
  Mana := 10; Level := aPoziom; Strength := aSil; Dexterity := aZre;
  Parry := aPar; Kick := aKop;
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
  CheckEqual(30, Strength, 'POROWNANIE leaves the last SIL in place');
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
  Mana := 10;
  CompareFoe;
  CheckEqual(15, Mana, 'BAKTERIA restores five mana');
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
  Heart := 0;
  Energy := 30000; Strength := 127; Dexterity := 127; Fled := 0;
  Fleeing := 0; FleeEnergy := 0; Mana := 0; FireballCharges := 0;
  PoisonCharges := 0; PoisonRounds := 0; Kick := 0; KickMinMana := 0;
  KickMaxEnergy := 0; Armor := 0; WornCount := 0; LuckRoll := 0;
  ItemCount := 0;
end;

procedure TestEncounterHeartVeasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if Heart = 0 then FightVeryEasy;
  CheckEqual(-10, Heart, 'VEASY eventually drops the heart');
end;

procedure TestEncounterHeartEasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if Heart = 0 then FightEasy;
  CheckEqual(-10, Heart, 'EASY eventually drops the heart');
end;

procedure TestEncounterHeartNeasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if Heart = 0 then FightNotEasy;
  CheckEqual(-10, Heart, 'NEASY eventually drops the heart');
end;

procedure TestEncounterHeartTrudno;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 110 do
    if Heart = 0 then FightHard;
  CheckEqual(-10, Heart, 'TRUDNO eventually drops the heart');
end;

procedure TestEncounterHeartBtrudno;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 150 do
    if Heart = 0 then FightVeryHard;
  CheckEqual(-10, Heart, 'BTRUDNO eventually drops the heart');
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
    Energy := 100; Cooking := 1; Bigos := 0;
    Fight;
    if Cooking > 1 then
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
    Energy := 30000;
    Fight;
    if Parry > 99 then
      Break;
  end;
  CheckTrue(Parry > 99, 'WALKA eventually teaches the parry skill');
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
