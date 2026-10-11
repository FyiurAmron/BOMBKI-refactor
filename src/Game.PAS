unit Game;

interface
uses crt;

var MaxEnergy, Dachshund, Shepherd, Spaniel, Poodle, Pooch, Cabman, Vendor, Sweeper: Integer;
var Drunkard, SickMan, Minibarman, Fatso, DJ, Pedal, Couple, Maciek, Overall, Door, OldElf: Integer;
var CageStrong: Integer;
procedure ShowIntro;

var OldSword, OuterRoom, ItemCount, SmallShield, Heart, Diploma, Pipe, Wisdom, Strength, Dexterity, ManaBottle, Practice: Integer;
var MaxWisdom, MaxStrength, MaxDexterity, Energy, Roll, Doughnut, Cookie, DryRation, Bread, BreadRoll, Sausage: Integer;
var Mana, MaxMana, EnemyEnergy, FightExperience, EnemyStrength, EnemyDexterity, EnemyDodged, PlayerDodged, DodgeChance, Damage: Integer;
var Armor, WornCount, Parry, Kick, KickMinMana, KickMaxEnergy, Fleeing, FleeEnergy, Fled, Experience, Room, InArena: Integer;
var Woodworm, Fly, Bacterium, Snail, Beetle, Cockroach, Ant, Spider, Boar, Rat, Fox: Integer;
var Partridge, Hare, Mongrel, Eagle, Deer, Elephant, Lion, Giraffe, Camel, Ostrich, Boa: Integer;
var Wolf, Bison, Panther, Gladiator, Warrior, Tamer, Loot, MoveGuard, Tracksuit, Wearing: Integer;
var Money, Permit: Longint;
var SpikedSuit, LuckRoll, Guitarist, Drummer, Keyboardist, Liroy, Cassette, CompareScroll: Integer;
var Sorrel, Daisy, Clover, SowThistle, Dandelion, Rose, Blackberry, Thistle, Gooseberry, Raspberry, Grass, Quest, QuestKills: Integer;
var Kid, Lunatic, Listener, Fan, Man, Policeman, Bouncer, OldMan, Gorilla, Backpack: Shortint;
var Reporter, TeleportPill, Cooking, Bigos, LuckyLeaf, Level, Comparing, FireballCharges, PoisonCharges, PoisonRounds, Duncan, DuncanQuest: Shortint;
var WornGarment: string;
var Command: string;
  procedure TakeDrop;
  procedure UseItems;
  procedure DisplayPrefs;
  procedure ShieldBlock;
  procedure Fight;
  procedure ArenaMaze;
  procedure DescribeBeasts;
  procedure EnterTrance;
  procedure FightWeak;
  procedure FightWeakish;
  procedure FightMedium;
  procedure FightHard;
  procedure FightVeryHard;
  procedure FightVeryEasy;
  procedure FightEasy;
  procedure FightNotEasy;
  procedure SuitGain;
  procedure PillGain;
  procedure CassetteGain;
  procedure LeafGain;
  procedure ScrollGain;
  procedure DescribeStage;
  procedure StageFights;
  procedure DescribeCrowd;
  procedure SpawnMonsters;
  procedure DescribePlants;
  procedure ExpandAbbrev;
  procedure PlantFights;
  procedure FightDog;
  procedure DescribeStreet;
  procedure CompareFoe;
  procedure HandleTrain;

  procedure Room0;
  procedure Room1;
  procedure Room4;
  procedure Room13;
  procedure PlainRooms;
  procedure Room5;
  procedure Room11;
  procedure Room30;
  procedure Room60;
  procedure Room75;
  procedure Room100;
  procedure Room83;

procedure Start;

implementation

procedure ShowIntro;
begin
  ClrScr;
  MaxEnergy := 50;
  WriteLn('         |||||| ');
  WriteLn('         ||||||                     M&M=MILY MUD ');
  WriteLn('         ||||||     ');
  WriteLn(' /-----------------------\       /\  /\   | |   \./  ');
  WriteLn('|   /\           /\       |     /  \/  \  | |__  | ');
  WriteLn('|   \/           \/       |');
  WriteLn('|        /                |     /\  /\   |   |  |-\ ');
  WriteLn('| \     /___)      /      |    /  \/  \  |___|  |_/ ');
  WriteLn('|  \______________/       |');
  WriteLn('|   \____________/        |');
  WriteLn('\_________________________/');
  WriteLn('VERSJA CETA 0.86 23.05.99 - LAST MODYFIKACIONEN');
  WriteLn('NACISNIJ DOWOLNY KLAWISZ ABY ROZPOCZAC GRE');
  WriteLn('KORZYSTAJ Z DUZYCH LITER !!!!!!!!!!!!!!!!!');
  repeat
    Sound(100);
    Delay(100);
    Sound(200);
    Delay(100);
    Sound(300);
    Delay(100);
    Sound(400);
    Delay(100);
    Sound(500);
    Delay(100);
    Sound(600);
    Delay(100);
    Sound(500);
    Delay(100);
    Sound(400);
    Delay(100);
    Sound(300);
    Delay(100);
    Sound(200);
    Delay(100);
    WriteLn('TICK !!!');
  until KeyPressed;
  NoSound;
end;

procedure Room5;
begin
  WriteLn('SZOK!! AAA UPSI  O NIE FUJ ACH AJ OCH NEIN EEE UGH   ');
  WriteLn('STWIERDZASZ ZE W TYM POKOJU JEST X POKOI O NIE !! JAK SIE WYDOSTAC?');
  WriteLn('AHA (NA SCIANIE JEST PLAKAT)');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-MUD SZKOLA');
      WriteLn('ZACHOD-POKOJ');
      WriteLn('POLNOC-POKOJ');
      WriteLn('POLODNIE-POKOJ');
      WriteLn('GORA-POKOJ');
      WriteLn('DOL-POKOJ');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Room := 4;
    if Command = 'ZACHOD' then Room := 6;
    if Command = 'POLNOC' then Room := 7;
    if Command = 'POLODNIE' then Room := 8;
    if Command = 'GORA' then Room := 9;
    if Command = 'DOL' then Room := 10;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE BYNAJMNIEJ PISZE');
      WriteLn('TO JEST POKOJ DO ORIETACJI W TERENIE ORAZ W KIERUNKACH');
    end;
  until Room <> 5;
end;

procedure Room0;
begin
  WriteLn('TU ZACZYNA SIE GRE');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then WriteLn('DOSTEPNE WYJSCIE-POLNOC-HALA GLOWNA MUD SZKOLE ');
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLNOC' then Room := 1;
  until Room <> 0;
