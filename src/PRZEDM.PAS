unit PRZEDM; { checksum = $647E }
interface
uses  crt, monstra, dos;
var MMIECZ, MIECHO2, PRZED, MTARCZA, SERCE, DYPLOM, FAJKA, MAD, SIL, ZRE, MBUTELKA, PRA: Integer;
var MAXMAD, MAXSIL, MAXZRE, ENERGIA, FUKS, PACZEK, CIASTKO, SUCHA, CHLEB, BULKA, WEKA: Integer;
var MANA, MAXMANA, WROGEN, MINIKUNSZT, WROGSIL, WROGZRE, ON, TY, SZANSA, WPYSK: Integer;
var PRO, ILOSC, PAR, KOP, KOPM, KOPHP, ZWIEJ, WIMP, PASZOL, KUNSZT, MIECHO, ARENA: Integer;  { see PRZEDM-LINE-LAYOUT }
var KORNIK, MUCHA, BAKTERIA, SLIMAK, ZUK, KARALUCH, MROWKA, PAJAK, DZIK, SZCZUR, LIS: Integer;
var KUROPATWA, ZAJAC, WILCZUR, ORZEL, SARNA, SLON, LEW, ZYRAFA, WIELBLAD, STRUS, BOA: Integer;
var WILK, BIZON, PANTERA, GLADIATOR, WOJOWNIK, TRENER, CZY, STOP, KOMPLET, CIALO: Integer;
var FORSA, PRZEPUSTKA: Longint;
var GARNITUR, FUKSROLL, GITARZYSTA, PERKUSISTA, ORGANISTA, LIROY, kaseta, SCROLLPOR: Integer;
var SZCZAW, STOKROTKA, KONICZYNKA, MLECZ, DMUCHAWIEC, ROZA, JEZYNA, OSET, AGREST, MALINA, TRAWA, QUEST, QUESTWYK: Integer;
var DZIECKO, WARIAT, SLUCHACZ, FAN, CZLOWIEK, POLICJANT, OCHRONIARZ, DZIADEK, GORYL, PLECAK: Shortint;
var REPORTER, PIGULKA, POTRAWKI, BIGOS, LISTEK, POZIOM, POR, FIREBALL, POISON, ILEPOI, DUNCAN, DUNQ: Shortint;
var JAKIEUB: string;
var plik: Text;
var wpisz: string;
  procedure BRANIE; { Entry 00D0:023F }
  procedure UZYWANIE; { Entry 00D8:07C6 }
  procedure PIERDOLY; { Entry 00E0:003B }
  procedure TARCZA; { Entry 00C0:0022 }
  procedure WALKA; { Entry 00C8:04EC }
  procedure MINIARENA; { Entry 00E8:0299 }
  procedure KTO; { Entry 00B8:0523 }
  procedure MODE; { Entry 00A0:0000 }
  procedure SLABO; { Entry 0028:0047 }
  procedure MNIEJSLABO; { Entry 0030:0038 }
  procedure SREDNIO; { Entry 0038:0038 }
  procedure TRUDNO; { Entry 0040:0038 }
  procedure BTRUDNO; { Entry 0060:0038 }
  procedure VEASY; { Entry 0048:0038 }
  procedure EASY; { Entry 0050:0038 }
  procedure NEASY; { Entry 0058:0038 }
  procedure GARNITURZYSK; { Entry 0078:0049 }
  procedure PIGULKAZYSK; { Entry 0080:004E }
  procedure KASETAZYSK; { Entry 0088:004E }
  procedure LISTEKZYSK; { Entry 0090:0054 }
  procedure SCROLLPORZYSK; { Entry 0098:0034 }
  procedure SCENA; { Entry 00A8:00D3 }
  procedure FIGHTSCENA; { Entry 00F0:0077 }
  procedure TLUM; { Entry 00B0:01C8 }
  procedure POTWORY; { Entry 0008:0000 }
  procedure BLUSZCZ; { Entry 0020:02E3 }
  procedure KOMENDY; { Entry 0100:0043 }
  procedure FIGHTBLUSZCZ; { Entry 00F8:0522 }
  procedure WALKAPIES; { Entry 0000:0046 }
  procedure ULSKLEPIKOWA; { Entry 0070:0209 }
  procedure POROWNANIE; { Entry 0068:0816 }
  procedure TRAIN; { Entry 0010:00E3 }
  procedure save; { Entry 0108:0000 }
implementation

function MinikunsztMaxe(diff: Integer): Integer;
{ MINIKUNSZT bonus for MAXE vs WROGEN difference.
  diff = MAXE - WROGEN (positive = player stronger).
  Original has overlapping ranges at diff=3 (gets +10 and +9 = 19). }
begin
  if diff > 0 then begin
    case diff of
      1, 2: MinikunsztMaxe := 10;
      3: MinikunsztMaxe := 19;  { overlap: <4 gives 10, >2 and <7 gives 9 }
      4..6: MinikunsztMaxe := 9;
      7..9: MinikunsztMaxe := 8;
      10..12: MinikunsztMaxe := 7;
      13..15: MinikunsztMaxe := 6;
      16..18: MinikunsztMaxe := 5;
      19..21: MinikunsztMaxe := 4;
      22..24: MinikunsztMaxe := 3;
      25..27: MinikunsztMaxe := 2;
      28..30: MinikunsztMaxe := 1;
      else MinikunsztMaxe := 0;
    end;
  end else if diff < 0 then begin
    diff := -diff;
    if diff = 2 then MinikunsztMaxe := 12
    else if diff = 4 then MinikunsztMaxe := 13
    else if diff = 6 then MinikunsztMaxe := 14
    else if diff = 8 then MinikunsztMaxe := 15
    else if diff = 10 then MinikunsztMaxe := 16
    else if diff = 12 then MinikunsztMaxe := 17
    else if diff = 14 then MinikunsztMaxe := 18
    else if diff = 16 then MinikunsztMaxe := 19
    else if diff = 18 then MinikunsztMaxe := 20
    else if diff > 20 then MinikunsztMaxe := 21
    else MinikunsztMaxe := 0;
  end else
    MinikunsztMaxe := 11;
end;

function MinikunsztAttr(diff: Integer): Integer;
{ MINIKUNSZT bonus for SIL/WROGSIL or ZRE/WROGZRE difference.
  diff = player - enemy (positive = player stronger).
  For SIL: exact values. For ZRE: paired ranges (handled by caller). }
begin
  if diff > 0 then begin
    if diff >= 10 then MinikunsztAttr := 1
    else MinikunsztAttr := 11 - diff;
  end else if diff < 0 then begin
    diff := -diff;
    if diff >= 10 then MinikunsztAttr := 21
    else MinikunsztAttr := 11 + diff;
  end else
    MinikunsztAttr := 11;
end;

function MinikunsztZre(diff: Integer): Integer;
{ MINIKUNSZT bonus for ZRE vs WROGZRE difference (paired ranges). }
var step: Integer;
begin
  if diff > 0 then begin
    step := (diff + 1) div 2;
    if step >= 10 then MinikunsztZre := 1
    else MinikunsztZre := 11 - step;
  end else if diff < 0 then begin
    diff := -diff;
    step := (diff + 1) div 2;
    if step >= 10 then MinikunsztZre := 21
    else MinikunsztZre := 11 + step;
  end else
    MinikunsztZre := 11;
end;

function SZANSA_RandomDodge(szansa: Integer): Integer;
{ Returns the Random upper bound for player dodge based on SZANSA.
  SZANSA ranges: >30=12, 28-30=13, 25-27=14, 21-30=15, 19-20=16,
  17-18=17, 13-16=18, 10-12=19, 7-9=20, 5-6=21, 3-4=22, <3=23 }
begin
  if szansa > 30 then SZANSA_RandomDodge := 12
  else if szansa > 27 then SZANSA_RandomDodge := 13
  else if szansa > 24 then SZANSA_RandomDodge := 14
  else if szansa > 20 then SZANSA_RandomDodge := 15
  else if szansa > 18 then SZANSA_RandomDodge := 16
  else if szansa > 16 then SZANSA_RandomDodge := 17
  else if szansa > 12 then SZANSA_RandomDodge := 18
  else if szansa > 9 then SZANSA_RandomDodge := 19
  else if szansa > 6 then SZANSA_RandomDodge := 20
  else if szansa > 4 then SZANSA_RandomDodge := 21
  else if szansa > 2 then SZANSA_RandomDodge := 22
  else SZANSA_RandomDodge := 23;
end;

function SZANSA_RandomEnemyDodge(szansa: Integer): Integer;
{ Returns the Random upper bound for enemy dodge based on SZANSA.
  SZANSA ranges: >30=60, 28-30=58, 25-27=56, 21-30=54, 19-20=52,
  17-18=51, 13-16=48, 10-12=46, 7-9=42, 5-6=40, 3-4=38, <3=35 }
begin
  if szansa > 30 then SZANSA_RandomEnemyDodge := 60
  else if szansa > 27 then SZANSA_RandomEnemyDodge := 58
  else if szansa > 24 then SZANSA_RandomEnemyDodge := 56
  else if szansa > 20 then SZANSA_RandomEnemyDodge := 54
  else if szansa > 18 then SZANSA_RandomEnemyDodge := 52
  else if szansa > 16 then SZANSA_RandomEnemyDodge := 51
  else if szansa > 12 then SZANSA_RandomEnemyDodge := 48
  else if szansa > 9 then SZANSA_RandomEnemyDodge := 46
  else if szansa > 6 then SZANSA_RandomEnemyDodge := 42
  else if szansa > 4 then SZANSA_RandomEnemyDodge := 40
  else if szansa > 2 then SZANSA_RandomEnemyDodge := 38
  else SZANSA_RandomEnemyDodge := 35;
end;

function OGOL_ZRE_Bonus(zre: Integer): Integer;
{ ZRE bonus for OGOL: paired ranges 8-9:+4, 10-11:+5, etc. up to 20-21:+10. }
begin
  if zre >= 8 then OGOL_ZRE_Bonus := zre div 2
  else OGOL_ZRE_Bonus := 0;
end;

function OGOL_PAR_Bonus(par: Integer): Integer;
{ PAR bonus: >75 gives +2, >50 gives +1 (cumulative). }
var bonus: Integer;
begin
  bonus := 0;
  if par > 75 then bonus := bonus + 1;
  if par > 50 then bonus := bonus + 1;
  OGOL_PAR_Bonus := bonus;
end;

function OGOL_KOP_Bonus(kop: Integer): Integer;
{ KOP bonus: >70 gives +2, >10 gives +2 (cumulative). }
var bonus: Integer;
begin
  bonus := 0;
  if kop > 70 then bonus := bonus + 2;
  if kop > 10 then bonus := bonus + 2;
  OGOL_KOP_Bonus := bonus;
end;

