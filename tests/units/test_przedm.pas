program test_przedm;
{Unit tests for PRZEDM: the deterministic procedures
(state machines, stat arithmetic, item handling,
combat stat arithmetic). Each test sets up the
PRZEDM globals it reads, so the tests are
order-independent and safe to run one per process.}
uses pastest, MONSTRA, PRZEDM;

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
  MIECHO := 42;
  MODE;
  CheckEqual(42, MIECHO2, 'MODE saves MIECHO into MIECHO2');
  CheckEqual(1000, MIECHO, 'MODE switches MIECHO to 1000');
end;

procedure TestKomendy;
begin
  wpisz := 'PN'; KOMENDY;
  CheckStrEqual('POLNOC', wpisz, 'PN expands to POLNOC');
  wpisz := 'PD'; KOMENDY;
  CheckStrEqual('POLODNIE', wpisz, 'PD expands to POLODNIE');
  wpisz := 'W'; KOMENDY;
  CheckStrEqual('WSCHOD', wpisz, 'W expands to WSCHOD');
  wpisz := 'Z'; KOMENDY;
  CheckStrEqual('ZACHOD', wpisz, 'Z expands to ZACHOD');
  wpisz := 'G'; KOMENDY;
  CheckStrEqual('GORA', wpisz, 'G expands to GORA');
  wpisz := 'D'; KOMENDY;
  CheckStrEqual('DOL', wpisz, 'D expands to DOL');
  wpisz := 'E'; KOMENDY;
  CheckStrEqual('EXIT', wpisz, 'E expands to EXIT');
  wpisz := 'M'; KOMENDY;
  CheckStrEqual('MODE', wpisz, 'M expands to MODE');
  wpisz := 'POLNOC'; KOMENDY;
  CheckStrEqual('POLNOC', wpisz, 'full command passes through KOMENDY');
end;

procedure TestTrainSila;
begin
  SIL := 10; MAXSIL := 20; PRA := 10; wpisz := 'TRENUJ SILA';
  TRAIN;
  CheckEqual(11, SIL, 'TRENUJ SILA raises SIL by one');
  CheckEqual(7, PRA, 'TRENUJ SILA spends three PRA');
end;

procedure TestTrainZrecznosc;
begin
  ZRE := 10; MAXZRE := 20; PRA := 10; wpisz := 'TRENUJ ZRECZNOSC';
  TRAIN;
  CheckEqual(11, ZRE, 'TRENUJ ZRECZNOSC raises ZRE by one');
  CheckEqual(8, PRA, 'TRENUJ ZRECZNOSC spends two PRA');
end;

procedure TestTrainMadrosc;
begin
  MAD := 10; MAXMAD := 20; PRA := 10; wpisz := 'TRENUJ MADROSC';
  TRAIN;
  CheckEqual(11, MAD, 'TRENUJ MADROSC raises MAD by one');
  CheckEqual(7, PRA, 'TRENUJ MADROSC spends three PRA');
end;

procedure TestTrainNeedsPracticePoints;
begin
  SIL := 10; MAXSIL := 20; PRA := 2; wpisz := 'TRENUJ SILA';
  TRAIN;
  CheckEqual(10, SIL, 'TRENUJ SILA refuses with two PRA');
  CheckEqual(2, PRA, 'TRENUJ SILA spends nothing with two PRA');
end;

procedure TestTrainCapsAtMaximum;
begin
  SIL := 20; MAXSIL := 20; PRA := 10; wpisz := 'TRENUJ SILA';
  TRAIN;
  CheckEqual(20, SIL, 'TRENUJ SILA stops at MAXSIL');
  CheckEqual(10, PRA, 'TRENUJ SILA spends nothing at MAXSIL');
end;