end;
procedure Room1;
begin
  WriteLn('JESTES W OKROGLYM SALONIE WYPELNIONYM WITRAZAMI ');
  WriteLn('W POWIETRZU UNOSZA SIE ZAPACHY I SO TO ZAPACHY OK');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  WriteLn('NAPISZ PATRZ PLAKAT ABY GO ODCZYTA'#143' ');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-TAM GDZIE ZACZYNASZ GRE');
      WriteLn('POLNOC-MIASTO');
      WriteLn('WSCHOD-POKOJ TRENINGOWY 1');
      WriteLn('ZACHOD-MUD SZKOLA');
      WriteLn('DOL-PODDZIEMNY POKOJ TRENINGOWY(2)');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLODNIE' then Room := 0;
    if Command = 'WSCHOD' then Room := 2;
    if Command = 'DOL' then Room := 3;
    if Command = 'ZACHOD' then Room := 4;
    if Command = 'POLNOC' then Room := 20;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn(#169' NA PLAKACIE PISZE:');
      WriteLn('JE'#189'ELI CHCESZ TRENOWAC UDAJ SIE DO POKOJU TRENINGOWEGO');
      WriteLn('JE'#189'ELI CHCESZ NAUCZYC SIE NOWYCH KOMEND IDZ DO MUD SZKOLY');
      WriteLn('DOPIERO POTEM IDZ DO MIASTA ');
      WriteLn('A OTO TAJNE KOMENDY :');
      WriteLn(' MODE - WPROWADZENIE W STAN PODSWIADOMOSCI');
      WriteLn(' UNMODE - POWROT DO POPRZEDNIEGO STANU');
      WriteLn('W CZASIE POBYTU W STANIE PODSWIADOMOSCI DZIALA WIELE KOMEND MIN:');
      WriteLn(' JA - WSZYSTKO O TOBIE , BIERZ , UZYJ , ZDEJMIJ , ODRZUC I INNE ');
      WriteLn(' PONADTO WIELE KOMEND TRZEBA ODKRYC NP:ZMIEN KOLOR , ZMIEN TLO ');
      WriteLn(' UWAGA Z OSTATNIEJ CHWILI : KOMENDA SPIJ W STANIE PODSWIADOMOSCI!');
    end;
  until Room <> 1;
end;
procedure Room4;
begin
  if Room <> 4 then Exit;
  WriteLn('JESTES W HALLU MUD SZKOLY- OGARNIA CIE CYKORIA  ');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! AFISZ!!!');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-POKOJ CENTRALNY');
      WriteLn('ZACHOD-MUD SZKOLA (2)');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Room := 1;
    if Command = 'ZACHOD' then Room := 5;
    if Command = 'PATRZ AFISZ' then begin
      WriteLn(#169' NA AFISZU BYNAJMNIEJ PISZE');
      WriteLn('TO JEST MUD SZKOLA KUJ KOMEDY ALBO ZGINIESZ!!!!!!!!');
      WriteLn('JESLI CHODZI O EKWIPUNEK TO BIERZ (PRZEDMIOT)=BIERZESZ PRZEDMIOT');
      WriteLn('UZYJ (PRZEDMIOT) = UZYWASZ PRZEDMIOTU ODRZUC (PRZEDMIOT) = ODRZUCASZ');
      WriteLn('BRONIE I TARCZE I UBRONIA MOZNA ZDJAC KOMENDA ODLORZ (PRZEDMIOT) ');
    end;
  until Room <> 4;

end;
procedure Room13;
begin
  if Room <> 13 then Exit;
  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if CageStrong = 13 then WriteLn('SILNY , NAPAKOWANY POTWOR STOI POD SCIANA');
  if CageStrong = 0 then WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Room := 11;
    if (Command = 'ZABIJ POTWOR') and (CageStrong = 13) then begin
      EnemyEnergy := 20;
      EnemyDexterity := 3;
      EnemyStrength := 10;
      Fight;
      if Fled = 0 then begin
        CageStrong := 0;
        Loot := Random(15);
        WriteLn('WYCIAGASZ ', Loot, ' MONET Z CIALA POTWORA');
        Money := Money + Loot;
        if OldSword = 0 then begin
          Roll := Random(20);
          if Roll < 7 then begin OldSword := Room; WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA'); end;
        end;
        if SmallShield = 0 then begin
          Roll := Random(20);
          if Roll < 7 then begin SmallShield := Room; WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA'); end;
        end;
        if Heart = 0 then begin
          Roll := Random(20);
          if Roll < 6 then begin Heart := Room; WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA'); end;
        end;
      end else Fled := 0;
    end;
  until Room <> 13;

end;
procedure SimpleRoom(RoomNo, DestRoom: Integer; Direction, ExitDesc: string);

begin
  if Room = RoomNo then begin
    WriteLn('JESTES W DOSYC CIASNYM POKOJU I NICZEGO TU NIEMA ');
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn(Direction + '-' + ExitDesc);
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = Direction then Room := DestRoom;
    until Room <> RoomNo;
  end;
end;

procedure PlainRooms;
begin
  SimpleRoom(6, 5, 'WSCHOD', 'MUD SZKOLA(2)');
  SimpleRoom(8, 5, 'POLNOC', 'MUD SZKOLA(2)');
  SimpleRoom(7, 5, 'POLODNIE', 'MUD SZKOLA(2)');
  SimpleRoom(10, 5, 'GORA', 'MUD SZKOLA(2)');
end;
procedure Room11;
begin
  if Room <> 11 then Exit;
  WriteLn('JESTES W POKOJU PROWADZACYM DO KLATEK');
  WriteLn('DRZWI POD TOBA SIE ZATRZASNELY I NIE MASZ ODWROTU');
  WriteLn('WE WSZYSTKICH KIERUNKACH SA KLATKI I UJADAJACE SIE W NICH POTWORY');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-KLATKA CIENIASA');
      WriteLn('ZACHOD-KLATKA SILNEGO');
      WriteLn('POLNOC-KLATKA ZRECZNEGO');
      WriteLn('POLODNIE-KLATKA ODPORNEGO');
      WriteLn('GORA-KLATKA SILNEGO,ODPORNEGO I ZRECZNEGO ');
      WriteLn('DOL-JEDYNA DROGA NIE PROWADZACA DO KLATEK');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Room := 12;
    if Command = 'ZACHOD' then Room := 13;
    if Command = 'POLNOC' then Room := 14;
    if Command = 'POLODNIE' then Room := 15;
    if Command = 'GORA' then Room := 16;
    if Command = 'DOL' then Room := 17;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE PISZE:');
      WriteLn('W KLATKACH SA POTWORKI - ZABIJ JE! KOMEDA : ZABIJ [COS] - ZABIJA ');
      WriteLn('CZASAMI COS WYPADNIE Z POTWORKA MOZE CI SIE TO PRZYDAC');
    end;
  until Room <> 11;

end;
procedure Room30;
begin
  if Room <> 30 then Exit;
  WriteLn('ULICA DLUGA CIAGNIE SIE W NIESKONCZONOSC,SORKI');
  WriteLn('NA POLNOCY ZNAJDUJESZ OGROMNA BUDOWLE=TO ARENA PRZEZNACZONA DO WALKI');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-CENTRUM MIASTA');
      WriteLn('ZACHOD-ULICA DLUGA');
      WriteLn('POLNOC-WEJSCIE NA ARENE');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Room := 20;
    if Command = 'ZACHOD' then Room := 31;
    if Command = 'POLNOC' then Room := 32;
  until Room <> 30;

end;
procedure Room60;
begin
  if Room <> 60 then Exit;
  WriteLn('JESTES W DOLINIE ROZRYWEK DOLINA CIAGNIE SIE NA POLNOC, NA WSCHODZIE');
  WriteLn('JEST SLYSZALNY JAKIS DZIWNY  HALAS , NA ZACHODZIE ZAS "LA LA LA LA" ');
  WriteLn('ZAWSZE MOZESZ WROCIC SIE IDAC NA POLODNIE ;)');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA DLUGA');
      WriteLn('WSCHOD-BUDOWLA PELNA HALASU');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLODNIE' then Room := 31;
    if Command = 'WSCHOD' then Room := 61;
  until Room <> 60;

end;
procedure Room75;
begin
  if Room <> 75 then Exit;
  WriteLn('JESTES NA ULICY CIEMNEJ , WLASCIWIE NARAZIE NIE JEST TU JESZCZE TAK CIEMNO ');
  WriteLn('TA ULICA WYGLADA NA REMONTOWAN'#164' , NA POLNOC WIDZISZ JAKIS BAR ');
  WriteLn('NA POLODNIE PRZEBIEGAJA CIE DRESZCZE , JEST TAM NAPRAWDE CIEMNO');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-CENTRUM MIASTA');
      WriteLn('POLNOC-BAR POD DWOMA PEDALAMI');
      WriteLn('POLODNIE-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'ZACHOD' then Room := 20;
    if Command = 'POLNOC' then Room := 76;
    if Command = 'POLODNIE' then Room := 77;
  until Room <> 75;

end;
procedure Room83;
begin
  if Room <> 83 then Exit;
  WriteLn('............................. PIERDUT...........PIERDUT......PIERDUT');
  WriteLn('DOPIERO TERAZ SIE ZORIENTOWALES ZE NA SRODKU STOI WIELKIE DRZEWO');
  WriteLn('HMMM ALE ZARAZ ... TE KRZAKI NA ZACHOD WYGLADAJA BARDZO PODEJRZANIE....');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-BLUSZCZ');
      WriteLn('ZACHOD-PODEJRZANE KRZAKI');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLNOC' then Room := 80;
    if Command = 'ZACHOD' then Room := 84;
  until Room <> 83;

end;
procedure Room100;
begin
  if Room <> 100 then Exit;
  WriteLn('ZNALAZLES SIE NA ROZJEZDZIE DROG , DROGI PILNUJE QUEST-MASTER ');
  WriteLn('QUEST-MASTER NIE POSCI CIE DALEJ DOPOKI NIE KUPISZ I ROZWIAZESZ QUESTA');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-DROGA O KTOREJ MOZESZ POMAZYC ( BO JEST W PRODUKCJI !!! )');
      if Permit = 0 then WriteLn('ZACHOD-DROGA ( ZABLOKOWANA PRZEZ QUEST-MASTERA)');
      if Permit < 0 then WriteLn('ZACHOD-DROGA');
    end;
    if Command = 'LISTA' then begin
      WriteLn('LATWY QUEST      - 200');
      WriteLn('PRZECIETNY QUEST - 100');
      WriteLn('TRUDNY QUEST     - 50');
      WriteLn('KOMEDA - SPRZEDAJ QUEST - OZNACZA IZ QUEST ZOSTAL WYKONANY');
    end;
    if (Command = 'KUP LATWY QUEST') and (Money > 199) then begin
      WriteLn('ZABIJ 75 POTWOROW');
      Quest := 1;
      QuestKills := 75;
      Money := Money - 200;
    end;
    if (Command = 'KUP PRZECIETNY QUEST') and (Money > 99) then begin
      WriteLn('ZABIJ 50 POTWOROW W TYM LIROYA I DAJ MI DYPLOM MUD SZKOLY');
      Quest := 2;
      QuestKills := 200;
      Money := Money - 100;
    end;
    if (Command = 'KUP TRUDNY QUEST') and (Money > 49) then begin
      WriteLn('ZABIJ 50 POTWOROW W TYM LIROYA I DAJ MI FAJKE I POSWIEC 1 PRAKTYKE');
      Quest := 3;
      QuestKills := 200;
      Money := Money - 50;
    end;
    if (Command = 'SPRZEDAJ QUEST') and (Quest > 0) then begin
      if (Quest = 1) and (QuestKills < 1) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 100 KUNSZTU -----');
        Experience := Experience + 100;
        Quest := 0;
        QuestKills := 0;
        Permit := Permit - 10;
        ItemCount := ItemCount + 1;
      end;
      if (Quest = 2) and (QuestKills < 1) and (Diploma <= -10) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 250 KUNSZTU -----');
        Experience := Experience + 250;
        Quest := 0;
        QuestKills := 0;
        Diploma := 0;
        MaxEnergy := MaxEnergy - 5;
        Permit := Permit - 10;
      end;
      if (Quest = 3) and (QuestKills < 1) and (Pipe <= -10) and (Practice > 0) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 425 KUNSZTU -----');
        Experience := Experience + 425;
        ItemCount := ItemCount - 1;
        Wisdom := Wisdom - 1;
        Quest := 0;
        QuestKills := 0;
        Pipe := Pipe + 10;
        Practice := Practice - 1;
        Permit := Permit - 10;
      end;

    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLODNIE' then Room := 22;
    if (Command = 'ZACHOD') and (Permit <= -10) then Room := 101;
if (Command = 'ZACHOD') and (Permit = 0) then WriteLn('QUEST-MASTER MOWI CI : BARDZO MI PRZYKRO ALE MUSISZ MIEC PRZEPUSTKE');
    if Command = 'ZABIJ QUEST-MASTER' then begin
      PoisonCharges := 10;
      FireballCharges := 20;
      EnemyStrength := 10;
      EnemyDexterity := 26;
      EnemyEnergy := 188;
      Fight;
      if EnemyEnergy < 1 then Permit := Permit - 10;
    end;
  until Room <> 100;

end;

function FightExpForEnergy(diff: Integer): Integer;

begin
  if diff > 0 then begin
    case diff of
      1, 2: FightExpForEnergy := 10;
      3: FightExpForEnergy := 19;
      4..6: FightExpForEnergy := 9;
      7..9: FightExpForEnergy := 8;
      10..12: FightExpForEnergy := 7;
      13..15: FightExpForEnergy := 6;
      16..18: FightExpForEnergy := 5;
      19..21: FightExpForEnergy := 4;
      22..24: FightExpForEnergy := 3;
      25..27: FightExpForEnergy := 2;
      28..30: FightExpForEnergy := 1;
      else FightExpForEnergy := 0;
    end;
  end else if diff < 0 then begin
    diff := -diff;
    if diff = 2 then FightExpForEnergy := 12
    else if diff = 4 then FightExpForEnergy := 13
    else if diff = 6 then FightExpForEnergy := 14
    else if diff = 8 then FightExpForEnergy := 15
    else if diff = 10 then FightExpForEnergy := 16
    else if diff = 12 then FightExpForEnergy := 17
    else if diff = 14 then FightExpForEnergy := 18
    else if diff = 16 then FightExpForEnergy := 19
    else if diff = 18 then FightExpForEnergy := 20
    else if diff > 20 then FightExpForEnergy := 21
    else FightExpForEnergy := 0;
  end else
    FightExpForEnergy := 11;
end;

function FightExpForStrength(diff: Integer): Integer;

begin
  if diff > 0 then begin
    if diff >= 10 then FightExpForStrength := 1
    else FightExpForStrength := 11 - diff;
  end else if diff < 0 then begin
    diff := -diff;
    if diff >= 10 then FightExpForStrength := 21
    else FightExpForStrength := 11 + diff;
  end else
    FightExpForStrength := 11;
end;

function FightExpForDexterity(diff: Integer): Integer;

var step: Integer;
begin
  if diff > 0 then begin
    step := (diff + 1) div 2;
    if step >= 10 then FightExpForDexterity := 1
    else FightExpForDexterity := 11 - step;
  end else if diff < 0 then begin
    diff := -diff;
    step := (diff + 1) div 2;
    if step >= 10 then FightExpForDexterity := 21
    else FightExpForDexterity := 11 + step;
  end else
    FightExpForDexterity := 11;
end;

function DodgeBound(DodgeChance: Integer): Integer;

begin
  if DodgeChance > 30 then DodgeBound := 12
  else if DodgeChance > 27 then DodgeBound := 13
  else if DodgeChance > 24 then DodgeBound := 14
  else if DodgeChance > 20 then DodgeBound := 15
  else if DodgeChance > 18 then DodgeBound := 16
  else if DodgeChance > 16 then DodgeBound := 17
  else if DodgeChance > 12 then DodgeBound := 18
  else if DodgeChance > 9 then DodgeBound := 19
  else if DodgeChance > 6 then DodgeBound := 20
  else if DodgeChance > 4 then DodgeBound := 21
  else if DodgeChance > 2 then DodgeBound := 22
  else DodgeBound := 23;
end;

function EnemyDodgeBound(DodgeChance: Integer): Integer;

begin
  if DodgeChance > 30 then EnemyDodgeBound := 60
  else if DodgeChance > 27 then EnemyDodgeBound := 58
  else if DodgeChance > 24 then EnemyDodgeBound := 56
  else if DodgeChance > 20 then EnemyDodgeBound := 54
  else if DodgeChance > 18 then EnemyDodgeBound := 52
  else if DodgeChance > 16 then EnemyDodgeBound := 51
  else if DodgeChance > 12 then EnemyDodgeBound := 48
  else if DodgeChance > 9 then EnemyDodgeBound := 46
  else if DodgeChance > 6 then EnemyDodgeBound := 42
  else if DodgeChance > 4 then EnemyDodgeBound := 40
  else if DodgeChance > 2 then EnemyDodgeBound := 38
  else EnemyDodgeBound := 35;
end;

function DexterityBonus(Dexterity: Integer): Integer;

begin
  if Dexterity >= 8 then DexterityBonus := Dexterity div 2
  else DexterityBonus := 0;
end;

function ParryBonus(Parry: Integer): Integer;

var bonus: Integer;
begin
  bonus := 0;
  if Parry > 75 then bonus := bonus + 1;
  if Parry > 50 then bonus := bonus + 1;
  ParryBonus := bonus;
end;

function KickBonus(Kick: Integer): Integer;

var bonus: Integer;
begin
  bonus := 0;
  if Kick > 70 then bonus := bonus + 2;
  if Kick > 10 then bonus := bonus + 2;
  KickBonus := bonus;
end;

procedure FightDog;
begin
  EnemyEnergy := 10;
  EnemyDexterity := 10;
  EnemyStrength := 5;
  Fight;
  Loot := Random(15);
  WriteLn('WYCIAGASZ ', Loot, ' MONET Z CIALA PSA');
  Money := Money + Loot;
  if Heart = 0 then begin
    Roll := Random(20);
    if Roll < 5 then begin Heart := Room; WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA PSA');
    end;
  end;
end;

procedure SpawnMonsters;
begin
  repeat
    Bacterium := Random(38) + 20;
    Snail := Random(38) + 20;
    Beetle := Random(38) + 20;
    Cockroach := Random(38) + 20;
    Ant := Random(38) + 20;
    Spider := Random(38) + 20;
    Boar := Random(38) + 20;
    Fox := Random(38) + 20;
    Rat := Random(38) + 20;
    Partridge := Random(38) + 20;
  until (Bacterium > 32) and (Snail > 32) and (Beetle > 32) and (Cockroach > 32)
    and (Ant > 32) and (Spider > 32) and (Boar > 32) and (Fox > 32)
    and (Rat > 32) and (Partridge > 32);
  repeat Deer := Random(38) + 20;
    Eagle := Random(38) + 20;
    Hare := Random(38) + 20;
    Mongrel := Random(38) + 20;
    Woodworm := Random(38) + 20;
    Fly := Random(38) + 20;
  until (Deer > 32) and (Eagle > 32) and (Hare > 32) and (Mongrel > 32)
    and (Woodworm > 32) and (Fly > 32);
  repeat Elephant := Random(38) + 20;
    Lion := Random(38) + 20;
    Giraffe := Random(38) + 20;
    Camel := Random(38) + 20;
    Ostrich := Random(38) + 20;
    Boa := Random(38) + 20;
    Wolf := Random(38) + 20;
    Bison := Random(38) + 20;
    Panther := Random(38) + 20;
  until (Elephant > 32) and (Lion > 32) and (Giraffe > 32) and (Camel > 32)
    and (Ostrich > 32) and (Boa > 32) and (Wolf > 32) and (Bison > 32)
    and (Panther > 32);
  repeat Gladiator := Random(38) + 20;
    Warrior := Random(38) + 20;
    Tamer := Random(38) + 20;
  until (Gladiator > 32) and (Warrior > 32) and (Tamer > 32);
  repeat
    Dachshund := Random(7) + 20;
    Shepherd := Random(7) + 20;
    Pooch := Random(7) + 20;
    Spaniel := Random(7) + 20;
    Poodle := Random(7) + 20;
  until (Dachshund > 19) and (Shepherd > 19) and (Pooch > 19)
    and (Spaniel > 19) and (Poodle > 19);
  repeat Cabman := Random(7) + 20;
    Vendor := Random(7) + 20;
    Sweeper := Random(7) + 20;
    Drunkard := Random(7) + 20;
    SickMan := Random(7) + 20;
  until (Cabman > 19) and (Vendor > 19)
    and (Sweeper > 19) and (Drunkard > 19) and (SickMan > 19);
  repeat Kid := Random(7) + 60;
    Lunatic := Random(8) + 60;
    Listener := Random(8) + 60;
    Fan := Random(8) + 60;
    Man := Random(8) + 60;
  until (Kid > 60) and (Lunatic > 60) and (Listener > 60) and (Fan > 60)
    and (Man > 60);
  repeat Policeman := Random(9) + 60;
    Bouncer := Random(9) + 60;
    Gorilla := Random(9) + 60;
    OldMan := Random(8) + 60;
    Reporter := Random(7) + 60;
  until (Policeman > 60) and (Bouncer > 60) and (Gorilla > 60) and (OldMan > 60)
    and (Reporter > 60); Guitarist := Random(3) + 70;
  Drummer := Random(3) + 70;
  Keyboardist := Random(3) + 70;
  Liroy := Random(3) + 70;
  Minibarman := 67;
  Fatso := 67;
  DJ := 69;
  Pedal := 76;
  Couple := 76;
  Maciek := 76;
  Door := 1;
  OldElf := 1;
  repeat
    Sorrel := Random(8) + 77;
    Clover := Random(8) + 77;
    Daisy := Random(8) + 77;
    SowThistle := Random(8) + 77;
    Dandelion := Random(8) + 77;
    Rose := Random(8) + 77;
    Thistle := Random(8) + 77;
    Raspberry := Random(8) + 77;
    Gooseberry := Random(8) + 77;
    Blackberry := Random(8) + 77;
    Grass := Random(8) + 77;
    Duncan := Random(8) + 77;
  until (Sorrel < 84) and (Daisy < 84) and (Clover < 84) and (SowThistle < 84)
    and (Dandelion < 84) and (Rose < 84) and (Thistle < 84) and (Raspberry < 84);
end;
procedure TrainAttribute(var Attribute, MaxAttribute: Integer; MinPractice, PracticeCost: Integer; cmdForm, nounForm: string);

begin
  if (Practice > MinPractice) and (Attribute < MaxAttribute) then begin
    Attribute := Attribute + 1;
    Practice := Practice - PracticeCost;
    WriteLn('TRENUJESZ ', cmdForm, ' I MASZ ', Attribute, ' ', nounForm, ' I ZOSTALO CI ', Practice, ' PRAKTYK');
  end;
end;

procedure HandleTrain;
begin
  if Command = 'TRENUJ' then WriteLn('CO CHCESZ TRENOWAC?');
  if Command = 'TRENUJ SILA' then
    TrainAttribute(Strength, MaxStrength, 2, 3, 'SILE', 'SILY');
  if Command = 'TRENUJ ZRECZNOSC' then
    TrainAttribute(Dexterity, MaxDexterity, 1, 2, 'ZRECZNOSC', 'ZRECZNOSCI');
  if Command = 'TRENUJ MADROSC' then
    TrainAttribute(Wisdom, MaxWisdom, 2, 3, 'MADROSC', 'MADROSCI');
end;

procedure DescribePlants;
begin
  if Sorrel = Room then WriteLn('PONURY SZCZAW PLANUJE ZEMSCIC SIE NA SWOJEJ TESCIOWEJ-LISCIU KLONOWYM');
  if Daisy = Room then WriteLn('STOKROTKA TUTAJ ROSNIE POLNA ( A NAD NIA SZUMI GEJ) ');
  if Clover = Room then WriteLn('KONICZYNKA KTORA TUTAJ JEST NIE PRZENIESIE CI SZCZESCIA');
  if SowThistle = Room then WriteLn('MLECZ WLASNIE DOWIODL ZE EINSTEIN SIE MYLIL');
  if Dandelion = Room then WriteLn('DMUCHAWIEC WLASNIE DOJRZAL DO TEGO ABY GO ZDMUCHNAC');
  if Rose = Room then WriteLn('PRZEROSNIETA ROZA POKAZUJE KOLCE NA ZNAK IZ NIE WARTO JEJ ATAKOWAC');
  if Thistle = Room then WriteLn('KIEDYS MYSLALES ZE OSET TO LATWY DO WYRWANIA CHWAST ... MYLILES SIE');
  if Blackberry = Room then WriteLn('TA JEZYNA W CIEMNOSCIACH WYGLADA JAK JAKIS NIEBYWALY SMOK ... ');
  if Gooseberry = Room then WriteLn('AGREST JEST TU , CHCESZ SPROBOWAC JAK SMAKUJE ?');
  if Raspberry = Room then WriteLn('MALINA JAK DZIEWCZYNA , CHOC DZIEWCZYNY NIE SA CHYBA AZ TAKIMI MUTANTAMI');
  if Grass = Room then WriteLn('TRAWA NIE WYDAJE SIE TRUDNYM PRZECIWNIKIEM , LECZ NIE DAJ SIE ZWIESC');
  if Room = Duncan then WriteLn('ROLNIK DUNCAN PROBOJE ZAPANOWAC NAD TYM ZYWIOLEM I UPRAWIAC SWOJE MARCHEWKI');
end;

procedure CompositeFight(EnemyEnergyBase, EnemyEnergyRand, EnemyDexterityBase, EnemyDexterityRand, EnemyStrengthBase, EnemyStrengthRand,
  LootBase, LootRand, HeartChance: Integer; RequireEnergy: Boolean; AntDoughnut: Boolean);

begin
  if EnemyEnergyRand > 0 then EnemyEnergy := Random(EnemyEnergyRand) + EnemyEnergyBase else EnemyEnergy := EnemyEnergyBase;
  if EnemyDexterityRand > 0 then EnemyDexterity := Random(EnemyDexterityRand) + EnemyDexterityBase else EnemyDexterity := EnemyDexterityBase;
  if EnemyStrengthRand > 0 then EnemyStrength := Random(EnemyStrengthRand) + EnemyStrengthBase else EnemyStrength := EnemyStrengthBase;
  Fight;
  if (Fled = 0) and (not RequireEnergy or (Energy > 0)) then begin
    Loot := Random(LootRand) + LootBase;
    WriteLn('WYCIAGASZ ', Loot, ' MONET Z CIALA');
    Money := Money + Loot;
    if AntDoughnut then begin
      if Command = 'ZABIJ MROWKA' then begin
        Roll := Random(10);
        if (Roll < 7) and (Doughnut <> -10) then begin
          WriteLn('WYCIAGASZ PACZEK Z CIALA MROWKI');
          Doughnut := -10;
          ItemCount := ItemCount + 1;
        end;
      end;
    end else if (HeartChance > 0) and (Heart = 0) then begin
      Roll := Random(20);
      if (Roll < HeartChance) and (Heart <> -10) then begin
        WriteLn('WYCIAGASZ SERCE Z CIALA TRUPA');
        Heart := -10;
        ItemCount := ItemCount + 1;
      end;
    end;
  end;
end;

procedure FightWeak;
begin
  CompositeFight(1, 0, 1, 0, 2, 0, 0, 3, 0, False, True);
end;

procedure FightWeakish;
begin
  CompositeFight(34, 3, 8, 4, 10, 0, 10, 21, 5, False, False);
end;

procedure FightMedium;
begin
  CompositeFight(50, 5, 10, 5, 13, 2, 30, 30, 7, False, False);
end;

procedure FightHard;
begin
  CompositeFight(60, 6, 12, 3, 15, 3, 20, 40, 7, False, False);
end;

procedure FightVeryEasy;
begin
  CompositeFight(90, 10, 14, 2, 17, 2, 10, 55, 4, True, False);
end;

procedure FightEasy;
begin
  CompositeFight(100, 20, 16, 0, 18, 2, 30, 30, 4, True, False);
end;

procedure FightNotEasy;
begin
  CompositeFight(130, 20, 20, 0, 19, 2, 20, 45, 4, True, False);
end;

procedure FightVeryHard;
begin
  CompositeFight(72, 3, 13, 2, 16, 2, 15, 50, 5, False, False);
end;
procedure CompareFoe;
begin
  if Mana > 9 then begin
    Roll := Random(100);
    WriteLn('KOGO CHCESZ ZE SOBA POROWNAC?');
    ReadLn(Command);
    Overall := Level + Strength + DexterityBonus(Dexterity) + ParryBonus(Parry) + KickBonus(Kick);
    if (Command = 'DZIK') or (Command = 'SZCZUR') or (Command = 'LIS') or
       (Command = 'KUROPATWA') or (Command = 'ZAJAC') or (Command = 'WILCZUR') or
       (Command = 'ORZEL') or (Command = 'SARNA') or (Command = 'DZIECKO') or (Command = 'DZIADEK') then
        begin if Overall < 16 then WriteLn('NICZEGO NIE MOGE ZAGWARANTOWAC ..... MACIE PODOBNE PARAMETRY');
        if (Strength > 15) and (Strength < 19) then WriteLn('PRZECIWNIK GODNY TWEJ DUMY , RACZEJ NIE POGRASZ');
        if Strength > 18 then WriteLn('WSTYD MI ZA CIEBIE ... JESZCZE TU JESTES ! NA CO CZEKASZ ? KILLUJ');
        end;
    if (Command = 'SLON') or (Command = 'LEW') or (Command = 'ZYRAFA') or (Command = 'WIELBLAD') or
       (Command = 'STRUS') or (Command = 'BOA') or (Command = 'WILK') or (Command = 'BIZON') or
       (Command = 'PANTERA') or (Command = 'WARIAT') or (Command = 'SLUCHACZ') or (Command = 'FAN') or
       (Command = 'CZLOWIEK') or (Command = 'REPORTER') then
      begin if Overall < 16 then WriteLn('TAK  TAK MAMA KUPI BERECIK GLOWKA W PORZADKU ? ');
      if (Strength > 15) and (Strength < 21) then WriteLn(' NA TWOIM MIEJSCU BYM SIE NIE ZAPUSZCZAL ');
      if (Strength > 20) and (Strength < 23) then WriteLn(' RYZYK FIZYK - TAK NA 50% - WALKA NA SMIERC I ZYCIE');
      if Strength > 22 then WriteLn('SPOX KILLUJ BEZ UPRZEDZEN');
    end;
    if (Command = 'GLADIATOR') or (Command = 'WOJOWNIK') or (Command = 'TRENER') or
       (Command = 'POLICJANT') or (Command = 'GORYL') or (Command = 'OCHRONIARZ') then begin
      if Overall < 15 then WriteLn('HA HA NIE NA SERJO . DAJ SE W ZYLE OKI? TO DOWCIP? HA HA HA');
      if (Overall > 14) and (Overall < 18) then WriteLn('POMARZ SOBIE WARIACIE . MOZE CI SIE PRZYSNI');
      if (Overall > 17) and (Overall < 23) then WriteLn('POWIEM  BEZ OGRODEK-TO GLUPI POMYSL');
      if (Overall > 22) and (Overall < 26) then WriteLn('TO DOSC RYZYKOWNE ZE TAK POWIEM');
      if Overall > 25 then WriteLn('TO BEDZIE TAK PROSTE JAK ZABICIE DZIECKA TOPOREM !!!');
    end;
    if (Command = 'MINI-BARMAN') or (Command = 'GRUBAS') or (Command = 'D.J') then begin
      if Overall < 24 then WriteLn('SMIERC PODZIEKUJE CI ZA TWOJ DAR (ALE ZGAPIAM)');
      if (Overall > 23) and (Overall < 26) then WriteLn('NIE UDAWAJ BISTY-BOYS PRZEGRASZ NA 99%');
      if (Overall > 25) and (Overall < 29) then WriteLn('PERFEKCYJNY MECZ NA SMIERC I ZYCIE !!!');
      if Overall > 28 then WriteLn('JESTES ZNACZNIE SILNIEJSZY !!!(ALE GLUPSZY)');
      if Overall > 34 then WriteLn('UWAZAJ DOSTANIESZ MALO KUNSZTU !!!');
    end;
    if (Command = 'TAKSOWKARZ') or (Command = 'SPRZEDAWCA') or (Command = 'GITARZYSTA') or (Command = 'PERKUSISTA') or
       (Command = 'ORGANISTA') or (Command = 'ZEBRAK') or (Command = 'PIJAK') or (Command = 'ZAMIATACZ') or (Command = 'SZCZAW') or
       (Command = 'STOKROTKA') or (Command = 'KONICZYNKA') or (Command = 'MLECZ') or (Command = 'DMUCHAWIEC') then begin
      if Overall < 21 then WriteLn('NIE');
      if (Overall > 22) and (Overall < 28) then WriteLn('RACZEJ NIE , CHOC MOZNA ZARYZYKOWAC(NIE POLECAM)');
      if Overall > 27 then WriteLn('TAK');
    end;
    if (Command='PEDAL') or (Command='PARA') or (Command='MACIEK') or (Command='ROZA') or
       (Command='MALINA') or (Command='TRAWA') or (Command = 'AGREST') or (Command = 'JEZYNA') then begin
      if Overall < 20 then WriteLn('WIERZ MI ALE TO NAPRAWDE WIERZ MI ZE NIE MASZ SZANS');
      if (Overall > 19) and (Overall < 26) then WriteLn('RACZEJ NIE WYGRASZ WIEC LEPIEJ NIE ATAKUJ');
      if (Overall > 25) and (Overall < 30) then WriteLn('JESTESCIE SOBIE ROWNI (NAPRAWDE !!!) - WIEC 50% SZANS');
      if Overall > 29 then WriteLn('JESTES SILNIEJSZY STAD WNIOSEK ZE SOBIE PORADZISZ');
      if Overall > 35 then WriteLn('P.S - JESTES DUZO DUZO SILNIEJSZY ZABIJ BEZ OGRODEK!!!');
    end;
    if Command = 'LIROY' then begin
      if Overall < 28 then WriteLn('HAHAHAHAHAHAHAHAHAHHAHOHOHOHHOHOHOHOHOHOHOHOAHAHAHAHAHAHAH');
      if (Overall > 27) and (Overall < 33) then WriteLn('HIHIHIHIHIHIHIHHEHEHEHE :))))))');
      if (Overall > 32) and (Overall < 44) then WriteLn('SPROOB'#224'J A MO'#189'E WYGRAC SIE UDA......');
    if (Overall > 43) and (Overall < 48) then WriteLn('NIE PRZEJMUJ SIE JEGO MORD'#164' JESTES SILNIEJSZY I BASTA');
      if Overall > 47 then WriteLn('UWAZAJ ... NA CHLAPIACE MOZGI FLAKI PRZECIWNIKA');
    end;
    if Command = 'POKRZYWA' then begin
      if Overall < 40 then WriteLn('NIE MASZ NAJMNIEJSZYCH SZANS');
      if Overall > 39 then WriteLn('JEST PEWNE PRAWDOPODOBIENSTWO WYGRANIA TEGO STARCIA');

    end;
    if (Command = 'SPANIEL') or (Command = 'OWCZAREK') or (Command = 'PIESEK') or (Command='JAMNIK') or (Command='PUDEL') then
      WriteLn('JASNE ZE MOZESZ GO ZABIC ZABIJ !!! ZABIJ . TEN PARSZYWY PIES NIE MA RACJI BYTU');
    if (Roll < 3) and (Comparing < 100) then begin
      WriteLn('***************** UCZYSZ SIE ZDOLNOSCI POROWNYWANIE *****************');
      Comparing := Comparing + 1;
      Experience := Experience + 5;
    end;
    if Command = 'BAKTERIA' then begin
      WriteLn('BAKTERIA MA MAGIC RESISTANCE');
      Mana := Mana + 5;
    end;
  end;
end;

procedure DescribeStreet;
begin
  if Dachshund = Room then WriteLn('DLUGI JAMNIK GRYZIE CI PODESZWY');
  if Shepherd = Room then WriteLn('PUCHATY OWCZAREK WYLEGUJE SIE W SLONCU');
  if Pooch = Room then WriteLn('PIESEK SZUKA DRZEWKA ABY ULZYC SOBIE');
  if Spaniel = Room then WriteLn('SPANIEL SLINI SIE AZ MILO');
  if Poodle = Room then WriteLn('PUDEL JE KITIKET WIEC CHYBA MU NIE PRZERWIESZ.....?');
  if Cabman = Room then WriteLn('TAKSOWKARZ WTARGNA TU ZE SWOJA BRYKA , I CZEKA NA KLIENTOW');
  if Vendor = Room then
    WriteLn('SPRZEDAWCA PRECELKOW WLASNIE SPRZEDAL OSTATNIEGO , CZYM DOPROWADZA DO SZALENSTWA LATAJACE WOKOLO NIEGO KRUKI');
  if Sweeper = Room then WriteLn('ZAMIATACZ ULIC SPRAWIA ZE JEST TU CZYSTO JAK W CHLEWIE');
  if Drunkard = Room then WriteLn('PIJAK TU STOI(DOBRE SOBIE) I SMIERDZI MU Z GEBY');
  if SickMan = Room then WriteLn('ZEBRAK UDOWADNIA PRZECHODNIOM ZE ON NAPRAWDE JEST CHORY NA AIDS');
end;

procedure SuitGain;
begin
  Roll := Random(1000);
  if Roll <= 25 then begin
    WriteLn('ZYSKUJESZ GARNITUR !!!! Z CIALA WROGA !!!!');
    WriteLn('PRZEDMIOT UNIQE !!! 2.5% !!! ');
    SpikedSuit := SpikedSuit - 10;
    ItemCount := ItemCount + 1;
  end;
end;
procedure PillGain;
begin
  Roll := Random(1000);
  if Roll <= 42 then begin
    WriteLn('HMMM , A TO CO ? , TOZ TO !!! PIGULKA TRANSPORTUJACA !!! PROSTO Z CIALA WROGA');
    TeleportPill := TeleportPill - 10;
    ItemCount := ItemCount + 1;
  end;
end;
procedure CassetteGain;
begin
  Roll := Random(100);
  if (Roll < 2) and (Room <> 10000) then begin
    WriteLn('WYCIAGASZ KASETE LIROYA Z CIALA BIEDNEGO CZLOWIEKA');
    WriteLn('!!! PRZEDMIOT UNIQE 2% !!!');
    Cassette := Cassette - 10;
    MaxEnergy := MaxEnergy + 5;
    Armor := Armor - 8;
    ItemCount := ItemCount + 1;
    Dexterity := Dexterity + 1;
  end;
end;
procedure LeafGain;
begin
  Roll := Random(100);
  if (Roll < 6) and (Room <> 10000) then begin
    WriteLn('WYCIAGASZ LISTEK SZCZESCIA Z CIALA WROGIEJ TOBIE POSTACI');
    WriteLn('!!! PRZEDMIOT UNIQE 4% !!!');
    LuckyLeaf := LuckyLeaf - 10;
    ItemCount := ItemCount + 1;
    MaxMana := MaxMana + 40;
  end;
end;
procedure ScrollGain;
begin
  Roll := Random(100);
  if (Roll < 10) and (Room <> 10000) then begin
    WriteLn('WYCIAGASZ SCROLL POROWNANIA Z WROGIEJ TOBIE POSTACI');
    CompareScroll := CompareScroll - 10;
    ItemCount := ItemCount + 1;
  end;
end;

procedure EnterTrance;
begin
  OuterRoom := Room;
  Room := 1000;
end;
procedure DescribeStage;
begin
  if Guitarist = Room then WriteLn('GITARZYSTA GRA TU NA WYSOKIM CE-DUR');
  if Drummer = Room then WriteLn('PERKUSISTA TLUCZE TU NIEMILOSIERNIE (W) TALEZE I BEBNY');
  if Keyboardist = Room then WriteLn('ORGANISTA KORZYSTA Z 8 CIASIO NARAZ PODL'#164'CZONYCH DO SIECI');
  if Liroy = Room then WriteLn('MAGA BOSS TEJ PLANSZY - LIROY SPIEWA JEDEN ZE SWOICH KAWALKOW');
end;
procedure DescribeCrowd;
begin
  if Room = Kid then WriteLn('MILE DZIECKO POWTARZA NAJLEPSZE KAWALKI LIROYA');
  if Room = Lunatic then WriteLn('WARIAT SIE CIESZY ZE NIE TYLKO ON JEST WARIATEM');
  if Room = Listener then WriteLn('SLUCHACZ SLUCHA');
  if Room = Fan then WriteLn('FAN LIROYA ZAPUSCIL SOBIE BRODKE JAK LIROY I MA PODJAR');
  if Room = Man then WriteLn('NORMALNY CZLOWIEK PRZYSZEDL POSLUCHAC LIROYA(DZIWNE NIE)?');
  if Room = Policeman then WriteLn('ZALANY POLICJANT STARA SIE PELNIC SWA SLUZBE');
  if Room = Bouncer then WriteLn('OCHRONIARZ ZABIJA KAZDEGO KTO PRZEJDZIE PRZEZ BALUSTRADKI');
  if Room = Gorilla then WriteLn('PRYWATNY GORYL LIROYA JE BANANA ');
  if Room = OldMan then WriteLn('DZIADEK NIESTESTY NIE SKACZE DO GORY JAK KANGURY');
  if Room = Reporter then WriteLn('REPORTER UWAZNIE ZAPISUJE WSZYSTKIE WULGARYZMY');
end;

procedure DescribeBeasts;
begin
  if Woodworm = Room then WriteLn('KORNIK SZUKA JAKIEGOS DRZEWA ABY COS PRZEKASIC');
  if Fly = Room then WriteLn('MUCHA BZYKA SOBIE TO TU TO TAM');
  if Bacterium = Room then WriteLn('BAKTERIA KTORA ZOBACZYLES POD MIKROSKOPEM STARA USUNAC CI SIE Z DROGI');
  if Snail = Room then WriteLn('SLIMAK KTORY ZOSTAWIA SLUZ POWOLI SUNIE PO PODLODZE');
  if Beetle = Room then WriteLn('ZUK KTORY WIDZI CO SIE SWIECI ZWIEWA STAD');
  if Cockroach = Room then WriteLn('OHYDNY KARALUCH MA OCHOTE CIE OBRZYDZIC');
  if Ant = Room then WriteLn('MROWKA NIESIE TLUSTY PACZEK I SIE CIESZY');
  if Spider = Room then WriteLn('PAJAK ZROBIL SIEC NA SCIANIE ARENY');
  if Boar = Room then WriteLn('TLUSTY DZICZEK BIEGNIE SOBIE TEDY');
  if Rat = Room then WriteLn('JEST TUTAJ SZCZUR,TAK WIELKI ZE WIEKSZEGO NIE WIDZIALES');
  if Fox = Room then WriteLn('CHYTRY LIS SZUKA SPOSOBU BY CIE ZABIC');
  if Partridge = Room then WriteLn('KUROPATWA PO PROSTU JEST TU');
  if Hare = Room then WriteLn('ZAJAC KICA SOBIE SPIEWAJAC "POMYLONE MISIE"');
  if Mongrel = Room then WriteLn('CZARNY WILCZUR PO KRZYWEJ SIE TOCZY (MU PIANA Z UST)');
  if Eagle = Room then WriteLn('ORZEL SZYBUJE W POWIETRZYU W POSZUKIWANIU OFIARY');
  if Deer = Room then WriteLn('SARNA SKASZE SOBIE NIE ZDAJAC SOBIE SPRAWY ZE ZARAZ ZGINIE');
  if Elephant = Room then WriteLn('OGROMNIASTY SLON ZGNIATA WSZYSTKO CO NAPOTKA');
  if Lion = Room then WriteLn('LEW - KROL ZWIERZAT WLASNIE ZABIJA NIEWINNE DZIECKO ROZWALAJAC JEGO MOZG');
  if Giraffe = Room then WriteLn('ZYRAFA KTORA TU STOI NIE SZUKA ZACZEPKI');
  if Camel = Room then WriteLn('WIELBLAD KORZYSTA Z GARBOW UZYWAJAC ICH JAKO SMIERTELNEJ BRONI');
  if Ostrich = Room then WriteLn('STRUS NIE CHOWA GLOWY W PIASEK BO JEST NA BETONIE');
  if Boa = Room then WriteLn('BOA DUSICIEL WLASNIE ZJADL KROWE ');
  if Wolf = Room then WriteLn('WILK CHORY NA WSCIEKLIZNE PANOSZY SIE W OKOLICY');
  if Bison = Room then WriteLn('NIEWINNY BIZON MORDUJE WLASNIE PUBLICZNOSC');
  if Panther = Room then WriteLn('ZWINNA PANTERA NUDZI SIE POLYKAJAC RESZTKI LUDZKIEGO MIESA');
  if Gladiator = Room then WriteLn('GLADIATOR ZDOBYWA TUTAJ KUNSZT');
  if Warrior = Room then WriteLn('WOJOWNIK GREEN PEACE MORDUJE TUTAJ BEZBRONNE LWIATKA :( ');
  if Tamer = Room then WriteLn('TRENER CYRKU LAPIE ZWIERZETA NA SWOJE PRZEDSTAWIENIE');
end;

procedure ShieldBlock;
begin
  Roll := Random(100);
  if Roll <= Armor then begin
    Damage := Damage - WornCount;
    if Damage < 0 then Damage := 0;
    WriteLn('OSLONILES SIE ! TRACISZ ', Damage, ' ENERGII');
  end;
end;

procedure Fight;
begin
  FightExperience := FightExperience + FightExpForEnergy(MaxEnergy - EnemyEnergy);
  FightExperience := FightExperience + FightExpForStrength(Strength - EnemyStrength);
  FightExperience := FightExperience + FightExpForDexterity(Dexterity - EnemyDexterity);

  repeat
    EnemyDodged := 0;
    PlayerDodged := 0;
    WriteLn('WALCZYSZ - <<<<TWOJ WROG MA ', EnemyEnergy, '%>>>><<<< A TY MASZ ', Energy, '% ENERGII>>>>>');
    if Dexterity > EnemyDexterity then begin
      DodgeChance := Dexterity - EnemyDexterity;
      Roll := Random(DodgeBound(DodgeChance));
      if Roll < 10 then begin
        WriteLn('UNIKASZ CIOSU WROGA TWEGO I SMIEJESZ SIE Z JEGO NIEPORADNOSCI');
        PlayerDodged := 1;
      end;
      Roll := Random(EnemyDodgeBound(DodgeChance));
      if Roll < 10 then begin
        WriteLn('PRZECIWNIK UNIKA TWOJEGO LAMERSKIEGO ATAKU');
        EnemyDodged := 1;
      end;
    end;
    if EnemyDexterity > Dexterity then begin
      DodgeChance := EnemyDexterity - Dexterity;
      Roll := Random(DodgeBound(DodgeChance));
      if Roll < 10 then begin
        WriteLn('PRZECIWNIK Z GRACJA UNIKA TWEGO CIOSU');
        EnemyDodged := 1;
      end;
      Roll := Random(EnemyDodgeBound(DodgeChance));
      if Roll < 10 then begin
        WriteLn('BEZ PARDONU OMIJASZ CIOS TWOJEGO PRZECIWNIKA');
        PlayerDodged := 1;
      end;
    end;
    if PlayerDodged = 0 then begin
      Damage := Random(EnemyStrength);
      if Damage < 6 then WriteLn('PRZECIWNIK CIE TYLKO DRASNA I TRACISZ ', Damage, '% ENERGII');
      if (Damage > 5) and (Damage < 21) then WriteLn('DOSTALES I TRACISZ ', Damage, '% ENERGII');
      if (Damage > 20) and (Damage < 51) then WriteLn('PRZECIWNIK !MASAKRUJE! CIEBIE I TRACISZ AZ ', Damage, '% ENERGII');
      if Damage > 50 then WriteLn('PRZECIWNIK !!!WYPRUWA FLAKI!!! Z CIEBIE I TRACISZ !!! ', Damage, '% ENERGII');
      FightExperience := FightExperience + 1;
      ShieldBlock;
      if (Parry > 0) and (Damage > 0) then begin
        Roll := Random(140);
        if Roll <= Parry then begin
          if Damage < 3 then begin
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ 0% ENERGI');
            Damage := 0;
          end;
          if (Damage > 2) and (Damage < 10) then begin
            Damage := Damage - 2;
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ ', Damage, '% ENERGI');
          end;
          if Damage > 9 then begin
            Damage := Damage - 3;
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ ', Damage, '% ENERGI');
          end;
          if (Roll < 1) and (Parry < 100) then begin
            WriteLn('*************** UCZYSZ SIE ZDOLNOSCI PAROWANIE !!!!! ***************');
            Parry := Parry + 1;
            FightExperience := FightExperience + 5;
          end;
        end;
      end;
      Energy := Energy - Damage;
      if FireballCharges > 0 then begin
        Roll := Random(100);
        if Roll < 10 then begin
          TextColor(14);
          Roll := Random(20);
          WriteLn('PRZECIWNIK PUSZCZA FIREBALLA W TWYM KIERUNKU - TRACISZ ', Roll, '% ENERGII');
          Energy := Energy - Roll;
          FireballCharges := FireballCharges - 1;
          TextColor(15);
        end;
      end;
      if PoisonCharges > 0 then begin
        Roll := Random(100);
        if Roll < 10 then begin
          TextColor(4);
          WriteLn('PRZECIWNIK RZUCA CZAR "POISON" ');
          PoisonCharges := PoisonCharges - 1;
          TextColor(15);
          PoisonRounds := PoisonRounds + 10;
        end;
      end;
      if PoisonRounds > 0 then begin
        Roll := Random(5);
        WriteLn('JESTES ZATRUTY - TRACISZ ', Roll, '% ENERGI');
        Energy := Energy - Roll;
        PoisonRounds := PoisonRounds - 1;
      end;
    end;
    if EnemyDodged = 0 then begin
      Damage := Random(Strength);
      if Damage * 10 < LuckRoll then begin
        repeat
          Damage := Random(Strength);
          WriteLn('FUKSROLL FUKSROLL FUKSROLL ! ');
        until (Damage * 10) > LuckRoll;
      end;
      EnemyEnergy := EnemyEnergy - Damage;
      if Damage < 6 then
        WriteLn('MASZ PECHA : LEKKO POPCHNALES GO I STRACIL TYLKO ', Damage, '% ENERGII');

      if (Damage > 5) and (Damage < 21) then
        WriteLn('DOSTAL I STRACIL ', Damage, '% ENERGII');
      if (Damage > 20) and (Damage < 51) then WriteLn(' !MASAKRUJESZ! PRZECIWNIKA I TRACI ON AZ ', Damage, '% ENERGII');
      if Damage > 50 then WriteLn(' !!!WYPRUWASZ FLAKI!!! Z PRZECIWNIKA I TRACI ON  !!!! ', Damage, '% ENERGII');
    end;
    Delay(2000);
    if (Kick > 0) and (Mana > KickMinMana) and (Energy < KickMaxEnergy) then begin
      Roll := Random(100);
      if Roll <= Kick - 10 then begin
        Roll := Random(10) + Random(Level);
        TextColor(14);
        WriteLn('TWOJ SUPER KOP ZABIERA ', Roll, '% ENERGI');
        TextColor(15);
        Mana := Mana - Random(3) - 3;
        EnemyEnergy := EnemyEnergy - Roll;
      end else WriteLn('TWOJ SUPER KOP CHYBIA PRZECIWNIKA ');
      Mana := Mana - Random(2) - 2;
    end;
    if (Fleeing > 0) and (Energy < FleeEnergy) and (Mana > 14) then begin
      Mana := Mana - 15;
      Roll := Random(100);
      if Roll <= Fleeing then begin
        Fled := 1;
        WriteLn('WSTYD !!! UCIEKLES Z POLA BITWY TRACISZ 20 KUNSZTU');
        Experience := Experience - 20;
      end else WriteLn('NIE UDALO CI SIE UCIEC !!!! WALCZYSZ DALEJ !!! ');
    end;
  until (Energy < 1) or (EnemyEnergy < 1) or (Fled = 1);
  if (EnemyEnergy < 1) and (Energy > 0) then begin
    if MaxEnergy > 75 then FightExperience := FightExperience - 2;
    if MaxEnergy > 115 then FightExperience := FightExperience - 3;
    if Parry > 50 then FightExperience := FightExperience - 2;
    if Parry > 75 then FightExperience := FightExperience - 2;
    if Parry > 95 then FightExperience := FightExperience - 1;
    if Kick > 50 then FightExperience := FightExperience - 5;
    if Kick > 95 then FightExperience := FightExperience - 2;
    if FightExperience < 0 then FightExperience := 0;
    WriteLn('ZABILES GO ! ZYSKUJESZ ZA TO ', FightExperience, ' KUNSZTU ');
    Experience := FightExperience + Experience;
    FireballCharges := 0;
    PoisonCharges := 0;

    if Quest > 0 then QuestKills := QuestKills - 1;
    if Cooking > 0 then begin
      Roll := Random(100);
      if Cooking > Roll then begin
        WriteLn('ROBISZ SOBIE PYSZNY PYSZNY BIGOS Z KAPUSTA Z WROGA');
        Bigos := Bigos - 10;
        ItemCount := ItemCount + 1;
        if (Roll < 1) and (Cooking < 100) then begin
          WriteLn('UCZYSZ SIE ZDOLNOSCI POTRAWKI !!! ');
          Cooking := Cooking + 1;
          Experience := Experience + 10;

        end;
      end;
    end;
  end;
  if Energy < 1 then begin
    WriteLn('!!!!!!!!!!!ZOSTALES ZABITY!!!!!!!!!!!!');
    Delay(3000);
    Room := 10000;
  end;
  FightExperience := 0;
end;

procedure TakeDrop;
begin
  if (Command = 'BIERZ STARY') and (OldSword = OuterRoom) then begin
    WriteLn('PODNOSISZ STARY ZARDZEWIALY MIECZ I MASZ JAROWE ZE GO POSIADASZ');
    OldSword := -10;
    ItemCount := ItemCount + 1;
  end;
  if (Command = 'BIERZ MALA') and (SmallShield = OuterRoom) then begin
    WriteLn('PODNOSISZ MALA TARCZA (JEST OKRAGLA)');
    SmallShield := -10;
    ItemCount := ItemCount + 1;
  end;
  if (Command = 'BIERZ SERCE') and (Heart = OuterRoom) then begin
    WriteLn('PODNOSISZ ZAKRWAWIONE SERCE (BLEEEE)');
    Heart := -10;
    ItemCount := ItemCount + 1;
  end;
  if (Command = 'BIERZ DYPLOM') and (Diploma = OuterRoom) then begin
    WriteLn('PODNOSISZ DYPLOM MUD SZKOLY , I CZUJESZ PRZEPLYWAJACA PRZEZ CIEBIE MOC');
    Diploma := -10;
    MaxEnergy := MaxEnergy + 5;
    ItemCount := ItemCount + 1;
  end;
  if (Command = 'BIERZ FAJKA') and (Pipe = OuterRoom) then begin
    WriteLn('PODNOSISZ FAJKE ');
    Pipe := -10;
    ItemCount := ItemCount + 1;
    if Wisdom < MaxWisdom then Wisdom := Wisdom + 1;
  end;
  if (Command = 'ODRZUC STARY') and (OldSword = -10) then begin
    WriteLn('ODRZUCASZ STARY ZARDZEWIALY MIECZ I MASZ JAROWE ZE GO NIE POSIADASZ');
    OldSword := OuterRoom;
    ItemCount := ItemCount - 1;
  end;
  if (Command = 'ODRZUC FAJKA') and (Pipe = -10) then begin
    WriteLn('WYRZUCASZ FAJKE ');
    Pipe := OuterRoom;
    ItemCount := ItemCount - 1;
    Wisdom := Wisdom - 1;
  end;
  if (Command = 'ODRZUC MALA') and (SmallShield = -10) then begin
    WriteLn('ODRZUCASZ MALA ZWYKLA TARCZE ');
    SmallShield := OuterRoom;
    ItemCount := ItemCount - 1;
  end;
  if (Command = 'ODRZUC SERCE') and (Heart = -10) then begin
    WriteLn('ODRZUCASZ ZAKRWAWIONE SERCE ');
    Heart := OuterRoom;
    ItemCount := ItemCount - 1;
  end;
  if (Command = 'ODRZUC DYPLOM') and (Diploma = -10) then begin
    WriteLn('ODRZUCASZ DYPLOM MUD SZKOLY , I PRZESTAJESZ CZUC PRZEPLYWAJACA PRZEZ CIEBIE MOC');
    Diploma := OuterRoom;
    MaxEnergy := MaxEnergy - 5;
    ItemCount := ItemCount - 1;
  end;
end;
procedure UseItems;
begin
  if (Command = 'UZYJ FAJKA') and (Pipe = -10) then WriteLn('ZAPALASZ FAJECZKE I PYKASZ Z ZADOWOLENIEM');
  if (Command = 'UZYJ SERCE') and (Heart = -10) then begin
    Heart := 0;
    WriteLn('ZJADASZ ZAKRWAWIONE SERCE I ODZYSKUJESZ 5% ENERGII');
    Energy := Energy + 5;
    if Energy > MaxEnergy then Energy := MaxEnergy;
    ItemCount := ItemCount - 1;
  end;
  if (Command = 'UZYJ DYPLOM') and (Diploma = -10) then begin
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
  if (Command = 'UZYJ PACZEK') and (Doughnut <= -10) then begin
    ItemCount := ItemCount - 1;
    Doughnut := Doughnut + 10;
    WriteLn('ZJADASZ PACZKA I TYJESZ 1 KILO (DOSTAJESZ 8%ENERGII)');
    Energy := Energy + 8;
    if Energy > MaxEnergy then Energy := MaxEnergy;
  end;
  if (Command = 'UZYJ CIASTKO') and (Cookie <= -10) then begin
    ItemCount := ItemCount - 1;
    Cookie := Cookie + 10;
    WriteLn('ZJADASZ CIASTKO I TYJESZ 2 KILO (DOSTAJESZ 12% ENERGII)');
    Energy := Energy + 12;
    if Energy > MaxEnergy then Energy := MaxEnergy;
  end;
  if (Command = 'UZYJ SUCHA RACJA') and (DryRation <= -10) then begin
    ItemCount := ItemCount - 1;
    DryRation := DryRation + 10;
    WriteLn('ZJADASZ SUCHA RACJE I CHUDNIESZ 3 KILO (DOSTAJESZ 16% ENERGII)');
    Energy := Energy + 16;
    if Energy > MaxEnergy then Energy := MaxEnergy;
  end;
  if (Command = 'UZYJ BULKA') and (BreadRoll <= -10) then begin
    ItemCount := ItemCount - 1;
    BreadRoll := BreadRoll + 10;
    WriteLn('ZJADASZ BULKE I STWIERDZASZ ZE ZYSKALES 20%');
    Energy := Energy + 20;
    if Energy > MaxEnergy then Energy := MaxEnergy;
  end;
  if (Command = 'ZNISZCZ PRZEPUSTKA') and (Permit <= -10) then begin
    WriteLn('GRRRRRRRRR .... GLUPIA PRZEPUSTKA');
    Permit := Permit + 10;
    ItemCount := ItemCount + 1;
  end;
  if (Command = 'PATRZ PRZEPUSTKA') and (Permit <= -10) then begin
    WriteLn('|========================|');
    WriteLn('| Niniejszym zaswiadczam |');
    WriteLn('|  Iz osoba posiadajaca  |');
    WriteLn('|      Ten dokument      |');
    WriteLn('|   Ukonczyla pozytywnie |');
    WriteLn('| Jeden z moich quest'#162'w  |');
    WriteLn('|========================|');
  end;
  if (Command = 'UZYJ CHLEB') and (Bread <= -10) then begin
    ItemCount := ItemCount - 1;
    Bread := Bread + 10;
    WriteLn('ZJADASZ DUZY CIEPLY CHLEB I JESTES PELEN (ZYSKUJESZ 26%)');
    Energy := Energy + 26;
    if Energy > MaxEnergy then Energy := MaxEnergy;
  end;
  if Command = 'UZYJ KASETA' then WriteLn('TEN PRZEMIOT JEST TYPU : SMIEC . S.Z -8 MAXE +5 ZRE +1 ');
  if (Command = 'UZYJ WEKA') and (Sausage <= -10) then begin
    ItemCount := ItemCount - 1;
    Sausage := Sausage + 10;
    WriteLn('ZJADASZ DLUGASNA WEKE I TYJAC 15 KILO ZYSKUJESZ 34%');
    Energy := Energy + 34;
    if Energy > MaxEnergy then Energy := MaxEnergy;
  end;
  if (Command = 'UZYJ MALA BUTELKA MANY') and (ManaBottle <= -10) then begin
    ItemCount := ItemCount - 1;
    ManaBottle := ManaBottle + 10;
    WriteLn('WYPIJASZ MALA BUTELKE MANY I ODZYSKUJESZ 30 MANY');
    Mana := Mana + 30;
    if Mana > MaxMana then Mana := MaxMana;
  end;
  if (Command = 'UZYJ BIGOS') and (Bigos <= -10) then begin
    ItemCount := ItemCount - 1;
    Bigos := Bigos + 10;
    WriteLn('ZJADASZ BIGOS Z WROGA I ODZYSKUJESZ 20% ENERGI');
    Energy := Energy + 20;
    if Energy > MaxEnergy then Energy := MaxEnergy;

  end;
  if (Command = 'UZYJ KOMPLET') and (Tracksuit <= -10) and (WornGarment = '') then begin
    WriteLn('NAKLADASZ KOMPLET UBRAN FIRMY "SYF"');
    Armor := Armor + 7;
    Wearing := 1;
    WornGarment := 'SYF';
  end;
  if (Command = 'ODLORZ KOMPLET') and (Tracksuit <= -10) and (WornGarment = 'SYF') then begin
    WriteLn('ZDEJMUJESZ KOMPLET UBRAN FIRMY "SYF"');
    Wearing := 0;
    Armor := Armor - 7;
    WornGarment := '';
  end;
  if (Command = 'UZYJ LISTEK') and (LuckyLeaf <= -10) then WriteLn('LISTEK JEST TYPU SMIEC MAX PRZEDMIOTOW + 3 ');
  if (Command = 'UZYJ GARNITUR') and (SpikedSuit <= -10) and (WornGarment = '') then begin
    WriteLn('NAKLADASZ GARNITUR Z KOLCAMI NA SWE (NIE)WYSPORTOWANE CIALO');
    Wearing := 1;
    WornCount := WornCount + 1;
    Armor := Armor + 10;
    LuckRoll := LuckRoll + 15;
    WornGarment := 'GARNITUR';
  end;
  if (Command = 'UZYJ PIGULKA') and (TeleportPill <= -10) then begin
    WriteLn('WSZYSTKO ZACZYNA WIROWAC , POTEM NAGLY BLYSK I ZNAJDUJESZ SIE W PRZESZLOSCI');
    TeleportPill := TeleportPill + 10;
    SpawnMonsters;
    if Wisdom < 10 then begin
      WriteLn('BRAK OBYCIA W POSLUGIWANIU SIE MAGICZNYMI PRZEDMIOTAMI SPRAWIL ZE ');
      WriteLn('ZNACZNIE OPADLES Z SIL I STALES SIE BARDZO ZMECZONY');
      MaxEnergy := MaxEnergy - 1;
      Energy := 1;
      Experience := Experience - 50;
    end;
    if (Wisdom > 9) and (Wisdom < 16) then begin
      WriteLn('MASZ PEWNE OBYCIE W MAGICZNYCH PRZEDMIOTACH ALE MIMO WSZYSTKO');
      WriteLn('OPADLES Z SIL I STALES SIE ZMECZONY');
      Energy := Energy - 40;
      if Energy < 1 then Energy := 1;
      Experience := Experience - 30;
    end;
    if Wisdom > 15 then WriteLn('ZNASZ SIE NA TEGO TYPU PRZEDMIOTACH , WYSZEDLES Z TEGO BEZ SZWANKU');
  end;
  if (Command = 'ODLORZ GARNITUR') and (SpikedSuit <= -10) and (WornGarment = 'GARNITUR') then begin
    WriteLn('ZDEJMUJESZ GARNITUR Z KOLCAMI ZE SWEGO (NIE)WYSPORTOWANEGO CIALA');
    Wearing := 0;
    WornCount := WornCount - 1;
    Armor := Armor - 10;
    LuckRoll := LuckRoll - 15;
    WornGarment := '';
  end;
end;

procedure DisplayPrefs;
begin
  if Command = 'ZMIEN KOLOR' then begin
    WriteLn('PODAJ LICZBE KOLORU');
    ReadLn(Roll);
    TextColor(Roll);
  end;
  if Command = 'ZMIEN TLO' then begin
    WriteLn('PODAJ LICZBE TLA');
    ReadLn(Roll);
    TextBackground(Roll);
  end;
end;
procedure ArenaMaze;
begin
  if (Room = 33) or (Room = 34) or (Room = 35) or (Room = 36) or (Room = 37) or
     (Room = 38) or (Room = 39) or (Room = 40) or (Room = 41) or (Room = 42) or
     (Room = 43) or (Room = 44) or (Room = 45) or (Room = 46) or (Room = 47) or
     (Room = 48) or (Room = 49) or (Room = 50) or (Room = 51) or (Room = 52) or
     (Room = 53) or (Room = 54) or (Room = 55) or (Room = 56) or (Room = 57) then
  begin
    InArena := 1;
    WriteLn('JESTES NA ARENIE I CZUJESZ POTRZEBE ZABIJANIA');
    DescribeBeasts;
    repeat
      write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if (Command = 'ZABIJ BAKTERIA') and (Room = Bacterium) then
      begin FightWeak;
        Bacterium := 0;
        WriteLn('BUUUUU! BIEDNA BAKTERIA ');
      end;
      if (Command = 'ZABIJ SLIMAK') and (Room = Snail) then
      begin FightWeak;
        if Fled = 0 then Snail := 0;
      end;
      if (Command = 'ZABIJ KORNIK') and (Room = Woodworm) then
      begin FightWeak;
        if Fled = 0 then Woodworm := 0;
      end;
      if (Command = 'ZABIJ MUCHA') and (Room = Fly) then
      begin FightWeak;
        if Fled = 0 then Fly := 0;
      end;

      if (Command = 'ZABIJ ZUK') and (Room = Beetle) then
      begin FightWeak;
        if Fled = 0 then Beetle := 0;
      end;
      if (Command = 'ZABIJ KARALUCH') and (Room = Cockroach) then
      begin FightWeak;
        Cockroach := 0;
      end;
      if (Command = 'ZABIJ MROWKA') and (Room = Ant) then
      begin FightWeak;
        Ant := 0;
      end;
      if (Command = 'ZABIJ PAJAK') and (Room = Spider) then
      begin FightWeak;
        Spider := 0;
      end;
      if (Command = 'ZABIJ DZIK') and (Room = Boar) then
      begin FightWeakish;
        Boar := 0;
      end;
      if (Command = 'ZABIJ WILCZUR') and (Room = Mongrel) then
      begin WriteLn('WILCZUR PRZYJA PROPOZYCJE Z GODNOSCIA');
        FightWeakish;
        Mongrel := 0;
      end;

      if (Command = 'ZABIJ SZCZUR') and (Room = Rat) then
      begin FightWeakish;
        Rat := 0;
      end;
      if (Command = 'ZABIJ LIS') and (Room = Fox) then
      begin FightWeakish;
        Fox := 0;
      end;
      if (Command = 'ZABIJ KUROPATWA') and (Room = Partridge) then
      begin FightWeakish;
        Partridge := 0;
      end;
      if (Command = 'ZABIJ ZAJAC') and (Room = Hare) then
      begin FightWeakish;
        Hare := 0;
      end;
      if (Command = 'ZABIJ ORZEL') and (Room = Eagle) then
      begin FightWeakish;
        Eagle := 0;
      end;
      if (Command = 'ZABIJ SARNA') and (Room = Deer) then
      begin FightWeakish;
        Deer := 0;
      end;
      if (Command = 'ZABIJ SLON') and (Room = Elephant) then
      begin FightMedium;
        Elephant := 0;
      end;
      if (Command = 'ZABIJ LEW') and (Room = Lion) then
      begin FightMedium;
        Lion := 0;
      end;
      if (Command = 'ZABIJ ZYRAFA') and (Room = Giraffe) then
      begin FightMedium;
        Giraffe := 0;
      end;
      if (Command = 'ZABIJ WILK') and (Room = Wolf) then
      begin FightMedium;
        Wolf := 0;
      end;
      if (Command = 'ZABIJ WIELBLAD') and (Room = Camel) then
      begin FightMedium;
        Camel := 0;
      end;
      if (Command = 'ZABIJ STRUS') and (Room = Ostrich) then
      begin FightMedium;
        Ostrich := 0;
      end;
      if (Command = 'ZABIJ BOA') and (Room = Boa) then
      begin FightMedium;
        Boa := 0;
      end;
      if (Command = 'ZABIJ BIZON') and (Room = Bison) then
      begin FightMedium;
        Bison := 0;
      end;
      if (Command = 'ZABIJ PANTERA') and (Room = Panther) then
      begin FightMedium;
        Panther := 0;
      end;
      if (Command = 'ZABIJ GLADIATOR') and (Room = Gladiator) then
      begin FightHard;
        Gladiator := 0;
        PillGain;
      end;
      if (Command = 'ZABIJ WOJOWNIK') and (Room = Warrior) then
      begin FightHard;
        Warrior := 0;
        PillGain;
      end;
      if (Command = 'ZABIJ TRENER') and (Room = Tamer) then
      begin FightHard;
        Tamer := 0;
        SuitGain;
      end;
      if Command = 'EXIT' then begin
        if Room = 33 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLODNIE-WEJSCIE NA ARENE');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (Room = 34) or (Room = 37) or (Room = 38) or (Room = 39) or
                (Room = 42) or (Room = 43) or (Room = 44) or (Room = 48) or
                (Room = 49) then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (Room = 35) or (Room = 36) then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Room = 40 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Room = 41 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
        if (Room = 45) or (Room = 50) or (Room = 54) then begin
          WriteLn('MOZESZ WYJSC NA :');
          WriteLn('POLNOC-ARENA');
          WriteLn('POLODNIE-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (Room = 46) or (Room = 51) or (Room = 55) then begin
          WriteLn('MOZESZ WYJSC NA :');
          WriteLn('POLNOC-ARENA');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
        if (Room = 47) or (Room = 52) or (Room = 53) then begin
          WriteLn('MOZESZ ISC NA :');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Room = 56 then begin
          WriteLn('DOSTEPNE WYJSCIE:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Room = 57 then begin
          WriteLn('DOSTEPNE WYJSCIE:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
      end;
      if Command = 'WYJSCIE' then exit;
      if Command = 'POLODNIE' then begin
        InArena := 0;
        if Room = 33 then Room := 32;
        if Room = 34 then Room := 33;
        if (Room = 35) or (Room = 36) or (Room = 40) or (Room = 41) then InArena := 1;
        if Room = 37 then Room := 34;
        if Room = 38 then Room := 35;
        if Room = 39 then Room := 36;
        if Room = 42 then Room := 37;
        if Room = 43 then Room := 38;
        if Room = 44 then Room := 39;
        if Room = 45 then Room := 40;
        if Room = 46 then Room := 41;
        if Room = 47 then Room := 42;
        if Room = 48 then Room := 43;
        if Room = 49 then Room := 44;
        if Room = 50 then Room := 45;
        if Room = 51 then Room := 46;
        if Room = 52 then Room := 48;
        if Room = 53 then Room := 49;
        if Room = 54 then Room := 50;
        if Room = 55 then Room := 51;
        if Room = 56 then Room := 54;
        if Room = 57 then Room := 55;
      end;
      if Command = 'POLNOC' then begin
        InArena := 0;
        if Room = 33 then begin Room := 34; MoveGuard := 1; end;
        if (Room = 34) and (MoveGuard = 0) then begin Room := 37; MoveGuard := 1; end;
        if (Room = 35) and (MoveGuard = 0) then begin Room := 38; MoveGuard := 1; end;
        if (Room = 36) and (MoveGuard = 0) then begin Room := 39; MoveGuard := 1; end;
        if (Room = 37) and (MoveGuard = 0) then begin Room := 42; MoveGuard := 1; end;
        if (Room = 38) and (MoveGuard = 0) then begin Room := 43; MoveGuard := 1; end;
        if (Room = 39) and (MoveGuard = 0) then begin Room := 44; MoveGuard := 1; end;
        if (Room = 40) and (MoveGuard = 0) then begin Room := 45; MoveGuard := 1; end;
        if (Room = 41) and (MoveGuard = 0) then begin Room := 46; MoveGuard := 1; end;
        if (Room = 42) and (MoveGuard = 0) then begin Room := 47; MoveGuard := 1; end;
        if (Room = 43) and (MoveGuard = 0) then begin Room := 48; MoveGuard := 1; end;
        if (Room = 44) and (MoveGuard = 0) then begin Room := 49; MoveGuard := 1; end;
        if (Room = 45) and (MoveGuard = 0) then begin Room := 50; MoveGuard := 1; end;
        if (Room = 46) and (MoveGuard = 0) then begin Room := 51; MoveGuard := 1; end;
        if (Room = 47) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 48) and (MoveGuard = 0) then begin Room := 52; MoveGuard := 1; end;
        if (Room = 49) and (MoveGuard = 0) then begin Room := 53; MoveGuard := 1; end;
        if (Room = 50) and (MoveGuard = 0) then begin Room := 54; MoveGuard := 1; end;
        if (Room = 51) and (MoveGuard = 0) then begin Room := 55; MoveGuard := 1; end;
        if (Room = 52) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 53) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 54) and (MoveGuard = 0) then begin Room := 56; MoveGuard := 1; end;
        if (Room = 55) and (MoveGuard = 0) then begin Room := 57; MoveGuard := 1; end;
        if (Room = 56) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 57) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
      end;
      if Command = 'WSCHOD' then begin
        InArena := 0;
        if (Room = 33) and (MoveGuard = 0) then begin Room := 35; MoveGuard := 1; end;
        if (Room = 34) and (MoveGuard = 0) then begin Room := 38; MoveGuard := 1; end;
        if (Room = 35) and (MoveGuard = 0) then begin Room := 40; MoveGuard := 1; end;
        if (Room = 36) and (MoveGuard = 0) then begin Room := 33; MoveGuard := 1; end;
        if (Room = 37) and (MoveGuard = 0) then begin Room := 43; MoveGuard := 1; end;
        if (Room = 38) and (MoveGuard = 0) then begin Room := 45; MoveGuard := 1; end;
        if (Room = 39) and (MoveGuard = 0) then begin Room := 34; MoveGuard := 1; end;
        if (Room = 40) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 41) and (MoveGuard = 0) then begin Room := 36; MoveGuard := 1; end;
        if (Room = 42) and (MoveGuard = 0) then begin Room := 48; MoveGuard := 1; end;
        if (Room = 43) and (MoveGuard = 0) then begin Room := 50; MoveGuard := 1; end;
        if (Room = 44) and (MoveGuard = 0) then begin Room := 37; MoveGuard := 1; end;
        if (Room = 45) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 46) and (MoveGuard = 0) then begin Room := 39; MoveGuard := 1; end;
        if (Room = 47) and (MoveGuard = 0) then begin Room := 52; MoveGuard := 1; end;
        if (Room = 48) and (MoveGuard = 0) then begin Room := 54; MoveGuard := 1; end;
        if (Room = 49) and (MoveGuard = 0) then begin Room := 42; MoveGuard := 1; end;
        if (Room = 50) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 51) and (MoveGuard = 0) then begin Room := 44; MoveGuard := 1; end;
        if (Room = 52) and (MoveGuard = 0) then begin Room := 56; MoveGuard := 1; end;
        if (Room = 53) and (MoveGuard = 0) then begin Room := 47; MoveGuard := 1; end;
        if (Room = 54) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 55) and (MoveGuard = 0) then begin Room := 49; MoveGuard := 1; end;
        if (Room = 56) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 57) and (MoveGuard = 0) then begin Room := 53; MoveGuard := 1; end;
      end;
      if Command = 'ZACHOD' then begin
        InArena := 0;
        if (Room = 33) and (MoveGuard = 0) then begin Room := 36; MoveGuard := 1; end;
        if (Room = 34) and (MoveGuard = 0) then begin Room := 39; MoveGuard := 1; end;
        if (Room = 35) and (MoveGuard = 0) then begin Room := 33; MoveGuard := 1; end;
        if (Room = 36) and (MoveGuard = 0) then begin Room := 41; MoveGuard := 1; end;
        if (Room = 37) and (MoveGuard = 0) then begin Room := 44; MoveGuard := 1; end;
        if (Room = 38) and (MoveGuard = 0) then begin Room := 34; MoveGuard := 1; end;
        if (Room = 39) and (MoveGuard = 0) then begin Room := 46; MoveGuard := 1; end;
        if (Room = 40) and (MoveGuard = 0) then begin Room := 35; MoveGuard := 1; end;
        if (Room = 41) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 42) and (MoveGuard = 0) then begin Room := 49; MoveGuard := 1; end;
        if (Room = 43) and (MoveGuard = 0) then begin Room := 37; MoveGuard := 1; end;
        if (Room = 44) and (MoveGuard = 0) then begin Room := 51; MoveGuard := 1; end;
        if (Room = 45) and (MoveGuard = 0) then begin Room := 38; MoveGuard := 1; end;
        if (Room = 46) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 47) and (MoveGuard = 0) then begin Room := 53; MoveGuard := 1; end;
        if (Room = 48) and (MoveGuard = 0) then begin Room := 42; MoveGuard := 1; end;
        if (Room = 49) and (MoveGuard = 0) then begin Room := 55; MoveGuard := 1; end;
        if (Room = 50) and (MoveGuard = 0) then begin Room := 43; MoveGuard := 1; end;
        if (Room = 51) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 52) and (MoveGuard = 0) then begin Room := 47; MoveGuard := 1; end;
        if (Room = 53) and (MoveGuard = 0) then begin Room := 57; MoveGuard := 1; end;
        if (Room = 54) and (MoveGuard = 0) then begin Room := 48; MoveGuard := 1; end;
        if (Room = 55) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
        if (Room = 56) and (MoveGuard = 0) then begin Room := 52; MoveGuard := 1; end;
        if (Room = 57) and (MoveGuard = 0) then begin InArena := 1; MoveGuard := 1; end;
      end;
      MoveGuard := 0;
      until (InArena = 0) or (Room = 1000);
  end;
end;
procedure StageFights;
begin
  if (Command = 'ZABIJ PERKUSISTA') and (Drummer = Room) then begin
    FightVeryEasy;
    Drummer := 0;
    CassetteGain;
  end;
  if (Command = 'ZABIJ GITARZYSTA') and (Guitarist = Room) then begin
    FightVeryEasy;
    Guitarist := 0;
    CassetteGain;
  end;
  if (Command = 'ZABIJ LIROY') and (Liroy = Room) then begin
    FightNotEasy;
    if (Room <> 10000) and (Energy > 0) and (Fled = 0) then begin
      WriteLn('GRATULACJE !!! ZABILES LIROYA DOSTAJESZ ZA DARMO 30 KASY');
      Money := Money + 30;
      CassetteGain;
      if Quest > 1 then QuestKills := QuestKills - 150;
      Liroy := 0;
    end;
  end;
  if (Command = 'ZABIJ ORGANISTA') and (Keyboardist = Room) then begin
    FightVeryEasy;
    Keyboardist := 0;
    CassetteGain;
  end;
end;
procedure KillPlant(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Room) then begin
    FightVeryEasy;
    Plant := 0;
  end;
end;

procedure KillPlantIfAlive(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Room) then begin
    FightVeryEasy;
    if Energy > 0 then Plant := 0;
  end;
end;

procedure KillPlantEasyIfAlive(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Room) then begin
    FightEasy;
    if Energy > 0 then Plant := 0;
  end;
end;

procedure PlantFights;
begin
  if (Command = 'ZABIJ DUNCAN') and (Duncan = Room) then begin
    FightEasy;
    if EnemyEnergy < 1 then Duncan := 0;
  end;
  if (Command = 'SECRET LISTA') and (Duncan = Room) then begin
    WriteLn('OTO CO AKTUALNIE MAM DO ZAOFEROWANIA : PAMIETAJ U MNIE TYLKO KUPUJEMY');
    WriteLn('MARCHEWKA Z SADU DUNCANA   : 7000');
    WriteLn('PRZEPUSTKA QUEST-MASTERA   :  400');
    WriteLn('PLECAK                     : 4800');
  end;
  if Command = 'KUP DOKUMENT' then begin if Money > 399 then begin
      WriteLn('OTO PODROBIONA PRZEPUSTKA HE , HE NAWET QUEST-MASTER SIE NIE POKAPUJE');
      Permit := Permit - 10;
      Money := Money - 400;
      ItemCount := ItemCount + 1; end;
  end;
  if (Command = 'KUP PLECAK') and (Duncan = Room) then begin if Money > 4799 then begin
      WriteLn('HE HE HE MILO SIE Z TOBA ROBI INTERESY');
      Money := Money - 4800;
      Backpack := Backpack - 10;
      ItemCount := ItemCount + 1; end;
  end;
  if (Command = 'ROZMAWIAJ DUNCAN') and (Duncan = Room) then begin
    if DuncanQuest = 0 then begin
      WriteLn('UCH A COZ TO ZA STRASZNA ROSLINA - PRZELAKL SIE DUNCAN WIDZAC CIEBIE');
      WriteLn('AAA TO JAKIS WAL A NIE ROSLINA , MOWI PO CHWILI,JAK CI SIE NUDZI TO ');
      WriteLn('MOZESZ POMOC MI WYRYWAC CHWASTY , SZCZEGOLNIA ZABOJCZA DLA MOICH MARCHEWECZEK');
      WriteLn('JEST TA WREDNA POKRZYWA , SZKODA ZE TAK JAK INNE POTWORY SIE ODREGENEROWUJE');
      WriteLn('ALE JAK JA ZABIJESZ , POWIEDZMY ... 4 RAZY TO MOZE DA SOBIE SPOKOJ');
      WriteLn('CO CI DAM W ZAMIAN ? TROCHE KUNSZTU , A MOJ STARY PRACUJE NA CZARNYM RYNKU');
      DuncanQuest := 75;
    end;
    if DuncanQuest <> 0 then
      WriteLn('TO CO ZABIJESZ TE ROSLINY CZY BEDZIEMY TU STAC JAK OSTATNIE LOSIE?');

    if DuncanQuest = -125 then begin
      WriteLn('DZIEKI DZIEKI , TO BYLA DOBRA ROBOTA , OD TERAZ MOZESZ PISAC PRZY MNIE :');
      WriteLn('SECRET LISTA , TO MOZE AKURAT BEDE COS MIAL NA ZBYCIU , ADIOS');
      DuncanQuest := 0;
      Experience := Experience + 125;
      WriteLn('--------- ZDOBYLES 125 KUNSZTU ------------------------');

    end;
  end;

  KillPlant('ZABIJ SZCZAW', Sorrel);
  KillPlant('ZABIJ KONICZYNKA', Clover);
  KillPlant('ZABIJ MLECZ', SowThistle);
  KillPlant('ZABIJ DMUCHAWIEC', Dandelion);

  KillPlantIfAlive('ZABIJ STOKROTKA', Daisy);

  KillPlantEasyIfAlive('ZABIJ ROZA', Rose);
  KillPlantEasyIfAlive('ZABIJ OSET', Thistle);
  KillPlantEasyIfAlive('ZABIJ MALINA', Raspberry);
  KillPlantEasyIfAlive('ZABIJ AGREST', Gooseberry);
  KillPlantEasyIfAlive('ZABIJ JEZYNA', Blackberry);

  if (Command = 'ZABIJ TRAWA') and (Grass = Room) then begin
    WriteLn('HA HA HA WOLAJA SETKI LISCI TRAWY - TO BEDZIE WALKA');
    FightHard;
    if Energy > 0 then FightHard;
    if Energy > 0 then FightHard;
    if Energy > 0 then FightHard;
    if (Energy > 0) and (Fled = 0) then
      WriteLn('UFF STRUDZONY POSTANAWIASZ ODPOCZAC TYLU PRZECIWNIKOW DAWNO NIE WIDZIALES');
  end;
end;
procedure ExpandAbbrev;

const
  AbbrevCount = 8;
  AbbrevFrom: array[1..AbbrevCount] of string = ('PN','PD','W','Z','G','D','E','M');
  AbbrevTo:   array[1..AbbrevCount] of string = ('POLNOC','POLODNIE','WSCHOD','ZACHOD','GORA','DOL','EXIT','MODE');
var i: Integer;
begin
  for i := 1 to AbbrevCount do
    if Command = AbbrevFrom[i] then begin
      Command := AbbrevTo[i];
      Exit;
    end;
end;

const
  TranceRoom = 1000;
  DeadRoom = 10000;

  Lvl1_Threshold = 700;
  Lvl2_Threshold = 725;
  Lvl3_Threshold = 730;
  Lvl4_Base = 735;
  Lvl9_Base = 735;
var
  Unused52: Integer;
  WeaponKind: Integer;
  SavedFlag: Integer;
  CageWeakling: Integer;
  CageAgile: Integer;
  CageTough: Integer;
  CageHuge: Integer;
  ShieldKind: Integer;
  ItemLimit: Integer;
  SwordValue: Integer;
  ShieldValue: Integer;
  HeartValue: Integer;
  CheckpointStage: Integer;
  ArmorRating: Integer;
  SleepHours: Integer;
  CookingDisplayBug: Integer;
  Unused76: Integer;
  LoadDummy: Integer;
  Returning: Integer;
  ReturnScroll: Integer;
  Beer: Integer;
  ExitRequested: Boolean;
  SaveFile: Text;

type
  TRace = record
    name: string;
    Strength, Dexterity, Wisdom: Integer;
    MaxStrength, MaxDexterity, MaxWisdom: Integer;
    MaxManaBonus, MoneyBonus, MaxEnergyBonus, EnergyBonus: Integer;
  end;

  TDexterityLimit = record
    Dexterity: Integer;
    limit: Integer;
  end;

  TCommandHandler = procedure;
  TCommandEntry = record
    cmd: string;
    run: TCommandHandler;
  end;

  TRoomEntry = record
    room: Integer;
    run: TCommandHandler;
  end;

  TPredicate = function: Boolean;
  TShopAction = procedure;
  TShopRule = record
    cmd: string;
    allowed: TPredicate;
    act: TShopAction;
  end;

const
  Races: array[1..6] of TRace = (
    (name:'CZLOWIEK'; Strength:10; Dexterity:10; Wisdom:10;
     MaxStrength:15; MaxDexterity:15; MaxWisdom:15;
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'OLBRZYM'; Strength:13; Dexterity:13; Wisdom:5;
     MaxStrength:20; MaxDexterity:20; MaxWisdom:7;
     MaxManaBonus:-30; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'NIMFA'; Strength:10; Dexterity:13; Wisdom:7;
     MaxStrength:15; MaxDexterity:20; MaxWisdom:11;
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'POL-ELF'; Strength:6; Dexterity:16; Wisdom:8;
     MaxStrength:10; MaxDexterity:24; MaxWisdom:12;
     MaxManaBonus:-20; MoneyBonus:30; MaxEnergyBonus:-5; EnergyBonus:-5),
    (name:'UFOK'; Strength:9; Dexterity:9; Wisdom:13;
     MaxStrength:13; MaxDexterity:14; MaxWisdom:20;
     MaxManaBonus:50; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'CZAROMIL'; Strength:6; Dexterity:7; Wisdom:16;
     MaxStrength:9; MaxDexterity:11; MaxWisdom:25;
     MaxManaBonus:150; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0)
  );

  DexterityItemLimits: array[1..7] of TDexterityLimit = (
    (Dexterity: 0; limit: 10), (Dexterity: 11; limit: 11), (Dexterity: 13; limit: 12),
    (Dexterity: 16; limit: 13), (Dexterity: 19; limit: 14), (Dexterity: 21; limit: 15),
    (Dexterity: 25; limit: 16));

procedure ConcertFights; forward;
procedure ChooseRace; forward;
procedure Checkpoints; forward;
procedure CheckLevelUp; forward;
procedure Training; forward;
procedure Room2; forward;
procedure Room3; forward;
procedure Room9; forward;
procedure Room12; forward;
procedure StreetFights; forward;
procedure BakeryShop; forward;
procedure ArmouryShop; forward;
procedure GeneralStoreShop; forward;
procedure MagicShop; forward;
procedure ConcertRooms; forward;
procedure SaveCharacter; forward;
procedure Death; forward;
procedure LoadCharacter; forward;
procedure ShowCharacter; forward;

function LevelName(lvl: Integer): string;

const
  LevelNames: array[4..13] of string = (
    'CZWARTYM', 'PIATYM', 'SZ'#224'STYM', 'SIODMYM', 'OSMYM',
    'DZIEWIATYM', 'DZIESIATYM', 'JEDENASTYM', 'DWUNASTYM', 'TRZYNASTYM');
begin
  if (lvl >= 4) and (lvl <= 13) then LevelName := LevelNames[lvl]
  else LevelName := '';
end;

function LevelThreshold(lvl: Integer): Integer;

begin
  case lvl of
    1: LevelThreshold := Lvl1_Threshold;
    2: LevelThreshold := Lvl2_Threshold;
    3: LevelThreshold := Lvl3_Threshold;
    4..8: LevelThreshold := Lvl4_Base + lvl;
    9..13: LevelThreshold := Lvl9_Base + 2 * lvl;
    else LevelThreshold := Lvl9_Base + 2 * lvl;
  end;
end;

procedure ShowItem(val: Integer; const desc: string; width: Integer);

begin
  if val <= -10 then
    if width = 0 then WriteLn(desc)
    else WriteLn(desc, val:width);
end;

procedure ShowItemPlain(val: Integer; const desc: string);

begin
  if val <= -10 then
    WriteLn(desc, val);
end;

procedure ShowItemDiv10(val: Integer; const desc: string);

begin
  if val <= -10 then
    WriteLn(desc, val div 10);
end;

procedure ShowCharacter;

var
  i, gap: Integer;
begin

  for i := High(DexterityItemLimits) downto Low(DexterityItemLimits) do
    if Dexterity >= DexterityItemLimits[i].Dexterity then begin
      ItemLimit := DexterityItemLimits[i].limit;
      Break;
    end;
  if Backpack < 0 then ItemLimit := ItemLimit + 4;
  WriteLn('NOSISZ ZE SOBA:');
  ShowItem(OldSword, 'STARY ZARDZEWIALY MIECZ', 0);
  ShowItem(SmallShield, 'OKRAGLA MALA TARCZA', 0);
  ShowItem(Heart, 'ZAKRWAWIONE SERCE', 0);
  ShowItem(Diploma, 'DYPLOM MUD SZKOLY', 0);
  ShowItem(Doughnut, 'SMACZNY POLANY LIKIEREM PACZEK', 10);
  ShowItem(Cookie, 'SMACZNE CIASTKO ', 10);
  ShowItem(DryRation, 'TWARDA SUCHA RACJE', 10);
  ShowItem(BreadRoll, 'OKRAGLA PACHNACA BULKA', 10);
  ShowItem(Bread, 'DUZY CIEPLY CHLEB', 10);
  ShowItem(Sausage, 'DLUGA I SMACZNA WEKE', 10);
  ShowItem(Bigos, 'PYSZNY BIGOS Z KAPUSTA Z WROGA', 10);
  ShowItemDiv10(Beer, 'OZEWIAJACE PIWSKO Z KONKRETNYM KLIMATEM');
  ShowItemPlain(Pipe, 'CIEZKA FAJKA OD DZIADA MROZA');
  ShowItemPlain(Tracksuit, 'KOMPLET UBRAN FIRMY "SYF"');
  ShowItemPlain(SpikedSuit, 'GARNITUR Z KOLCAMI');
  ShowItemPlain(ManaBottle, 'MALA BUTELKE MANY');
  ShowItemPlain(LuckyLeaf, 'DELIKATNY CHOC SZORSTKI LISTEK');
  ShowItemPlain(Cassette, 'KASETA LIROYA : L - JAK LIROY ');
  ShowItemPlain(TeleportPill, 'PIGULKA TRANSPORTUJACA (M:G) ');
  ShowItemPlain(Permit, 'PRZEPUSTKA WLASNORECZNIE PODPISANA PRZEZ QUEST-MASTERA ');
  ShowItemPlain(CompareScroll, 'SCROLL Z CZAREM : POROWNYWANIE ');
  ShowItemPlain(ReturnScroll, 'SCROLL Z CZAREM : POWROT ');
  WriteLn('W SUMIE MASZ ', ItemCount, '/', ItemLimit, ' PRZEDMIOTOW');
  if WeaponKind = 0 then WriteLn('BIJESZ SIE NA PIESCI');
  if ShieldKind = 0 then WriteLn('NIE MASZ ZADNEJ OCHRONY');
  if WornGarment = '' then WriteLn('JESTES NAGI !!!!!!!!');
  if WornGarment = 'SYF' then WriteLn('MASZ NA SOBIE KOMPLET UBRAN FIRMY "SYF"');
  if WornGarment = 'GARNITUR' then WriteLn('MASZ NA SOBIE GRANITUR Z KOLCAMI ');
  if (ShieldKind = 1) and (SmallShield = -100) then
    WriteLn('TWOJA OCHRONA JEST MALA TARCZA');
  if (WeaponKind = 1) and (OldSword = -100) then
    WriteLn('JAKO BRONI UZYWASZ STAREGO MIECZA');
  WriteLn('MASZ ', Money, ' MONET I ', Practice, ' PRAKTYK');

  gap := LevelThreshold(Level) - Experience;
  case Level of
    1: WriteLn('JESTES NA PIERWSZYM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    2: WriteLn('JESTES NA DRUGIM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    3: WriteLn('JESTES NA TRZECIM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, 'KUNSZTU');
    4..8: WriteLn('JESTES NA ', LevelName(Level), ' LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    9..13: WriteLn('JESTES NA ', LevelName(Level), ' LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
  end;
  if Level > 13 then
    WriteLn('JESTES NA BARDZO WYSOKIM LEVELU A DO NASTEPNEGO BRAKUJE CI TYLKO', gap, ' KUNSZTU');

  WriteLn('TWOJE PARAMETRY : SILA - ', Strength, '/', MaxStrength,
         ' ZRECZNOSC - ', Dexterity, '/', MaxDexterity,
         ' MADROSC - ', Wisdom, '/', MaxWisdom);
  ArmorRating := 10 * WornCount + Armor;
  WriteLn('S.Z-', ArmorRating,
         '                    FUKSROLL-', LuckRoll);
  WriteLn('MASZ ', Mana, '/', MaxMana, ' MANY');
  WriteLn('MASZ ', Energy, '/', MaxEnergy, ' ENERGII');
  if Quest = 1 then WriteLn('TWOJ AKTUALNY QUEST - ZABIC MUSISZ JESZCZE ', QuestKills, ' POTWOROW');
  if Quest > 1 then WriteLn('TWOJ AKTUALNY QUEST - ZABIC MUSISZ JESZCZE ', QuestKills - 150, ' POTWOROW');
  if DuncanQuest <> 0 then WriteLn('NIE ZAPOMNIALES O POKRZYWIE W SADACH DUNCANA???');
end;

function FindRace(const name: string): Integer;

var
  i: Integer;
begin
  FindRace := 0;
  for i := Low(Races) to High(Races) do
    if name = Races[i].name then begin
      FindRace := i;
      Exit;
    end;
end;

procedure ChooseRace;

var
  chosen: Integer;
begin
  ShowIntro;
  repeat
    WriteLn('NAPISZ SWA RASE : OLBRZYM , NIMFA , UFOK , CZAROMIL , CZLOWIEK , POL-ELF');
    ReadLn(Command);
    chosen := FindRace(Command);
    if chosen > 0 then begin
      Strength := Races[chosen].Strength;
      Dexterity := Races[chosen].Dexterity;
      Wisdom := Races[chosen].Wisdom;
      MaxStrength := Races[chosen].MaxStrength;
      MaxDexterity := Races[chosen].MaxDexterity;
      MaxWisdom := Races[chosen].MaxWisdom;
      MaxMana := MaxMana + Races[chosen].MaxManaBonus;
      Money := Money + Races[chosen].MoneyBonus;
      MaxEnergy := MaxEnergy + Races[chosen].MaxEnergyBonus;
      Energy := Energy + Races[chosen].EnergyBonus;
    end;
  until chosen > 0;
  WriteLn('PODAJE SWE IMIE (I TAK MNIE TO NIE OBCHODZI)');
  ReadLn(Command);
  Energy := 50;
  Practice := 10;
  CageWeakling := 12;

  CageStrong := 13;
  CageAgile := 14;
  CageTough := 15;
  CageHuge := 16;

  Level := 1;
  MaxMana := MaxMana + 100;
  Mana := MaxMana;
  SpawnMonsters;
  WriteLn('WITAJ W MUD-ZIE INTERAKTYWNIEJ FORMIE ROZRYWKI');
  WriteLn('MUD JEST TO BARDZO SKOMPLIKOWANA GRA INTERNETOWA');
  WriteLn('TEN PROGRAM NIE JEST IDENTYCZNY JAK MUD TYLE ZE NIE GRA W TO 1000 OSOB');
  WriteLn('DZIEKI TEMU PROGRAMOWI NAUCZYSZ SIE GRAC W PRAWDZIWEGO MUDA');
  WriteLn('ALE MAM NADZIEJE ZE ROZRYWKA TA BEDZIE DLA CIEBIE NOWYM WYZWANIEM');
  WriteLn('W CZASIE GRY BEDZIESZ POZNAWAL CORAZ TO NOWE KOMENDY');
  WriteLn('ALE JAK NARAZIE TYLKO KILKA Z NIECH');
  WriteLn('KOMENDA EXIT PODAJE WSZYSTKIE AKTUALNIE DOSTEPNE WYJSCIA');
  WriteLn('PORUSZASZ SIE ZA POMOCA KOMEND POLNOC POLODNIE WSCHOD ZACHOD GORA DOL');
  WriteLn('ABY SIE PATRZEC UZYJ KOMENDY PATRZ RAZEM Z RZECZA KTORA CHCESZ OBEJRZECZ');
end;

procedure KillDog(cmd: string; var Dog: Integer; extraMsg: Boolean);

begin
  if (Command = cmd) and (Dog = Room) then begin
    FightDog;
    Dog := 0;
    if extraMsg then begin
      WriteLn('GDY NAGLE!!!! NIEBIOSA SIE OTWIERAJA');
      WriteLn('A SPANIEL PRZEMAWIA DO CIEBIE LUDZKIM GLOSEM !!!!!');
      WriteLn('HAU HAU CHAMIE PO CO MNIE ZABILES ??? ');
    end;
  end;
end;

procedure KillTownsfolk(cmd: string; var npc: Integer; SpikedSuit: Boolean);

begin
  if (Command = cmd) and (npc = Room) then begin
    FightVeryEasy;
    npc := 0;
    if SpikedSuit then SuitGain;
  end;
end;

procedure KillSweeper;

begin
  if (Command = 'ZABIJ ZAMIATACZ') and (Sweeper = Room) then begin
    FightVeryEasy;
    Sweeper := 0;
    Roll := Random(100);
    if (Roll < 35) and (Tracksuit = 0) then begin
      WriteLn('ZYSKALES KOMPLET OBRABIAJAC ZAMIATACZA');
      Tracksuit := Tracksuit - 10;
    end;
  end;
end;

procedure KillSickMan;

begin
  if (Command = 'ZABIJ ZEBRAK') and (SickMan = Room) then begin
    FightVeryEasy;
    if Energy > 0 then begin
      Roll := Random(10);
      WriteLn('Z GRUBEGO PORTFELA ZEBRAKA WYCIAGASZ BONUS !!! ',
              Roll, ' MONET!');
      Money := Money + Roll;
      SickMan := 0;
    end;
  end;
end;

procedure StreetFights;

begin

  KillDog('ZABIJ OWCZAREK', Shepherd, False);
  KillDog('ZABIJ PIESEK', Pooch, False);
  KillDog('ZABIJ JAMNIK', Dachshund, False);
  KillDog('ZABIJ SPANIEL', Spaniel, True);
  KillDog('ZABIJ PUDEL', Poodle, False);

  KillTownsfolk('ZABIJ TAKSOWKARZ', Cabman, True);
  KillTownsfolk('ZABIJ SPRZEDAWCA', Vendor, True);
  KillSweeper;
  KillTownsfolk('ZABIJ PIJAK', Drunkard, False);
  KillSickMan;
end;

procedure Training;

begin
  if Command = 'PATRZ PLAKAT' then begin
    WriteLn('NA PLAKACIE PISZE:');
    WriteLn('MOZESZ CWICZYC UZYWAJAC KOMENDY CWICZ RAZEM Z ');
    if Wisdom < 11 then WriteLn('Z NICZYM BO MASZ ZA MALA MADROSC');
    if (Wisdom > 10) and (Strength > 11) then WriteLn('KOPAC - KOMENDA:KOP ');
    if (Wisdom > 10) and (Dexterity > 10) then WriteLn('UCIEKAC - KOMENDA : ZWIEJ ');
    if (Wisdom > 15) and (Dexterity > 11) then WriteLn('PAROWANIE - SAMOCZYNNIE ');
    if Wisdom > 11 then WriteLn('POROWNANIE-KOMEDA POROWNAJ');
    if Wisdom > 18 then WriteLn('POTRAWKI-SAMOCZYNNIE , PO WALCE');
    if Wisdom > 17 then WriteLn('POWROT-KOMEDA POWROT');
    if Dexterity > 20 then WriteLn('ZRECZNE RECE - KOMENDA : RECE');
    if (Strength > 20) and (Dexterity > 10) then WriteLn('KRZEPA : SAMOCZYNNIE');
    if (Wisdom > 19) and (Dexterity > 10) and (Strength > 10) then
      WriteLn('TARGOWANIE SIE : SAMOCZYNNIE');
    if (Strength > 25) and (Wisdom > 12) then WriteLn('WIROWANIE - SAMOCZYNNIE ');
    if (Strength > 29) and (Wisdom > 14) then WriteLn('FATALITY - SAMOCZYNNIE ');
    if Dexterity > 22 then WriteLn('COMBO - SAMOCZYNNIE ');
    if Dexterity > 28 then WriteLn('SUPER COMBO - SAMOCZYNNIE ');
    if Wisdom > 22 then WriteLn('TRUCIZNA - SAMOCZYNNIE');
    if Wisdom > 23 then WriteLn('UZDRAWIANIE - KOMENDA UZDROW');
    if (Dexterity > 24) and (Wisdom > 14) and (Strength > 14) then
      WriteLn('MOCNY SEN - SAMOCZYNNIE ');
    if Wisdom > 24 then WriteLn('OSLEPIANIE  - KOMEDA OSLEP ');
    if Wisdom > 26 then WriteLn('NEKROMANCJA - SAMOCZYNNIE ');
    if (Strength > 12) and (Wisdom > 19) and (Dexterity > 12) then
      WriteLn('SZAL - KOMEDNA SZAL');
    if (Dexterity > 22) and (Wisdom > 16) then WriteLn('SIATKA - KOMENDA SIATKA');
    if Dexterity > 30 then WriteLn('CIOS W PLECY - KOMENDA CIOS W (COS)');
    if Wisdom > 29 then WriteLn('ROZPALANIE OGNISKA - KOMENDA ROZPAL');
    if Wisdom > 19 then WriteLn('HIPER SPEED - KOMENDA SPEED');
    if (Wisdom > 23) and (Dexterity > 12) then WriteLn('PIECZENIE - KOMENDA PIECZ');
    WriteLn('W STANIE PODSWIADOMOSCI KOMEDA ZDOLNOSCI SPRAWDZI TWE ZDOLNOSCI');
  end;

  if Command = 'CWICZ KOPAC' then
    if (Wisdom > 10) and (Strength > 11) and (Practice > 0) then begin
      Kick := Kick + Wisdom;
      Practice := Practice - 1;
      WriteLn('CWICZYSZ KOPANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Kick,
              '% MASZ ', Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ UCIEKAC' then begin
    if Wisdom > 10 then
      if Dexterity > 10 then
        if (Practice > 0) and (Fleeing < 85) then begin
          Fleeing := Fleeing + Wisdom + Dexterity - 5;
          Practice := Practice - 1;
          WriteLn('CWICZYSZ UCIEKANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Fleeing,
                  '% MASZ ', Practice, ' PRAKTYK');
        end else
          WriteLn('ALBO MASZ ZA DOBRZE WYTRENOWANE ALBO ZA MALO PRAKTYK');
  end;

  if Command = 'CWICZ POWROT' then
    if (Wisdom > 17) and (Returning < 90) and (Practice > 0) then begin
      Returning := Returning + 2 * Wisdom - 3;
      Practice := Practice - 1;
      WriteLn('CWICZYSZ POWRACANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Returning,
              '% MASZ ', Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ PAROWANIE' then
    if (Wisdom > 15) and (Dexterity > 11) and (Parry < 90) and (Practice > 0) then begin
      Parry := Parry + Wisdom + Dexterity - 14;
      Practice := Practice - 1;
      WriteLn('CWICZYSZ PAROWANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Parry,
              '% MASZ ', Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ POROWNANIE' then
    if (Wisdom > 11) and (Comparing < 90) and (Practice > 0) then begin
      Comparing := Comparing + 3 * Wisdom - 9;
      Practice := Practice - 1;
      WriteLn('CWICZYSZ POROWNYWANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Comparing,
              '% MASZ ', Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ POTRAWKI' then
    if (Wisdom > 18) and (Cooking < 90) and (Practice > 0) then begin
      Cooking := Cooking + Wisdom + 1;
      Practice := Practice - 1;
      WriteLn('CWICZYSZ POTRAWKI - PRAWDOPODOBIENSTWO JEST TERAZ ', Cooking,
              '% MASZ ', Practice, ' PRAKTYK');
    end;
end;

procedure SaveCharacter;
begin
  Command := 'JA';
  SavedFlag := 1;
  WriteLn('ALL RIGHT !!! GRA ZAPISANA! ;)');
  ClrScr;
  Assign(SaveFile, 'pliki.tpu');
  Rewrite(SaveFile);
  WriteLn(SaveFile, Mana * 4);
  WriteLn(SaveFile, Level + $17);
  WriteLn(SaveFile, OldSword);
  WriteLn(SaveFile, Pipe);
  WriteLn(SaveFile, Diploma);
  WriteLn(SaveFile, SmallShield);
  WriteLn(SaveFile, SpikedSuit);
  WriteLn(SaveFile, Experience);
  WriteLn(SaveFile, (Energy + $28) * 4);
  WriteLn(SaveFile, OuterRoom);
  WriteLn(SaveFile, Dexterity + 12);
  WriteLn(SaveFile, Strength - 24);
  WriteLn(SaveFile, Wisdom);
  WriteLn(SaveFile, Practice);
  WriteLn(SaveFile, CheckpointStage);
  WriteLn(SaveFile, Unused52);
  WriteLn(SaveFile, 0);
  WriteLn(SaveFile, Money * Wisdom);
  WriteLn(SaveFile, Loot);
  WriteLn(SaveFile, MaxEnergy);
  WriteLn(SaveFile, ItemLimit);
  WriteLn(SaveFile, Comparing);
  WriteLn(SaveFile, MaxMana);
  WriteLn(SaveFile, MaxStrength);
  WriteLn(SaveFile, MaxDexterity);
  WriteLn(SaveFile, MaxWisdom);
  WriteLn(SaveFile, ItemCount);
  WriteLn(SaveFile, Armor);
  WriteLn(SaveFile, LuckRoll);
  WriteLn(SaveFile, WeaponKind);
  WriteLn(SaveFile, Wearing);
  WriteLn(SaveFile, Overall);
  WriteLn(SaveFile, SavedFlag);
  WriteLn(SaveFile, CageWeakling);
  WriteLn(SaveFile, CageStrong);
  WriteLn(SaveFile, CageAgile);
  WriteLn(SaveFile, CageTough);
  WriteLn(SaveFile, CageHuge);
  WriteLn(SaveFile, ShieldKind);
  WriteLn(SaveFile, ArmorRating);
  WriteLn(SaveFile, Cooking);
  WriteLn(SaveFile, CookingDisplayBug);
  WriteLn(SaveFile, Unused76);
  WriteLn(SaveFile, Heart);
  WriteLn(SaveFile, ManaBottle);
  WriteLn(SaveFile, Cookie);
  WriteLn(SaveFile, DryRation);
  WriteLn(SaveFile, Bread);
  WriteLn(SaveFile, BreadRoll);
  WriteLn(SaveFile, Sausage);
  WriteLn(SaveFile, Bread);
  WriteLn(SaveFile, BreadRoll);
  WriteLn(SaveFile, WornCount);
  WriteLn(SaveFile, Parry);
  WriteLn(SaveFile, Kick);
  WriteLn(SaveFile, KickMinMana);
  WriteLn(SaveFile, KickMaxEnergy);
  WriteLn(SaveFile, Fleeing);
  WriteLn(SaveFile, FleeEnergy);
  WriteLn(SaveFile, Fled);
  WriteLn(SaveFile, InArena);
  WriteLn(SaveFile, Tracksuit);
  WriteLn(SaveFile, Cassette);
  WriteLn(SaveFile, TeleportPill);
  WriteLn(SaveFile, Woodworm);
  WriteLn(SaveFile, Fly);
  WriteLn(SaveFile, Bacterium);
  WriteLn(SaveFile, Quest);
  WriteLn(SaveFile, QuestKills);
  WriteLn(SaveFile, Snail);
  WriteLn(SaveFile, LuckyLeaf);
  WriteLn(SaveFile, Returning);
  WriteLn(SaveFile, Bigos);
  WriteLn(SaveFile, Beer);
  WriteLn(SaveFile, CompareScroll);
  WriteLn(SaveFile, ReturnScroll);
  WriteLn(SaveFile, OldElf);
  WriteLn(SaveFile, DuncanQuest);
  WriteLn(SaveFile, Backpack);
  WriteLn(SaveFile, Duncan);
  WriteLn(SaveFile, WornGarment);
  Close(SaveFile);
end;

procedure Death;

begin
  WriteLn('AJAJAJAJ TWOJA GLOWA NAWALA JAK TESCIOWA!!!');
  WriteLn('NIC NA TO NIE PORADZE , TRZEBA BYLO SIE STARAC');
  WriteLn('NAGLE REFLEKSJA - DO JASNEJ CENZURY JAK SIE WALCZYLO TYM MIECZEM?');
  WriteLn('NIESTETY WRAZ ZE SMIERCIA TRACISZ KUNSZT ADEKWATNIE DO TWOJEGO LEVELKA');
  WriteLn('POJAWISZ SIE W CENTRUM MIASTA ..... POWODZENIA');
  WriteLn('P.S : AHA POTWORY SIE ODREGENEROWALY');
  WriteLn('P.S.2 : Z OSTATNIEJ CHWILI : HE HE HE SPROBOJ ODLOADOWAC POSTAC >:)');
  if Quest = 1 then QuestKills := 50;
  if Quest > 1 then QuestKills := 200;
  Energy := MaxEnergy;
  Experience := Experience - 250 + Random(50) - (5 * Level);
  Room := 20;
  SpawnMonsters;
  Command := 'PAMIETAJ';
  ReadLn;
  SaveCharacter;
end;

procedure BuyItem(cmd: string; var Item: Integer; price: Integer;
                  msg: string; available: Boolean);

begin
  if (Command = cmd) and available and (Money >= price) then begin
    ItemCount := ItemCount + 1;
    Item := Item - 10;
    Money := Money - price;
    WriteLn(msg);
  end;
end;

procedure BakeryShop;

begin
  if Command = 'LISTA' then begin
    WriteLn('NAZWA         CENA');
    WriteLn('PACZEK     :   8  ');
    WriteLn('CIASTKO    :   12 ');
    WriteLn('SUCHA RACJA:   15 ');
    WriteLn('BULKA      :   19 ');
    WriteLn('CHLEB      :   24 ');
    WriteLn('WEKA       :   29 ');
  end;
  StreetFights;
  BuyItem('KUP PACZEK', Doughnut, 8, 'KUPUJESZ PACZEK ZA 8 MONET', True);
  BuyItem('KUP CIASTKO', Cookie, 12, 'KUPUJESZ CIASTKO ZA 12 MONET', True);
  BuyItem('KUP SUCHA RACJA', DryRation, 15, 'KUPUJESZ SUCHA RACJE ZA 15 MONET', True);
  BuyItem('KUP BULKA', BreadRoll, 19, 'KUPUJESZ BULKE ZA 19 MONET', True);
  BuyItem('KUP CHLEB', Bread, 24, 'KUPUJESZ CHLEB ZA 24 MONET', True);
  BuyItem('KUP WEKA', Sausage, 29, 'KUPUJESZ WEKE ZA 29 MONET', True);
end;

procedure RunShopRules(const rules: array of TShopRule);
var
  i: Integer;
begin
  for i := Low(rules) to High(rules) do
    if Command = rules[i].cmd then begin
      if rules[i].allowed then
        rules[i].act;
      Break;
    end;
end;

function Always: Boolean;
begin
  Always := True;
end;

function CanBuyOldSword: Boolean;
begin
  CanBuyOldSword := (OldSword = 0) and (Money >= 70);
end;

procedure BuyOldSword;
begin
  ItemCount := ItemCount + 1;
  OldSword := -10;
  Money := Money - 70;
  WriteLn('KUPUJESZ ZWYKLY MALY !STARY! MIECZYK ZA 70 MONET');
  SwordValue := 500;
end;

function CanSellOldSword: Boolean;
begin
  CanSellOldSword := OldSword = -10;
end;

procedure SellOldSword;
begin
  WriteLn('SPRZEDAWCA MOWI CI : WYPCHAJ SIE Z TYM MIECZEM');
  WriteLn('ALBO DOBRA KUPIE GO OD CIEBIE ZA 30 MONET');
  Money := Money + 30;
  OldSword := 0;
  ItemCount := ItemCount - 1;
end;

function CanBuySmallShield: Boolean;
begin
  CanBuySmallShield := (SmallShield = 0) and (Money >= 15);
end;

procedure BuySmallShield;
begin
  ItemCount := ItemCount + 1;
  SmallShield := -10;
  Money := Money - 15;
  WriteLn('KUPUJESZ !MALA! TARCZA ZA 15 MONET');
end;

procedure SellSmallShield;

begin
  WriteLn('TA TARCZA JEST BAJER,FRAJER KUPIE JA OD CIEBIE ZA 8 MONET');
  Money := Money + 8;
  SmallShield := 0;
  ItemCount := ItemCount - 1;
end;

const
  ArmouryRules: array[1..4] of TShopRule = (
    (cmd:'KUP STARY'; allowed:CanBuyOldSword; act:BuyOldSword),
    (cmd:'SPRZEDAJ STARY'; allowed:CanSellOldSword; act:SellOldSword),
    (cmd:'KUP MALA'; allowed:CanBuySmallShield; act:BuySmallShield),
    (cmd:'SPRZEDAJ MALA'; allowed:Always; act:SellSmallShield)
  );

function CanBuyPipe: Boolean;
begin
  CanBuyPipe := (Pipe = 0) and (Money >= 480);
end;

procedure BuyPipe;
begin
  WriteLn('KUPUJESZ FAJKE ZA 480 MONET');
  Money := Money - 480;
  Pipe := Pipe - 10;
  ItemCount := ItemCount + 1;
  Wisdom := Wisdom + 1;
end;

function CanBuyTracksuit: Boolean;
begin
  CanBuyTracksuit := (Tracksuit = 0) and (Money >= 35);
end;

procedure BuyTracksuit;
begin
  WriteLn('KUPUJESZ !KOMPLET! UBRAN FIRMY "SYF" ZA 35 MONET');
  Money := Money - 35;
  Tracksuit := Tracksuit - 10;
  ItemCount := ItemCount + 1;
end;

function CanSellTracksuit: Boolean;
begin
  CanSellTracksuit := (Tracksuit <= -10) and (WornGarment <> 'SYF');
end;

procedure SellTracksuit;
begin
  WriteLn('SPRZEDAJESZ !KOMPLET! UBRAN FIRMY "SYF" ZA 15 MONET');
  Money := Money + 15;
  Tracksuit := Tracksuit + 10;
  ItemCount := ItemCount - 1;
end;

function CanSellPipe: Boolean;
begin
  CanSellPipe := Pipe = -10;
end;

procedure SellPipe;
begin
  WriteLn('SPRZEDAJESZ FAJKE ZA 120 MONET');
  Money := Money + 120;
  Pipe := Pipe + 10;
  ItemCount := ItemCount - 1;
  Wisdom := Wisdom - 1;
end;

function CanBuyCassette: Boolean;
begin
  CanBuyCassette := Money >= 1999;
end;

procedure BuyCassette;
begin
  WriteLn('KUPUJESZ KASETE LIROYA - L JAK LIROY ZA 1999 MONET');
  Money := Money - 1999;
  Cassette := Cassette - 10;
  Armor := Armor - 8;
  MaxEnergy := MaxEnergy + 5;
  Dexterity := Dexterity + 1;
  ItemCount := ItemCount + 1;
end;

function CanBuySpikedSuit: Boolean;
begin
  CanBuySpikedSuit := Money >= 1000;
end;

procedure BuySpikedSuit;
begin
  WriteLn('KUPUJESZ GARNITUR Z KOLCAMI ZA JEDYNE 1000 $');
  Money := Money - 1000;
  SpikedSuit := SpikedSuit - 10;
  ItemCount := ItemCount + 1;
end;

function CanSellSpikedSuit: Boolean;
begin
  CanSellSpikedSuit := WornGarment <> 'GARNITUR';
end;

procedure SellSpikedSuit;
begin
  WriteLn('SPRZEDAJESZ GARNITUR Z KOLCAMI ZA JEDYNE 500 $');
  Money := Money + 500;
  SpikedSuit := SpikedSuit + 10;
  ItemCount := ItemCount - 1;
end;

function CanSellCassette: Boolean;
begin
  CanSellCassette := Cassette < 0;
end;

procedure SellCassette;
begin
  WriteLn('SPRZEDAJESZ KASETE LIROYA - L JAK LIROY ZA 1000 MONET');
  Money := Money + 1000;
  Cassette := Cassette + 10;
  Armor := Armor + 8;
  MaxEnergy := MaxEnergy - 5;
  Dexterity := Dexterity - 1;
  ItemCount := ItemCount - 1;
end;

const
  GeneralStoreRules: array[1..8] of TShopRule = (
    (cmd:'KUP FAJKA'; allowed:CanBuyPipe; act:BuyPipe),
    (cmd:'KUP KOMPLET'; allowed:CanBuyTracksuit; act:BuyTracksuit),
    (cmd:'SPRZEDAJ KOMPLET'; allowed:CanSellTracksuit; act:SellTracksuit),
    (cmd:'SPRZEDAJ FAJKA'; allowed:CanSellPipe; act:SellPipe),
    (cmd:'KUP KASETA'; allowed:CanBuyCassette; act:BuyCassette),
    (cmd:'KUP GARNITUR'; allowed:CanBuySpikedSuit; act:BuySpikedSuit),
    (cmd:'SPRZEDAJ GARNITUR'; allowed:CanSellSpikedSuit; act:SellSpikedSuit),
    (cmd:'SPRZEDAJ KASETA'; allowed:CanSellCassette; act:SellCassette)
  );

function CanBuyManaBottle: Boolean;
begin
  CanBuyManaBottle := Money >= 15;
end;

procedure BuyManaBottle;
begin
  WriteLn('KUPUJESZ MALA BUTELKA MANY ZA 20 MONET ( AHHHH TA INFLACJA ) ');
  Money := Money - 20;
  ManaBottle := ManaBottle - 10;
  ItemCount := ItemCount + 1;
end;

function CanBuyLuckyLeaf: Boolean;
begin
  CanBuyLuckyLeaf := Money >= 820;
end;

procedure BuyLuckyLeaf;
begin
  WriteLn('KUPUJESZ LISTEK KTORY PRZYNOSCI SZCZESCIE ZA 820 KESZU');
  Money := Money - 830;
  LuckyLeaf := LuckyLeaf - 10;
  ItemCount := ItemCount + 1;
  MaxMana := MaxMana + 40;
end;

function CanSellLuckyLeaf: Boolean;
begin
  CanSellLuckyLeaf := Money >= 820;
end;

procedure SellLuckyLeaf;
begin
  WriteLn('SPRZEDAJESZ LISTEK ZA 400 !!! CIESZ SIE');
  Money := Money + 400;
  LuckyLeaf := LuckyLeaf + 10;
  ItemCount := ItemCount - 1;
  MaxMana := MaxMana - 40;
end;

function CanBuyTeleportPill: Boolean;
begin
  CanBuyTeleportPill := Money >= 235;
end;

procedure BuyTeleportPill;
begin
  WriteLn('KUPUJESZ PIGULKE TRANSPORTUJACA ZA 235 MONET');
  Money := Money - 235;
  TeleportPill := TeleportPill - 10;
  ItemCount := ItemCount + 1;
end;

function CanSellTeleportPill: Boolean;
begin
  CanSellTeleportPill := TeleportPill <= 10;
end;

procedure SellTeleportPill;
begin
  WriteLn('SPRZEDAWCA KUPUJE OD CIEBIE PIGULKE ZA 170 MONET');
  Money := Money + 170;
  TeleportPill := TeleportPill + 10;
  ItemCount := ItemCount - 1;
end;

function CanBuyCompareScroll: Boolean;
begin
  CanBuyCompareScroll := Money > 39;
end;

procedure BuyCompareScroll;
begin
  WriteLn('SPRZEDAWCA SPRZEDAJE CI SCROLL ZA 40 MONET');
  Money := Money - 40;
  CompareScroll := CompareScroll - 10;
  ItemCount := ItemCount + 1;
end;

function CanSellCompareScroll: Boolean;
begin
  CanSellCompareScroll := CompareScroll < 0;
end;

procedure SellCompareScroll;
begin
  WriteLn('SPRZEDAWCA KUPUJE OD CIEBIE SCROLL ZA NEDZNE 18 MONET');
  Money := Money + 18;
  CompareScroll := CompareScroll + 10;
  ItemCount := ItemCount - 1;
end;

const
  MagicShopRules: array[1..7] of TShopRule = (
    (cmd:'KUP MALA BUTELKA MANY'; allowed:CanBuyManaBottle; act:BuyManaBottle),
    (cmd:'KUP LISTEK'; allowed:CanBuyLuckyLeaf; act:BuyLuckyLeaf),
    (cmd:'SPRZEDAJ LISTEK'; allowed:CanSellLuckyLeaf; act:SellLuckyLeaf),
    (cmd:'KUP PIGULKA TRANSPORTUJACA'; allowed:CanBuyTeleportPill; act:BuyTeleportPill),
    (cmd:'SPRZEDAJ PIGULKA TRANSPORTUJACA'; allowed:CanSellTeleportPill; act:SellTeleportPill),
    (cmd:'KUP SCROLL POROWNYWANIE'; allowed:CanBuyCompareScroll; act:BuyCompareScroll),
    (cmd:'SPRZEDAJ SCROLL POROWNYWANIE'; allowed:CanSellCompareScroll; act:SellCompareScroll)
  );

procedure ArmouryShop;

begin
  if Command = 'LISTA' then begin
    WriteLn('NAZWA         CENA');
    if OldSword = 0 then
      WriteLn('!STARY! MIECZ           :   70  10%-50%');
    if SmallShield = 0 then
      WriteLn('!MALA! TARCZA           :   15  10%-50%');
    WriteLn('DLUGI MIECZ GLADIATORA  : 3200  2%');
  end;
  StreetFights;
  RunShopRules(ArmouryRules);
end;

procedure GeneralStoreShop;

begin
  if Command = 'LISTA' then begin
    WriteLn('NAZWA                        CENA');
    if Pipe = 0 then WriteLn('FAJKA                      :  480');
    if Tracksuit = 0 then
      WriteLn('!KOMPLET! UBRAN FIRMY "SYF":   35 ');
    WriteLn('!KASETA! LIROYA            : 1999 4%');
    WriteLn('GARNITUR Z KOLCAMI(3)      : 1000 2,5%');
  end;
  if Command = 'PATRZ POSTER' then
    WriteLn('OKAZJA !!! PRZY ZAKUPIE GARNITURU KOMPLET UBRAN GRATIS !!!(ZART)');
  RunShopRules(GeneralStoreRules);
end;

procedure MagicShop;

begin
  if Command = 'LISTA' then begin
    WriteLn('NAZWA                  CENA');
    WriteLn('MALA BUTELKA MANY       :   20');
    WriteLn('SREDNIA BUTELKA MANY    :   40');
    WriteLn('SPORA BUTELKA MANY      :   80');
    WriteLn('LISTEK SZCZESCIA        :  820 3%');
    WriteLn('PIERSCIONEK ZARECZYNOWY : 1800 N/A');
    WriteLn('PIGULKA TRANSPORTUJACA  :  235 ');
    WriteLn('SCROLL POROWNYWANIE     :   40 ');
  end;
  RunShopRules(MagicShopRules);
end;

procedure ConcertFights;

begin
  if (Command = 'ZABIJ DZIECKO') and (Kid = Room) then begin
    FightWeakish;
    if EnemyEnergy < 1 then Kid := 0;
  end;
  if (Command = 'ZABIJ DZIADEK') and (OldMan = Room) then begin
    FightWeakish;
    if EnemyEnergy < 1 then begin
      OldMan := 0;
      Roll := Random(100);
      if (Roll < 5) and (Pipe = 0) then begin
        WriteLn('WYCIAGASZ FAJKE Z UST DZIADKA ');
        WriteLn('TEN PRZEDMIOT JEST UNIQE 5%');
        Pipe := Pipe - 10;
        Wisdom := Wisdom + 1;
      end;
    end;
  end;
  if (Command = 'ZABIJ WARIAT') and (Lunatic = Room) then begin
    FightMedium;
    if EnemyEnergy < 1 then Lunatic := 0;
  end;
  if (Command = 'ZABIJ SLUCHACZ') and (Listener = Room) then begin
    FightMedium;
    if EnemyEnergy < 1 then Listener := 0;
  end;
  if (Command = 'ZABIJ CZLOWIEK') and (Man = Room) then begin
    FightMedium;
    if EnemyEnergy < 1 then Man := 0;
  end;
  if (Command = 'ZABIJ FAN') and (Fan = Room) then begin
    FightMedium;
    if EnemyEnergy < 1 then Fan := 0;
  end;
  if (Command = 'ZABIJ REPORTER') and (Reporter = Room) then begin
    FightMedium;
    if EnemyEnergy < 1 then Reporter := 0;
  end;
  if (Command = 'ZABIJ POLICJANT') and (Policeman = Room) then begin
    FightHard;
    if EnemyEnergy < 1 then Policeman := 0;
  end;
  if (Command = 'ZABIJ GORYL') and (Gorilla = Room) then begin
    FightHard;
    if EnemyEnergy < 1 then Gorilla := 0;
    SuitGain;
  end;
  if (Command = 'ZABIJ OCHRONIARZ') and
     (Bouncer = Room) then begin
    FightHard;
    if EnemyEnergy < 1 then Bouncer := 0;
    SuitGain;
  end;
end;

procedure Checkpoints;

begin
  if (Experience >= 400) and (CheckpointStage = 0) and (Strength < 20) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Experience >= 180) and (CheckpointStage = 0) and (Strength < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Experience >= 360) and (CheckpointStage = 1) and (Strength < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    CheckpointStage := 2;
    SpawnMonsters;
  end;
  if (Experience >= 540) and (CheckpointStage = 2) and (Strength < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    CheckpointStage := 3;
    SpawnMonsters;
  end;
  if (Experience >= 300) and (CheckpointStage = 0) and (Strength > 7) and (Strength < 13) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Experience >= 500) and (CheckpointStage = 1) and (Strength > 7) and (Strength < 13) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    CheckpointStage := 2;
    SpawnMonsters;
  end;
end;

procedure Room2;

begin
  if Room <> 2 then Exit;
  WriteLn('JESTES W POKOJU GDZIE RAMBO TRENUJE SWYCH UCZNOW ');
  WriteLn('WSZ'#168'DZIE S'#164' PRZEDMIOTY DO R'#224#189'NYCH RODZAJI '#143'WICZE'#227);
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-POK'#224'J CENTRALNY');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'ZACHOD' then Room := 1;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn(#169' NA PLAKACIE PISZE:');
      WriteLn('ABY TRENOWA'#143' U'#189'YJ KOM'#168'DY TRENUJ RAZEM Z ');
      WriteLn('SILA , ZRECZNOSC  LUB MADROSC ');
    end;
    HandleTrain;
  until Room <> 2;
end;

procedure Room3;

begin
  if Room <> 3 then Exit;
  WriteLn('ZSZEDLES NA DOL GDZIE TRENUJE SIE MEDYTUJAC');
  WriteLn('NA SRODKU NA WIELKI MATERAC PRZEZNACZONY DO MEDYTACJI');
  WriteLn('NA SCIANCE JEST PIEKNIUTKI PLAKAT');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then
      WriteLn('DOSTEPNE WYJSCIE-GORA-HALA GLOWNA MUD SZKOLE ');
    if Command = 'WYJSCIE' then Exit;
    if Command = 'GORA' then Room := 1;
    Training;
  until Room <> 3;
end;

procedure Room9;

begin
  WriteLn('JESTES W MALUTKIM POKOJU ALE WIDZISZ WYJSCIA W DWIE STRONY ');
  WriteLn('SKADS SLYSZYSZ DZIWNE NIEPOKOJACE WRZASKI');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('DOL-MUD SZKOLA (2)');
      WriteLn('GORA-KLATKI PELNE GAJDY');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'DOL' then Room := 5;
    if Command = 'GORA' then Room := 11;
  until Room <> 9;
end;

procedure Room12;

begin
  if Room <> 12 then Exit;
  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if CageWeakling = 12 then
    WriteLn('POTWOR - CIENIAS STOI NA 1 NODZE POD SCIANA');
  if CageWeakling = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'ZACHOD' then Room := 11;
    if (Command = 'ZABIJ POTWOR') and (CageWeakling = 12) then begin
      EnemyEnergy := 20; EnemyDexterity := 3; EnemyStrength := 3;
      Fight;
      if Fled = 0 then begin
        CageWeakling := 0;
        Loot := Random(10);
        WriteLn('WYCIAGASZ ', Loot, ' MONET Z CIALA POTWORA');
        Money := Money + Loot;
        if OldSword = 0 then begin
          Roll := Random(20);
          if Roll < 4 then begin
            OldSword := Room;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            SwordValue := 500;
          end;
        end;
        if SmallShield = 0 then begin
          Roll := Random(20);
          if Roll < 4 then begin
            SmallShield := Room;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            ShieldValue := 300;
          end;
        end;
        if Heart = 0 then begin
          Roll := Random(20);
          if Roll < 6 then begin
            Heart := Room;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            HeartValue := 50;
          end;
        end;
      end
      else
        Fled := 0;
    end;
  until Room <> 12;
end;

procedure ConcertRooms;

begin
  if Room = 61 then begin

    WriteLn('KIEDY PODSZEDLES BLIZEJ ZBARANIALES - TO SALA KONCERTOWA !!!');
    WriteLn('WOKOLO TLUMY SLUCHAJA MUZYKI , DZIWNA TO MUZYKA - WLASCIWIE SAME SLOWA');
    WriteLn('!!!!!!!!!NA SCIANIE JEST PLAKAT !!!!!!!!!!!!!!!');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-DOLINA ROZRYWEK');
        WriteLn('POLNOC-TLUM');
        WriteLn('POLODNIE-TLUM');
      end;
      ConcertFights;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'ZACHOD' then Room := 60;
      if Command = 'POLNOC' then Room := 63;
      if Command = 'POLODNIE' then Room := 62;
      if Command = 'WSCHOD' then Room := 64;
      if Command = 'PATRZ PLAKAT' then begin
        WriteLn(' NA PLAKACIE PISZE :');
        WriteLn('20 X 98 r KONCERT LIROYA - ZAPRASZAMY WSZYSTKICH  ');
      end;
    until Room <> 61;
  end;
  if Room = 62 then begin

    WriteLn('NA BRZEGACH TLUM JEST MNIEJSZY , MIMO TO UCZUCIE SCISKU IRYTUJE CIE');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-TLUM');
        WriteLn('WSCHOD-TLUM');
      end;
      ConcertFights;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Room := 61;
      if Command = 'WSCHOD' then Room := 65;
    until Room <> 62;
  end;
  if Room = 63 then begin

    WriteLn('NA BRZEGACH TLUM JEST RZADSZY , BOISZ SIE POMYSLEC CO SIE DZIEJE W SRODKU');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLODNIE-TLUM');
        WriteLn('WSCHOD-TLUM');
        WriteLn('POLNOC-PIWIARNIA');
      end;
      ConcertFights;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLODNIE' then Room := 61;
      if Command = 'WSCHOD' then Room := 66;
      if Command = 'POLNOC' then Room := 67;
    until Room <> 63;
  end;
  if Room = 64 then begin

    WriteLn('JESTES W SRODKU TLUMU A DO TEGO PRZY BALUSTRADKACH-CO ZA TLOK');
    WriteLn('NIE MOZNA ODDYCHAC W TAKIM TLUMIE - LEPIEJ SZYBKO Z TAD IDZ');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-TLUM');
        WriteLn('POLNOC-TLUM');
        WriteLn('POLODNIE-TLUM');
      end;
      ConcertFights;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Room := 66;
      if Command = 'ZACHOD' then Room := 61;
      if Command = 'POLODNIE' then Room := 65;
    until Room <> 64;
  end;
  if Room = 65 then begin

    WriteLn('JESTES Z BOKU ALE PRZY BALUSTRADKACH LUDZIE WPYCHAJA CIE NA TE BALUSTRADKI');
    WriteLn('NIE MOZNA ODDYCHAC W TAKIM TLUMIE - LEPIEJ SZYBKO Z TAD IDZ');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-TLUM');
        WriteLn('POLNOC-TLUM');
      end;
      ConcertFights;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Room := 64;
      if Command = 'ZACHOD' then Room := 62;
    until Room <> 65;
  end;
  if Room = 66 then begin

    WriteLn('JESTES PRZY BALUSTRADKACH-NIE BEDE SIE ROZWODZIL JAK CI JEST CIASNO');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-TLUM');
        WriteLn('POLODNIE-TLUM');
      end;
      ConcertFights;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLODNIE' then Room := 64;
      if Command = 'ZACHOD' then Room := 63;
    until Room <> 66;
  end;
  if Room = 67 then begin

    WriteLn('JESTES W PIWIARNI - WOKOLO CIEBIE UNOSI SIE ZAPACH PIWA , TY NIE PIJASZ PIWA');
    WriteLn('TY PIJASZ JABOLA !!! , NIE REZYGNUJAC ZE SWYCH PRZYZWYCZAJEN ROZGLADASZ SIE:');
    if Minibarman = 67 then
      WriteLn('I WIDZISZ MINI-BARMANA SPIESZACEGO SIE ABY PODAC WSZYSTKIM NAWARZONE PIWO');
    if Fatso = 67 then
      WriteLn('I WIDZISZ GRUBASA KTORY PO WYPICIU 18 PIW WYRAZNIE MA PEWNE OBJAWY SPICIA');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('WSCHOD-WEJSCIE NA ESTRADE');
        WriteLn('POLODNIE-TLUM');
      end;
      ConcertFights;
      if (Command = 'ZABIJ MINI-BARMAN') and (Minibarman = 67) then begin
        WriteLn('---------------  ROUND ONE --------------------');
        WriteLn('----------------  FIGHT -----------------------');
        FightVeryHard;
        if Energy > 0 then begin
          Minibarman := 0;
          Roll := Random(100);
          if Roll < 15 then begin
            WriteLn('Z CIALA MINI-BARMANA WYCIAGASZ NAPOJ BOGOW : PIWO !!!');
            Beer := Beer - 10;
            ItemCount := ItemCount + 1;
          end;
        end;
      end;
      if (Command = 'ZABIJ GRUBAS') and (Fatso = 67) then begin
        FightVeryHard;
        if Energy > 0 then begin
          Fatso := 0;
          if Roll < 15 then begin
            WriteLn('Z CIALA GRUBASA WYCIAGASZ NAPOJ BOGOW : PIWO !!!');
            Beer := Beer - 10;
            ItemCount := ItemCount + 1;
          end;
        end;
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLODNIE' then Room := 63;
      if Command = 'WSCHOD' then Room := 68;
    until Room <> 67;
  end;
  if Room = 68 then begin

    WriteLn('TO JEST WEJSCIE NA SCENE NA KTOREJ TANCZY LIROY - UWAZAJ');
    WriteLn('NA SCIANIE WISI !!!TABLICZKA!!!');
    DescribeCrowd;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-PIWIARNIA');
        WriteLn('WSCHOD-SCENA');
        WriteLn('P.S-HEJ DZIECI JESLI CHCECIE ZOBACZYC TAMTEN SWIAT PODLACZCIE SIE DO 1000 WAT');
      end;
      ConcertFights;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'ZACHOD' then Room := 67;
      if Command = 'WSCHOD' then Room := 69;
      if Command = 'PATRZ TABLICZKA' then
        WriteLn('*** NIE UPOWAZNIONYM WSTEP WZBRONIONY *** ');
    until Room <> 68;
  end;
  if Room = 69 then begin

    WriteLn('JESTES NA SCENIE , WLASCIWIE TO DOPIERO POCZATEK SCENY');
    WriteLn('WLASCIWIE JESTES JESZCZE ZA KULISAMI BO WIDZOWIE CIE NIE WIDZA');
    if DJ = 69 then
      WriteLn('D.J PILNUJE ABY WSZYSTKO PRZEBIEGALO ZGODNIE Z PLAYBACKIEM');
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-WEJSCIE NA SCENE');
        WriteLn('POLODNIE-SCENA');
      end;
      if Command = 'ZABIJ D.J' then begin
        if DJ = 69 then begin
          FightVeryHard;
          if EnemyEnergy < 0 then begin
            DJ := 0;
            Roll := Random(100);
            if Roll < 25 then begin
              WriteLn('WYCIAGASZ SUCHA RACJA Z CIALA D.J-a');
              DryRation := DryRation - 10;
              ItemCount := ItemCount + 1;
            end;
            if Roll < 3 then begin
              WriteLn('WYCIAGASZ KASETE LIROYA Z CIALA D.J-a');
              WriteLn('!!! PRZEDMIOT UNIQE 3% !!!');
              Cassette := Cassette - 10;
              MaxEnergy := MaxEnergy + 5;
              Armor := Armor - 8;
              ItemCount := ItemCount + 1;
              Dexterity := Dexterity + 1;
            end;
          end;
        end;
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'ZACHOD' then Room := 68;
      if Command = 'POLODNIE' then Room := 70;
    until Room <> 69;
  end;
  if Room = 70 then begin

    WriteLn('ALL RIGHT JESTES NA SCENIE !!! NA TWOJ WIDOK OCHRONIAZE COS MAMROCZA');
    WriteLn('TLUMY CIE PRAKTYCZNIE NIE ZAUWAZAJA BO ICH OCZY SKIEROWANE SA NA LIROYA');
    WriteLn('GDY NAGLE WSROD TLUMU ZAUWAZASZ NIEZLA LALE,JEDNAK ONA KOCHA LIROYA :(');
    DescribeStage;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SCENA');
        WriteLn('POLODNIE-SRODEK SCENY');
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Room := 69;
      if Command = 'POLODNIE' then Room := 71;
      StageFights;
    until Room <> 70;
  end;
  if Room = 71 then begin

    WriteLn('LUDZIE SIE NA CIEBIE GAPIA , JESTES NA SRODKU SCENY !!! KTOS CI MOWI:');
    WriteLn('HEY MAN IT,S COOL YEAH! . A TY NA TO: JE JE KUP KUL....');
    DescribeStage;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SCENA');
        WriteLn('POLODNIE-SCENA');
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Room := 70;
      if Command = 'POLODNIE' then Room := 72;
      StageFights;
    until Room <> 71;
  end;
  if Room = 72 then begin

    WriteLn('UFFF PRZEBIEGLES PRZEZ SRODEK SCENY WIEC TREMA CIE JUZ NIE DRECZY');
    WriteLn('DALEJ PISAC NIE MA O CZYM WIEC MOZESZ MI NASKOCZYC ');
    DescribeStage;
    repeat
      Write(Energy, '%.', Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SRODEK SCENY');
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Room := 71;
      StageFights;
    until Room <> 72;
  end;
end;

procedure LoadCharacter;
begin
  ReadLn(Command);
  Assign(SaveFile, 'pliki.tpu');
  Reset(SaveFile);
  Read(SaveFile, Mana);
  Mana := Mana div 4;
  Read(SaveFile, Level);
  Level := Level - $17;
  Read(SaveFile, OldSword);
  Read(SaveFile, Pipe);
  Read(SaveFile, Diploma);
  Read(SaveFile, SmallShield);
  Read(SaveFile, SpikedSuit);
  Read(SaveFile, Experience);
  Read(SaveFile, Energy);
  Energy := Energy div 4;
  Energy := Energy - $28;
  Read(SaveFile, OuterRoom);
  Read(SaveFile, Dexterity);
  Dexterity := Dexterity - 12;
  Read(SaveFile, Strength);
  Strength := Strength + 24;
  Read(SaveFile, Wisdom);
  Read(SaveFile, Practice);
  Read(SaveFile, CheckpointStage);
  Read(SaveFile, Unused52);
  Read(SaveFile, LoadDummy);
  Read(SaveFile, Money);
  Money := Money div Wisdom;
  Read(SaveFile, Loot);
  Read(SaveFile, MaxEnergy);
  Read(SaveFile, ItemLimit);
  Read(SaveFile, Comparing);
  Read(SaveFile, MaxMana);
  Read(SaveFile, MaxStrength);
  Read(SaveFile, MaxDexterity);
  Read(SaveFile, MaxWisdom);
  Read(SaveFile, ItemCount);
  Read(SaveFile, Armor);
  Read(SaveFile, LuckRoll);
  Read(SaveFile, WeaponKind);
  Read(SaveFile, Wearing);
  Read(SaveFile, Overall);
  Read(SaveFile, SavedFlag);
  Read(SaveFile, CageWeakling);
  Read(SaveFile, CageStrong);
  Read(SaveFile, CageAgile);
  Read(SaveFile, CageTough);
  Read(SaveFile, CageHuge);
  Read(SaveFile, ShieldKind);
  Read(SaveFile, ArmorRating);
  Read(SaveFile, Cooking);
  Read(SaveFile, CookingDisplayBug);
  Read(SaveFile, Unused76);
  Read(SaveFile, Heart);
  Read(SaveFile, ManaBottle);
  Read(SaveFile, Cookie);
  Read(SaveFile, DryRation);
  Read(SaveFile, Bread);
  Read(SaveFile, BreadRoll);
  Read(SaveFile, Sausage);
  Read(SaveFile, Bread);
  Read(SaveFile, BreadRoll);
  Read(SaveFile, WornCount);
  Read(SaveFile, Parry);
  Read(SaveFile, Kick);
  Read(SaveFile, KickMinMana);
  Read(SaveFile, KickMaxEnergy);
  Read(SaveFile, Fleeing);
  Read(SaveFile, FleeEnergy);
  Read(SaveFile, Fled);
  Read(SaveFile, InArena);
  Read(SaveFile, Tracksuit);
  Read(SaveFile, Cassette);
  Read(SaveFile, TeleportPill);
  Read(SaveFile, Woodworm);
  Read(SaveFile, Fly);
  Read(SaveFile, Bacterium);
  Read(SaveFile, Quest);
  Read(SaveFile, QuestKills);
  Read(SaveFile, Snail);
  Read(SaveFile, LuckyLeaf);
  Read(SaveFile, Returning);
  Read(SaveFile, Bigos);
  Read(SaveFile, Beer);
  Read(SaveFile, CompareScroll);
  Read(SaveFile, ReturnScroll);
  Read(SaveFile, OldElf);
  Read(SaveFile, DuncanQuest);
  Read(SaveFile, Backpack);
  ReadLn(SaveFile, Duncan);
  Read(SaveFile, WornGarment);
  Close(SaveFile);
  WriteLn('suckemall:', WornGarment);
end;

procedure CheckLevelUp;

var
  threshold: Integer;
begin
  if Level < 1 then Exit;
  threshold := LevelThreshold(Level);
  if Experience < threshold then Exit;

  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');

  if Level = 1 then Experience := Experience - 725
  else if Level = 2 then Experience := Experience - 730
  else if Level = 3 then Experience := Experience - 735
  else if Level <= 8 then Experience := (Experience - Lvl4_Base) - Level
  else Experience := (Experience - (Level * 2)) - Lvl9_Base;
  if Wisdom < 11 then Practice := Practice + 3;
  if (Wisdom > 10) and (Wisdom < 16) then Practice := Practice + 4;
  if (Wisdom > 15) and (Wisdom < 23) then Practice := Practice + 5;
  if Wisdom > 22 then Practice := Practice + 6;
  WriteLn('<<<<<<<<<<<<ZYSKALES ', Practice, ' PRAKTYK >>>>>>>>>>>>>>>');
  if Dexterity > 12 then MaxEnergy := MaxEnergy + 11
  else MaxEnergy := MaxEnergy + 10;
  if Dexterity > 16 then MaxEnergy := MaxEnergy + 1;
  if Dexterity > 21 then MaxEnergy := MaxEnergy + 1;
  if (Dexterity > 26) and (Strength > 20) then MaxEnergy := MaxEnergy + 1;
  WriteLn('<<<<<<<<<<<<ZYSKALES ', MaxEnergy, ' MAXIMUM ENERGI >>>>>>>>>>>>>');
  MaxMana := MaxMana + Wisdom + 2;
   WriteLn('<<<<<<<<<<<<<<ZYSKALES ', Wisdom + 2, 'MANY >>>>>>>>>>>>>>>>>');
  Level := Level + 1;
  CheckpointStage := 0;
  if Level = 12 then begin
    WriteLn('HURRRA TO JUZ DWUNASTY POZIOM , CZAS PODWYZSZYC MAXYMALNE PARAMETRY');
    if Strength >= MaxStrength then MaxStrength := MaxStrength + 3;
    if Dexterity >= MaxDexterity then MaxDexterity := MaxDexterity + 3;
    if Wisdom >= MaxWisdom then MaxWisdom := MaxWisdom + 3;
    if Strength < MaxStrength then MaxStrength := MaxStrength + 2;
    if Dexterity < MaxDexterity then MaxDexterity := MaxDexterity + 2;
    if Wisdom < MaxWisdom then MaxWisdom := MaxWisdom + 2;
    if (MaxWisdom > MaxStrength) and (MaxWisdom > MaxDexterity) then
      MaxWisdom := MaxWisdom + 3;
    if (MaxStrength > MaxWisdom) and (MaxStrength > MaxDexterity) then
      MaxStrength := MaxStrength + 3;
    if (MaxDexterity > MaxStrength) and (MaxDexterity > MaxWisdom) then
      MaxDexterity := MaxDexterity + 3;
    if (MaxDexterity = MaxStrength) and (MaxStrength = MaxWisdom) then begin
      MaxDexterity := MaxDexterity + 1;
      MaxWisdom := MaxWisdom + 1;
      MaxStrength := MaxStrength + 1;
    end;
    if (MaxDexterity > MaxWisdom) and (MaxDexterity = MaxStrength) then begin
      MaxStrength := MaxStrength + 2;
      MaxDexterity := MaxDexterity + 1;
    end;
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', MaxStrength,
          ' MAXYMALNIE SILY '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', MaxDexterity,
          ' MAXYMALNIE ZRECZNOSCI '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', MaxWisdom,
          ' MAXYMALNIE MADROSCI '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
  end;
end;

procedure CmdScan;
begin
  WriteLn('FUNKCJA BEDZIE DOSTEPNA ZA DWA LATA , I TAK ZGINIESZ , I TAK :) ');
end;

procedure CmdClearScreen;
begin
  ClrScr;
end;

procedure CmdGiveEnergy;
begin
  Energy := Energy + 200;
end;

procedure CmdTakeMoney;
begin
  Money := Money - 100;
end;

procedure CmdResetArmor;
begin
  WornCount := 0;
  Armor := 0;
  LuckRoll := 0;
end;

procedure CmdStrip;
begin
  Wearing := 0;
  WeaponKind := 0;
  ShieldKind := 0;
  WornGarment := '';
  OldSword := -10;
  SmallShield := -10;
  Strength := Strength - 1;
end;

procedure CmdNoExit;
begin
  WriteLn('NAPISZ UNMODE ');
end;

procedure CmdQuitGame;
begin
  ExitRequested := True;
end;

procedure CmdJustSaved;
begin
  if SavedFlag = 1 then begin
    Command := 'ZDOLNOSCI';
    SavedFlag := 0;
    WriteLn(OuterRoom, ' MIECHO!');
  end;
end;

procedure CmdDrinkBeer;
begin
  if Beer <= -10 then begin
    Beer := Beer + 10;
    WriteLn('GDY POCZULES AMBROZJE W USTACH ODZYSKALES 10 MANY ZAS GDY GO WYPILES 10% E.');
    ItemCount := ItemCount - 1;
    Energy := Energy + 10;
    Mana := Mana + 10;
  end;
end;

procedure CmdWieldOldSword;
begin
  if (OldSword = -10) and (WeaponKind = 0) then begin
    OldSword := -100;
    WeaponKind := 1;
    WriteLn('UZYWASZ STAREGO ZARDZEWIALEGO MIECZA JAKO BRONI');
    Strength := Strength + 1;
    LuckRoll := LuckRoll + 3;
  end;
end;

procedure CmdUnwieldOldSword;
begin
  if (OldSword = -100) and (WeaponKind = 1) then begin
    OldSword := -10;
    WeaponKind := 0;
    WriteLn('CHOWASZ STARY ZARDZEWIALY MIECZ I NIE UZYWASZ GO JAKO BRONI');
    Strength := Strength - 1;
    LuckRoll := LuckRoll - 3;
  end;
end;

procedure CmdWieldSmallShield;
begin
  if (ShieldKind = 0) and (SmallShield = -10) then begin
    ShieldKind := 1;
    Armor := Armor + 15;
    WornCount := WornCount + 1;
    SmallShield := -100;
    WriteLn('UZYWASZ MALEJ TARCZY JAKO TARCZY');
  end;
end;

procedure CmdUnwieldSmallShield;
begin
  if (ShieldKind = 1) and (SmallShield = -100) then begin
    ShieldKind := 0;
    Armor := Armor - 15;
    WornCount := WornCount - 1;
    SmallShield := -10;
    WriteLn('JUZ NIE UZYWASZ MALEJ TARCZY JAKO TARCZY');
  end;
end;

procedure CmdSetFleeEnergy;
begin
  if Fleeing > 0 then begin
    WriteLn('PONIZEJ ILU ENERGII CHCESZ UCIEKAC?');
    ReadLn(FleeEnergy);
  end;
end;

procedure CmdSleep;
begin
  SleepHours := 0;
  repeat
    SleepHours := SleepHours + 1;
    Delay(5000);
    WriteLn('SPISZ JUZ ', SleepHours, ' GODZIN');
    Experience := Experience - 20;
    Energy := Energy + 10;
  until KeyPressed;
  WriteLn('PO OBUDZENIU STWIERDZILES ZE ZYSKALES ', SleepHours * 10,
      ' ENERGI I STRACILES ', (20 * SleepHours) - Random(2 * SleepHours), ' KUNSZTU');
  Experience := Experience + Random(2 * SleepHours);
  if SleepHours > 4 then begin
    WriteLn('DLUGI SEN DODATKOWO POZWOLIL CI ODPOCZAC : ZYSKALES ', Wisdom, 'ENERGI');
    Energy := Energy + Wisdom;
  end;
  if SleepHours > 8 then begin
    WriteLn('PELNOWARTOSCIOWY SEN SPOWODOWAL SUPER ZYSK : ', Wisdom * 2, 'ENERGI');
    Energy := Energy + (Wisdom * 2);
  end;
  if Energy > MaxEnergy then Energy := MaxEnergy;
end;

procedure CmdCompare;
begin
  if Comparing > 0 then begin
    Roll := Random(100);
    if Comparing > Roll then begin
      CompareFoe;
      Mana := Mana - 10;
    end
  else begin
      WriteLn('POPELNILES PEWNE BLEDY I NIE UDALO SIE WYKONAC CZARU');
      Mana := Mana - 5;
    end;
  end;
end;

procedure CmdGiveMoney;
begin
  Money := Money + 5000;
end;

procedure CmdRefuseFoodDrop;
begin
  if (Command = 'ODRZUC PACZEK') or (Command = 'ODRZUC CIASTKO') or
   (Command = 'ODRZUC SUCHA RACJA') or (Command = 'ODRZUC BULKA') or
   (Command = 'ODRZUC CHLEB') or (Command = 'ODRZUC WEKA') or
   (Command = 'ODRZUC SERCE') or (Command = 'ODRZUC BIGOS') then
    WriteLn('JAK SMIESZ WYRZUCAC JEDZENIE!!! WSTYD MI ZA CIEBIE !!! NIE POZWOLE !!!');
end;

procedure CmdOpenPortal;
begin
  if ((Command = 'POWROT') and (Returning > 0)) or
   ((Command = 'UZYJ SCROLL POWROT') and (ReturnScroll < 0)) then begin
    Roll := Random(100);
    if Command = 'UZYJ SCROLL POWROT' then begin
      Roll := Random(1);
      ReturnScroll := ReturnScroll + 10;
      ItemCount := ItemCount - 1;
    end;
    if Roll <= Returning then begin
      WriteLn('OTWIERASZ MAGICZNY PORTAL KTORY PRZENOSI CIE DO MIASTA');
      Mana := Mana - 15;
      OuterRoom := 20;
    end;
    if (Roll > Returning) and (Returning + 30 > Roll) then begin
      WriteLn('NIE UDAJE CI SIE OTWORZYC MAGICZNEGO PORTALU');
      Mana := Mana - 5;
    end;
    if Returning + 29 < Roll then begin
      WriteLn('OTWIERASZ MAGICZNY PORTAL KTORY JEDNAK PRZENOSI CIE DO INNEGO MIEJSCA');
      Mana := Mana - 10;
      OuterRoom := Random(100) + 1;
    end;
  end;
end;

procedure CmdUseCompareScroll;
begin
  if CompareScroll < 0 then begin
    CompareFoe;
    Mana := Mana - 10;
    CompareScroll := CompareScroll + 10;
    ItemCount := ItemCount - 1;
  end;
end;

procedure CmdSetKickThresholds;
begin
  if Kick > 0 then begin
    WriteLn('ZADAM CI PARE PYTAN:');
    WriteLn('1)PONIZEJ JAKIEJ ENERGI CHCESZ ZACZAC KOPAC');
    ReadLn(KickMaxEnergy);
    WriteLn('2)DO JAKIECH ILOSCI MANA CHCESZ KOPAC');
    ReadLn(KickMinMana);
  end;
end;

procedure CmdSpeede;
begin
  Permit := Permit - 10;
end;

procedure CmdShowSkills;
begin
  if (Wisdom > 10) and (Strength > 11) then WriteLn('KOPANIE       - ', Kick, '%');
  if (Wisdom > 10) and (Dexterity > 10) then WriteLn('UCIEKANIE     - ', Fleeing, '%');
  if (Wisdom > 15) and (Dexterity > 11) then WriteLn('PAROWANIE     - ', Parry, '%');
  if Wisdom > 11 then WriteLn('POROWNYWANIE  - ', Comparing, '%');
  if Wisdom > 18 then WriteLn('POTRAWKI      - ', CookingDisplayBug, '%');
  if Wisdom > 19 then WriteLn('POWROT        - ', Returning, '%');
end;

procedure CmdLeaveTrance;
begin
  Room := OuterRoom;
end;

const
  GroundCommands: array[1..32] of TCommandEntry = (
    (cmd:'PAMIETAJ'; run:SaveCharacter),
    (cmd:'SCAN'; run:CmdScan),
    (cmd:'CZYSC EKRAN'; run:CmdClearScreen),
    (cmd:'DAWAJ EN'; run:CmdGiveEnergy),
    (cmd:'ZABIERAJ KASE'; run:CmdTakeMoney),
    (cmd:'USTAW SZ'; run:CmdResetArmor),
    (cmd:'ZDEJMUJ'; run:CmdStrip),
    (cmd:'EXIT'; run:CmdNoExit),
    (cmd:'WYJSCIE'; run:CmdQuitGame),
    (cmd:'JA'; run:ShowCharacter),

    (cmd:''; run:TakeDrop),
    (cmd:''; run:CmdJustSaved),
    (cmd:'UZYJ PIWO'; run:CmdDrinkBeer),
    (cmd:'UZYJ STARY'; run:CmdWieldOldSword),
    (cmd:'ODLOZ STARY'; run:CmdUnwieldOldSword),
    (cmd:'UZYJ MALA'; run:CmdWieldSmallShield),
    (cmd:'ODLOZ MALA'; run:CmdUnwieldSmallShield),

    (cmd:''; run:UseItems),
    (cmd:'ZWIEJ'; run:CmdSetFleeEnergy),
    (cmd:'SPIJ'; run:CmdSleep),
    (cmd:'POROWNAJ'; run:CmdCompare),
    (cmd:'DAWAJ KASE'; run:CmdGiveMoney),
    (cmd:''; run:CmdRefuseFoodDrop),
    (cmd:''; run:CmdOpenPortal),
    (cmd:'UZYJ SCROLL POROWNYWANIE'; run:CmdUseCompareScroll),
    (cmd:'KOP'; run:CmdSetKickThresholds),
    (cmd:'JESTEM SPEEDE'; run:CmdSpeede),
    (cmd:'ZDOLNOSCI'; run:CmdShowSkills),

    (cmd:''; run:DisplayPrefs),
    (cmd:'WLACZ POSTAC'; run:LoadCharacter),
    (cmd:'UNMODE'; run:CmdLeaveTrance),
    (cmd:'UM'; run:CmdLeaveTrance)
  );

procedure Room14;

begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if CageAgile = 14 then
    WriteLn('ZRECZNY POTWOR SMIGA MIEDZY SCIANAMI');
  if CageAgile = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SMIERDZA DOSYC MOCNO');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Room := 11;
    if (Command = 'ZABIJ POTWOR') and (CageAgile = 14) then begin
      EnemyEnergy := 20; EnemyDexterity := 30; EnemyStrength := 3;
      Fight;
      if Fled = 0 then begin
        CageAgile := 0;
        Loot := Random(15);
        WriteLn('WYCIAGASZ ', Loot, ' MONET Z CIALA POTWORA');
        Money := Money + Loot;
        if OldSword = 0 then begin
          Roll := Random(20);
          if Roll < 7 then begin
            OldSword := Room;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            SwordValue := 500;
          end;
        end;
        if SmallShield = 0 then begin
          Roll := Random(20);
          if Roll < 7 then begin
            SmallShield := Room;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            ShieldValue := 300;
          end;
        end;
        if Heart = 0 then begin
          Roll := Random(20);
          if Roll < 6 then begin
            Heart := Room;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            HeartValue := 50;
          end;
        end;
      end else
        Fled := 0;
    end;
  until Room <> 14;

end;
procedure Room15;

begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if CageTough = 15 then
    WriteLn('POWOLNY ACZ ODPORNY NA BOL POTWOR SPOKOJNIE LEZY POD SCIANA');
  if CageTough = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Room := 11;
    if (Command = 'ZABIJ POTWOR') and (CageTough = 15) then begin
      EnemyEnergy := 40; EnemyDexterity := 3; EnemyStrength := 3;
      Fight;
      if Fled = 0 then begin
        CageTough := 0;
        Loot := Random(15);
        WriteLn('WYCIAGASZ ', Loot, ' MONET Z CIALA POTWORA');
        Money := Money + Loot;
        if OldSword = 0 then begin
          Roll := Random(20);
          if Roll < 7 then begin
            OldSword := Room;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            SwordValue := 500;
          end;
        end;
        if SmallShield = 0 then begin
          Roll := Random(20);
          if Roll < 7 then begin
            SmallShield := Room;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            ShieldValue := 300;
          end;
        end;
        if Heart = 0 then begin
          Roll := Random(20);
          if Roll < 6 then begin
            Heart := Room;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            HeartValue := 50;
          end;
        end;
      end else
        Fled := 0;
    end;
  until Room <> 15;

end;
procedure Room16;

label
  L1027_Flee, L1028_AfterFlee;
begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if CageHuge = 16 then
    WriteLn('OGROMNY POTWOR WIDZAC MIESO RZUCA SIE NA CIEBIE');
  if CageHuge = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    if CageHuge = 16 then begin
      EnemyEnergy := 40; EnemyDexterity := 11; EnemyStrength := 10;
      Fight;
      if Fled <> 0 then goto L1027_Flee;
      CageHuge := 0;
      Loot := Random(30);
      WriteLn('WYCIAGASZ ', Loot, ' MONET Z CIALA POTWORA');
      Money := Money + Loot;
      if OldSword = 0 then begin
        Roll := Random(20);
        if Roll < 10 then begin
          OldSword := Room;
          WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
          SwordValue := 500;
        end;
      end;
      if SmallShield = 0 then begin
        Roll := Random(20);
        if Roll < 10 then begin
          SmallShield := Room;
          WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
          ShieldValue := 300;
        end;
      end;
      if Heart = 0 then begin
        Roll := Random(20);
        if Roll < 6 then begin
          Heart := Room;
          WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
          HeartValue := 50;
        end;
      end;
      goto L1028_AfterFlee;
      L1027_Flee:
      Fled := 0;
      Room := 11;
      L1028_AfterFlee:
    end;
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('DOL-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'DOL' then Room := 11;
  until Room <> 16;

end;
procedure Room17;

begin

  WriteLn('JESTES W POKOJU W KTORYM !JEST! !PLAKAT (SMIERDZI TU) ');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('GORA-KLATKI PELNE GAJDY');
      WriteLn('DOL-TELEPORT!!!');
    end;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE PISZE:');
      WriteLn('SORRY ZE NIE UMYLEM POKOJU ALE NIE MAM NA TO CZASU');
      WriteLn('JEZELI BYLES AKTYWNY TO POWINIENES LICZYC NA NAGRODE');
      WriteLn('SPRAWDZ CZY LEZY TU COS , POTEM MOZESZ ZEJZD DO TELEPORTU ');
      if (CageWeakling = 0) and (CageAgile = 0) and
      (CageStrong = 0) and (CageTough = 0) and
      (CageHuge = 0) and (Diploma = 0) then
        Diploma := 17;
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'GORA' then Room := 11;
    if Command = 'DOL' then Room := 18;
  until Room <> 17;

end;
procedure Room18;

begin

  WriteLn('BBBBBBBBZBZBZBZBZZZZZZZzzzzzzzzzbbzbBbzbzbzBZZZ');
  WriteLn('===-------......_________.....----------....._______....-------======');
  WriteLn('T***E***L***E***P***O***R***T***O***W***A***L***E***S***** *****S***I***E!');
  WriteLn('==========================================================================');
  Room := 1;

end;
procedure Room20;

begin

  WriteLn('JESTES W CENTRUM MIASTA : NA SCIANIE JEST PLAKAT (DUZY RUCH) ');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'PATRZ PLAKAT' then
      WriteLn('TO JEST MIASTO : RADZ SOBIE SAM!');
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-POKOJ CENTRALNY');
      WriteLn('POLNOC-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-UL.CIEMNA');
      WriteLn('ZACHOD-UL.DLUGA');
    end;
    if Command = 'WYJSC0IE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Room := 1;
    if Command = 'POLNOC' then Room := 21;
    if Command = 'ZACHOD' then Room := 30;
    if Command = 'WSCHOD' then Room := 75;
    StreetFights;
  until Room <> 20;

end;
procedure Room76;

begin

  WriteLn('JESTES W BARZE POD DWOMA PEDALAMI CHCAC ROZWIKLAC TA DZIWNA NAZWE');
  WriteLn('PYTASZ SIE BARMANA : PRZEPRASZAM DLACZEGO TEN BAR NAZYWA SIE  ');
  WriteLn('"POD DWOMA PEDALAMI"? A ON NA TO -WLASCIWIE TO NIE WIEM');
  WriteLn(' ALE SPYTAM SIE ZONY:MAREEEK!!.......(teraz ju'#190' wiesz) ');
  if Maciek = 76 then
    WriteLn('MACIEK , TUTEJSZY BARMAN SERWUJE TUTAJ DRINKI (MOZLIWA LISTA!');
  if Pedal = 76 then
    WriteLn(' PEDAL CZEKA TU NA TEGO JEDYNEGO');
  if Couple = 76 then
    WriteLn('PARA-JACEK I JUREK OBMYSLAJA MIESIAC MIODOWY');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA CIEMNA');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Room := 75;
    if Command = 'LISTA' then begin
      WriteLn('DRINK        CENA');
      WriteLn('ORAL DRINK     130');
      WriteLn('ONANISOFT      180');
      WriteLn('PEDAL&SPRZEGLO 220');
    end;
    if Command = 'ZABIJ PEDAL' then begin
      FightEasy;
      Pedal := 0;
      PillGain;
    end;
    if Command = 'ZABIJ PARA' then begin
      FightVeryHard;
      Couple := 0;
      FightVeryHard;
    end;
    if Command = 'ZABIJ MACIEK' then begin
      FightEasy;
      Maciek := 0;
    end;
    if Command = 'MAM 18 LAT' then begin
      WriteLn('I CO Z TEGO ??? A JA MAM 100 LAT I ZYJE !!!');
    end;
  until Room <> 76;

end;
procedure Room77;

begin

  WriteLn('ZNALAZLES SIE WSROD BLUSZCZU , WOKOLO CIEBIE TAJEMNICZE ROSLINY ');
  WriteLn('MUSISZ BARDZO UWAZAC,TU NAWET STOKROTKA MOZE BYC ZABOJCZA');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-UL.CIEMNA');
      WriteLn('WSCHOD-BLUSZCZ');
      WriteLn('ZACHOD-BLUSZCZ');
      WriteLn('POLODNIE-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Room := 75;
    if Command = 'WSCHOD' then Room := 78;
    if Command = 'ZACHOD' then Room := 79;
    if Command = 'POLODNIE' then Room := 80;
  until Room <> 77;

end;
procedure Room78;

begin

  WriteLn('WSZEDLES W GASZCZ ROSLIN I KWIATOW');
  WriteLn('NIE MA CO OPISYWAC WYSTARCZY POWIEDZIEC ZE JEST TU BYDLO CHWASTOW');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Room := 77;
  until Room <> 78;

end;
procedure Room79;

begin

  WriteLn('SLYSZYSZ POKRZYWE KTORA POZERA BEZBRONNY SZCZAW .... OHYDA');
  WriteLn('WOKOLO TAK CIEMNO,ZE GDYBY NIE JA JUZ DAWNO BYS ZGINA');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 77;
  until Room <> 79;

end;
procedure Room80;

begin

  WriteLn('CHOC TO MALO PRAWDOPODOBNE TUTAJ JEST JESZCZE CIEMNIEJ');
  WriteLn('PONADTO W NIEKTORYCH MIEJSCACH ZNAJDUJE SIE BLOTO I INNE BZDURY');
  WriteLn('NA SRODKU ZNAJDUJE SIE STUDNIA I MALO CZYTELNY NAPIS');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-BLUSZCZ');
      WriteLn('WSCHOD-BLUSZCZ');
      WriteLn('ZACHOD-BLUSZCZ');
      WriteLn('POLODNIE-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Room := 77;
    if Command = 'ZACHOD' then Room := 81;
    if Command = 'WSCHOD' then Room := 82;
    if Command = 'POLODNIE' then Room := 83;
    if Command = 'PATRZ NAPIS' then
      WriteLn('PISZE TUTAJ : '#2'A'#2'RZY'#2' D'#2' S'#2'UDN'#2' (MOWILEM ZE MALO CZYTELNY)');
    if Command = 'PATRZ STUDNIA' then begin
      Roll := Random(3) + 1;
      WriteLn('ZAGLADASZ DO SRODKA STUDNI,COS TAM JEST,WYCI'#164'GASZ ', Roll,
          ' MONET!');
      Money := Money + Roll;
      Roll := Random(100);
      if Roll < 10 then begin
        WriteLn('JAK SMIESZ PODBIERAC MOJE SWIETOSCI , GIN CHAMIE , GIN');
        Energy := Energy - 40;
        WriteLn('ODDAWAJ MOJE PIENIADZE !!!');
        Money := Money - 100;
        if Money < 0 then Money := 0;
      end;
    end;
  until Room <> 80;

end;
procedure Room81;

begin

  WriteLn('PRZEDZIERASZ SIE PRZEZ CALY TEN SYF I NAJCHETNIEJ BYS');
  WriteLn('TERAZ PORZYCZY'#157' KOSIARKI OD SWEGO KOLEGI TOMKA');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 80;
  until Room <> 81;

end;
procedure Room82;

begin

  WriteLn('W TEJ KOMNACIE JEST ZNACZNIE JASNIEJ A TO DLATEGO ZE NAPROMIENIOWANE');
  WriteLn('I ZMUTOWANE ROSLINY ID'#164' W TWYM KIERUNKU');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Room := 80;
  until Room <> 82;

end;
procedure Room84;

begin

  WriteLn('TO CIEKAWE ZE WCZESNIEJ NIE ZAUWAZYLES TYCH KRARZAKOW PRZEDZIERASZ');
  WriteLn('SIE PRZEZ ICH GASZCZ WYGLADA TO NA NIEZBYT MILA KRAINE');
  WriteLn('DALES NA ZACHOD WIDZISZ JAKIES PODEJRZANE BUDOWLE , A NA POLODNIE BRRRR.');
  WriteLn('NA POLODNIE JAK GDYBY KTOS SIE OBZERAL , ALE BARDZO GLOSNO I NIEBEZPIECZNIE');
  DescribePlants;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
      WriteLn('ZACHOD-BUDYNEK');
      WriteLn('POLODNIE-WEJSCIE DO GROTY ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 83;
    if Command = 'ZACHOD' then Room := 85;
    if Command = 'POLODNIE' then Room := 87;
  until Room <> 84;

end;
procedure Room87;

begin

  WriteLn('MLASK , MLASK KTOS RZECZYWISCIE SIE OBZERA CZY JESTES 100% PEWNY IZ');
  WriteLn('CHCESZ SIE ZAGLEBIC W TE NIEBADANE CZELUSCIE PIEKIELNE?, MOZE LEPIEJ WROC');
  Roll := Random(100);
  if Roll < 40 then begin
    WriteLn('NO PIEKNIE WLAZLES W JAKIES TOKSYCZNE SUBSTANCJE ,AAA, TO PARZY TRACISZ ',
       25 - Dexterity, '%');
    Energy := Energy - 25 + Dexterity;
  end;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-GROTA');
      WriteLn('POLNOC-PODEJRZANE KRZAKI');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Room := 84;
    if Command = 'POLODNIE' then Room := 88;
  until Room <> 87;

end;
procedure Room88;

begin

  WriteLn('MOJ BOZE , COZ TO JEST , NA TRONIE SIEDZI 20 RAZY WIEKSZA OD CIEBIE POKRZYWA');
  WriteLn('WOKOL NIEJ UWIJAJA SIE PRACOWITE MLECZE DOSTARCZAJAC JEJ SWIEZEGO ');
  WriteLn('MIESA LUDZKIEGO !!! , UWIELBIA ONA MOZGI KTORE WYSSYSA JAK PYSZNY PUDDING ');
  WriteLn('W PEWNYM MOMECIE ZAUWAZA CIEBIE - WITAJ WEDROWCZE PODOBAM CI SIE? - (TAK,NIE)');
  Write('TAK lub NIE >');
  ReadLn(Command);
  WriteLn('NO TO GIN!!!');
  repeat
    EnemyEnergy := 200; EnemyDexterity := 15; EnemyStrength := 18;
    FireballCharges := 5; PoisonCharges := 1;
    Fight;
    if EnemyEnergy < 0 then begin
      LeafGain;
      PillGain;
      ScrollGain;
      if DuncanQuest <> 0 then DuncanQuest := DuncanQuest - 50;
    end;
    if Energy > 0 then begin
      WriteLn('UFFF,TO BYLA PRZYGODA,WOKOL GROMADZILY SIE SETKI MLECZOW - NIE MIALBYS SZANS');
      Room := 87;
    end;
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-WEJSCIE DO GROTY');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Room := 87;
  until Room <> 88;

end;
procedure Room85;

begin

  WriteLn('DO DOBRA WYGLADA TO NA JAKIS DOM , WEJDZMY DO SRODKA ');
  WriteLn('GOD DAMN , A NIECH MNIE MA MATEUSZ W SWOJEJ OPIECE , TE DRZWI ZYJA !!!');
  if Door <> 0 then
    WriteLn('DRZWI WYCIAGAJA SWE DREWNIANE RECE W TWYM KIERUNKU MOWIAC : NIE WPUSZCZE');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'ZABIJ DRZWI' then begin
      if Door <> 0 then begin
        FightNotEasy;
        if Energy > 0 then Door := 0;
      end;
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-PODEJRZANE KRZAKI');
      if Door <> 0 then
        WriteLn('ZACHOD-GDYBY NIE TE CHOLERNE DRZWI ... ');
      if Door = 0 then
        WriteLn('ZACHOD-WEJSCIE DO DOMKU');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 84;
    if (Command = 'ZACHOD') and (Door = 0) then Room := 86;
    if (Command = 'ZACHOD') and (Door <> 0) then
      WriteLn('SPROBOJ OMINAC TE MEGA-PRZYPAKOWANE DRZWI KTORYCH BY SIE HE-MAN NIE POWSTYDZIL');
  until Room <> 85;

end;
procedure Room86;

begin

  WriteLn('DOBRA JESTES W SRODKU BRAK OSWIETLENIA CIE NIE WZRUSZA , DOOKOLA ROZNE GARNKI');
  if OldElf <> 0 then
    WriteLn('W ROGU ZAUWAZASZ MALEGO WYGLODZONEGO ELFIEGO STARUCHA');
  if OldElf = 0 then
    WriteLn('WIDZISZ TU TYLKO PLASZCZ PO STARUCHU KTORY ZNIKNA W PRZESTRZEN');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'DAWAJ KUNSZT' then Experience := Experience + 500;
    if Command = 'PATRZ GARNKI' then
      WriteLn('Z JEZOREM NA WIERZCHU PATRZYSZ DO GARNKOW LECZ NIC W NICH NIE MA');
    if Command = 'ROZMAWIAJ STARUCH' then begin
      if (Sausage > -30) and (Money < 200) and (ReturnScroll = 0) then begin
        WriteLn('STARUCH MOWI CI : HEJ KTO TY JESTES CZY ZE MAGICZNE DRZWI NIE POWSTRZYMALY CIE?');
        WriteLn('MUSISZ BYC NIEZLYM WOJOWNIKIEM ,SPOXOLANDIA, GLODNY JESTEM PRZYNIES MI 4 WEKI ');
        WriteLn('ORAZ OKOLO 200 KASY , A DAM CI TAKIE NUMERY O JAKICH CI SIE NIE SNILO....');
      end;
    end;
    if Command = 'ROZMAWIAJ STARUCH' then begin
      if (Sausage < -30) and (Money > 199) then begin
        WriteLn('STARUCH MOWI CI : OOO JAKA PIEKNA WEKA ... MNIAM I DRUGA TRZECIA I CZWARTA');
        WriteLn('TO BYLO DOBRE ZARCIE !!! , DAWAJ KASE , PIENIADZE !!! , CO SIE TAK GAPISZ?');
        WriteLn('WYNOCHA STAD !!! MRAMMMARAMMARAMAAMMARAM BUM !! -T-E-L-E-P-O-R-T-Y');
        WriteLn('WYGLADA ZE ZROBIL CIE W BUCA , A MOZE JEDNAK NIE , CO TO ? , SCROLL POWROTU');
        WriteLn('I PIWSKO NA OSLODZENIE ZYCIA , NO TRUDNO PRZYNAJMNIEJ CZEGOS SIE NAUCZYLES');
        Room := 20;
        Beer := Beer - 10;
        Sausage := Sausage + 40;
        Money := Money - 200;
        ReturnScroll := ReturnScroll - 10;
        Experience := Experience + 50;
        ItemCount := ItemCount - 2;
      end;
    end;
    if Command = 'ROZMAWIAJ STARUCH' then begin
      if ReturnScroll < 0 then begin
        WriteLn('AAAA SPADAJ STAD BO CI KOSCI POLAMIE');
        Room := 16;
      end;
    end;
    if Command = 'ZABIJ STARUCH' then begin
      if OldElf <> 0 then begin
        FightWeak;
        OldElf := 0;
        WriteLn('HMMM UBRANIE JEST , ALE CIALO GDZIES ZNIKNELO , WTEM SLYSZYSZ GLOS :');
        WriteLn('--- TO BYL TWOJ BLAD --- , DOSTAJESZ OCMIENIA LECZ NIE WIESZ CO TO BYLO');
        Level := Level - 1;
      end;
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BUDYNEK');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 85;
  until Room <> 86;

end;
procedure Room21;

begin

  WriteLn('JESTES NA ULICY NA ULICY SKLEPIKOWEJ - JAK SAMA NAZWA WZKAZUJE  ');
  WriteLn('JEST TU PARE SKLEPIKOW KTORE BYC MOZE CI SIE PRZYDADZA');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-CENTRUM MIASTA');
      WriteLn('POLNOC-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-PIEKARNIA');
      WriteLn('ZACHOD-ZBROJOWNIA');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Room := 20;
    if Command = 'POLNOC' then Room := 22;
    if Command = 'WSCHOD' then Room := 23;
    if Command = 'ZACHOD' then Room := 24;
    StreetFights;
  until Room <> 21;

end;
procedure Room22;

begin

  WriteLn('CIAGNIE SIE TEDY ULICA SKLEPIKOWA JEST TU JESZCZE PARE  ');
  WriteLn('INTERESUJACYCH SKLEPOW. DALEJ CIAGNIE SIE KILKA ULIC....');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-UL.SKLEPIKOWA');
      WriteLn('POLNOC-ROZJAZD!');
      WriteLn('WSCHOD-SKLEP WIELOBRANZOWY');
      WriteLn('ZACHOD-SKLEP MAGICZNY  ');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Room := 21;
    if Command = 'WSCHOD' then Room := 25;
    if Command = 'ZACHOD' then Room := 26;
    if Command = 'POLNOC' then Room := 100;
    StreetFights;
  until Room <> 22;

end;
procedure Room101;

begin

  WriteLn('IDZIESZ DROGA , MIASTA PO DRODZE MIJASZ DROGOWSKAZ . JEST TU O WIELE ');
  WriteLn('NIEBEZPIECZNIEJ NIZ W MIESCIE PELNO TU ZEZIMIERZKOW ROZNEGO RODZAJU');
  WriteLn('JESLI NIE CHCESZ MIEC KLOPOTOW LEPIEJ DOBRZE TRYMAJ SIE DROGI....');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ROZJAZD!');
      WriteLn('ZACHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if Command = 'PATRZ DROGOWSKAZ' then
      WriteLn('WSCHOD - MIASTO , ZACHOD - SHIGGHLERATHR');
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 100;
    if Command = 'ZACHOD' then Room := 102;
    if Command = 'POLNOC' then Room := 104;
  until Room <> 101;

end;
procedure Room102;

begin

  WriteLn('IDZIESZ DALEJ KAMIENISTA DROGA , BRZYDALA BI CI SIE JAKA BRYCZKA NALEPIEJ ');
  WriteLn('MODEL SZKAPA 2000 , ALE COZ KONIE SA TYLKO DLA NAJBOGATSZYCH');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-DROGA');
      WriteLn('ZACHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 101;
    if Command = 'ZACHOD' then Room := 103;
  until Room <> 102;

end;
procedure Room103;

begin

  WriteLn('CO TO ZA GLUPOTA ? DROGA SKRECA TROCHE W LEWO , TROCHE W PRAWO ALE ');
  WriteLn('PRZECIEZ ROWNIE DOBRZE MOGLA BY ISC SRODKIEM , ZYSKALI BY NA TYM WSZYSCY');
  WriteLn('A SZCZEGOLNIE TY ,  BO BOLA CIE NOGI OD TEGO CHODZENIA NIEMOZEBNIE');
  WriteLn('UPS DROGA SIE KONCZY NA TEJ NIEPRZEPASTNEJ RZECE O DALSZEJ PODROZY NIE MA MOWY');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 102;
  until Room <> 103;

end;
procedure Room23;

begin

  WriteLn('JESTES W PIEKARNI , SKLEP PRZESIAKNIETY JEST PRZYJEMNYM ZAPACHEM CHLEBA ');
  WriteLn('PIEKARZ MILO SIE NA CIEBIE PATRZY WYCIERAJAC MAKE Z TWARZY');
  WriteLn('NA SCIANIE  JEST PLAKAT CALY W MACE');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn('LISTA-LISTA DOSTEPNYCH RZECZY,KUP (PRZEDMIOT)-KUPUJESZ GO ');
      WriteLn('PO ODEJSCIU OD LADY REKLAMACJI NIE UWZGLEDNIA SIE');
    end;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-ULICA SKLEPIKOWA');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Room := 21;
    BakeryShop;
  until Room <> 23;

end;
procedure Room24;

begin

  WriteLn('JESTES W ZBROJOWNI - SKLEP NIEDAWNO ZOSTAL OTWARTY');
  WriteLn('SPRZEDAWCA(BRZYDKA AURA) STARA SIE WCISNAC CI JAKIS TOWAR ');
  WriteLn('NA SCIANIE WISI PLAKAT');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    ArmouryShop;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA SKLEPIKOWA');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 21;
    if Command = 'PATRZ PLAKAT' then
      WriteLn('LISTA,KUP XXX I SPRZEDAJ XXX TO JEST DOSTEPNE W TYM SKLEPIE ');
    StreetFights;
  until Room <> 24;

end;
procedure Room25;

begin

  WriteLn('WSZEDLES DO SKLEPU WIELOBRANZOWEGO,STWIERDZASZ OBECNOSC SPRZEDAWCY');
  WriteLn('NA DRZWIACH ZOSTALA WYWIESZONA WYWIESZKA');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-ULICA SKLEPIKOWA');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Room := 22;
    if Command = 'PATRZ WYWIESZKA' then
      WriteLn('* SKLEP OTWARTY DO ODWOLANIA *');
    StreetFights;
    GeneralStoreShop;
  until Room <> 25;

end;
procedure Room26;

begin

  WriteLn('WCHODZISZ DO SKLEPU ALE NICZEGO TU NIE MA POZA SPRZEDAWCA I JEGO TOWAREM');
  DescribeStreet;
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA SKLEPIKOWA');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 22;
    if Command = 'PATRZ PLAKAT' then
      WriteLn('* OTWARTE Z POWODU CHOROBY *');
    MagicShop;
    StreetFights;
  until Room <> 26;

end;
procedure Room31;

begin

  WriteLn('IDAC ULICA DLUGA NA POLNOC SPOSTRZEGASZ DOLINE ROZRYWEK');
  WriteLn('A NA POLODNIE BASNIOWY GAJ...........');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA DLUGA');
      WriteLn('POLNOC-DOLINA ROZRYWEK');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Room := 30;
    if Command = 'POLNOC' then Room := 60;
  until Room <> 31;

end;
procedure Room32;

begin

  WriteLn('CZESC TO ARENA PRZYCHODZA TU TACY JAK TY PO TO ABY MORDOWAC');
  WriteLn('!!!!!O NIE!!!!!!!! TO STRASZNE!!! ( SIE DAL NABRAC ) (NAPISZ PATRZ PLAKAT');
  repeat
    Write(Energy, '%.', Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE PISZE');
      WriteLn('NIE ATAKUJ LUDZI I ZWIERZAT Z ZOO CHYBA ZE MASZ 3 LEVEL( LUB WYZEJ :P)');
    end;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA DLUGA');
      WriteLn('POLNOC-ARENA');
    end;
    if Command = 'WYJSCIE' then begin ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Room := 30;
    if Command = 'POLNOC' then Room := 33;
  until Room <> 32;

end;

const

  RoomDispatch: array[1..46] of TRoomEntry = (
    (room: 0; run:Room0),
    (room: 1; run:Room1),
    (room: 2; run:Room2),
    (room: 3; run:Room3),
    (room: 4; run:Room4),
    (room: 5; run:Room5),

    (room: -1; run:PlainRooms),
    (room: 9; run:Room9),
    (room: 11; run:Room11),
    (room: 12; run:Room12),
    (room: 13; run:Room13),
    (room: 14; run:Room14),
    (room: 15; run:Room15),
    (room: 16; run:Room16),
    (room: 17; run:Room17),
    (room: 18; run:Room18),
    (room: 20; run:Room20),
    (room: 75; run:Room75),
    (room: 30; run:Room30),
    (room: 76; run:Room76),
    (room: 77; run:Room77),
    (room: 78; run:Room78),
    (room: 79; run:Room79),
    (room: 80; run:Room80),
    (room: 81; run:Room81),
    (room: 82; run:Room82),
    (room: 83; run:Room83),
    (room: 84; run:Room84),
    (room: 87; run:Room87),
    (room: 88; run:Room88),
    (room: 85; run:Room85),
    (room: 86; run:Room86),
    (room: 21; run:Room21),
    (room: 22; run:Room22),
    (room: 101; run:Room101),
    (room: 102; run:Room102),
    (room: 103; run:Room103),
    (room: 100; run:Room100),
    (room: 23; run:Room23),
    (room: 24; run:Room24),
    (room: 25; run:Room25),
    (room: 26; run:Room26),
    (room: 31; run:Room31),
    (room: 60; run:Room60),

    (room: -1; run:ConcertRooms),
    (room: 32; run:Room32)
  );

procedure Start;
label
  L1012_TrancePrompt, L1025_Exit;
var
  gi, ri: Integer;
begin

  Randomize;
  ChooseRace;
  ReadKey;
  repeat
    Checkpoints;
    CheckLevelUp;

    if ItemCount > ItemLimit then begin
      WriteLn('JESTES OBLADOWANY !!! MASZ O ', ItemCount - ItemLimit, ' ZA DUZO');
      WriteLn('TRACISZ ', (ItemCount - ItemLimit) * 10, '% ENERGI');
      Energy := Energy - ((ItemCount - ItemLimit) * 10);
    end;

    if PoisonRounds > 0 then begin
      Roll := Random(5);
      WriteLn('JESTES ZATRUTY TRACISZ ', Roll, ' % ENERGI');
      PoisonRounds := PoisonRounds - 1;
    end;

    ExitRequested := False;
    for ri := Low(RoomDispatch) to High(RoomDispatch) do
      if (RoomDispatch[ri].room = -1) or (Room = RoomDispatch[ri].room) then begin
        RoomDispatch[ri].run;
        if ExitRequested then goto L1025_Exit;
      end;

    ArenaMaze;
    if Room = DeadRoom then Death;
    if Energy > MaxEnergy then Energy := MaxEnergy;
    if Room = TranceRoom then begin
      if OldSword = OuterRoom then
        WriteLn('W TWYM POKOJU LEZY !STARY! ZARDZEWIALY MIECZ');
      if SmallShield = OuterRoom then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE !MALA! TARCZA');
      if Heart = OuterRoom then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE ZAKRWAWIONE !SERCE!');
      if Diploma = OuterRoom then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE !DYPLOM! MUD SZKOLY');
      if Pipe = OuterRoom then
        WriteLn('TU LEZY !FAJKA!');
      L1012_TrancePrompt: Write(Energy, '%.', Experience, '>');
      ReadLn(Command);

      ExitRequested := False;
      for gi := Low(GroundCommands) to High(GroundCommands) do
        if (GroundCommands[gi].cmd = '') or (Command = GroundCommands[gi].cmd) then begin
          GroundCommands[gi].run;
          if ExitRequested then goto L1025_Exit;
        end;
      if Room = TranceRoom then goto L1012_TrancePrompt;
    end;

    Fled := 0;

  until Room = 193;

  L1025_Exit: ;

end;

end.