procedure WALKAPIES;
begin
  WROGEN := 10;
  WROGZRE := 10;
  WROGSIL := 5;
  WALKA;
  CZY := Random(15);
  WriteLn('WYCIAGASZ ', CZY, ' MONET Z CIALA PSA');
  FORSA := FORSA + CZY;
  if SERCE = 0 then begin
    FUKS := Random(20);
    if FUKS < 5 then begin SERCE := MIECHO; WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA PSA');
    end;
  end;
end;

procedure POTWORY;
begin
  repeat
    BAKTERIA := Random(38) + 20;
    SLIMAK := Random(38) + 20;
    ZUK := Random(38) + 20;
    KARALUCH := Random(38) + 20;
    MROWKA := Random(38) + 20;
    PAJAK := Random(38) + 20;
    DZIK := Random(38) + 20;
    LIS := Random(38) + 20;
    SZCZUR := Random(38) + 20;
    KUROPATWA := Random(38) + 20;
  until (BAKTERIA > 32) and (SLIMAK > 32) and (ZUK > 32) and (KARALUCH > 32)
    and (MROWKA > 32) and (PAJAK > 32) and (DZIK > 32) and (LIS > 32)
    and (SZCZUR > 32) and (KUROPATWA > 32);
  repeat SARNA := Random(38) + 20;
    ORZEL := Random(38) + 20;
    ZAJAC := Random(38) + 20;
    WILCZUR := Random(38) + 20;
    KORNIK := Random(38) + 20;
    MUCHA := Random(38) + 20;
  until (SARNA > 32) and (ORZEL > 32) and (ZAJAC > 32) and (WILCZUR > 32)
    and (KORNIK > 32) and (MUCHA > 32);
  repeat SLON := Random(38) + 20;
    LEW := Random(38) + 20;
    ZYRAFA := Random(38) + 20;
    WIELBLAD := Random(38) + 20;
    STRUS := Random(38) + 20;
    BOA := Random(38) + 20;
    WILK := Random(38) + 20;
    BIZON := Random(38) + 20;
    PANTERA := Random(38) + 20;
  until (SLON > 32) and (LEW > 32) and (ZYRAFA > 32) and (WIELBLAD > 32)
    and (STRUS > 32) and (BOA > 32) and (WILK > 32) and (BIZON > 32)
    and (PANTERA > 32);
  repeat GLADIATOR := Random(38) + 20;
    WOJOWNIK := Random(38) + 20;
    TRENER := Random(38) + 20;
  until (GLADIATOR > 32) and (WOJOWNIK > 32) and (TRENER > 32);
  repeat
    MONSTRA.JAMNIK := Random(7) + 20;
    MONSTRA.OWCZAREK := Random(7) + 20;
    MONSTRA.PIESEK := Random(7) + 20;
    MONSTRA.SPANIEL := Random(7) + 20;
    MONSTRA.PUDEL := Random(7) + 20;
  until (MONSTRA.JAMNIK > 19) and (MONSTRA.OWCZAREK > 19) and (MONSTRA.PIESEK > 19)
    and (MONSTRA.SPANIEL > 19) and (MONSTRA.PUDEL > 19);
  repeat MONSTRA.TAKSOWKARZ := Random(7) + 20;
    MONSTRA.SPRZEDAWCA := Random(7) + 20;
    MONSTRA.ZAMIATACZ := Random(7) + 20;
    MONSTRA.PIJAK := Random(7) + 20;
    MONSTRA.ZEBRAK := Random(7) + 20;
  until (MONSTRA.TAKSOWKARZ > 19) and (MONSTRA.SPRZEDAWCA > 19)
    and (MONSTRA.ZAMIATACZ > 19) and (MONSTRA.PIJAK > 19) and (MONSTRA.ZEBRAK > 19);
  repeat DZIECKO := Random(7) + 60;
    WARIAT := Random(8) + 60;
    SLUCHACZ := Random(8) + 60;
    FAN := Random(8) + 60;
    CZLOWIEK := Random(8) + 60;
  until (DZIECKO > 60) and (WARIAT > 60) and (SLUCHACZ > 60) and (FAN > 60)
    and (CZLOWIEK > 60);
  repeat POLICJANT := Random(9) + 60;
    OCHRONIARZ := Random(9) + 60;
    GORYL := Random(9) + 60;
    DZIADEK := Random(8) + 60;
    REPORTER := Random(7) + 60;
  until (POLICJANT > 60) and (OCHRONIARZ > 60) and (GORYL > 60) and (DZIADEK > 60)
    and (REPORTER > 60); GITARZYSTA := Random(3) + 70;
  PERKUSISTA := Random(3) + 70;
  ORGANISTA := Random(3) + 70;
  LIROY := Random(3) + 70;
  MONSTRA.MINIBARMAN := 67;
  MONSTRA.GRUBAS := 67;
  MONSTRA.DJ := 69;
  MONSTRA.PEDAL := 76;
  MONSTRA.PARA := 76;
  MONSTRA.MACIEK := 76;
  MONSTRA.DRZWI := 1;
  MONSTRA.STARUCH := 1;
  repeat
    SZCZAW := Random(8) + 77;
    KONICZYNKA := Random(8) + 77;
    STOKROTKA := Random(8) + 77;
    MLECZ := Random(8) + 77;
    DMUCHAWIEC := Random(8) + 77;
    ROZA := Random(8) + 77;
    OSET := Random(8) + 77;
    MALINA := Random(8) + 77;
    AGREST := Random(8) + 77;
    JEZYNA := Random(8) + 77;
    TRAWA := Random(8) + 77;
    DUNCAN := Random(8) + 77;
  until (SZCZAW < 84) and (STOKROTKA < 84) and (KONICZYNKA < 84) and (MLECZ < 84)
    and (DMUCHAWIEC < 84) and (ROZA < 84) and (OSET < 84) and (MALINA < 84);
end;
procedure TrenujAtrybut(var atr, maxAtr: Integer; minPRA, costPRA: Integer; cmdForm, nounForm: string);
{ Helper for training one attribute: checks PRA and max, increments attr, deducts PRA.
  cmdForm = command form (accusative: SILE, ZRECZNOSC, MADROSC)
  nounForm = noun form (genitive: SILY, ZRECZNOSCI, MADROSCI) }
begin
  if (PRA > minPRA) and (atr < maxAtr) then begin
    atr := atr + 1;
    PRA := PRA - costPRA;
    WriteLn('TRENUJESZ ', cmdForm, ' I MASZ ', atr, ' ', nounForm, ' I ZOSTALO CI ', PRA, ' PRAKTYK');
  end;
end;

procedure TRAIN;
begin
  if wpisz = 'TRENUJ' then WriteLn('CO CHCESZ TRENOWAC?');
  if wpisz = 'TRENUJ SILA' then
    TrenujAtrybut(SIL, MAXSIL, 2, 3, 'SILE', 'SILY');
  if wpisz = 'TRENUJ ZRECZNOSC' then
    TrenujAtrybut(ZRE, MAXZRE, 1, 2, 'ZRECZNOSC', 'ZRECZNOSCI');
  if wpisz = 'TRENUJ MADROSC' then
    TrenujAtrybut(MAD, MAXMAD, 2, 3, 'MADROSC', 'MADROSCI');
end;

procedure BLUSZCZ;
begin
  if SZCZAW = MIECHO then WriteLn('PONURY SZCZAW PLANUJE ZEMSCIC SIE NA SWOJEJ TESCIOWEJ-LISCIU KLONOWYM');
  if STOKROTKA = MIECHO then WriteLn('STOKROTKA TUTAJ ROSNIE POLNA ( A NAD NIA SZUMI GEJ) ');
  if KONICZYNKA = MIECHO then WriteLn('KONICZYNKA KTORA TUTAJ JEST NIE PRZENIESIE CI SZCZESCIA');
  if MLECZ = MIECHO then WriteLn('MLECZ WLASNIE DOWIODL ZE EINSTEIN SIE MYLIL');
  if DMUCHAWIEC = MIECHO then WriteLn('DMUCHAWIEC WLASNIE DOJRZAL DO TEGO ABY GO ZDMUCHNAC');
  if ROZA = MIECHO then WriteLn('PRZEROSNIETA ROZA POKAZUJE KOLCE NA ZNAK IZ NIE WARTO JEJ ATAKOWAC');
  if OSET = MIECHO then WriteLn('KIEDYS MYSLALES ZE OSET TO LATWY DO WYRWANIA CHWAST ... MYLILES SIE');
  if JEZYNA = MIECHO then WriteLn('TA JEZYNA W CIEMNOSCIACH WYGLADA JAK JAKIS NIEBYWALY SMOK ... ');
  if AGREST = MIECHO then WriteLn('AGREST JEST TU , CHCESZ SPROBOWAC JAK SMAKUJE ?');
  if MALINA = MIECHO then WriteLn('MALINA JAK DZIEWCZYNA , CHOC DZIEWCZYNY NIE SA CHYBA AZ TAKIMI MUTANTAMI');
  if TRAWA = MIECHO then WriteLn('TRAWA NIE WYDAJE SIE TRUDNYM PRZECIWNIKIEM , LECZ NIE DAJ SIE ZWIESC');
  if MIECHO = DUNCAN then WriteLn('ROLNIK DUNCAN PROBOJE ZAPANOWAC NAD TYM ZYWIOLEM I UPRAWIAC SWOJE MARCHEWKI');
end;

procedure WalkaZlozone(wroGenBase, wroGenRand, wroZreBase, wroZreRand, wroSilBase, wroSilRand,
  czyBase, czyRand, serceChance: Integer; checkEnergia: Boolean; specialMrowka: Boolean);
{ Unified combat helper for difficulty procedures.
  wroGenBase/wroGenRand: WROGEN = Random(wroGenRand) + wroGenRand (if wroGenRand>0) else fixed
  wroZreBase/wroZreRand: WROGZRE similar
  wroSilBase/wroSilRand: WROGSIL similar
  czyBase/czyRand: CZY = Random(czyRand) + czyBase
  serceChance: FUKS threshold for SERCE drop (0 = no SERCE drop)
  checkEnergia: whether to require ENERGIA > 0
  specialMrowka: if True, use MROWKA/PACZEK logic instead of SERCE }
var
  serceDrop: Boolean;
begin
  if wroGenRand > 0 then WROGEN := Random(wroGenRand) + wroGenBase else WROGEN := wroGenBase;
  if wroZreRand > 0 then WROGZRE := Random(wroZreRand) + wroZreBase else WROGZRE := wroZreBase;
  if wroSilRand > 0 then WROGSIL := Random(wroSilRand) + wroSilBase else WROGSIL := wroSilBase;
  WALKA;
  if (PASZOL = 0) and (not checkEnergia or (ENERGIA > 0)) then begin
    CZY := Random(czyRand) + czyBase;
    WriteLn('WYCIAGASZ ', CZY, ' MONET Z CIALA');
    FORSA := FORSA + CZY;
    if specialMrowka then begin
      if wpisz = 'ZABIJ MROWKA' then begin
        FUKS := Random(10);
        if (FUKS < 7) and (PACZEK <> -10) then begin
          WriteLn('WYCIAGASZ PACZEK Z CIALA MROWKI');
          PACZEK := -10;
          PRZED := PRZED + 1;
        end;
      end;
    end else if (serceChance > 0) and (SERCE = 0) then begin
      FUKS := Random(20);
      if (FUKS < serceChance) and (SERCE <> -10) then begin
        WriteLn('WYCIAGASZ SERCE Z CIALA TRUPA');
        SERCE := -10;
        PRZED := PRZED + 1;
      end;
    end;
  end;