procedure TestPotworyRanges;
begin
  POTWORY;
  { Random(38) + 20 redrawn until above 32: [33, 57]. }
  CheckRange('BAKTERIA', BAKTERIA, 33, 57);
  CheckRange('SLIMAK', SLIMAK, 33, 57);
  CheckRange('ZUK', ZUK, 33, 57);
  CheckRange('KARALUCH', KARALUCH, 33, 57);
  CheckRange('MROWKA', MROWKA, 33, 57);
  CheckRange('PAJAK', PAJAK, 33, 57);
  CheckRange('DZIK', DZIK, 33, 57);
  CheckRange('LIS', LIS, 33, 57);
  CheckRange('SZCZUR', SZCZUR, 33, 57);
  CheckRange('KUROPATWA', KUROPATWA, 33, 57);
  CheckRange('SARNA', SARNA, 33, 57);
  CheckRange('ORZEL', ORZEL, 33, 57);
  CheckRange('ZAJAC', ZAJAC, 33, 57);
  CheckRange('WILCZUR', WILCZUR, 33, 57);
  CheckRange('KORNIK', KORNIK, 33, 57);
  CheckRange('MUCHA', MUCHA, 33, 57);
  CheckRange('SLON', SLON, 33, 57);
  CheckRange('LEW', LEW, 33, 57);
  CheckRange('ZYRAFA', ZYRAFA, 33, 57);
  CheckRange('WIELBLAD', WIELBLAD, 33, 57);
  CheckRange('STRUS', STRUS, 33, 57);
  CheckRange('BOA', BOA, 33, 57);
  CheckRange('WILK', WILK, 33, 57);
  CheckRange('BIZON', BIZON, 33, 57);
  CheckRange('PANTERA', PANTERA, 33, 57);
  CheckRange('GLADIATOR', GLADIATOR, 33, 57);
  CheckRange('WOJOWNIK', WOJOWNIK, 33, 57);
  CheckRange('TRENER', TRENER, 33, 57);
  { Random(7) + 60 redrawn until above 60: [61, 66]. }
  CheckRange('DZIECKO', DZIECKO, 61, 66);
  CheckRange('REPORTER', REPORTER, 61, 66);
  { Random(8) + 60 redrawn until above 60: [61, 67]. }
  CheckRange('WARIAT', WARIAT, 61, 67);
  CheckRange('SLUCHACZ', SLUCHACZ, 61, 67);
  CheckRange('FAN', FAN, 61, 67);
  CheckRange('CZLOWIEK', CZLOWIEK, 61, 67);
  CheckRange('DZIADEK', DZIADEK, 61, 67);
  { Random(9) + 60 redrawn until above 60: [61, 68]. }
  CheckRange('POLICJANT', POLICJANT, 61, 68);
  CheckRange('OCHRONIARZ', OCHRONIARZ, 61, 68);
  CheckRange('GORYL', GORYL, 61, 68);
  { Random(3) + 70, drawn once: [70, 72]. }
  CheckRange('GITARZYSTA', GITARZYSTA, 70, 72);
  CheckRange('PERKUSISTA', PERKUSISTA, 70, 72);
  CheckRange('ORGANISTA', ORGANISTA, 70, 72);
  CheckRange('LIROY', LIROY, 70, 72);
  { Fixed constants from POTWORY. }
  CheckEqual(67, MONSTRA.MINIBARMAN, 'MINIBARMAN is 67');
  CheckEqual(67, MONSTRA.GRUBAS, 'GRUBAS is 67');
  CheckEqual(69, MONSTRA.DJ, 'DJ is 69');
  CheckEqual(76, MONSTRA.PEDAL, 'PEDAL is 76');
  CheckEqual(76, MONSTRA.PARA, 'PARA is 76');
  CheckEqual(76, MONSTRA.MACIEK, 'MACIEK is 76');
  CheckEqual(1, MONSTRA.DRZWI, 'DRZWI is 1');
  CheckEqual(1, MONSTRA.STARUCH, 'STARUCH is 1');
  { Random(7) + 20, condition always true: [20, 26]. }
  CheckRange('JAMNIK', MONSTRA.JAMNIK, 20, 26);
  CheckRange('OWCZAREK', MONSTRA.OWCZAREK, 20, 26);
  CheckRange('PIESEK', MONSTRA.PIESEK, 20, 26);
  CheckRange('SPANIEL', MONSTRA.SPANIEL, 20, 26);
  CheckRange('PUDEL', MONSTRA.PUDEL, 20, 26);
  CheckRange('TAKSOWKARZ', MONSTRA.TAKSOWKARZ, 20, 26);
  CheckRange('SPRZEDAWCA', MONSTRA.SPRZEDAWCA, 20, 26);
  CheckRange('ZAMIATACZ', MONSTRA.ZAMIATACZ, 20, 26);
  CheckRange('PIJAK', MONSTRA.PIJAK, 20, 26);
  CheckRange('ZEBRAK', MONSTRA.ZEBRAK, 20, 26);
  { Random(8) + 77 redrawn until below 84: [77, 83]. }
  CheckRange('SZCZAW', SZCZAW, 77, 83);
  CheckRange('STOKROTKA', STOKROTKA, 77, 83);
  CheckRange('KONICZYNKA', KONICZYNKA, 77, 83);
  CheckRange('MLECZ', MLECZ, 77, 83);
  CheckRange('DMUCHAWIEC', DMUCHAWIEC, 77, 83);
  CheckRange('ROZA', ROZA, 77, 83);
  CheckRange('OSET', OSET, 77, 83);
  CheckRange('MALINA', MALINA, 77, 83);
  { Random(8) + 77, not in the until condition: [77, 84]. }
  CheckRange('AGREST', AGREST, 77, 84);
  CheckRange('JEZYNA', JEZYNA, 77, 84);
  CheckRange('TRAWA', TRAWA, 77, 84);
  CheckRange('DUNCAN', DUNCAN, 77, 84);
end;

procedure TestTarczaAppliesShield;
begin
  { PRO at 100 forces the Random(100) roll to succeed. }
  WPYSK := 50; ILOSC := 30; PRO := 100;
  TARCZA;
  CheckEqual(20, WPYSK, 'TARCZA subtracts ILOSC from WPYSK');
end;

procedure TestTarczaClampsAtZero;
begin
  WPYSK := 10; ILOSC := 30; PRO := 100;
  TARCZA;
  CheckEqual(0, WPYSK, 'TARCZA clamps WPYSK at zero');
end;