end;

procedure SLABO;
begin
  WalkaZlozone(1, 0, 1, 0, 2, 0, 0, 3, 0, False, True);
end;

procedure MNIEJSLABO;
begin
  WalkaZlozone(34, 3, 8, 4, 10, 0, 10, 21, 5, False, False);
end;

procedure SREDNIO;
begin
  WalkaZlozone(50, 5, 10, 5, 13, 2, 30, 30, 7, False, False);
end;

procedure TRUDNO;
begin
  WalkaZlozone(60, 6, 12, 3, 15, 3, 20, 40, 7, False, False);
end;

procedure VEASY;
begin
  WalkaZlozone(90, 10, 14, 2, 17, 2, 10, 55, 4, True, False);
end;

procedure EASY;
begin
  WalkaZlozone(100, 20, 16, 0, 18, 2, 30, 30, 4, True, False);
end;

procedure NEASY;
begin
  WalkaZlozone(130, 20, 20, 0, 19, 2, 20, 45, 4, True, False);
end;

procedure BTRUDNO;
begin
  WalkaZlozone(72, 3, 13, 2, 16, 2, 15, 50, 5, False, False);
end;
procedure POROWNANIE;
begin
  if MANA > 9 then begin
    FUKS := Random(100);
    WriteLn('KOGO CHCESZ ZE SOBA POROWNAC?');
    ReadLn(wpisz);
    MONSTRA.OGOL := POZIOM + SIL + OGOL_ZRE_Bonus(ZRE) + OGOL_PAR_Bonus(PAR) + OGOL_KOP_Bonus(KOP);
    if (wpisz = 'DZIK') or (wpisz = 'SZCZUR') or (wpisz = 'LIS') or
       (wpisz = 'KUROPATWA') or (wpisz = 'ZAJAC') or (wpisz = 'WILCZUR') or
       (wpisz = 'ORZEL') or (wpisz = 'SARNA') or (wpisz = 'DZIECKO') or (wpisz = 'DZIADEK') then
        begin if MONSTRA.OGOL < 16 then WriteLn('NICZEGO NIE MOGE ZAGWARANTOWAC ..... MACIE PODOBNE PARAMETRY');
        if (SIL > 15) and (SIL < 19) then WriteLn('PRZECIWNIK GODNY TWEJ DUMY , RACZEJ NIE POGRASZ');
        if SIL > 18 then WriteLn('WSTYD MI ZA CIEBIE ... JESZCZE TU JESTES ! NA CO CZEKASZ ? KILLUJ');
        end;
    if (wpisz = 'SLON') or (wpisz = 'LEW') or (wpisz = 'ZYRAFA') or (wpisz = 'WIELBLAD') or
       (wpisz = 'STRUS') or (wpisz = 'BOA') or (wpisz = 'WILK') or (wpisz = 'BIZON') or
       (wpisz = 'PANTERA') or (wpisz = 'WARIAT') or (wpisz = 'SLUCHACZ') or (wpisz = 'FAN') or
       (wpisz = 'CZLOWIEK') or (wpisz = 'REPORTER') then
      begin if MONSTRA.OGOL < 16 then WriteLn('TAK  TAK MAMA KUPI BERECIK GLOWKA W PORZADKU ? ');
      if (SIL > 15) and (SIL < 21) then WriteLn(' NA TWOIM MIEJSCU BYM SIE NIE ZAPUSZCZAL ');
      if (SIL > 20) and (SIL < 23) then WriteLn(' RYZYK FIZYK - TAK NA 50% - WALKA NA SMIERC I ZYCIE');
      if SIL > 22 then WriteLn('SPOX KILLUJ BEZ UPRZEDZEN');
    end;
    if (wpisz = 'GLADIATOR') or (wpisz = 'WOJOWNIK') or (wpisz = 'TRENER') or
       (wpisz = 'POLICJANT') or (wpisz = 'GORYL') or (wpisz = 'OCHRONIARZ') then begin
      if MONSTRA.OGOL < 15 then WriteLn('HA HA NIE NA SERJO . DAJ SE W ZYLE OKI? TO DOWCIP? HA HA HA');
      if (MONSTRA.OGOL > 14) and (MONSTRA.OGOL < 18) then WriteLn('POMARZ SOBIE WARIACIE . MOZE CI SIE PRZYSNI');
      if (MONSTRA.OGOL > 17) and (MONSTRA.OGOL < 23) then WriteLn('POWIEM  BEZ OGRODEK-TO GLUPI POMYSL');
      if (MONSTRA.OGOL > 22) and (MONSTRA.OGOL < 26) then WriteLn('TO DOSC RYZYKOWNE ZE TAK POWIEM');
      if MONSTRA.OGOL > 25 then WriteLn('TO BEDZIE TAK PROSTE JAK ZABICIE DZIECKA TOPOREM !!!');
    end;
    if (wpisz = 'MINI-BARMAN') or (wpisz = 'GRUBAS') or (wpisz = 'D.J') then begin
      if MONSTRA.OGOL < 24 then WriteLn('SMIERC PODZIEKUJE CI ZA TWOJ DAR (ALE ZGAPIAM)');
      if (MONSTRA.OGOL > 23) and (MONSTRA.OGOL < 26) then WriteLn('NIE UDAWAJ BISTY-BOYS PRZEGRASZ NA 99%');
      if (MONSTRA.OGOL > 25) and (MONSTRA.OGOL < 29) then WriteLn('PERFEKCYJNY MECZ NA SMIERC I ZYCIE !!!');
      if MONSTRA.OGOL > 28 then WriteLn('JESTES ZNACZNIE SILNIEJSZY !!!(ALE GLUPSZY)');
      if MONSTRA.OGOL > 34 then WriteLn('UWAZAJ DOSTANIESZ MALO KUNSZTU !!!');
    end;
    if (wpisz = 'TAKSOWKARZ') or (wpisz = 'SPRZEDAWCA') or (wpisz = 'GITARZYSTA') or (wpisz = 'PERKUSISTA') or
       (wpisz = 'ORGANISTA') or (wpisz = 'ZEBRAK') or (wpisz = 'PIJAK') or (wpisz = 'ZAMIATACZ') or (wpisz = 'SZCZAW') or
       (wpisz = 'STOKROTKA') or (wpisz = 'KONICZYNKA') or (wpisz = 'MLECZ') or (wpisz = 'DMUCHAWIEC') then begin
      if MONSTRA.OGOL < 21 then WriteLn('NIE');
      if (MONSTRA.OGOL > 22) and (MONSTRA.OGOL < 28) then WriteLn('RACZEJ NIE , CHOC MOZNA ZARYZYKOWAC(NIE POLECAM)');
      if MONSTRA.OGOL > 27 then WriteLn('TAK');
    end;
    if (wpisz='PEDAL') or (wpisz='PARA') or (wpisz='MACIEK') or (wpisz='ROZA') or
       (wpisz='MALINA') or (wpisz='TRAWA') or (wpisz = 'AGREST') or (wpisz = 'JEZYNA') then begin
      if MONSTRA.OGOL < 20 then WriteLn('WIERZ MI ALE TO NAPRAWDE WIERZ MI ZE NIE MASZ SZANS');
      if (MONSTRA.OGOL > 19) and (MONSTRA.OGOL < 26) then WriteLn('RACZEJ NIE WYGRASZ WIEC LEPIEJ NIE ATAKUJ');
      if (MONSTRA.OGOL > 25) and (MONSTRA.OGOL < 30) then WriteLn('JESTESCIE SOBIE ROWNI (NAPRAWDE !!!) - WIEC 50% SZANS');
      if MONSTRA.OGOL > 29 then WriteLn('JESTES SILNIEJSZY STAD WNIOSEK ZE SOBIE PORADZISZ');
      if MONSTRA.OGOL > 35 then WriteLn('P.S - JESTES DUZO DUZO SILNIEJSZY ZABIJ BEZ OGRODEK!!!');
    end;
    if wpisz = 'LIROY' then begin
      if MONSTRA.OGOL < 28 then WriteLn('HAHAHAHAHAHAHAHAHAHHAHOHOHOHHOHOHOHOHOHOHOHOAHAHAHAHAHAHAH');
      if (MONSTRA.OGOL > 27) and (MONSTRA.OGOL < 33) then WriteLn('HIHIHIHIHIHIHIHHEHEHEHE :))))))');
      if (MONSTRA.OGOL > 32) and (MONSTRA.OGOL < 44) then WriteLn('SPROOB'#224'J A MO'#189'E WYGRAC SIE UDA......');
    if (MONSTRA.OGOL > 43) and (MONSTRA.OGOL < 48) then WriteLn('NIE PRZEJMUJ SIE JEGO MORD'#164' JESTES SILNIEJSZY I BASTA');
      if MONSTRA.OGOL > 47 then WriteLn('UWAZAJ ... NA CHLAPIACE MOZGI FLAKI PRZECIWNIKA');
    end;
    if wpisz = 'POKRZYWA' then begin
      if MONSTRA.OGOL < 40 then WriteLn('NIE MASZ NAJMNIEJSZYCH SZANS');
      if MONSTRA.OGOL > 39 then WriteLn('JEST PEWNE PRAWDOPODOBIENSTWO WYGRANIA TEGO STARCIA');

    end;
    if (wpisz = 'SPANIEL') or (wpisz = 'OWCZAREK') or (wpisz = 'PIESEK') or (wpisz='JAMNIK') or (wpisz='PUDEL') then
      WriteLn('JASNE ZE MOZESZ GO ZABIC ZABIJ !!! ZABIJ . TEN PARSZYWY PIES NIE MA RACJI BYTU');
    if (FUKS < 3) and (POR < 100) then begin
      WriteLn('***************** UCZYSZ SIE ZDOLNOSCI POROWNYWANIE *****************');
      POR := POR + 1;
      KUNSZT := KUNSZT + 5;
    end;
    if wpisz = 'BAKTERIA' then begin
      WriteLn('BAKTERIA MA MAGIC RESISTANCE');
      MANA := MANA + 5;
    end;
  end;
end;

procedure ULSKLEPIKOWA;
begin
  if MONSTRA.JAMNIK = MIECHO then WriteLn('DLUGI JAMNIK GRYZIE CI PODESZWY');
  if MONSTRA.OWCZAREK = MIECHO then WriteLn('PUCHATY OWCZAREK WYLEGUJE SIE W SLONCU');
  if MONSTRA.PIESEK = MIECHO then WriteLn('PIESEK SZUKA DRZEWKA ABY ULZYC SOBIE');
  if MONSTRA.SPANIEL = MIECHO then WriteLn('SPANIEL SLINI SIE AZ MILO');
  if MONSTRA.PUDEL = MIECHO then WriteLn('PUDEL JE KITIKET WIEC CHYBA MU NIE PRZERWIESZ.....?');
  if MONSTRA.TAKSOWKARZ = MIECHO then WriteLn('TAKSOWKARZ WTARGNA TU ZE SWOJA BRYKA , I CZEKA NA KLIENTOW');
  if MONSTRA.SPRZEDAWCA = MIECHO then
    WriteLn('SPRZEDAWCA PRECELKOW WLASNIE SPRZEDAL OSTATNIEGO , CZYM DOPROWADZA DO SZALENSTWA LATAJACE WOKOLO NIEGO KRUKI');
  if MONSTRA.ZAMIATACZ = MIECHO then WriteLn('ZAMIATACZ ULIC SPRAWIA ZE JEST TU CZYSTO JAK W CHLEWIE');
  if MONSTRA.PIJAK = MIECHO then WriteLn('PIJAK TU STOI(DOBRE SOBIE) I SMIERDZI MU Z GEBY');
  if MONSTRA.ZEBRAK = MIECHO then WriteLn('ZEBRAK UDOWADNIA PRZECHODNIOM ZE ON NAPRAWDE JEST CHORY NA AIDS');
end;

procedure GARNITURZYSK;
begin
  FUKS := Random(1000);
  if FUKS <= 25 then begin
    WriteLn('ZYSKUJESZ GARNITUR !!!! Z CIALA WROGA !!!!');
    WriteLn('PRZEDMIOT UNIQE !!! 2.5% !!! ');
    GARNITUR := GARNITUR - 10;
    PRZED := PRZED + 1;
  end;
end;
procedure PIGULKAZYSK;
begin
  FUKS := Random(1000);
  if FUKS <= 42 then begin
    WriteLn('HMMM , A TO CO ? , TOZ TO !!! PIGULKA TRANSPORTUJACA !!! PROSTO Z CIALA WROGA');
    PIGULKA := PIGULKA - 10;
    PRZED := PRZED + 1;
  end;
end;
procedure KASETAZYSK;
begin
  FUKS := Random(100);
  if (FUKS < 2) and (MIECHO <> 10000) then begin
    WriteLn('WYCIAGASZ KASETE LIROYA Z CIALA BIEDNEGO CZLOWIEKA');
    WriteLn('!!! PRZEDMIOT UNIQE 2% !!!');
    kaseta := kaseta - 10;
    MAXE := MAXE + 5;
    PRO := PRO - 8;
    PRZED := PRZED + 1;
    ZRE := ZRE + 1;
  end;
end;
procedure LISTEKZYSK;
begin
  FUKS := Random(100);
  if (FUKS < 6) and (MIECHO <> 10000) then begin
    WriteLn('WYCIAGASZ LISTEK SZCZESCIA Z CIALA WROGIEJ TOBIE POSTACI');
    WriteLn('!!! PRZEDMIOT UNIQE 4% !!!');
    LISTEK := LISTEK - 10;
    PRZED := PRZED + 1;
    MAXMANA := MAXMANA + 40;
  end;
end;
procedure SCROLLPORZYSK;
begin
  FUKS := Random(100);
  if (FUKS < 10) and (MIECHO <> 10000) then begin
    WriteLn('WYCIAGASZ SCROLL POROWNANIA Z WROGIEJ TOBIE POSTACI');
    SCROLLPOR := SCROLLPOR - 10;
    PRZED := PRZED + 1;
  end;
end;

procedure MODE;
begin
  MIECHO2 := MIECHO;
  MIECHO := 1000;
end;
procedure SCENA;
begin
  if GITARZYSTA = MIECHO then WriteLn('GITARZYSTA GRA TU NA WYSOKIM CE-DUR');
  if PERKUSISTA = MIECHO then WriteLn('PERKUSISTA TLUCZE TU NIEMILOSIERNIE (W) TALEZE I BEBNY');
  if ORGANISTA = MIECHO then WriteLn('ORGANISTA KORZYSTA Z 8 CIASIO NARAZ PODL'#164'CZONYCH DO SIECI');
  if LIROY = MIECHO then WriteLn('MAGA BOSS TEJ PLANSZY - LIROY SPIEWA JEDEN ZE SWOICH KAWALKOW');
end;
procedure TLUM;
begin
  if MIECHO = DZIECKO then WriteLn('MILE DZIECKO POWTARZA NAJLEPSZE KAWALKI LIROYA');
  if MIECHO = WARIAT then WriteLn('WARIAT SIE CIESZY ZE NIE TYLKO ON JEST WARIATEM');
  if MIECHO = SLUCHACZ then WriteLn('SLUCHACZ SLUCHA');
  if MIECHO = FAN then WriteLn('FAN LIROYA ZAPUSCIL SOBIE BRODKE JAK LIROY I MA PODJAR');
  if MIECHO = CZLOWIEK then WriteLn('NORMALNY CZLOWIEK PRZYSZEDL POSLUCHAC LIROYA(DZIWNE NIE)?');
  if MIECHO = POLICJANT then WriteLn('ZALANY POLICJANT STARA SIE PELNIC SWA SLUZBE');
  if MIECHO = OCHRONIARZ then WriteLn('OCHRONIARZ ZABIJA KAZDEGO KTO PRZEJDZIE PRZEZ BALUSTRADKI');
  if MIECHO = GORYL then WriteLn('PRYWATNY GORYL LIROYA JE BANANA ');
  if MIECHO = DZIADEK then WriteLn('DZIADEK NIESTESTY NIE SKACZE DO GORY JAK KANGURY');
  if MIECHO = REPORTER then WriteLn('REPORTER UWAZNIE ZAPISUJE WSZYSTKIE WULGARYZMY');
end;

procedure KTO;
begin
  if KORNIK = MIECHO then WriteLn('KORNIK SZUKA JAKIEGOS DRZEWA ABY COS PRZEKASIC');
  if MUCHA = MIECHO then WriteLn('MUCHA BZYKA SOBIE TO TU TO TAM');
  if BAKTERIA = MIECHO then WriteLn('BAKTERIA KTORA ZOBACZYLES POD MIKROSKOPEM STARA USUNAC CI SIE Z DROGI');
  if SLIMAK = MIECHO then WriteLn('SLIMAK KTORY ZOSTAWIA SLUZ POWOLI SUNIE PO PODLODZE');
  if ZUK = MIECHO then WriteLn('ZUK KTORY WIDZI CO SIE SWIECI ZWIEWA STAD');
  if KARALUCH = MIECHO then WriteLn('OHYDNY KARALUCH MA OCHOTE CIE OBRZYDZIC');
  if MROWKA = MIECHO then WriteLn('MROWKA NIESIE TLUSTY PACZEK I SIE CIESZY');
  if PAJAK = MIECHO then WriteLn('PAJAK ZROBIL SIEC NA SCIANIE ARENY');
  if DZIK = MIECHO then WriteLn('TLUSTY DZICZEK BIEGNIE SOBIE TEDY');
  if SZCZUR = MIECHO then WriteLn('JEST TUTAJ SZCZUR,TAK WIELKI ZE WIEKSZEGO NIE WIDZIALES');
  if LIS = MIECHO then WriteLn('CHYTRY LIS SZUKA SPOSOBU BY CIE ZABIC');
  if KUROPATWA = MIECHO then WriteLn('KUROPATWA PO PROSTU JEST TU');
  if ZAJAC = MIECHO then WriteLn('ZAJAC KICA SOBIE SPIEWAJAC "POMYLONE MISIE"');
  if WILCZUR = MIECHO then WriteLn('CZARNY WILCZUR PO KRZYWEJ SIE TOCZY (MU PIANA Z UST)');
  if ORZEL = MIECHO then WriteLn('ORZEL SZYBUJE W POWIETRZYU W POSZUKIWANIU OFIARY');
  if SARNA = MIECHO then WriteLn('SARNA SKASZE SOBIE NIE ZDAJAC SOBIE SPRAWY ZE ZARAZ ZGINIE');
  if SLON = MIECHO then WriteLn('OGROMNIASTY SLON ZGNIATA WSZYSTKO CO NAPOTKA');
  if LEW = MIECHO then WriteLn('LEW - KROL ZWIERZAT WLASNIE ZABIJA NIEWINNE DZIECKO ROZWALAJAC JEGO MOZG');
  if ZYRAFA = MIECHO then WriteLn('ZYRAFA KTORA TU STOI NIE SZUKA ZACZEPKI');
  if WIELBLAD = MIECHO then WriteLn('WIELBLAD KORZYSTA Z GARBOW UZYWAJAC ICH JAKO SMIERTELNEJ BRONI');
  if STRUS = MIECHO then WriteLn('STRUS NIE CHOWA GLOWY W PIASEK BO JEST NA BETONIE');
  if BOA = MIECHO then WriteLn('BOA DUSICIEL WLASNIE ZJADL KROWE ');
  if WILK = MIECHO then WriteLn('WILK CHORY NA WSCIEKLIZNE PANOSZY SIE W OKOLICY');
  if BIZON = MIECHO then WriteLn('NIEWINNY BIZON MORDUJE WLASNIE PUBLICZNOSC');
  if PANTERA = MIECHO then WriteLn('ZWINNA PANTERA NUDZI SIE POLYKAJAC RESZTKI LUDZKIEGO MIESA');
  if GLADIATOR = MIECHO then WriteLn('GLADIATOR ZDOBYWA TUTAJ KUNSZT');
  if WOJOWNIK = MIECHO then WriteLn('WOJOWNIK GREEN PEACE MORDUJE TUTAJ BEZBRONNE LWIATKA :( ');
  if TRENER = MIECHO then WriteLn('TRENER CYRKU LAPIE ZWIERZETA NA SWOJE PRZEDSTAWIENIE');
end;

procedure TARCZA;
begin
  FUKS := Random(100);
  if FUKS <= PRO then begin
    WPYSK := WPYSK - ILOSC;
    if WPYSK < 0 then WPYSK := 0;
    WriteLn('OSLONILES SIE ! TRACISZ ', WPYSK, ' ENERGII');
  end;
end;

procedure WALKA;
begin
  MINIKUNSZT := MINIKUNSZT + MinikunsztMaxe(MONSTRA.MAXE - WROGEN);
  MINIKUNSZT := MINIKUNSZT + MinikunsztAttr(SIL - WROGSIL);
  MINIKUNSZT := MINIKUNSZT + MinikunsztZre(ZRE - WROGZRE);

  repeat
    ON := 0;
    TY := 0;
    WriteLn('WALCZYSZ - <<<<TWOJ WROG MA ', WROGEN, '%>>>><<<< A TY MASZ ', ENERGIA, '% ENERGII>>>>>');
    if ZRE > WROGZRE then begin
      SZANSA := ZRE - WROGZRE;
      FUKS := Random(SZANSA_RandomDodge(SZANSA));
      if FUKS < 10 then begin
        WriteLn('UNIKASZ CIOSU WROGA TWEGO I SMIEJESZ SIE Z JEGO NIEPORADNOSCI');
        TY := 1;
      end;
      FUKS := Random(SZANSA_RandomEnemyDodge(SZANSA));
      if FUKS < 10 then begin
        WriteLn('PRZECIWNIK UNIKA TWOJEGO LAMERSKIEGO ATAKU');
        ON := 1;
      end;
    end;
    if WROGZRE > ZRE then begin
      SZANSA := WROGZRE - ZRE;
      FUKS := Random(SZANSA_RandomDodge(SZANSA));
      if FUKS < 10 then begin
        WriteLn('PRZECIWNIK Z GRACJA UNIKA TWEGO CIOSU');
        ON := 1;
      end;
      FUKS := Random(SZANSA_RandomEnemyDodge(SZANSA));
      if FUKS < 10 then begin
        WriteLn('BEZ PARDONU OMIJASZ CIOS TWOJEGO PRZECIWNIKA');
        TY := 1;
      end;
    end;
    if TY = 0 then begin
      WPYSK := Random(WROGSIL);
      if WPYSK < 6 then WriteLn('PRZECIWNIK CIE TYLKO DRASNA I TRACISZ ', WPYSK, '% ENERGII');
      if (WPYSK > 5) and (WPYSK < 21) then WriteLn('DOSTALES I TRACISZ ', WPYSK, '% ENERGII');
      if (WPYSK > 20) and (WPYSK < 51) then WriteLn('PRZECIWNIK !MASAKRUJE! CIEBIE I TRACISZ AZ ', WPYSK, '% ENERGII');
      if WPYSK > 50 then WriteLn('PRZECIWNIK !!!WYPRUWA FLAKI!!! Z CIEBIE I TRACISZ !!! ', WPYSK, '% ENERGII');
      MINIKUNSZT := MINIKUNSZT + 1;
      TARCZA;
      if (PAR > 0) and (WPYSK > 0) then begin
        FUKS := Random(140);
        if FUKS <= PAR then begin
          if WPYSK < 3 then begin
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ 0% ENERGI');
            WPYSK := 0;
          end;
          if (WPYSK > 2) and (WPYSK < 10) then begin
            WPYSK := WPYSK - 2;
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ ', WPYSK, '% ENERGI');
          end;
          if WPYSK > 9 then begin
            WPYSK := WPYSK - 3;
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ ', WPYSK, '% ENERGI');
          end;
          if (FUKS < 1) and (PAR < 100) then begin
            WriteLn('*************** UCZYSZ SIE ZDOLNOSCI PAROWANIE !!!!! ***************');
            PAR := PAR + 1;
            MINIKUNSZT := MINIKUNSZT + 5;
          end;
        end;
      end;
      ENERGIA := ENERGIA - WPYSK;
      if FIREBALL > 0 then begin
        FUKS := Random(100);
        if FUKS < 10 then begin
          TextColor(14);
          FUKS := Random(20);
          WriteLn('PRZECIWNIK PUSZCZA FIREBALLA W TWYM KIERUNKU - TRACISZ ', FUKS, '% ENERGII');
          ENERGIA := ENERGIA - FUKS;
          FIREBALL := FIREBALL - 1;
          TextColor(15);
        end;
      end;
      if POISON > 0 then begin
        FUKS := Random(100);
        if FUKS < 10 then begin
          TextColor(4);
          WriteLn('PRZECIWNIK RZUCA CZAR "POISON" ');
          POISON := POISON - 1;
          TextColor(15);
          ILEPOI := ILEPOI + 10;
        end;
      end;
      if ILEPOI > 0 then begin
        FUKS := Random(5);
        WriteLn('JESTES ZATRUTY - TRACISZ ', FUKS, '% ENERGI');
        ENERGIA := ENERGIA - FUKS;
        ILEPOI := ILEPOI - 1;
      end;
    end;
    if ON = 0 then begin
      WPYSK := Random(SIL);
      if WPYSK * 10 < FUKSROLL then begin
        repeat
          WPYSK := Random(SIL);
          WriteLn('FUKSROLL FUKSROLL FUKSROLL ! ');
        until (WPYSK * 10) > FUKSROLL;
      end;
      WROGEN := WROGEN - WPYSK;
      if WPYSK < 6 then
        WriteLn('MASZ PECHA : LEKKO POPCHNALES GO I STRACIL TYLKO ', WPYSK, '% ENERGII');

      if (WPYSK > 5) and (WPYSK < 21) then
        WriteLn('DOSTAL I STRACIL ', WPYSK, '% ENERGII');
      if (WPYSK > 20) and (WPYSK < 51) then WriteLn(' !MASAKRUJESZ! PRZECIWNIKA I TRACI ON AZ ', WPYSK, '% ENERGII');
      if WPYSK > 50 then WriteLn(' !!!WYPRUWASZ FLAKI!!! Z PRZECIWNIKA I TRACI ON  !!!! ', WPYSK, '% ENERGII');
    end;
    Delay(2000);
    if (KOP > 0) and (MANA > KOPM) and (ENERGIA < KOPHP) then begin
      FUKS := Random(100);
      if FUKS <= KOP - 10 then begin
        FUKS := Random(10) + Random(POZIOM);
        TextColor(14);
        WriteLn('TWOJ SUPER KOP ZABIERA ', FUKS, '% ENERGI');
        TextColor(15);
        MANA := MANA - Random(3) - 3;
        WROGEN := WROGEN - FUKS;
      end else WriteLn('TWOJ SUPER KOP CHYBIA PRZECIWNIKA ');
      MANA := MANA - Random(2) - 2;
    end;
    if (ZWIEJ > 0) and (ENERGIA < WIMP) and (MANA > 14) then begin
      MANA := MANA - 15;
      FUKS := Random(100);
      if FUKS <= ZWIEJ then begin
        PASZOL := 1;
        WriteLn('WSTYD !!! UCIEKLES Z POLA BITWY TRACISZ 20 KUNSZTU');
        KUNSZT := KUNSZT - 20;
      end else WriteLn('NIE UDALO CI SIE UCIEC !!!! WALCZYSZ DALEJ !!! ');
    end;
  until (ENERGIA < 1) or (WROGEN < 1) or (PASZOL = 1);
  if (WROGEN < 1) and (ENERGIA > 0) then begin
    if MONSTRA.MAXE > 75 then MINIKUNSZT := MINIKUNSZT - 2;
    if MONSTRA.MAXE > 115 then MINIKUNSZT := MINIKUNSZT - 3;
    if PAR > 50 then MINIKUNSZT := MINIKUNSZT - 2;
    if PAR > 75 then MINIKUNSZT := MINIKUNSZT - 2;
    if PAR > 95 then MINIKUNSZT := MINIKUNSZT - 1;
    if KOP > 50 then MINIKUNSZT := MINIKUNSZT - 5;
    if KOP > 95 then MINIKUNSZT := MINIKUNSZT - 2;
    if MINIKUNSZT < 0 then MINIKUNSZT := 0;
    WriteLn('ZABILES GO ! ZYSKUJESZ ZA TO ', MINIKUNSZT, ' KUNSZTU ');
    KUNSZT := MINIKUNSZT + KUNSZT;
    FIREBALL := 0;
    POISON := 0;

    if QUEST > 0 then QUESTWYK := QUESTWYK - 1;
    if POTRAWKI > 0 then begin
      FUKS := Random(100);
      if POTRAWKI > FUKS then begin
        WriteLn('ROBISZ SOBIE PYSZNY PYSZNY BIGOS Z KAPUSTA Z WROGA');
        BIGOS := BIGOS - 10;
        PRZED := PRZED + 1;
        if (FUKS < 1) and (POTRAWKI < 100) then begin
          WriteLn('UCZYSZ SIE ZDOLNOSCI POTRAWKI !!! ');
          POTRAWKI := POTRAWKI + 1;
          KUNSZT := KUNSZT + 10;

        end;
      end;
    end;
  end;
  if ENERGIA < 1 then begin
    WriteLn('!!!!!!!!!!!ZOSTALES ZABITY!!!!!!!!!!!!');
    Delay(3000);
    MIECHO := 10000;
  end;
  MINIKUNSZT := 0;
end;

procedure BRANIE;
begin
  if (wpisz = 'BIERZ STARY') and (MMIECZ = MIECHO2) then begin
    WriteLn('PODNOSISZ STARY ZARDZEWIALY MIECZ I MASZ JAROWE ZE GO POSIADASZ');
    MMIECZ := -10;
    PRZED := PRZED + 1;
  end;
  if (wpisz = 'BIERZ MALA') and (MTARCZA = MIECHO2) then begin
    WriteLn('PODNOSISZ MALA TARCZA (JEST OKRAGLA)');
    MTARCZA := -10;
    PRZED := PRZED + 1;
  end;
  if (wpisz = 'BIERZ SERCE') and (SERCE = MIECHO2) then begin
    WriteLn('PODNOSISZ ZAKRWAWIONE SERCE (BLEEEE)');
    SERCE := -10;
    PRZED := PRZED + 1;
  end;
  if (wpisz = 'BIERZ DYPLOM') and (DYPLOM = MIECHO2) then begin
    WriteLn('PODNOSISZ DYPLOM MUD SZKOLY , I CZUJESZ PRZEPLYWAJACA PRZEZ CIEBIE MOC');
    DYPLOM := -10;
    MONSTRA.MAXE := MONSTRA.MAXE + 5;
    PRZED := PRZED + 1;
  end;
  if (wpisz = 'BIERZ FAJKA') and (FAJKA = MIECHO2) then begin
    WriteLn('PODNOSISZ FAJKE ');
    FAJKA := -10;
    PRZED := PRZED + 1;
    if MAD < MAXMAD then MAD := MAD + 1;
  end;
  if (wpisz = 'ODRZUC STARY') and (MMIECZ = -10) then begin
    WriteLn('ODRZUCASZ STARY ZARDZEWIALY MIECZ I MASZ JAROWE ZE GO NIE POSIADASZ');
    MMIECZ := MIECHO2;
    PRZED := PRZED - 1;
  end;
  if (wpisz = 'ODRZUC FAJKA') and (FAJKA = -10) then begin
    WriteLn('WYRZUCASZ FAJKE ');
    FAJKA := MIECHO2;
    PRZED := PRZED - 1;
    MAD := MAD - 1;
  end;
  if (wpisz = 'ODRZUC MALA') and (MTARCZA = -10) then begin
    WriteLn('ODRZUCASZ MALA ZWYKLA TARCZE ');
    MTARCZA := MIECHO2;
    PRZED := PRZED - 1;
  end;
  if (wpisz = 'ODRZUC SERCE') and (SERCE = -10) then begin
    WriteLn('ODRZUCASZ ZAKRWAWIONE SERCE ');
    SERCE := MIECHO2;
    PRZED := PRZED - 1;
  end;
  if (wpisz = 'ODRZUC DYPLOM') and (DYPLOM = -10) then begin
    WriteLn('ODRZUCASZ DYPLOM MUD SZKOLY , I PRZESTAJESZ CZUC PRZEPLYWAJACA PRZEZ CIEBIE MOC');
    DYPLOM := MIECHO2;
    MONSTRA.MAXE := MONSTRA.MAXE - 5;
    PRZED := PRZED - 1;
  end;
end;
procedure UZYWANIE;
begin
  if (wpisz = 'UZYJ FAJKA') and (FAJKA = -10) then WriteLn('ZAPALASZ FAJECZKE I PYKASZ Z ZADOWOLENIEM');
  if (wpisz = 'UZYJ SERCE') and (SERCE = -10) then begin
    SERCE := 0;
    WriteLn('ZJADASZ ZAKRWAWIONE SERCE I ODZYSKUJESZ 5% ENERGII');
    ENERGIA := ENERGIA + 5;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;
    PRZED := PRZED - 1;
  end;
  if (wpisz = 'UZYJ DYPLOM') and (DYPLOM = -10) then begin
    WriteLn('PATRZYSZ SIE NA DYPLOM:');
    WriteLn('--------------------------------------');
    WriteLn('|         DYPLOM MUD SZKOLY          |');
    WriteLn('|                                    |');
    WriteLn('|                                    |');
    WriteLn('|                                    |');
    WriteLn('|  BRAWO! BEZ WIEKSZYCH PROBLEMOW    |');
    WriteLn('|  PRZEBRNALES PRZEZ MUD SZKOLE      |');
    WriteLn('|  W NAGRODE ZA DUZA AKTYWNOSC       |');
    WriteLn('|  DAJE CI OTO TEN DYPLOM MUD SZKOLY |');
    WriteLn('|____________________________________|');
  end;
  if (wpisz = 'UZYJ PACZEK') and (PACZEK <= -10) then begin
    PRZED := PRZED - 1;
    PACZEK := PACZEK + 10;
    WriteLn('ZJADASZ PACZKA I TYJESZ 1 KILO (DOSTAJESZ 8%ENERGII)');
    ENERGIA := ENERGIA + 8;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;
  end;
  if (wpisz = 'UZYJ CIASTKO') and (CIASTKO <= -10) then begin
    PRZED := PRZED - 1;
    CIASTKO := CIASTKO + 10;
    WriteLn('ZJADASZ CIASTKO I TYJESZ 2 KILO (DOSTAJESZ 12% ENERGII)');
    ENERGIA := ENERGIA + 12;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;
  end;
  if (wpisz = 'UZYJ SUCHA RACJA') and (SUCHA <= -10) then begin
    PRZED := PRZED - 1;
    SUCHA := SUCHA + 10;
    WriteLn('ZJADASZ SUCHA RACJE I CHUDNIESZ 3 KILO (DOSTAJESZ 16% ENERGII)');
    ENERGIA := ENERGIA + 16;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;
  end;
  if (wpisz = 'UZYJ BULKA') and (BULKA <= -10) then begin
    PRZED := PRZED - 1;
    BULKA := BULKA + 10;
    WriteLn('ZJADASZ BULKE I STWIERDZASZ ZE ZYSKALES 20%');
    ENERGIA := ENERGIA + 20;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;
  end;
  if (wpisz = 'ZNISZCZ PRZEPUSTKA') and (PRZEPUSTKA <= -10) then begin
    WriteLn('GRRRRRRRRR .... GLUPIA PRZEPUSTKA');
    PRZEPUSTKA := PRZEPUSTKA + 10;
    PRZED := PRZED + 1;
  end;
  if (wpisz = 'PATRZ PRZEPUSTKA') and (PRZEPUSTKA <= -10) then begin
    WriteLn('|========================|');
    WriteLn('| Niniejszym zaswiadczam |');
    WriteLn('|  Iz osoba posiadajaca  |');
    WriteLn('|      Ten dokument      |');
    WriteLn('|   Ukonczyla pozytywnie |');
    WriteLn('| Jeden z moich quest'#162'w  |');
    WriteLn('|========================|');
  end;
  if (wpisz = 'UZYJ CHLEB') and (CHLEB <= -10) then begin
    PRZED := PRZED - 1;
    CHLEB := CHLEB + 10;
    WriteLn('ZJADASZ DUZY CIEPLY CHLEB I JESTES PELEN (ZYSKUJESZ 26%)');
    ENERGIA := ENERGIA + 26;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;
  end;
  if wpisz = 'UZYJ KASETA' then WriteLn('TEN PRZEMIOT JEST TYPU : SMIEC . S.Z -8 MAXE +5 ZRE +1 ');
  if (wpisz = 'UZYJ WEKA') and (WEKA <= -10) then begin
    PRZED := PRZED - 1;
    WEKA := WEKA + 10;
    WriteLn('ZJADASZ DLUGASNA WEKE I TYJAC 15 KILO ZYSKUJESZ 34%');
    ENERGIA := ENERGIA + 34;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;
  end;
  if (wpisz = 'UZYJ MALA BUTELKA MANY') and (MBUTELKA <= -10) then begin
    PRZED := PRZED - 1;
    MBUTELKA := MBUTELKA + 10;
    WriteLn('WYPIJASZ MALA BUTELKE MANY I ODZYSKUJESZ 30 MANY');
    MANA := MANA + 30;
    if MANA > MAXMANA then MANA := MAXMANA;
  end;
  if (wpisz = 'UZYJ BIGOS') and (BIGOS <= -10) then begin
    PRZED := PRZED - 1;
    BIGOS := BIGOS + 10;
    WriteLn('ZJADASZ BIGOS Z WROGA I ODZYSKUJESZ 20% ENERGI');
    ENERGIA := ENERGIA + 20;
    if ENERGIA > MONSTRA.MAXE then ENERGIA := MONSTRA.MAXE;

  end;
  if (wpisz = 'UZYJ KOMPLET') and (KOMPLET <= -10) and (JAKIEUB = '') then begin
    WriteLn('NAKLADASZ KOMPLET UBRAN FIRMY "SYF"');
    PRO := PRO + 7;
    CIALO := 1;
    JAKIEUB := 'SYF';
  end;
  if (wpisz = 'ODLORZ KOMPLET') and (KOMPLET <= -10) and (JAKIEUB = 'SYF') then begin
    WriteLn('ZDEJMUJESZ KOMPLET UBRAN FIRMY "SYF"');
    CIALO := 0;
    PRO := PRO - 7;
    JAKIEUB := '';
  end;
  if (wpisz = 'UZYJ LISTEK') and (LISTEK <= -10) then WriteLn('LISTEK JEST TYPU SMIEC MAX PRZEDMIOTOW + 3 ');
  if (wpisz = 'UZYJ GARNITUR') and (GARNITUR <= -10) and (JAKIEUB = '') then begin
    WriteLn('NAKLADASZ GARNITUR Z KOLCAMI NA SWE (NIE)WYSPORTOWANE CIALO');
    CIALO := 1;
    ILOSC := ILOSC + 1;
    PRO := PRO + 10;
    FUKSROLL := FUKSROLL + 15;
    JAKIEUB := 'GARNITUR';
  end;
  if (wpisz = 'UZYJ PIGULKA') and (PIGULKA <= -10) then begin
    WriteLn('WSZYSTKO ZACZYNA WIROWAC , POTEM NAGLY BLYSK I ZNAJDUJESZ SIE W PRZESZLOSCI');
    PIGULKA := PIGULKA + 10;
    POTWORY;
    if MAD < 10 then begin
      WriteLn('BRAK OBYCIA W POSLUGIWANIU SIE MAGICZNYMI PRZEDMIOTAMI SPRAWIL ZE ');
      WriteLn('ZNACZNIE OPADLES Z SIL I STALES SIE BARDZO ZMECZONY');
      MONSTRA.MAXE := MONSTRA.MAXE - 1;
      ENERGIA := 1;
      KUNSZT := KUNSZT - 50;
    end;
    if (MAD > 9) and (MAD < 16) then begin
      WriteLn('MASZ PEWNE OBYCIE W MAGICZNYCH PRZEDMIOTACH ALE MIMO WSZYSTKO');
      WriteLn('OPADLES Z SIL I STALES SIE ZMECZONY');
      ENERGIA := ENERGIA - 40;
      if ENERGIA < 1 then ENERGIA := 1;
      KUNSZT := KUNSZT - 30;
    end;
    if MAD > 15 then WriteLn('ZNASZ SIE NA TEGO TYPU PRZEDMIOTACH , WYSZEDLES Z TEGO BEZ SZWANKU');
  end;
  if (wpisz = 'ODLORZ GARNITUR') and (GARNITUR <= -10) and (JAKIEUB = 'GARNITUR') then begin
    WriteLn('ZDEJMUJESZ GARNITUR Z KOLCAMI ZE SWEGO (NIE)WYSPORTOWANEGO CIALA');
    CIALO := 0;
    ILOSC := ILOSC - 1;
    PRO := PRO - 10;
    FUKSROLL := FUKSROLL - 15;
    JAKIEUB := '';
  end;
end;

procedure PIERDOLY;
begin
  if wpisz = 'ZMIEN KOLOR' then begin
    WriteLn('PODAJ LICZBE KOLORU');
    ReadLn(FUKS);
    TextColor(FUKS);
  end;
  if wpisz = 'ZMIEN TLO' then begin
    WriteLn('PODAJ LICZBE TLA');
    ReadLn(FUKS);
    TextBackground(FUKS);
  end;
end;
procedure MINIARENA;
begin
  if (MIECHO = 33) or (MIECHO = 34) or (MIECHO = 35) or (MIECHO = 36) or (MIECHO = 37) or
     (MIECHO = 38) or (MIECHO = 39) or (MIECHO = 40) or (MIECHO = 41) or (MIECHO = 42) or
     (MIECHO = 43) or (MIECHO = 44) or (MIECHO = 45) or (MIECHO = 46) or (MIECHO = 47) or
     (MIECHO = 48) or (MIECHO = 49) or (MIECHO = 50) or (MIECHO = 51) or (MIECHO = 52) or
     (MIECHO = 53) or (MIECHO = 54) or (MIECHO = 55) or (MIECHO = 56) or (MIECHO = 57) then
  begin
    ARENA := 1;
    WriteLn('JESTES NA ARENIE I CZUJESZ POTRZEBE ZABIJANIA');
    KTO;
    repeat
      write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if (wpisz = 'ZABIJ BAKTERIA') and (MIECHO = BAKTERIA) then
      begin SLABO;
        BAKTERIA := 0;
        WriteLn('BUUUUU! BIEDNA BAKTERIA ');
      end;
      if (wpisz = 'ZABIJ SLIMAK') and (MIECHO = SLIMAK) then
      begin SLABO;
        if PASZOL = 0 then SLIMAK := 0;
      end;
      if (wpisz = 'ZABIJ KORNIK') and (MIECHO = KORNIK) then
      begin SLABO;
        if PASZOL = 0 then KORNIK := 0;
      end;
      if (wpisz = 'ZABIJ MUCHA') and (MIECHO = MUCHA) then
      begin SLABO;
        if PASZOL = 0 then MUCHA := 0;
      end;

      if (wpisz = 'ZABIJ ZUK') and (MIECHO = ZUK) then
      begin SLABO;
        if PASZOL = 0 then ZUK := 0;
      end;
      if (wpisz = 'ZABIJ KARALUCH') and (MIECHO = KARALUCH) then
      begin SLABO;
        KARALUCH := 0;
      end;
      if (wpisz = 'ZABIJ MROWKA') and (MIECHO = MROWKA) then
      begin SLABO;
        MROWKA := 0;
      end;
      if (wpisz = 'ZABIJ PAJAK') and (MIECHO = PAJAK) then
      begin SLABO;
        PAJAK := 0;
      end;
      if (wpisz = 'ZABIJ DZIK') and (MIECHO = DZIK) then
      begin MNIEJSLABO;
        DZIK := 0;
      end;
      if (wpisz = 'ZABIJ WILCZUR') and (MIECHO = WILCZUR) then
      begin WriteLn('WILCZUR PRZYJA PROPOZYCJE Z GODNOSCIA');
        MNIEJSLABO;
        WILCZUR := 0;
      end;

      if (wpisz = 'ZABIJ SZCZUR') and (MIECHO = SZCZUR) then
      begin MNIEJSLABO;
        SZCZUR := 0;
      end;
      if (wpisz = 'ZABIJ LIS') and (MIECHO = LIS) then
      begin MNIEJSLABO;
        LIS := 0;
      end;
      if (wpisz = 'ZABIJ KUROPATWA') and (MIECHO = KUROPATWA) then
      begin MNIEJSLABO;
        KUROPATWA := 0;
      end;
      if (wpisz = 'ZABIJ ZAJAC') and (MIECHO = ZAJAC) then
      begin MNIEJSLABO;
        ZAJAC := 0;
      end;
      if (wpisz = 'ZABIJ ORZEL') and (MIECHO = ORZEL) then
      begin MNIEJSLABO;
        ORZEL := 0;
      end;
      if (wpisz = 'ZABIJ SARNA') and (MIECHO = SARNA) then
      begin MNIEJSLABO;
        SARNA := 0;
      end;
      if (wpisz = 'ZABIJ SLON') and (MIECHO = SLON) then
      begin SREDNIO;
        SLON := 0;
      end;
      if (wpisz = 'ZABIJ LEW') and (MIECHO = LEW) then
      begin SREDNIO;
        LEW := 0;
      end;
      if (wpisz = 'ZABIJ ZYRAFA') and (MIECHO = ZYRAFA) then
      begin SREDNIO;
        ZYRAFA := 0;
      end;
      if (wpisz = 'ZABIJ WILK') and (MIECHO = WILK) then
      begin SREDNIO;
        WILK := 0;
      end;
      if (wpisz = 'ZABIJ WIELBLAD') and (MIECHO = WIELBLAD) then
      begin SREDNIO;
        WIELBLAD := 0;
      end;
      if (wpisz = 'ZABIJ STRUS') and (MIECHO = STRUS) then
      begin SREDNIO;
        STRUS := 0;
      end;
      if (wpisz = 'ZABIJ BOA') and (MIECHO = BOA) then
      begin SREDNIO;
        BOA := 0;
      end;
      if (wpisz = 'ZABIJ BIZON') and (MIECHO = BIZON) then
      begin SREDNIO;
        BIZON := 0;
      end;
      if (wpisz = 'ZABIJ PANTERA') and (MIECHO = PANTERA) then
      begin SREDNIO;
        PANTERA := 0;
      end;
      if (wpisz = 'ZABIJ GLADIATOR') and (MIECHO = GLADIATOR) then
      begin TRUDNO;
        GLADIATOR := 0;
        PIGULKAZYSK;
      end;
      if (wpisz = 'ZABIJ WOJOWNIK') and (MIECHO = WOJOWNIK) then
      begin TRUDNO;
        WOJOWNIK := 0;
        PIGULKAZYSK;
      end;
      if (wpisz = 'ZABIJ TRENER') and (MIECHO = TRENER) then
      begin TRUDNO;
        TRENER := 0;
        GARNITURZYSK;
      end;
      if wpisz = 'EXIT' then begin
        if MIECHO = 33 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLODNIE-WEJSCIE NA ARENE');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (MIECHO = 34) or (MIECHO = 37) or (MIECHO = 38) or (MIECHO = 39) or
                (MIECHO = 42) or (MIECHO = 43) or (MIECHO = 44) or (MIECHO = 48) or
                (MIECHO = 49) then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (MIECHO = 35) or (MIECHO = 36) then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if MIECHO = 40 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if MIECHO = 41 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
        if (MIECHO = 45) or (MIECHO = 50) or (MIECHO = 54) then begin
          WriteLn('MOZESZ WYJSC NA :');
          WriteLn('POLNOC-ARENA');
          WriteLn('POLODNIE-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (MIECHO = 46) or (MIECHO = 51) or (MIECHO = 55) then begin
          WriteLn('MOZESZ WYJSC NA :');
          WriteLn('POLNOC-ARENA');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
        if (MIECHO = 47) or (MIECHO = 52) or (MIECHO = 53) then begin
          WriteLn('MOZESZ ISC NA :');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if MIECHO = 56 then begin
          WriteLn('DOSTEPNE WYJSCIE:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if MIECHO = 57 then begin
          WriteLn('DOSTEPNE WYJSCIE:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
      end;
      if wpisz = 'WYJSCIE' then exit;
      if wpisz = 'POLODNIE' then begin
        ARENA := 0;
        if MIECHO = 33 then MIECHO := 32;
        if MIECHO = 34 then MIECHO := 33;
        if (MIECHO = 35) or (MIECHO = 36) or (MIECHO = 40) or (MIECHO = 41) then ARENA := 1;
        if MIECHO = 37 then MIECHO := 34;
        if MIECHO = 38 then MIECHO := 35;
        if MIECHO = 39 then MIECHO := 36;
        if MIECHO = 42 then MIECHO := 37;
        if MIECHO = 43 then MIECHO := 38;
        if MIECHO = 44 then MIECHO := 39;
        if MIECHO = 45 then MIECHO := 40;
        if MIECHO = 46 then MIECHO := 41;
        if MIECHO = 47 then MIECHO := 42;
        if MIECHO = 48 then MIECHO := 43;
        if MIECHO = 49 then MIECHO := 44;
        if MIECHO = 50 then MIECHO := 45;
        if MIECHO = 51 then MIECHO := 46;
        if MIECHO = 52 then MIECHO := 48;
        if MIECHO = 53 then MIECHO := 49;
        if MIECHO = 54 then MIECHO := 50;
        if MIECHO = 55 then MIECHO := 51;
        if MIECHO = 56 then MIECHO := 54;
        if MIECHO = 57 then MIECHO := 55;
      end;
      if wpisz = 'POLNOC' then begin
        ARENA := 0;
        if MIECHO = 33 then begin MIECHO := 34; STOP := 1; end;
        if (MIECHO = 34) and (STOP = 0) then begin MIECHO := 37; STOP := 1; end;
        if (MIECHO = 35) and (STOP = 0) then begin MIECHO := 38; STOP := 1; end;
        if (MIECHO = 36) and (STOP = 0) then begin MIECHO := 39; STOP := 1; end;
        if (MIECHO = 37) and (STOP = 0) then begin MIECHO := 42; STOP := 1; end;
        if (MIECHO = 38) and (STOP = 0) then begin MIECHO := 43; STOP := 1; end;
        if (MIECHO = 39) and (STOP = 0) then begin MIECHO := 44; STOP := 1; end;
        if (MIECHO = 40) and (STOP = 0) then begin MIECHO := 45; STOP := 1; end;
        if (MIECHO = 41) and (STOP = 0) then begin MIECHO := 46; STOP := 1; end;
        if (MIECHO = 42) and (STOP = 0) then begin MIECHO := 47; STOP := 1; end;
        if (MIECHO = 43) and (STOP = 0) then begin MIECHO := 48; STOP := 1; end;
        if (MIECHO = 44) and (STOP = 0) then begin MIECHO := 49; STOP := 1; end;
        if (MIECHO = 45) and (STOP = 0) then begin MIECHO := 50; STOP := 1; end;
        if (MIECHO = 46) and (STOP = 0) then begin MIECHO := 51; STOP := 1; end;
        if (MIECHO = 47) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 48) and (STOP = 0) then begin MIECHO := 52; STOP := 1; end;
        if (MIECHO = 49) and (STOP = 0) then begin MIECHO := 53; STOP := 1; end;
        if (MIECHO = 50) and (STOP = 0) then begin MIECHO := 54; STOP := 1; end;
        if (MIECHO = 51) and (STOP = 0) then begin MIECHO := 55; STOP := 1; end;
        if (MIECHO = 52) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 53) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 54) and (STOP = 0) then begin MIECHO := 56; STOP := 1; end;
        if (MIECHO = 55) and (STOP = 0) then begin MIECHO := 57; STOP := 1; end;
        if (MIECHO = 56) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 57) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
      end;
      if wpisz = 'WSCHOD' then begin
        ARENA := 0;
        if (MIECHO = 33) and (STOP = 0) then begin MIECHO := 35; STOP := 1; end;
        if (MIECHO = 34) and (STOP = 0) then begin MIECHO := 38; STOP := 1; end;
        if (MIECHO = 35) and (STOP = 0) then begin MIECHO := 40; STOP := 1; end;
        if (MIECHO = 36) and (STOP = 0) then begin MIECHO := 33; STOP := 1; end;
        if (MIECHO = 37) and (STOP = 0) then begin MIECHO := 43; STOP := 1; end;
        if (MIECHO = 38) and (STOP = 0) then begin MIECHO := 45; STOP := 1; end;
        if (MIECHO = 39) and (STOP = 0) then begin MIECHO := 34; STOP := 1; end;
        if (MIECHO = 40) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 41) and (STOP = 0) then begin MIECHO := 36; STOP := 1; end;
        if (MIECHO = 42) and (STOP = 0) then begin MIECHO := 48; STOP := 1; end;
        if (MIECHO = 43) and (STOP = 0) then begin MIECHO := 50; STOP := 1; end;
        if (MIECHO = 44) and (STOP = 0) then begin MIECHO := 37; STOP := 1; end;
        if (MIECHO = 45) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 46) and (STOP = 0) then begin MIECHO := 39; STOP := 1; end;
        if (MIECHO = 47) and (STOP = 0) then begin MIECHO := 52; STOP := 1; end;
        if (MIECHO = 48) and (STOP = 0) then begin MIECHO := 54; STOP := 1; end;
        if (MIECHO = 49) and (STOP = 0) then begin MIECHO := 42; STOP := 1; end;
        if (MIECHO = 50) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 51) and (STOP = 0) then begin MIECHO := 44; STOP := 1; end;
        if (MIECHO = 52) and (STOP = 0) then begin MIECHO := 56; STOP := 1; end;
        if (MIECHO = 53) and (STOP = 0) then begin MIECHO := 47; STOP := 1; end;
        if (MIECHO = 54) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 55) and (STOP = 0) then begin MIECHO := 49; STOP := 1; end;
        if (MIECHO = 56) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 57) and (STOP = 0) then begin MIECHO := 53; STOP := 1; end;
      end;
      if wpisz = 'ZACHOD' then begin
        ARENA := 0;
        if (MIECHO = 33) and (STOP = 0) then begin MIECHO := 36; STOP := 1; end;
        if (MIECHO = 34) and (STOP = 0) then begin MIECHO := 39; STOP := 1; end;
        if (MIECHO = 35) and (STOP = 0) then begin MIECHO := 33; STOP := 1; end;
        if (MIECHO = 36) and (STOP = 0) then begin MIECHO := 41; STOP := 1; end;
        if (MIECHO = 37) and (STOP = 0) then begin MIECHO := 44; STOP := 1; end;
        if (MIECHO = 38) and (STOP = 0) then begin MIECHO := 34; STOP := 1; end;
        if (MIECHO = 39) and (STOP = 0) then begin MIECHO := 46; STOP := 1; end;
        if (MIECHO = 40) and (STOP = 0) then begin MIECHO := 35; STOP := 1; end;
        if (MIECHO = 41) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 42) and (STOP = 0) then begin MIECHO := 49; STOP := 1; end;
        if (MIECHO = 43) and (STOP = 0) then begin MIECHO := 37; STOP := 1; end;
        if (MIECHO = 44) and (STOP = 0) then begin MIECHO := 51; STOP := 1; end;
        if (MIECHO = 45) and (STOP = 0) then begin MIECHO := 38; STOP := 1; end;
        if (MIECHO = 46) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 47) and (STOP = 0) then begin MIECHO := 53; STOP := 1; end;
        if (MIECHO = 48) and (STOP = 0) then begin MIECHO := 42; STOP := 1; end;
        if (MIECHO = 49) and (STOP = 0) then begin MIECHO := 55; STOP := 1; end;
        if (MIECHO = 50) and (STOP = 0) then begin MIECHO := 43; STOP := 1; end;
        if (MIECHO = 51) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 52) and (STOP = 0) then begin MIECHO := 47; STOP := 1; end;
        if (MIECHO = 53) and (STOP = 0) then begin MIECHO := 57; STOP := 1; end;
        if (MIECHO = 54) and (STOP = 0) then begin MIECHO := 48; STOP := 1; end;
        if (MIECHO = 55) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
        if (MIECHO = 56) and (STOP = 0) then begin MIECHO := 52; STOP := 1; end;
        if (MIECHO = 57) and (STOP = 0) then begin ARENA := 1; STOP := 1; end;
      end;
      STOP := 0;
      until (ARENA = 0) or (MIECHO = 1000);
  end;