{ WALKA: the pre-loop MINIKUNSZT arithmetic (PRZEDM.PAS
  612-693) and the victory adjustments (869-877) are
  deterministic. A dead enemy (WROGEN = 0) makes the
  combat loop run exactly one iteration and end in the
  victory path, so KUNSZT after WALKA is the stat
  arithmetic plus the one iteration bonus; the MAXE
  pair is then driven by MONSTRA.MAXE alone. A live
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
  ENERGIA := 100;
  PAR := aPar;
  KOP := aKop;
  KOPM := 0;
  KOPHP := 0;
  MANA := 0;
  FIREBALL := 0;
  POISON := 0;
  ILEPOI := 0;
  ZWIEJ := 0;
  WIMP := 0;
  PASZOL := 0;
  KUNSZT := 0;
  FUKSROLL := 0;
  PRO := 0;
  ILOSC := 0;
  MONSTRA.MAXE := aMaxE;
  WROGEN := aWrogE;
  SIL := aSil;
  WROGSIL := aWrogSil;
  ZRE := aZre;
  WROGZRE := aWrogZre;
end;

procedure RunWalka(aMaxE, aWrogE, aSil, aWrogSil,
  aZre, aWrogZre, aPar, aKop: Integer;
  ExpectedKunszt: Longint; const What: string);
begin
  WalkaSetup(aMaxE, aWrogE, aSil, aWrogSil,
    aZre, aWrogZre, aPar, aKop);
  WALKA;
  CheckEqual(ExpectedKunszt, KUNSZT, What);
end;

procedure RunWalkaRange(aMaxE, aWrogE, aSil, aWrogSil,
  aZre, aWrogZre, aPar, aKop: Integer;
  KunsztLo, KunsztHi: Longint; const What: string);
begin
  WalkaSetup(aMaxE, aWrogE, aSil, aWrogSil,
    aZre, aWrogZre, aPar, aKop);
  WALKA;
  CheckRange(What, KUNSZT, KunsztLo, KunsztHi);
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
  ILEPOI := 10;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy while poisoned');
  CheckTrue(ENERGIA > 0, 'WALKA survives the poison damage');
end;

procedure TestWalkaFireball;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  FIREBALL := 1;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy under fireball');
  CheckTrue((FIREBALL = 0) or (FIREBALL = 1),
    'WALKA spends the fireball or keeps it');
end;

procedure TestWalkaPoison;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  POISON := 1;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy under poison');
  CheckTrue((POISON = 0) or (POISON = 1),
    'WALKA spends the poison or keeps it');
end;

procedure TestWalkaParry;
begin
  WalkaSetup(0, 0, 1, 20, 10, 10, 139, 0);
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy through parry');
  CheckTrue(ENERGIA > 0, 'WALKA survives the parried attack');
end;

procedure TestWalkaParryLight;
begin
  WalkaSetup(0, 10, 3, 3, 10, 10, 139, 0);
  ENERGIA := 10000;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy through light parry');
  CheckTrue(ENERGIA > 0, 'WALKA survives the light parry');
end;

procedure TestWalkaSpecials;
begin
  WalkaSetup(0, 20, 3, 20, 10, 10, 139, 0);
  ENERGIA := 10000;
  FIREBALL := 1;
  POISON := 1;
  ILEPOI := 10;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy in the long fight');
  CheckTrue(ENERGIA > 0, 'WALKA survives the long fight');
end;

procedure TestWalkaSuperKopHit;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 100);
  MANA := 100; KOPHP := 100; ENERGIA := 50;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy with the super kop');
  CheckTrue(MANA < 100, 'WALKA spends mana on the super kop');
end;

procedure TestWalkaSuperKopHitAgain;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 100);
  MANA := 100; KOPHP := 100; ENERGIA := 50;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy with the kop again');
  CheckTrue(MANA < 100, 'WALKA spends mana on the kop again');
end;

procedure TestWalkaSuperKopChybia;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 11);
  MANA := 100; KOPHP := 100; ENERGIA := 50;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy when the kop misses');
  CheckTrue(MANA < 100, 'WALKA spends mana on the kop attempt');
end;

procedure TestWalkaFlee;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  ZWIEJ := 100; WIMP := 100; ENERGIA := 50; MANA := 100;
  WALKA;
  CheckTrue(PASZOL = 1, 'WALKA flees the battle');
end;

procedure TestWalkaFleeChybia;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  ZWIEJ := 1; WIMP := 100; ENERGIA := 50; MANA := 100;
  WALKA;
  CheckTrue(WROGEN < 1,
    'WALKA finishes the enemy when the flee fails');
end;

procedure TestWalkaPotrawki;
begin
  WalkaSetup(0, 0, 1, 1, 10, 10, 0, 0);
  POTRAWKI := 99; BIGOS := 50; PRZED := 0;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the enemy for the potrawki');
  CheckTrue((PRZED = 0) or (PRZED = 1),
    'WALKA cooks the bigos or not');
end;

procedure TestWalkaDeath;
begin
  WalkaSetup(0, 0, 1, 61, 10, 10, 0, 0);
  ENERGIA := 1;
  WALKA;
  CheckTrue((ENERGIA < 1) or (WROGEN < 1),
    'WALKA ends the fight by death or victory');
end;

procedure TestWalkaFukroll;
begin
  WalkaSetup(0, 10, 2, 1, 10, 10, 0, 0);
  FUKSROLL := 1;
  WALKA;
  CheckTrue(WROGEN < 1,
    'WALKA defeats the enemy through the fukroll');
end;

procedure EncounterSetup;
begin
  WalkaSetup(127, 0, 127, 1, 127, 1, 0, 0);
  MTARCZA := 0; POTRAWKI := 0; FIREBALL := 0; POISON := 0;
  ILEPOI := 0; SERCE := 0;
end;

procedure TestEncounters;
begin
  EncounterSetup;
  wpisz := 'ZABIJ MROWKA';
  SLABO;
  CheckTrue(WROGEN < 1, 'SLABO defeats the mrowka');
  EncounterSetup;
  WALKAPIES;
  CheckTrue(WROGEN < 1, 'WALKAPIES defeats the pies');
  EncounterSetup;
  MNIEJSLABO;
  CheckTrue(WROGEN < 1, 'MNIEJSLABO defeats the enemy');
  EncounterSetup;
  SREDNIO;
  CheckTrue(WROGEN < 1, 'SREDNIO defeats the enemy');
  EncounterSetup;
  TRUDNO;
  CheckTrue(WROGEN < 1, 'TRUDNO defeats the enemy');
  EncounterSetup;
  VEASY;
  CheckTrue((WROGEN < 1) and (ENERGIA > 0),
    'VEASY defeats the enemy and survives');
  EncounterSetup;
  EASY;
  CheckTrue((WROGEN < 1) and (ENERGIA > 0),
    'EASY defeats the enemy and survives');
  EncounterSetup;
  NEASY;
  CheckTrue((WROGEN < 1) and (ENERGIA > 0),
    'NEASY defeats the enemy and survives');
  EncounterSetup;
  BTRUDNO;
  CheckTrue(WROGEN < 1, 'BTRUDNO defeats the enemy');
end;

procedure TestWalkaDodge;
begin
  WalkaSetup(0, 30, 3, 1, 0, 2, 0, 0);
  ENERGIA := 100;
  WALKA;
  CheckTrue(WROGEN < 1, 'WALKA defeats the dodging enemy');
  CheckTrue(ENERGIA > 0, 'WALKA survives the dodged combat');
end;

procedure TestBraniePicksUpSword;
begin
  MIECHO2 := 7; MMIECZ := 7; PRZED := 0; wpisz := 'BIERZ STARY';
  BRANIE;
  CheckEqual(-10, MMIECZ, 'BIERZ STARY stores the sword as -10');
  CheckEqual(1, PRZED, 'BIERZ STARY counts one item');
end;

procedure TestBranieDropsSword;
begin
  MIECHO2 := 7; MMIECZ := -10; PRZED := 1; wpisz := 'ODRZUC STARY';
  BRANIE;
  CheckEqual(7, MMIECZ, 'ODRZUC STARY restores the sword marker');
  CheckEqual(0, PRZED, 'ODRZUC STARY uncounts the item');
end;

procedure TestBranieIgnoresMissingSword;
begin
  MIECHO2 := 7; MMIECZ := 0; PRZED := 0; wpisz := 'BIERZ STARY';
  BRANIE;
  CheckEqual(0, MMIECZ, 'BIERZ STARY needs the sword marker');
  CheckEqual(0, PRZED, 'BIERZ STARY counts nothing without the sword');
end;

procedure TestBraniePicksUpBluszczItems;
begin
  MIECHO2 := 7;
  MTARCZA := 7; SERCE := 7; DYPLOM := 7; FAJKA := 7;
  PRZED := 0; MAD := 0; MAXMAD := 5; MONSTRA.MAXE := 50;
  wpisz := 'BIERZ MALA'; BRANIE;
  wpisz := 'BIERZ SERCE'; BRANIE;
  wpisz := 'BIERZ DYPLOM'; BRANIE;
  wpisz := 'BIERZ FAJKA'; BRANIE;
  CheckEqual(-10, MTARCZA, 'BIERZ MALA stores the shield as -10');
  CheckEqual(-10, SERCE, 'BIERZ SERCE stores the heart as -10');
  CheckEqual(-10, DYPLOM, 'BIERZ DYPLOM stores the diploma as -10');
  CheckEqual(-10, FAJKA, 'BIERZ FAJKA stores the pipe as -10');
  CheckEqual(4, PRZED, 'four BRANIE picks count four items');
  CheckEqual(55, MONSTRA.MAXE, 'BIERZ DYPLOM adds five max energy');
  CheckEqual(1, MAD, 'BIERZ FAJKA adds one wisdom under the cap');
end;

procedure TestBranieDropsBluszczItems;
begin
  MIECHO2 := 7;
  MTARCZA := -10; SERCE := -10; DYPLOM := -10; FAJKA := -10;
  PRZED := 4; MAD := 1; MONSTRA.MAXE := 55;
  wpisz := 'ODRZUC FAJKA'; BRANIE;
  wpisz := 'ODRZUC MALA'; BRANIE;
  wpisz := 'ODRZUC SERCE'; BRANIE;
  wpisz := 'ODRZUC DYPLOM'; BRANIE;
  CheckEqual(7, MTARCZA, 'ODRZUC MALA restores the shield marker');
  CheckEqual(7, SERCE, 'ODRZUC SERCE restores the heart marker');
  CheckEqual(7, DYPLOM, 'ODRZUC DYPLOM restores the diploma marker');
  CheckEqual(7, FAJKA, 'ODRZUC FAJKA restores the pipe marker');
  CheckEqual(0, PRZED, 'four ODRZUC drops uncount four items');
  CheckEqual(50, MONSTRA.MAXE, 'ODRZUC DYPLOM removes five max energy');
  CheckEqual(0, MAD, 'ODRZUC FAJKA removes one wisdom');
end;

procedure TestUzywaSerce;
begin
  SERCE := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ SERCE';
  UZYWANIE;
  CheckEqual(0, SERCE, 'UZYJ SERCE consumes the heart');
  CheckEqual(15, ENERGIA, 'UZYJ SERCE restores five energy');
  CheckEqual(0, PRZED, 'UZYJ SERCE uncounts the item');
end;

procedure TestUzywaSerceClampsAtMaxE;
begin
  SERCE := -10; ENERGIA := 48; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ SERCE';
  UZYWANIE;
  CheckEqual(50, ENERGIA, 'UZYJ SERCE clamps energy at MONSTRA.MAXE');
end;

procedure TestUzywaKomplet;
begin
  KOMPLET := -10; JAKIEUB := ''; PRO := 0; CIALO := 0;
  wpisz := 'UZYJ KOMPLET';
  UZYWANIE;
  CheckEqual(7, PRO, 'UZYJ KOMPLET adds seven defense');
  CheckEqual(1, CIALO, 'UZYJ KOMPLET marks the body dressed');
  CheckStrEqual('SYF', JAKIEUB, 'UZYJ KOMPLET remembers the suit');
  wpisz := 'ODLORZ KOMPLET';
  UZYWANIE;
  CheckEqual(0, PRO, 'ODLORZ KOMPLET removes the defense');
  CheckEqual(0, CIALO, 'ODLORZ KOMPLET marks the body bare');
  CheckStrEqual('', JAKIEUB, 'ODLORZ KOMPLET forgets the suit');
end;

procedure TestUzywaKompletWorn;
begin
  KOMPLET := -10; JAKIEUB := 'SYF'; PRO := 0; CIALO := 1;
  wpisz := 'UZYJ KOMPLET';
  UZYWANIE;
  CheckEqual(0, PRO, 'UZYJ KOMPLET refuses while a suit is worn');
  CheckEqual(1, CIALO, 'UZYJ KOMPLET keeps the body dressed');
  CheckStrEqual('SYF', JAKIEUB, 'UZYJ KOMPLET keeps the worn suit');
end;