end;
procedure FIGHTSCENA;
begin
  if (wpisz = 'ZABIJ PERKUSISTA') and (PERKUSISTA = MIECHO) then begin
    VEASY;
    PERKUSISTA := 0;
    KASETAZYSK;
  end;
  if (wpisz = 'ZABIJ GITARZYSTA') and (GITARZYSTA = MIECHO) then begin
    VEASY;
    GITARZYSTA := 0;
    KASETAZYSK;
  end;
  if (wpisz = 'ZABIJ LIROY') and (LIROY = MIECHO) then begin
    NEASY;
    if (MIECHO <> 10000) and (ENERGIA > 0) and (PASZOL = 0) then begin
      WriteLn('GRATULACJE !!! ZABILES LIROYA DOSTAJESZ ZA DARMO 30 KASY');
      FORSA := FORSA + 30;
      KASETAZYSK;
      if QUEST > 1 then QUESTWYK := QUESTWYK - 150;
      LIROY := 0;
    end;
  end;
  if (wpisz = 'ZABIJ ORGANISTA') and (ORGANISTA = MIECHO) then begin
    VEASY;
    ORGANISTA := 0;
    KASETAZYSK;
  end;
end;
procedure ZabijRoslineVEASY(cmd: string; var roslin: Integer);
{ Kill plant with VEASY difficulty (no energy check). }
begin
  if (wpisz = cmd) and (roslin = MIECHO) then begin
    VEASY;
    roslin := 0;
  end;