procedure TestUzywaGarnitur;
begin
  GARNITUR := -10; JAKIEUB := ''; ILOSC := 0; PRO := 0; FUKSROLL := 0;
  wpisz := 'UZYJ GARNITUR';
  UZYWANIE;
  CheckEqual(10, PRO, 'UZYJ GARNITUR adds ten defense');
  CheckEqual(1, ILOSC, 'UZYJ GARNITUR counts one armor layer');
  CheckEqual(15, FUKSROLL, 'UZYJ GARNITUR adds fifteen resistance');
  CheckStrEqual('GARNITUR', JAKIEUB, 'UZYJ GARNITUR remembers the suit');
  wpisz := 'ODLORZ GARNITUR';
  UZYWANIE;
  CheckEqual(0, PRO, 'ODLORZ GARNITUR removes the defense');
  CheckEqual(0, ILOSC, 'ODLORZ GARNITUR uncounts the armor layer');
  CheckEqual(0, FUKSROLL, 'ODLORZ GARNITUR removes the resistance');
  CheckStrEqual('', JAKIEUB, 'ODLORZ GARNITUR forgets the suit');
end;

procedure TestUzywaButelkaMany;
begin
  MBUTELKA := -10; MANA := 10; MAXMANA := 50; PRZED := 1;
  wpisz := 'UZYJ MALA BUTELKA MANY';
  UZYWANIE;
  CheckEqual(40, MANA, 'UZYJ MALA BUTELKA MANY restores thirty mana');
  CheckEqual(0, PRZED, 'UZYJ MALA BUTELKA MANY uncounts the item');
end;

procedure TestUzywaButelkaManyClampsAtMaxMana;
begin
  MBUTELKA := -10; MANA := 45; MAXMANA := 50; PRZED := 1;
  wpisz := 'UZYJ MALA BUTELKA MANY';
  UZYWANIE;
  CheckEqual(50, MANA, 'UZYJ MALA BUTELKA MANY clamps mana at MAXMANA');
end;

procedure TestNiszczyPrzepustke;
begin
  PRZEPUSTKA := -10; PRZED := 0; wpisz := 'ZNISZCZ PRZEPUSTKA';
  UZYWANIE;
  CheckEqual(0, PRZEPUSTKA, 'ZNISZCZ PRZEPUSTKA burns the pass');
  CheckEqual(1, PRZED, 'ZNISZCZ PRZEPUSTKA counts one item');
end;

procedure TestPatrzPrzepustke;
begin
  PRZEPUSTKA := -10; PRZED := 0; wpisz := 'PATRZ PRZEPUSTKA';
  UZYWANIE;
  CheckEqual(-10, PRZEPUSTKA, 'PATRZ PRZEPUSTKA keeps the pass');
  CheckEqual(0, PRZED, 'PATRZ PRZEPUSTKA counts nothing');
end;

procedure TestUzywaDyplom;
begin
  DYPLOM := -10; wpisz := 'UZYJ DYPLOM';
  UZYWANIE;
  CheckEqual(-10, DYPLOM, 'UZYJ DYPLOM keeps the diploma');
end;

procedure TestUzywaPaczek;
begin
  PACZEK := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ PACZEK';
  UZYWANIE;
  CheckEqual(0, PACZEK, 'UZYJ PACZEK consumes the paczek');
  CheckEqual(18, ENERGIA, 'UZYJ PACZEK restores eight energy');
  CheckEqual(0, PRZED, 'UZYJ PACZEK uncounts the item');
end;

procedure TestUzywaCiastko;
begin
  CIASTKO := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ CIASTKO';
  UZYWANIE;
  CheckEqual(0, CIASTKO, 'UZYJ CIASTKO consumes the ciastko');
  CheckEqual(22, ENERGIA, 'UZYJ CIASTKO restores twelve energy');
end;

procedure TestUzywaSuchaRacja;
begin
  SUCHA := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ SUCHA RACJA';
  UZYWANIE;
  CheckEqual(0, SUCHA, 'UZYJ SUCHA RACJA consumes the racja');
  CheckEqual(26, ENERGIA, 'UZYJ SUCHA RACJA restores sixteen energy');
end;

procedure TestUzywaBulka;
begin
  BULKA := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ BULKA';
  UZYWANIE;
  CheckEqual(0, BULKA, 'UZYJ BULKA consumes the bulka');
  CheckEqual(30, ENERGIA, 'UZYJ BULKA restores twenty energy');
end;

procedure TestUzywaChleb;
begin
  CHLEB := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ CHLEB';
  UZYWANIE;
  CheckEqual(0, CHLEB, 'UZYJ CHLEB consumes the chleb');
  CheckEqual(36, ENERGIA, 'UZYJ CHLEB restores twenty-six energy');
end;

procedure TestUzyjaWeka;
begin
  WEKA := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ WEKA';
  UZYWANIE;
  CheckEqual(0, WEKA, 'UZYJ WEKA consumes the weka');
  CheckEqual(44, ENERGIA, 'UZYJ WEKA restores thirty-four energy');
end;

procedure TestUzywaBigos;
begin
  BIGOS := -10; ENERGIA := 10; MONSTRA.MAXE := 50; PRZED := 1;
  wpisz := 'UZYJ BIGOS';
  UZYWANIE;
  CheckEqual(0, BIGOS, 'UZYJ BIGOS consumes the bigos');
  CheckEqual(30, ENERGIA, 'UZYJ BIGOS restores twenty energy');
end;

procedure TestUzywaPigulkaLow;
begin
  PIGULKA := -10; MAD := 5; MONSTRA.MAXE := 50; ENERGIA := 40; KUNSZT := 100;
  wpisz := 'UZYJ PIGULKA';
  UZYWANIE;
  CheckEqual(0, PIGULKA, 'UZYJ PIGULKA consumes the pigulka');
  CheckEqual(1, ENERGIA, 'UZYJ PIGULKA with low MAD drains energy to one');
  CheckEqual(49, MONSTRA.MAXE, 'UZYJ PIGULKA with low MAD lowers max energy');
  CheckEqual(50, KUNSZT, 'UZYJ PIGULKA with low MAD lowers kunszt');
end;

procedure TestUzywaPigulkaMid;
begin
  PIGULKA := -10; MAD := 12; ENERGIA := 100; KUNSZT := 100;
  wpisz := 'UZYJ PIGULKA';
  UZYWANIE;
  CheckEqual(60, ENERGIA, 'UZYJ PIGULKA with mid MAD drains forty energy');
  CheckEqual(70, KUNSZT, 'UZYJ PIGULKA with mid MAD lowers kunszt');
end;

procedure TestUzywaPigulkaHigh;
begin
  PIGULKA := -10; MAD := 20; ENERGIA := 100; KUNSZT := 100;
  wpisz := 'UZYJ PIGULKA';
  UZYWANIE;
  CheckEqual(0, PIGULKA, 'UZYJ PIGULKA with high MAD consumes the pigulka');
  CheckEqual(100, ENERGIA, 'UZYJ PIGULKA with high MAD keeps energy');
  CheckEqual(100, KUNSZT, 'UZYJ PIGULKA with high MAD keeps kunszt');
end;

procedure TestGarniturZyskInvariant;
begin
  GARNITUR := 50; PRZED := 0;
  GARNITURZYSK;
  CheckTrue((GARNITUR = 50) or (GARNITUR = 40),
    'GARNITURZYSK drops GARNITUR by ten or not at all');
  CheckTrue((PRZED = 0) or (PRZED = 1),
    'GARNITURZYSK counts at most one item');
end;

procedure TestPigulkaZyskInvariant;
begin
  PIGULKA := 50; PRZED := 0;
  PIGULKAZYSK;
  CheckTrue((PIGULKA = 50) or (PIGULKA = 40),
    'PIGULKAZYSK drops PIGULKA by ten or not at all');
  CheckTrue((PRZED = 0) or (PRZED = 1),
    'PIGULKAZYSK counts at most one item');
end;

procedure TestKasetaZyskInvariant;
begin
  kaseta := 50; MAXE := 0; PRO := 0; PRZED := 0; ZRE := 0;
  MIECHO := 20;
  KASETAZYSK;
  CheckTrue((kaseta = 50) or (kaseta = 40),
    'KASETAZYSK drops the cassette by ten or not at all');
  CheckTrue((MAXE = 0) or (MAXE = 5),
    'KASETAZYSK raises MAXE by five or not at all');
  CheckTrue((PRO = 0) or (PRO = -8),
    'KASETAZYSK lowers PRO by eight or not at all');
  CheckTrue((PRZED = 0) or (PRZED = 1),
    'KASETAZYSK counts at most one item');
  CheckTrue((ZRE = 0) or (ZRE = 1),
    'KASETAZYSK raises ZRE by one or not at all');
end;

procedure TestListekZyskInvariant;
begin
  LISTEK := 50; PRZED := 0; MAXMANA := 0; MIECHO := 20;
  LISTEKZYSK;
  CheckTrue((LISTEK = 50) or (LISTEK = 40),
    'LISTEKZYSK drops the leaf by ten or not at all');
  CheckTrue((PRZED = 0) or (PRZED = 1),
    'LISTEKZYSK counts at most one item');
  CheckTrue((MAXMANA = 0) or (MAXMANA = 40),
    'LISTEKZYSK raises MAXMANA by forty or not at all');
end;

procedure TestScrollPorZyskInvariant;
begin
  SCROLLPOR := 50; PRZED := 0; MIECHO := 20;
  SCROLLPORZYSK;
  CheckTrue((SCROLLPOR = 50) or (SCROLLPOR = 40),
    'SCROLLPORZYSK drops the scroll by ten or not at all');
  CheckTrue((PRZED = 0) or (PRZED = 1),
    'SCROLLPORZYSK counts at most one item');
end;

{ The rare-gain branches of the loot procedures only
  trigger on a low Random roll, so the tests repeat
  the procedure until the first gain, which makes the
  result a single deterministic gain. }

procedure TestGarniturZyskGain;
var i: Integer;
begin
  GARNITUR := 100; PRZED := 0;
  i := 0;
  while (PRZED = 0) and (i < 2000) do begin
    GARNITURZYSK;
    i := i + 1;
  end;
  CheckTrue(PRZED > 0, 'GARNITURZYSK gains the suit');
  CheckEqual(90, GARNITUR,
    'GARNITURZYSK drops GARNITUR by ten');
end;

procedure TestPigulkaZyskGain;
var i: Integer;
begin
  PIGULKA := 100; PRZED := 0;
  i := 0;
  while (PRZED = 0) and (i < 2000) do begin
    PIGULKAZYSK;
    i := i + 1;
  end;
  CheckTrue(PRZED > 0, 'PIGULKAZYSK gains the pill');
  CheckEqual(90, PIGULKA,
    'PIGULKAZYSK drops PIGULKA by ten');
end;

procedure TestKasetaZyskGain;
var i: Integer;
begin
  kaseta := 100; MAXE := 0; PRO := 0; PRZED := 0;
  ZRE := 0; MIECHO := 20;
  i := 0;
  while (PRZED = 0) and (i < 2000) do begin
    KASETAZYSK;
    i := i + 1;
  end;
  CheckTrue(PRZED > 0, 'KASETAZYSK gains the cassette');
  CheckEqual(90, kaseta,
    'KASETAZYSK drops the cassette by ten');
  CheckEqual(5, MAXE, 'KASETAZYSK raises MAXE by five');
  CheckEqual(-8, PRO, 'KASETAZYSK lowers PRO by eight');
  CheckEqual(1, ZRE, 'KASETAZYSK raises ZRE by one');
end;