end;

procedure ZabijRoslineVEASYEnergy(cmd: string; var roslin: Integer);
{ Kill plant with VEASY difficulty (energy check). }
begin
  if (wpisz = cmd) and (roslin = MIECHO) then begin
    VEASY;
    if ENERGIA > 0 then roslin := 0;
  end;
end;

procedure ZabijRoslineEASYEnergy(cmd: string; var roslin: Integer);
{ Kill plant with EASY difficulty (energy check). }
begin
  if (wpisz = cmd) and (roslin = MIECHO) then begin
    EASY;
    if ENERGIA > 0 then roslin := 0;
  end;
end;

procedure FIGHTBLUSZCZ;
begin
  if (wpisz = 'ZABIJ DUNCAN') and (DUNCAN = MIECHO) then begin
    EASY;
    if WROGEN < 1 then DUNCAN := 0;
  end;
  if (wpisz = 'SECRET LISTA') and (DUNCAN = MIECHO) then begin
    WriteLn('OTO CO AKTUALNIE MAM DO ZAOFEROWANIA : PAMIETAJ U MNIE TYLKO KUPUJEMY');
    WriteLn('MARCHEWKA Z SADU DUNCANA   : 7000');
    WriteLn('PRZEPUSTKA QUEST-MASTERA   :  400');
    WriteLn('PLECAK                     : 4800');
  end;
  if wpisz = 'KUP DOKUMENT' then begin if FORSA > 399 then begin
      WriteLn('OTO PODROBIONA PRZEPUSTKA HE , HE NAWET QUEST-MASTER SIE NIE POKAPUJE');
      PRZEPUSTKA := PRZEPUSTKA - 10;
      FORSA := FORSA - 400;
      PRZED := PRZED + 1; end;
  end;
  if (wpisz = 'KUP PLECAK') and (DUNCAN = MIECHO) then begin if FORSA > 4799 then begin
      WriteLn('HE HE HE MILO SIE Z TOBA ROBI INTERESY');
      FORSA := FORSA - 4800;
      PLECAK := PLECAK - 10;
      PRZED := PRZED + 1; end;
  end;
  if (wpisz = 'ROZMAWIAJ DUNCAN') and (DUNCAN = MIECHO) then begin
    if DUNQ = 0 then begin
      WriteLn('UCH A COZ TO ZA STRASZNA ROSLINA - PRZELAKL SIE DUNCAN WIDZAC CIEBIE');
      WriteLn('AAA TO JAKIS WAL A NIE ROSLINA , MOWI PO CHWILI,JAK CI SIE NUDZI TO ');
      WriteLn('MOZESZ POMOC MI WYRYWAC CHWASTY , SZCZEGOLNIA ZABOJCZA DLA MOICH MARCHEWECZEK');
      WriteLn('JEST TA WREDNA POKRZYWA , SZKODA ZE TAK JAK INNE POTWORY SIE ODREGENEROWUJE');
      WriteLn('ALE JAK JA ZABIJESZ , POWIEDZMY ... 4 RAZY TO MOZE DA SOBIE SPOKOJ');
      WriteLn('CO CI DAM W ZAMIAN ? TROCHE KUNSZTU , A MOJ STARY PRACUJE NA CZARNYM RYNKU');
      DUNQ := 75;
    end;
    if DUNQ <> 0 then
      WriteLn('TO CO ZABIJESZ TE ROSLINY CZY BEDZIEMY TU STAC JAK OSTATNIE LOSIE?');

    if DUNQ = -125 then begin
      WriteLn('DZIEKI DZIEKI , TO BYLA DOBRA ROBOTA , OD TERAZ MOZESZ PISAC PRZY MNIE :');
      WriteLn('SECRET LISTA , TO MOZE AKURAT BEDE COS MIAL NA ZBYCIU , ADIOS');
      DUNQ := 0;
      KUNSZT := KUNSZT + 125;
      WriteLn('--------- ZDOBYLES 125 KUNSZTU ------------------------');

    end;
  end;
  { VEASY plants (no energy check) }
  ZabijRoslineVEASY('ZABIJ SZCZAW', SZCZAW);
  ZabijRoslineVEASY('ZABIJ KONICZYNKA', KONICZYNKA);
  ZabijRoslineVEASY('ZABIJ MLECZ', MLECZ);
  ZabijRoslineVEASY('ZABIJ DMUCHAWIEC', DMUCHAWIEC);
  { VEASY plant with energy check }
  ZabijRoslineVEASYEnergy('ZABIJ STOKROTKA', STOKROTKA);
  { EASY plants with energy check }
  ZabijRoslineEASYEnergy('ZABIJ ROZA', ROZA);
  ZabijRoslineEASYEnergy('ZABIJ OSET', OSET);
  ZabijRoslineEASYEnergy('ZABIJ MALINA', MALINA);
  ZabijRoslineEASYEnergy('ZABIJ AGREST', AGREST);
  ZabijRoslineEASYEnergy('ZABIJ JEZYNA', JEZYNA);
  { TRAWA - special: 3x TRUDNO }
  if (wpisz = 'ZABIJ TRAWA') and (TRAWA = MIECHO) then begin
    WriteLn('HA HA HA WOLAJA SETKI LISCI TRAWY - TO BEDZIE WALKA');
    TRUDNO;
    if ENERGIA > 0 then TRUDNO;
    if ENERGIA > 0 then TRUDNO;
    if ENERGIA > 0 then TRUDNO;
    if (ENERGIA > 0) and (PASZOL = 0) then
      WriteLn('UFF STRUDZONY POSTANAWIASZ ODPOCZAC TYLU PRZECIWNIKOW DAWNO NIE WIDZIALES');
  end;
end;
procedure KOMENDY;
{ Expand single-letter command abbreviations. }
const
  AbbrevCount = 8;
  AbbrevFrom: array[1..AbbrevCount] of string = ('PN','PD','W','Z','G','D','E','M');
  AbbrevTo:   array[1..AbbrevCount] of string = ('POLNOC','POLODNIE','WSCHOD','ZACHOD','GORA','DOL','EXIT','MODE');
var i: Integer;
begin
  for i := 1 to AbbrevCount do
    if wpisz = AbbrevFrom[i] then begin
      wpisz := AbbrevTo[i];
      Exit;
    end;
end;

procedure save;
begin
end;
end.