procedure TestListekZyskGain;
var i: Integer;
begin
  LISTEK := 100; PRZED := 0; MAXMANA := 0; MIECHO := 20;
  i := 0;
  while (PRZED = 0) and (i < 2000) do begin
    LISTEKZYSK;
    i := i + 1;
  end;
  CheckTrue(PRZED > 0, 'LISTEKZYSK gains the leaf');
  CheckEqual(90, LISTEK,
    'LISTEKZYSK drops the leaf by ten');
  CheckEqual(40, MAXMANA,
    'LISTEKZYSK raises MAXMANA by forty');
end;

procedure TestScrollPorZyskGain;
var i: Integer;
begin
  SCROLLPOR := 100; PRZED := 0; MIECHO := 20;
  i := 0;
  while (PRZED = 0) and (i < 2000) do begin
    SCROLLPORZYSK;
    i := i + 1;
  end;
  CheckTrue(PRZED > 0, 'SCROLLPORZYSK gains the scroll');
  CheckEqual(90, SCROLLPOR,
    'SCROLLPORZYSK drops the scroll by ten');
end;

procedure TestScenaMessages;
begin
  MIECHO := 1;
  GITARZYSTA := 1; PERKUSISTA := 1; ORGANISTA := 1; LIROY := 1;
  SCENA;
  CheckEqual(1, MIECHO, 'SCENA leaves MIECHO unchanged');
end;

procedure TestTlumMessages;
begin
  MIECHO := 1;
  DZIECKO := 1; WARIAT := 1; SLUCHACZ := 1; FAN := 1;
  CZLOWIEK := 1; POLICJANT := 1; OCHRONIARZ := 1; GORYL := 1;
  DZIADEK := 1; REPORTER := 1;
  TLUM;
  CheckEqual(1, MIECHO, 'TLUM leaves MIECHO unchanged');
end;

procedure TestKtoMessages;
begin
  MIECHO := 1;
  KORNIK := 1; MUCHA := 1; BAKTERIA := 1; SLIMAK := 1; ZUK := 1;
  KARALUCH := 1; MROWKA := 1; PAJAK := 1; DZIK := 1; SZCZUR := 1;
  LIS := 1; KUROPATWA := 1; ZAJAC := 1; WILCZUR := 1; ORZEL := 1;
  SARNA := 1; SLON := 1; LEW := 1; ZYRAFA := 1; WIELBLAD := 1;
  STRUS := 1; BOA := 1; WILK := 1; BIZON := 1; PANTERA := 1;
  GLADIATOR := 1; WOJOWNIK := 1; TRENER := 1;
  KTO;
  CheckEqual(1, MIECHO, 'KTO leaves MIECHO unchanged');
end;

procedure TestUlSklepMessages;
begin
  MIECHO := 1;
  MONSTRA.JAMNIK := 1; MONSTRA.OWCZAREK := 1; MONSTRA.PIESEK := 1;
  MONSTRA.SPANIEL := 1; MONSTRA.PUDEL := 1;
  MONSTRA.TAKSOWKARZ := 1; MONSTRA.SPRZEDAWCA := 1;
  MONSTRA.ZAMIATACZ := 1; MONSTRA.PIJAK := 1; MONSTRA.ZEBRAK := 1;
  ULSKLEPIKOWA;
  CheckEqual(1, MIECHO, 'ULSKLEPIKOWA leaves MIECHO unchanged');
end;

procedure TestBluszczMessages;
begin
  MIECHO := 1;
  SZCZAW := 1; STOKROTKA := 1; KONICZYNKA := 1; MLECZ := 1;
  DMUCHAWIEC := 1; ROZA := 1; OSET := 1; JEZYNA := 1;
  AGREST := 1; MALINA := 1; TRAWA := 1; DUNCAN := 1;
  BLUSZCZ;
  CheckEqual(1, MIECHO, 'BLUSZCZ leaves MIECHO unchanged');
end;

procedure TestPierdolyTlo;
begin
  FeedStdin('1');
  wpisz := 'ZMIEN TLO';
  PIERDOLY;
end;

procedure TestPorownanie;
begin
  MANA := 10;
  FeedStdin('DZIK');
  POROWNANIE;
end;

procedure MiniarenaSetup;
begin
  {Give every arena monster the same id (33) so the
   MIECHO = <monster> guard holds for each ZABIJ cmd.
   Raise ZRE so the enemy rarely dodges: each combat
   then ends in one or two rounds, keeping the arena
   tests cheap.}
  BAKTERIA := 33; SLIMAK := 33; KORNIK := 33; MUCHA := 33;
  ZUK := 33; KARALUCH := 33; MROWKA := 33; PAJAK := 33;
  DZIK := 33; WILCZUR := 33; SZCZUR := 33; LIS := 33;
  KUROPATWA := 33; ZAJAC := 33; ORZEL := 33; SARNA := 33;
  SLON := 33; LEW := 33; ZYRAFA := 33; WILK := 33;
  WIELBLAD := 33; STRUS := 33; BOA := 33; BIZON := 33;
  PANTERA := 33; GLADIATOR := 33; WOJOWNIK := 33; TRENER := 33;
  MIECHO := 33;
  SIL := 127; ZRE := 127; ENERGIA := 30000; PASZOL := 0;
end;

procedure TestMiniarenaSlabo;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ BAKTERIA|ZABIJ SLIMAK|ZABIJ KORNIK|ZABIJ MUCHA|' +
    'ZABIJ ZUK|ZABIJ KARALUCH|ZABIJ MROWKA|ZABIJ PAJAK|MODE');
  MINIARENA;
end;

procedure TestMiniarenaMniejslabo;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ DZIK|ZABIJ WILCZUR|ZABIJ SZCZUR|ZABIJ LIS|' +
    'ZABIJ KUROPATWA|ZABIJ ZAJAC|ZABIJ ORZEL|ZABIJ SARNA|MODE');
  MINIARENA;
end;

procedure TestMiniarenaSrednio;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ SLON|ZABIJ LEW|ZABIJ ZYRAFA|ZABIJ WILK|' +
    'ZABIJ WIELBLAD|ZABIJ STRUS|ZABIJ BOA|ZABIJ BIZON|' +
    'ZABIJ PANTERA|MODE');
  MINIARENA;
end;

procedure TestMiniarenaTrudno;
begin
  MiniarenaSetup;
  FeedStdin('ZABIJ GLADIATOR|ZABIJ WOJOWNIK|ZABIJ TRENER|MODE');
  MINIARENA;
end;

procedure MiniarenaAt(const cmd: string; miechoVal: integer);
begin
  MIECHO := miechoVal;
  FeedStdin(cmd);
  MINIARENA;
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
  MIECHO := 100;
  PERKUSISTA := 100; GITARZYSTA := 100; ORGANISTA := 100;
  LIROY := 100; DUNCAN := 100;
  SZCZAW := 100; STOKROTKA := 100; KONICZYNKA := 100;
  MLECZ := 100; DMUCHAWIEC := 100; ROZA := 100;
  OSET := 100; MALINA := 100; AGREST := 100;
  JEZYNA := 100; TRAWA := 100;
  SIL := 127; ZRE := 127; ENERGIA := 30000; PASZOL := 0;
  DUNQ := 0; FORSA := 10000; PRZEPUSTKA := 100;
  PLECAK := 100; QUEST := 0; KUNSZT := 0;
end;

procedure TestFightscena;
begin
  FightSetup;
  wpisz := 'ZABIJ PERKUSISTA'; FIGHTSCENA;
  wpisz := 'ZABIJ GITARZYSTA'; FIGHTSCENA;
  wpisz := 'ZABIJ LIROY'; FIGHTSCENA;
  wpisz := 'ZABIJ ORGANISTA'; FIGHTSCENA;
end;

procedure TestFightbluszczZabij;
begin
  FightSetup;
  wpisz := 'ZABIJ DUNCAN'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ SZCZAW'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ STOKROTKA'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ KONICZYNKA'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ MLECZ'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ DMUCHAWIEC'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ ROZA'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ OSET'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ MALINA'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ AGREST'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ JEZYNA'; FIGHTBLUSZCZ;
  wpisz := 'ZABIJ TRAWA'; FIGHTBLUSZCZ;
end;

procedure TestFightbluszczShop;
begin
  FightSetup;
  wpisz := 'SECRET LISTA'; FIGHTBLUSZCZ;
  wpisz := 'KUP DOKUMENT'; FIGHTBLUSZCZ;
  wpisz := 'KUP PLECAK'; FIGHTBLUSZCZ;
end;

procedure TestFightbluszczDuncan;
begin
  FightSetup;
  DUNQ := 0;
  wpisz := 'ROZMAWIAJ DUNCAN'; FIGHTBLUSZCZ;
  DUNQ := -125;
  wpisz := 'ROZMAWIAJ DUNCAN'; FIGHTBLUSZCZ;
end;

procedure PorownanieAsk(const monster: string;
  aPoziom, aSil, aZre, aPar, aKop: Integer);
begin
  {Drive one POROWNANIE conversation. The prompt reads the
   monster name from stdin, and the reply branches key off
   MONSTRA.OGOL (POZIOM + SIL plus the ZRE/PAR/KOP bonuses)
   and SIL, so both are set to reach each band.}
  FeedStdin(monster);
  MANA := 10; POZIOM := aPoziom; SIL := aSil; ZRE := aZre;
  PAR := aPar; KOP := aKop;
  POROWNANIE;
end;

procedure TestPorownanieBeasts;
begin
  {The beasts group (DZIK and friends) warns below OGOL 16,
   again from 16 to 18, and above 18.}
  PorownanieAsk('DZIK', 0, 0, 0, 0, 0);
  PorownanieAsk('KUROPATWA', 0, 16, 0, 0, 0);
  PorownanieAsk('SARNA', 0, 19, 0, 0, 0);
  PorownanieAsk('DZIADEK', 0, 30, 0, 0, 0);
  CheckEqual(30, SIL, 'POROWNANIE leaves the last SIL in place');
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
  MANA := 10;
  POROWNANIE;
  CheckEqual(15, MANA, 'BAKTERIA restores five mana');
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
  SERCE := 0;
  ENERGIA := 30000; SIL := 127; ZRE := 127; PASZOL := 0;
  ZWIEJ := 0; WIMP := 0; MANA := 0; FIREBALL := 0;
  POISON := 0; ILEPOI := 0; KOP := 0; KOPM := 0;
  KOPHP := 0; PRO := 0; ILOSC := 0; FUKSROLL := 0;
  PRZED := 0;
end;

procedure TestEncounterHeartVeasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if SERCE = 0 then VEASY;
  CheckEqual(-10, SERCE, 'VEASY eventually drops the heart');
end;

procedure TestEncounterHeartEasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if SERCE = 0 then EASY;
  CheckEqual(-10, SERCE, 'EASY eventually drops the heart');
end;

procedure TestEncounterHeartNeasy;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 160 do
    if SERCE = 0 then NEASY;
  CheckEqual(-10, SERCE, 'NEASY eventually drops the heart');
end;

procedure TestEncounterHeartTrudno;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 110 do
    if SERCE = 0 then TRUDNO;
  CheckEqual(-10, SERCE, 'TRUDNO eventually drops the heart');
end;

procedure TestEncounterHeartBtrudno;
var i: Integer;
begin
  LootSetup;
  for i := 1 to 150 do
    if SERCE = 0 then BTRUDNO;
  CheckEqual(-10, SERCE, 'BTRUDNO eventually drops the heart');
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
    ENERGIA := 100; POTRAWKI := 1; BIGOS := 0;
    WALKA;
    if POTRAWKI > 1 then
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
    ENERGIA := 30000;
    WALKA;
    if PAR > 99 then
      Break;
  end;
  CheckTrue(PAR > 99, 'WALKA eventually teaches the parry skill');
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
