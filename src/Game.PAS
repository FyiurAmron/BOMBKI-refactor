unit Game;

interface
uses crt;

type
  TPlayer = record
    Strength, Dexterity, Wisdom: Integer;
    MaxStrength, MaxDexterity, MaxWisdom: Integer;
    Energy, MaxEnergy: Integer;
    Mana, MaxMana: Integer;
    Practice: Integer;
    Level: Shortint;
    Experience: Integer;
    Money: Longint;
  end;

  TSkills = record
    Parry, Kick, KickMinMana, KickMaxEnergy: Integer;
    Fleeing, FleeEnergy: Integer;
    Comparing, Cooking: Shortint;
    CookingDisplayBug: Integer;
    Returning: Integer;
  end;

  TGear = record
    Armor, WornCount: Integer;
    ArmorRating: Integer;
    LuckRoll: Integer;
    Wearing: Integer;
    WeaponKind, ShieldKind: Integer;
    WornGarment: string;
    SwordValue, ShieldValue, HeartValue: Integer;
  end;

  TBag = record
    Count: Integer;
    Limit: Integer;
    Permit: Longint;
    Backpack: Shortint;
    OldSword, SmallShield, Heart, Diploma, Pipe: Integer;
    Doughnut, Cookie, DryRation, Bread, BreadRoll, Sausage: Integer;
    Bigos: Shortint;
    ManaBottle, Tracksuit, SpikedSuit, Cassette, CompareScroll: Integer;
    TeleportPill, LuckyLeaf: Shortint;
    ReturnScroll, Beer: Integer;
  end;

  TCombat = record
    EnemyEnergy, EnemyDexterity, EnemyStrength: Integer;
    EnemyDodged, PlayerDodged: Integer;
    DodgeChance, Damage: Integer;
    Fled: Integer;
    FightExperience: Integer;
    FireballCharges, PoisonCharges, PoisonRounds: Shortint;
    Loot, Roll: Integer;
  end;

  TWorld = record
    CageStrong, CageWeakling, CageAgile, CageTough, CageHuge: Integer;
    Woodworm, Fly, Bacterium, Snail, Beetle, Cockroach, Ant, Spider: Integer;
    Boar, Rat, Fox, Partridge, Hare, Mongrel, Eagle, Deer: Integer;
    Elephant, Lion, Giraffe, Camel, Ostrich, Boa, Wolf, Bison: Integer;
    Panther, Gladiator, Warrior, Tamer: Integer;
    Dachshund, Shepherd, Spaniel, Poodle, Pooch: Integer;
    Cabman, Vendor, Sweeper, Drunkard, SickMan: Integer;
    Kid, Lunatic, Listener, Fan, Man: Shortint;
    Policeman, Bouncer, OldMan, Gorilla, Reporter: Shortint;
    Guitarist, Drummer, Keyboardist, Liroy: Integer;
    Minibarman, Fatso, DJ, Pedal, Couple, Maciek: Integer;
    Sorrel, Daisy, Clover, SowThistle, Dandelion, Rose: Integer;
    Blackberry, Thistle, Gooseberry, Raspberry, Grass: Integer;
    Duncan: Shortint;
    Door, OldElf, Quest, QuestKills: Integer;
    DuncanQuest: Shortint;
  end;

  TSession = record
    Room, OuterRoom, InArena, MoveGuard: Integer;
    CheckpointStage, SavedFlag, SleepHours, Overall: Integer;
    ExitRequested: Boolean;
    SaveFile: Text;
  end;

var
  Player: TPlayer;
  Skills: TSkills;
  Gear: TGear;
  Bag: TBag;
  Combat: TCombat;
  World: TWorld;
  Session: TSession;
  Command: string;
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
  Player.MaxEnergy := 50;
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
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WSCHOD' then Session.Room := 4;
    if Command = 'ZACHOD' then Session.Room := 6;
    if Command = 'POLNOC' then Session.Room := 7;
    if Command = 'POLODNIE' then Session.Room := 8;
    if Command = 'GORA' then Session.Room := 9;
    if Command = 'DOL' then Session.Room := 10;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE BYNAJMNIEJ PISZE');
      WriteLn('TO JEST POKOJ DO ORIETACJI W TERENIE ORAZ W KIERUNKACH');
    end;
  until Session.Room <> 5;
end;

procedure Room0;
begin
  WriteLn('TU ZACZYNA SIE GRE');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then WriteLn('DOSTEPNE WYJSCIE-POLNOC-HALA GLOWNA MUD SZKOLE ');
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLNOC' then Session.Room := 1;
  until Session.Room <> 0;
end;
procedure Room1;
begin
  WriteLn('JESTES W OKROGLYM SALONIE WYPELNIONYM WITRAZAMI ');
  WriteLn('W POWIETRZU UNOSZA SIE ZAPACHY I SO TO ZAPACHY OK');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  WriteLn('NAPISZ PATRZ PLAKAT ABY GO ODCZYTA'#143' ');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'POLODNIE' then Session.Room := 0;
    if Command = 'WSCHOD' then Session.Room := 2;
    if Command = 'DOL' then Session.Room := 3;
    if Command = 'ZACHOD' then Session.Room := 4;
    if Command = 'POLNOC' then Session.Room := 20;
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
  until Session.Room <> 1;
end;
procedure Room4;
begin
  if Session.Room <> 4 then Exit;
  WriteLn('JESTES W HALLU MUD SZKOLY- OGARNIA CIE CYKORIA  ');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! AFISZ!!!');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-POKOJ CENTRALNY');
      WriteLn('ZACHOD-MUD SZKOLA (2)');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Session.Room := 1;
    if Command = 'ZACHOD' then Session.Room := 5;
    if Command = 'PATRZ AFISZ' then begin
      WriteLn(#169' NA AFISZU BYNAJMNIEJ PISZE');
      WriteLn('TO JEST MUD SZKOLA KUJ KOMEDY ALBO ZGINIESZ!!!!!!!!');
      WriteLn('JESLI CHODZI O EKWIPUNEK TO BIERZ (PRZEDMIOT)=BIERZESZ PRZEDMIOT');
      WriteLn('UZYJ (PRZEDMIOT) = UZYWASZ PRZEDMIOTU ODRZUC (PRZEDMIOT) = ODRZUCASZ');
      WriteLn('BRONIE I TARCZE I UBRONIA MOZNA ZDJAC KOMENDA ODLORZ (PRZEDMIOT) ');
    end;
  until Session.Room <> 4;

end;
procedure Room13;
begin
  if Session.Room <> 13 then Exit;
  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if World.CageStrong = 13 then WriteLn('SILNY , NAPAKOWANY POTWOR STOI POD SCIANA');
  if World.CageStrong = 0 then WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Session.Room := 11;
    if (Command = 'ZABIJ POTWOR') and (World.CageStrong = 13) then begin
      Combat.EnemyEnergy := 20;
      Combat.EnemyDexterity := 3;
      Combat.EnemyStrength := 10;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageStrong := 0;
        Combat.Loot := Random(15);
        WriteLn('WYCIAGASZ ', Combat.Loot, ' MONET Z CIALA POTWORA');
        Player.Money := Player.Money + Combat.Loot;
        if Bag.OldSword = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 7 then begin Bag.OldSword := Session.Room; WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA'); end;
        end;
        if Bag.SmallShield = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 7 then begin Bag.SmallShield := Session.Room; WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA'); end;
        end;
        if Bag.Heart = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 6 then begin Bag.Heart := Session.Room; WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA'); end;
        end;
      end else Combat.Fled := 0;
    end;
  until Session.Room <> 13;

end;
procedure SimpleRoom(RoomNo, DestRoom: Integer; Direction, ExitDesc: string);

begin
  if Session.Room = RoomNo then begin
    WriteLn('JESTES W DOSYC CIASNYM POKOJU I NICZEGO TU NIEMA ');
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn(Direction + '-' + ExitDesc);
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = Direction then Session.Room := DestRoom;
    until Session.Room <> RoomNo;
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
  if Session.Room <> 11 then Exit;
  WriteLn('JESTES W POKOJU PROWADZACYM DO KLATEK');
  WriteLn('DRZWI POD TOBA SIE ZATRZASNELY I NIE MASZ ODWROTU');
  WriteLn('WE WSZYSTKICH KIERUNKACH SA KLATKI I UJADAJACE SIE W NICH POTWORY');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WSCHOD' then Session.Room := 12;
    if Command = 'ZACHOD' then Session.Room := 13;
    if Command = 'POLNOC' then Session.Room := 14;
    if Command = 'POLODNIE' then Session.Room := 15;
    if Command = 'GORA' then Session.Room := 16;
    if Command = 'DOL' then Session.Room := 17;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE PISZE:');
      WriteLn('W KLATKACH SA POTWORKI - ZABIJ JE! KOMEDA : ZABIJ [COS] - ZABIJA ');
      WriteLn('CZASAMI COS WYPADNIE Z POTWORKA MOZE CI SIE TO PRZYDAC');
    end;
  until Session.Room <> 11;

end;
procedure Room30;
begin
  if Session.Room <> 30 then Exit;
  WriteLn('ULICA DLUGA CIAGNIE SIE W NIESKONCZONOSC,SORKI');
  WriteLn('NA POLNOCY ZNAJDUJESZ OGROMNA BUDOWLE=TO ARENA PRZEZNACZONA DO WALKI');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-CENTRUM MIASTA');
      WriteLn('ZACHOD-ULICA DLUGA');
      WriteLn('POLNOC-WEJSCIE NA ARENE');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'WSCHOD' then Session.Room := 20;
    if Command = 'ZACHOD' then Session.Room := 31;
    if Command = 'POLNOC' then Session.Room := 32;
  until Session.Room <> 30;

end;
procedure Room60;
begin
  if Session.Room <> 60 then Exit;
  WriteLn('JESTES W DOLINIE ROZRYWEK DOLINA CIAGNIE SIE NA POLNOC, NA WSCHODZIE');
  WriteLn('JEST SLYSZALNY JAKIS DZIWNY  HALAS , NA ZACHODZIE ZAS "LA LA LA LA" ');
  WriteLn('ZAWSZE MOZESZ WROCIC SIE IDAC NA POLODNIE ;)');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA DLUGA');
      WriteLn('WSCHOD-BUDOWLA PELNA HALASU');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLODNIE' then Session.Room := 31;
    if Command = 'WSCHOD' then Session.Room := 61;
  until Session.Room <> 60;

end;
procedure Room75;
begin
  if Session.Room <> 75 then Exit;
  WriteLn('JESTES NA ULICY CIEMNEJ , WLASCIWIE NARAZIE NIE JEST TU JESZCZE TAK CIEMNO ');
  WriteLn('TA ULICA WYGLADA NA REMONTOWAN'#164' , NA POLNOC WIDZISZ JAKIS BAR ');
  WriteLn('NA POLODNIE PRZEBIEGAJA CIE DRESZCZE , JEST TAM NAPRAWDE CIEMNO');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-CENTRUM MIASTA');
      WriteLn('POLNOC-BAR POD DWOMA PEDALAMI');
      WriteLn('POLODNIE-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'ZACHOD' then Session.Room := 20;
    if Command = 'POLNOC' then Session.Room := 76;
    if Command = 'POLODNIE' then Session.Room := 77;
  until Session.Room <> 75;

end;
procedure Room83;
begin
  if Session.Room <> 83 then Exit;
  WriteLn('............................. PIERDUT...........PIERDUT......PIERDUT');
  WriteLn('DOPIERO TERAZ SIE ZORIENTOWALES ZE NA SRODKU STOI WIELKIE DRZEWO');
  WriteLn('HMMM ALE ZARAZ ... TE KRZAKI NA ZACHOD WYGLADAJA BARDZO PODEJRZANIE....');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'POLNOC' then Session.Room := 80;
    if Command = 'ZACHOD' then Session.Room := 84;
  until Session.Room <> 83;

end;
procedure Room100;
begin
  if Session.Room <> 100 then Exit;
  WriteLn('ZNALAZLES SIE NA ROZJEZDZIE DROG , DROGI PILNUJE QUEST-MASTER ');
  WriteLn('QUEST-MASTER NIE POSCI CIE DALEJ DOPOKI NIE KUPISZ I ROZWIAZESZ QUESTA');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-DROGA O KTOREJ MOZESZ POMAZYC ( BO JEST W PRODUKCJI !!! )');
      if Bag.Permit = 0 then WriteLn('ZACHOD-DROGA ( ZABLOKOWANA PRZEZ QUEST-MASTERA)');
      if Bag.Permit < 0 then WriteLn('ZACHOD-DROGA');
    end;
    if Command = 'LISTA' then begin
      WriteLn('LATWY QUEST      - 200');
      WriteLn('PRZECIETNY QUEST - 100');
      WriteLn('TRUDNY QUEST     - 50');
      WriteLn('KOMEDA - SPRZEDAJ QUEST - OZNACZA IZ QUEST ZOSTAL WYKONANY');
    end;
    if (Command = 'KUP LATWY QUEST') and (Player.Money > 199) then begin
      WriteLn('ZABIJ 75 POTWOROW');
      World.Quest := 1;
      World.QuestKills := 75;
      Player.Money := Player.Money - 200;
    end;
    if (Command = 'KUP PRZECIETNY QUEST') and (Player.Money > 99) then begin
      WriteLn('ZABIJ 50 POTWOROW W TYM LIROYA I DAJ MI DYPLOM MUD SZKOLY');
      World.Quest := 2;
      World.QuestKills := 200;
      Player.Money := Player.Money - 100;
    end;
    if (Command = 'KUP TRUDNY QUEST') and (Player.Money > 49) then begin
      WriteLn('ZABIJ 50 POTWOROW W TYM LIROYA I DAJ MI FAJKE I POSWIEC 1 PRAKTYKE');
      World.Quest := 3;
      World.QuestKills := 200;
      Player.Money := Player.Money - 50;
    end;
    if (Command = 'SPRZEDAJ QUEST') and (World.Quest > 0) then begin
      if (World.Quest = 1) and (World.QuestKills < 1) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 100 KUNSZTU -----');
        Player.Experience := Player.Experience + 100;
        World.Quest := 0;
        World.QuestKills := 0;
        Bag.Permit := Bag.Permit - 10;
        Bag.Count := Bag.Count + 1;
      end;
      if (World.Quest = 2) and (World.QuestKills < 1) and (Bag.Diploma <= -10) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 250 KUNSZTU -----');
        Player.Experience := Player.Experience + 250;
        World.Quest := 0;
        World.QuestKills := 0;
        Bag.Diploma := 0;
        Player.MaxEnergy := Player.MaxEnergy - 5;
        Bag.Permit := Bag.Permit - 10;
      end;
      if (World.Quest = 3) and (World.QuestKills < 1) and (Bag.Pipe <= -10) and (Player.Practice > 0) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 425 KUNSZTU -----');
        Player.Experience := Player.Experience + 425;
        Bag.Count := Bag.Count - 1;
        Player.Wisdom := Player.Wisdom - 1;
        World.Quest := 0;
        World.QuestKills := 0;
        Bag.Pipe := Bag.Pipe + 10;
        Player.Practice := Player.Practice - 1;
        Bag.Permit := Bag.Permit - 10;
      end;

    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'POLODNIE' then Session.Room := 22;
    if (Command = 'ZACHOD') and (Bag.Permit <= -10) then Session.Room := 101;
if (Command = 'ZACHOD') and (Bag.Permit = 0) then WriteLn('QUEST-MASTER MOWI CI : BARDZO MI PRZYKRO ALE MUSISZ MIEC PRZEPUSTKE');
    if Command = 'ZABIJ QUEST-MASTER' then begin
      Combat.PoisonCharges := 10;
      Combat.FireballCharges := 20;
      Combat.EnemyStrength := 10;
      Combat.EnemyDexterity := 26;
      Combat.EnemyEnergy := 188;
      Fight;
      if Combat.EnemyEnergy < 1 then Bag.Permit := Bag.Permit - 10;
    end;
  until Session.Room <> 100;

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

function DodgeBound(chance: Integer): Integer;

begin
  if chance > 30 then DodgeBound := 12
  else if chance > 27 then DodgeBound := 13
  else if chance > 24 then DodgeBound := 14
  else if chance > 20 then DodgeBound := 15
  else if chance > 18 then DodgeBound := 16
  else if chance > 16 then DodgeBound := 17
  else if chance > 12 then DodgeBound := 18
  else if chance > 9 then DodgeBound := 19
  else if chance > 6 then DodgeBound := 20
  else if chance > 4 then DodgeBound := 21
  else if chance > 2 then DodgeBound := 22
  else DodgeBound := 23;
end;

function EnemyDodgeBound(chance: Integer): Integer;

begin
  if chance > 30 then EnemyDodgeBound := 60
  else if chance > 27 then EnemyDodgeBound := 58
  else if chance > 24 then EnemyDodgeBound := 56
  else if chance > 20 then EnemyDodgeBound := 54
  else if chance > 18 then EnemyDodgeBound := 52
  else if chance > 16 then EnemyDodgeBound := 51
  else if chance > 12 then EnemyDodgeBound := 48
  else if chance > 9 then EnemyDodgeBound := 46
  else if chance > 6 then EnemyDodgeBound := 42
  else if chance > 4 then EnemyDodgeBound := 40
  else if chance > 2 then EnemyDodgeBound := 38
  else EnemyDodgeBound := 35;
end;

function DexterityBonus(value: Integer): Integer;

begin
  if value >= 8 then DexterityBonus := value div 2
  else DexterityBonus := 0;
end;

function ParryBonus(value: Integer): Integer;

var bonus: Integer;
begin
  bonus := 0;
  if value > 75 then bonus := bonus + 1;
  if value > 50 then bonus := bonus + 1;
  ParryBonus := bonus;
end;

function KickBonus(value: Integer): Integer;

var bonus: Integer;
begin
  bonus := 0;
  if value > 70 then bonus := bonus + 2;
  if value > 10 then bonus := bonus + 2;
  KickBonus := bonus;
end;

procedure FightDog;
begin
  Combat.EnemyEnergy := 10;
  Combat.EnemyDexterity := 10;
  Combat.EnemyStrength := 5;
  Fight;
  Combat.Loot := Random(15);
  WriteLn('WYCIAGASZ ', Combat.Loot, ' MONET Z CIALA PSA');
  Player.Money := Player.Money + Combat.Loot;
  if Bag.Heart = 0 then begin
    Combat.Roll := Random(20);
    if Combat.Roll < 5 then begin Bag.Heart := Session.Room; WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA PSA');
    end;
  end;
end;

procedure SpawnMonsters;
begin
  repeat
    World.Bacterium := Random(38) + 20;
    World.Snail := Random(38) + 20;
    World.Beetle := Random(38) + 20;
    World.Cockroach := Random(38) + 20;
    World.Ant := Random(38) + 20;
    World.Spider := Random(38) + 20;
    World.Boar := Random(38) + 20;
    World.Fox := Random(38) + 20;
    World.Rat := Random(38) + 20;
    World.Partridge := Random(38) + 20;
  until (World.Bacterium > 32) and (World.Snail > 32) and (World.Beetle > 32) and (World.Cockroach > 32)
    and (World.Ant > 32) and (World.Spider > 32) and (World.Boar > 32) and (World.Fox > 32)
    and (World.Rat > 32) and (World.Partridge > 32);
  repeat World.Deer := Random(38) + 20;
    World.Eagle := Random(38) + 20;
    World.Hare := Random(38) + 20;
    World.Mongrel := Random(38) + 20;
    World.Woodworm := Random(38) + 20;
    World.Fly := Random(38) + 20;
  until (World.Deer > 32) and (World.Eagle > 32) and (World.Hare > 32) and (World.Mongrel > 32)
    and (World.Woodworm > 32) and (World.Fly > 32);
  repeat World.Elephant := Random(38) + 20;
    World.Lion := Random(38) + 20;
    World.Giraffe := Random(38) + 20;
    World.Camel := Random(38) + 20;
    World.Ostrich := Random(38) + 20;
    World.Boa := Random(38) + 20;
    World.Wolf := Random(38) + 20;
    World.Bison := Random(38) + 20;
    World.Panther := Random(38) + 20;
  until (World.Elephant > 32) and (World.Lion > 32) and (World.Giraffe > 32) and (World.Camel > 32)
    and (World.Ostrich > 32) and (World.Boa > 32) and (World.Wolf > 32) and (World.Bison > 32)
    and (World.Panther > 32);
  repeat World.Gladiator := Random(38) + 20;
    World.Warrior := Random(38) + 20;
    World.Tamer := Random(38) + 20;
  until (World.Gladiator > 32) and (World.Warrior > 32) and (World.Tamer > 32);
  repeat
    World.Dachshund := Random(7) + 20;
    World.Shepherd := Random(7) + 20;
    World.Pooch := Random(7) + 20;
    World.Spaniel := Random(7) + 20;
    World.Poodle := Random(7) + 20;
  until (World.Dachshund > 19) and (World.Shepherd > 19) and (World.Pooch > 19)
    and (World.Spaniel > 19) and (World.Poodle > 19);
  repeat World.Cabman := Random(7) + 20;
    World.Vendor := Random(7) + 20;
    World.Sweeper := Random(7) + 20;
    World.Drunkard := Random(7) + 20;
    World.SickMan := Random(7) + 20;
  until (World.Cabman > 19) and (World.Vendor > 19)
    and (World.Sweeper > 19) and (World.Drunkard > 19) and (World.SickMan > 19);
  repeat World.Kid := Random(7) + 60;
    World.Lunatic := Random(8) + 60;
    World.Listener := Random(8) + 60;
    World.Fan := Random(8) + 60;
    World.Man := Random(8) + 60;
  until (World.Kid > 60) and (World.Lunatic > 60) and (World.Listener > 60) and (World.Fan > 60)
    and (World.Man > 60);
  repeat World.Policeman := Random(9) + 60;
    World.Bouncer := Random(9) + 60;
    World.Gorilla := Random(9) + 60;
    World.OldMan := Random(8) + 60;
    World.Reporter := Random(7) + 60;
  until (World.Policeman > 60) and (World.Bouncer > 60) and (World.Gorilla > 60) and (World.OldMan > 60)
    and (World.Reporter > 60); World.Guitarist := Random(3) + 70;
  World.Drummer := Random(3) + 70;
  World.Keyboardist := Random(3) + 70;
  World.Liroy := Random(3) + 70;
  World.Minibarman := 67;
  World.Fatso := 67;
  World.DJ := 69;
  World.Pedal := 76;
  World.Couple := 76;
  World.Maciek := 76;
  World.Door := 1;
  World.OldElf := 1;
  repeat
    World.Sorrel := Random(8) + 77;
    World.Clover := Random(8) + 77;
    World.Daisy := Random(8) + 77;
    World.SowThistle := Random(8) + 77;
    World.Dandelion := Random(8) + 77;
    World.Rose := Random(8) + 77;
    World.Thistle := Random(8) + 77;
    World.Raspberry := Random(8) + 77;
    World.Gooseberry := Random(8) + 77;
    World.Blackberry := Random(8) + 77;
    World.Grass := Random(8) + 77;
    World.Duncan := Random(8) + 77;
  until (World.Sorrel < 84) and (World.Daisy < 84) and (World.Clover < 84) and (World.SowThistle < 84)
    and (World.Dandelion < 84) and (World.Rose < 84) and (World.Thistle < 84) and (World.Raspberry < 84);
end;
procedure TrainAttribute(var Attribute, MaxAttribute: Integer; MinPractice, PracticeCost: Integer; cmdForm, nounForm: string);

begin
  if (Player.Practice > MinPractice) and (Attribute < MaxAttribute) then begin
    Attribute := Attribute + 1;
    Player.Practice := Player.Practice - PracticeCost;
    WriteLn('TRENUJESZ ', cmdForm, ' I MASZ ', Attribute, ' ', nounForm, ' I ZOSTALO CI ', Player.Practice, ' PRAKTYK');
  end;
end;

procedure HandleTrain;
begin
  if Command = 'TRENUJ' then WriteLn('CO CHCESZ TRENOWAC?');
  if Command = 'TRENUJ SILA' then
    TrainAttribute(Player.Strength, Player.MaxStrength, 2, 3, 'SILE', 'SILY');
  if Command = 'TRENUJ ZRECZNOSC' then
    TrainAttribute(Player.Dexterity, Player.MaxDexterity, 1, 2, 'ZRECZNOSC', 'ZRECZNOSCI');
  if Command = 'TRENUJ MADROSC' then
    TrainAttribute(Player.Wisdom, Player.MaxWisdom, 2, 3, 'MADROSC', 'MADROSCI');
end;

procedure DescribePlants;
begin
  if World.Sorrel = Session.Room then WriteLn('PONURY SZCZAW PLANUJE ZEMSCIC SIE NA SWOJEJ TESCIOWEJ-LISCIU KLONOWYM');
  if World.Daisy = Session.Room then WriteLn('STOKROTKA TUTAJ ROSNIE POLNA ( A NAD NIA SZUMI GEJ) ');
  if World.Clover = Session.Room then WriteLn('KONICZYNKA KTORA TUTAJ JEST NIE PRZENIESIE CI SZCZESCIA');
  if World.SowThistle = Session.Room then WriteLn('MLECZ WLASNIE DOWIODL ZE EINSTEIN SIE MYLIL');
  if World.Dandelion = Session.Room then WriteLn('DMUCHAWIEC WLASNIE DOJRZAL DO TEGO ABY GO ZDMUCHNAC');
  if World.Rose = Session.Room then WriteLn('PRZEROSNIETA ROZA POKAZUJE KOLCE NA ZNAK IZ NIE WARTO JEJ ATAKOWAC');
  if World.Thistle = Session.Room then WriteLn('KIEDYS MYSLALES ZE OSET TO LATWY DO WYRWANIA CHWAST ... MYLILES SIE');
  if World.Blackberry = Session.Room then WriteLn('TA JEZYNA W CIEMNOSCIACH WYGLADA JAK JAKIS NIEBYWALY SMOK ... ');
  if World.Gooseberry = Session.Room then WriteLn('AGREST JEST TU , CHCESZ SPROBOWAC JAK SMAKUJE ?');
  if World.Raspberry = Session.Room then WriteLn('MALINA JAK DZIEWCZYNA , CHOC DZIEWCZYNY NIE SA CHYBA AZ TAKIMI MUTANTAMI');
  if World.Grass = Session.Room then WriteLn('TRAWA NIE WYDAJE SIE TRUDNYM PRZECIWNIKIEM , LECZ NIE DAJ SIE ZWIESC');
  if Session.Room = World.Duncan then WriteLn('ROLNIK DUNCAN PROBOJE ZAPANOWAC NAD TYM ZYWIOLEM I UPRAWIAC SWOJE MARCHEWKI');
end;

procedure CompositeFight(EnemyEnergyBase, EnemyEnergyRand, EnemyDexterityBase, EnemyDexterityRand, EnemyStrengthBase, EnemyStrengthRand,
  LootBase, LootRand, HeartChance: Integer; RequireEnergy: Boolean; AntDoughnut: Boolean);

begin
  if EnemyEnergyRand > 0 then Combat.EnemyEnergy := Random(EnemyEnergyRand) + EnemyEnergyBase else Combat.EnemyEnergy := EnemyEnergyBase;
  if EnemyDexterityRand > 0 then Combat.EnemyDexterity := Random(EnemyDexterityRand) + EnemyDexterityBase else Combat.EnemyDexterity := EnemyDexterityBase;
  if EnemyStrengthRand > 0 then Combat.EnemyStrength := Random(EnemyStrengthRand) + EnemyStrengthBase else Combat.EnemyStrength := EnemyStrengthBase;
  Fight;
  if (Combat.Fled = 0) and (not RequireEnergy or (Player.Energy > 0)) then begin
    Combat.Loot := Random(LootRand) + LootBase;
    WriteLn('WYCIAGASZ ', Combat.Loot, ' MONET Z CIALA');
    Player.Money := Player.Money + Combat.Loot;
    if AntDoughnut then begin
      if Command = 'ZABIJ MROWKA' then begin
        Combat.Roll := Random(10);
        if (Combat.Roll < 7) and (Bag.Doughnut <> -10) then begin
          WriteLn('WYCIAGASZ PACZEK Z CIALA MROWKI');
          Bag.Doughnut := -10;
          Bag.Count := Bag.Count + 1;
        end;
      end;
    end else if (HeartChance > 0) and (Bag.Heart = 0) then begin
      Combat.Roll := Random(20);
      if (Combat.Roll < HeartChance) and (Bag.Heart <> -10) then begin
        WriteLn('WYCIAGASZ SERCE Z CIALA TRUPA');
        Bag.Heart := -10;
        Bag.Count := Bag.Count + 1;
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
  if Player.Mana > 9 then begin
    Combat.Roll := Random(100);
    WriteLn('KOGO CHCESZ ZE SOBA POROWNAC?');
    ReadLn(Command);
    Session.Overall := Player.Level + Player.Strength + DexterityBonus(Player.Dexterity) + ParryBonus(Skills.Parry) + KickBonus(Skills.Kick);
    if (Command = 'DZIK') or (Command = 'SZCZUR') or (Command = 'LIS') or
       (Command = 'KUROPATWA') or (Command = 'ZAJAC') or (Command = 'WILCZUR') or
       (Command = 'ORZEL') or (Command = 'SARNA') or (Command = 'DZIECKO') or (Command = 'DZIADEK') then
        begin if Session.Overall < 16 then WriteLn('NICZEGO NIE MOGE ZAGWARANTOWAC ..... MACIE PODOBNE PARAMETRY');
        if (Player.Strength > 15) and (Player.Strength < 19) then WriteLn('PRZECIWNIK GODNY TWEJ DUMY , RACZEJ NIE POGRASZ');
        if Player.Strength > 18 then WriteLn('WSTYD MI ZA CIEBIE ... JESZCZE TU JESTES ! NA CO CZEKASZ ? KILLUJ');
        end;
    if (Command = 'SLON') or (Command = 'LEW') or (Command = 'ZYRAFA') or (Command = 'WIELBLAD') or
       (Command = 'STRUS') or (Command = 'BOA') or (Command = 'WILK') or (Command = 'BIZON') or
       (Command = 'PANTERA') or (Command = 'WARIAT') or (Command = 'SLUCHACZ') or (Command = 'FAN') or
       (Command = 'CZLOWIEK') or (Command = 'REPORTER') then
      begin if Session.Overall < 16 then WriteLn('TAK  TAK MAMA KUPI BERECIK GLOWKA W PORZADKU ? ');
      if (Player.Strength > 15) and (Player.Strength < 21) then WriteLn(' NA TWOIM MIEJSCU BYM SIE NIE ZAPUSZCZAL ');
      if (Player.Strength > 20) and (Player.Strength < 23) then WriteLn(' RYZYK FIZYK - TAK NA 50% - WALKA NA SMIERC I ZYCIE');
      if Player.Strength > 22 then WriteLn('SPOX KILLUJ BEZ UPRZEDZEN');
    end;
    if (Command = 'GLADIATOR') or (Command = 'WOJOWNIK') or (Command = 'TRENER') or
       (Command = 'POLICJANT') or (Command = 'GORYL') or (Command = 'OCHRONIARZ') then begin
      if Session.Overall < 15 then WriteLn('HA HA NIE NA SERJO . DAJ SE W ZYLE OKI? TO DOWCIP? HA HA HA');
      if (Session.Overall > 14) and (Session.Overall < 18) then WriteLn('POMARZ SOBIE WARIACIE . MOZE CI SIE PRZYSNI');
      if (Session.Overall > 17) and (Session.Overall < 23) then WriteLn('POWIEM  BEZ OGRODEK-TO GLUPI POMYSL');
      if (Session.Overall > 22) and (Session.Overall < 26) then WriteLn('TO DOSC RYZYKOWNE ZE TAK POWIEM');
      if Session.Overall > 25 then WriteLn('TO BEDZIE TAK PROSTE JAK ZABICIE DZIECKA TOPOREM !!!');
    end;
    if (Command = 'MINI-BARMAN') or (Command = 'GRUBAS') or (Command = 'D.J') then begin
      if Session.Overall < 24 then WriteLn('SMIERC PODZIEKUJE CI ZA TWOJ DAR (ALE ZGAPIAM)');
      if (Session.Overall > 23) and (Session.Overall < 26) then WriteLn('NIE UDAWAJ BISTY-BOYS PRZEGRASZ NA 99%');
      if (Session.Overall > 25) and (Session.Overall < 29) then WriteLn('PERFEKCYJNY MECZ NA SMIERC I ZYCIE !!!');
      if Session.Overall > 28 then WriteLn('JESTES ZNACZNIE SILNIEJSZY !!!(ALE GLUPSZY)');
      if Session.Overall > 34 then WriteLn('UWAZAJ DOSTANIESZ MALO KUNSZTU !!!');
    end;
    if (Command = 'TAKSOWKARZ') or (Command = 'SPRZEDAWCA') or (Command = 'GITARZYSTA') or (Command = 'PERKUSISTA') or
       (Command = 'ORGANISTA') or (Command = 'ZEBRAK') or (Command = 'PIJAK') or (Command = 'ZAMIATACZ') or (Command = 'SZCZAW') or
       (Command = 'STOKROTKA') or (Command = 'KONICZYNKA') or (Command = 'MLECZ') or (Command = 'DMUCHAWIEC') then begin
      if Session.Overall < 21 then WriteLn('NIE');
      if (Session.Overall > 22) and (Session.Overall < 28) then WriteLn('RACZEJ NIE , CHOC MOZNA ZARYZYKOWAC(NIE POLECAM)');
      if Session.Overall > 27 then WriteLn('TAK');
    end;
    if (Command='PEDAL') or (Command='PARA') or (Command='MACIEK') or (Command='ROZA') or
       (Command='MALINA') or (Command='TRAWA') or (Command = 'AGREST') or (Command = 'JEZYNA') then begin
      if Session.Overall < 20 then WriteLn('WIERZ MI ALE TO NAPRAWDE WIERZ MI ZE NIE MASZ SZANS');
      if (Session.Overall > 19) and (Session.Overall < 26) then WriteLn('RACZEJ NIE WYGRASZ WIEC LEPIEJ NIE ATAKUJ');
      if (Session.Overall > 25) and (Session.Overall < 30) then WriteLn('JESTESCIE SOBIE ROWNI (NAPRAWDE !!!) - WIEC 50% SZANS');
      if Session.Overall > 29 then WriteLn('JESTES SILNIEJSZY STAD WNIOSEK ZE SOBIE PORADZISZ');
      if Session.Overall > 35 then WriteLn('P.S - JESTES DUZO DUZO SILNIEJSZY ZABIJ BEZ OGRODEK!!!');
    end;
    if Command = 'LIROY' then begin
      if Session.Overall < 28 then WriteLn('HAHAHAHAHAHAHAHAHAHHAHOHOHOHHOHOHOHOHOHOHOHOAHAHAHAHAHAHAH');
      if (Session.Overall > 27) and (Session.Overall < 33) then WriteLn('HIHIHIHIHIHIHIHHEHEHEHE :))))))');
      if (Session.Overall > 32) and (Session.Overall < 44) then WriteLn('SPROOB'#224'J A MO'#189'E WYGRAC SIE UDA......');
    if (Session.Overall > 43) and (Session.Overall < 48) then WriteLn('NIE PRZEJMUJ SIE JEGO MORD'#164' JESTES SILNIEJSZY I BASTA');
      if Session.Overall > 47 then WriteLn('UWAZAJ ... NA CHLAPIACE MOZGI FLAKI PRZECIWNIKA');
    end;
    if Command = 'POKRZYWA' then begin
      if Session.Overall < 40 then WriteLn('NIE MASZ NAJMNIEJSZYCH SZANS');
      if Session.Overall > 39 then WriteLn('JEST PEWNE PRAWDOPODOBIENSTWO WYGRANIA TEGO STARCIA');

    end;
    if (Command = 'SPANIEL') or (Command = 'OWCZAREK') or (Command = 'PIESEK') or (Command='JAMNIK') or (Command='PUDEL') then
      WriteLn('JASNE ZE MOZESZ GO ZABIC ZABIJ !!! ZABIJ . TEN PARSZYWY PIES NIE MA RACJI BYTU');
    if (Combat.Roll < 3) and (Skills.Comparing < 100) then begin
      WriteLn('***************** UCZYSZ SIE ZDOLNOSCI POROWNYWANIE *****************');
      Skills.Comparing := Skills.Comparing + 1;
      Player.Experience := Player.Experience + 5;
    end;
    if Command = 'BAKTERIA' then begin
      WriteLn('BAKTERIA MA MAGIC RESISTANCE');
      Player.Mana := Player.Mana + 5;
    end;
  end;
end;

procedure DescribeStreet;
begin
  if World.Dachshund = Session.Room then WriteLn('DLUGI JAMNIK GRYZIE CI PODESZWY');
  if World.Shepherd = Session.Room then WriteLn('PUCHATY OWCZAREK WYLEGUJE SIE W SLONCU');
  if World.Pooch = Session.Room then WriteLn('PIESEK SZUKA DRZEWKA ABY ULZYC SOBIE');
  if World.Spaniel = Session.Room then WriteLn('SPANIEL SLINI SIE AZ MILO');
  if World.Poodle = Session.Room then WriteLn('PUDEL JE KITIKET WIEC CHYBA MU NIE PRZERWIESZ.....?');
  if World.Cabman = Session.Room then WriteLn('TAKSOWKARZ WTARGNA TU ZE SWOJA BRYKA , I CZEKA NA KLIENTOW');
  if World.Vendor = Session.Room then
    WriteLn('SPRZEDAWCA PRECELKOW WLASNIE SPRZEDAL OSTATNIEGO , CZYM DOPROWADZA DO SZALENSTWA LATAJACE WOKOLO NIEGO KRUKI');
  if World.Sweeper = Session.Room then WriteLn('ZAMIATACZ ULIC SPRAWIA ZE JEST TU CZYSTO JAK W CHLEWIE');
  if World.Drunkard = Session.Room then WriteLn('PIJAK TU STOI(DOBRE SOBIE) I SMIERDZI MU Z GEBY');
  if World.SickMan = Session.Room then WriteLn('ZEBRAK UDOWADNIA PRZECHODNIOM ZE ON NAPRAWDE JEST CHORY NA AIDS');
end;

procedure SuitGain;
begin
  Combat.Roll := Random(1000);
  if Combat.Roll <= 25 then begin
    WriteLn('ZYSKUJESZ GARNITUR !!!! Z CIALA WROGA !!!!');
    WriteLn('PRZEDMIOT UNIQE !!! 2.5% !!! ');
    Bag.SpikedSuit := Bag.SpikedSuit - 10;
    Bag.Count := Bag.Count + 1;
  end;
end;
procedure PillGain;
begin
  Combat.Roll := Random(1000);
  if Combat.Roll <= 42 then begin
    WriteLn('HMMM , A TO CO ? , TOZ TO !!! PIGULKA TRANSPORTUJACA !!! PROSTO Z CIALA WROGA');
    Bag.TeleportPill := Bag.TeleportPill - 10;
    Bag.Count := Bag.Count + 1;
  end;
end;
procedure CassetteGain;
begin
  Combat.Roll := Random(100);
  if (Combat.Roll < 2) and (Session.Room <> 10000) then begin
    WriteLn('WYCIAGASZ KASETE LIROYA Z CIALA BIEDNEGO CZLOWIEKA');
    WriteLn('!!! PRZEDMIOT UNIQE 2% !!!');
    Bag.Cassette := Bag.Cassette - 10;
    Player.MaxEnergy := Player.MaxEnergy + 5;
    Gear.Armor := Gear.Armor - 8;
    Bag.Count := Bag.Count + 1;
    Player.Dexterity := Player.Dexterity + 1;
  end;
end;
procedure LeafGain;
begin
  Combat.Roll := Random(100);
  if (Combat.Roll < 6) and (Session.Room <> 10000) then begin
    WriteLn('WYCIAGASZ LISTEK SZCZESCIA Z CIALA WROGIEJ TOBIE POSTACI');
    WriteLn('!!! PRZEDMIOT UNIQE 4% !!!');
    Bag.LuckyLeaf := Bag.LuckyLeaf - 10;
    Bag.Count := Bag.Count + 1;
    Player.MaxMana := Player.MaxMana + 40;
  end;
end;
procedure ScrollGain;
begin
  Combat.Roll := Random(100);
  if (Combat.Roll < 10) and (Session.Room <> 10000) then begin
    WriteLn('WYCIAGASZ SCROLL POROWNANIA Z WROGIEJ TOBIE POSTACI');
    Bag.CompareScroll := Bag.CompareScroll - 10;
    Bag.Count := Bag.Count + 1;
  end;
end;

procedure EnterTrance;
begin
  Session.OuterRoom := Session.Room;
  Session.Room := 1000;
end;
procedure DescribeStage;
begin
  if World.Guitarist = Session.Room then WriteLn('GITARZYSTA GRA TU NA WYSOKIM CE-DUR');
  if World.Drummer = Session.Room then WriteLn('PERKUSISTA TLUCZE TU NIEMILOSIERNIE (W) TALEZE I BEBNY');
  if World.Keyboardist = Session.Room then WriteLn('ORGANISTA KORZYSTA Z 8 CIASIO NARAZ PODL'#164'CZONYCH DO SIECI');
  if World.Liroy = Session.Room then WriteLn('MAGA BOSS TEJ PLANSZY - LIROY SPIEWA JEDEN ZE SWOICH KAWALKOW');
end;
procedure DescribeCrowd;
begin
  if Session.Room = World.Kid then WriteLn('MILE DZIECKO POWTARZA NAJLEPSZE KAWALKI LIROYA');
  if Session.Room = World.Lunatic then WriteLn('WARIAT SIE CIESZY ZE NIE TYLKO ON JEST WARIATEM');
  if Session.Room = World.Listener then WriteLn('SLUCHACZ SLUCHA');
  if Session.Room = World.Fan then WriteLn('FAN LIROYA ZAPUSCIL SOBIE BRODKE JAK LIROY I MA PODJAR');
  if Session.Room = World.Man then WriteLn('NORMALNY CZLOWIEK PRZYSZEDL POSLUCHAC LIROYA(DZIWNE NIE)?');
  if Session.Room = World.Policeman then WriteLn('ZALANY POLICJANT STARA SIE PELNIC SWA SLUZBE');
  if Session.Room = World.Bouncer then WriteLn('OCHRONIARZ ZABIJA KAZDEGO KTO PRZEJDZIE PRZEZ BALUSTRADKI');
  if Session.Room = World.Gorilla then WriteLn('PRYWATNY GORYL LIROYA JE BANANA ');
  if Session.Room = World.OldMan then WriteLn('DZIADEK NIESTESTY NIE SKACZE DO GORY JAK KANGURY');
  if Session.Room = World.Reporter then WriteLn('REPORTER UWAZNIE ZAPISUJE WSZYSTKIE WULGARYZMY');
end;

procedure DescribeBeasts;
begin
  if World.Woodworm = Session.Room then WriteLn('KORNIK SZUKA JAKIEGOS DRZEWA ABY COS PRZEKASIC');
  if World.Fly = Session.Room then WriteLn('MUCHA BZYKA SOBIE TO TU TO TAM');
  if World.Bacterium = Session.Room then WriteLn('BAKTERIA KTORA ZOBACZYLES POD MIKROSKOPEM STARA USUNAC CI SIE Z DROGI');
  if World.Snail = Session.Room then WriteLn('SLIMAK KTORY ZOSTAWIA SLUZ POWOLI SUNIE PO PODLODZE');
  if World.Beetle = Session.Room then WriteLn('ZUK KTORY WIDZI CO SIE SWIECI ZWIEWA STAD');
  if World.Cockroach = Session.Room then WriteLn('OHYDNY KARALUCH MA OCHOTE CIE OBRZYDZIC');
  if World.Ant = Session.Room then WriteLn('MROWKA NIESIE TLUSTY PACZEK I SIE CIESZY');
  if World.Spider = Session.Room then WriteLn('PAJAK ZROBIL SIEC NA SCIANIE ARENY');
  if World.Boar = Session.Room then WriteLn('TLUSTY DZICZEK BIEGNIE SOBIE TEDY');
  if World.Rat = Session.Room then WriteLn('JEST TUTAJ SZCZUR,TAK WIELKI ZE WIEKSZEGO NIE WIDZIALES');
  if World.Fox = Session.Room then WriteLn('CHYTRY LIS SZUKA SPOSOBU BY CIE ZABIC');
  if World.Partridge = Session.Room then WriteLn('KUROPATWA PO PROSTU JEST TU');
  if World.Hare = Session.Room then WriteLn('ZAJAC KICA SOBIE SPIEWAJAC "POMYLONE MISIE"');
  if World.Mongrel = Session.Room then WriteLn('CZARNY WILCZUR PO KRZYWEJ SIE TOCZY (MU PIANA Z UST)');
  if World.Eagle = Session.Room then WriteLn('ORZEL SZYBUJE W POWIETRZYU W POSZUKIWANIU OFIARY');
  if World.Deer = Session.Room then WriteLn('SARNA SKASZE SOBIE NIE ZDAJAC SOBIE SPRAWY ZE ZARAZ ZGINIE');
  if World.Elephant = Session.Room then WriteLn('OGROMNIASTY SLON ZGNIATA WSZYSTKO CO NAPOTKA');
  if World.Lion = Session.Room then WriteLn('LEW - KROL ZWIERZAT WLASNIE ZABIJA NIEWINNE DZIECKO ROZWALAJAC JEGO MOZG');
  if World.Giraffe = Session.Room then WriteLn('ZYRAFA KTORA TU STOI NIE SZUKA ZACZEPKI');
  if World.Camel = Session.Room then WriteLn('WIELBLAD KORZYSTA Z GARBOW UZYWAJAC ICH JAKO SMIERTELNEJ BRONI');
  if World.Ostrich = Session.Room then WriteLn('STRUS NIE CHOWA GLOWY W PIASEK BO JEST NA BETONIE');
  if World.Boa = Session.Room then WriteLn('BOA DUSICIEL WLASNIE ZJADL KROWE ');
  if World.Wolf = Session.Room then WriteLn('WILK CHORY NA WSCIEKLIZNE PANOSZY SIE W OKOLICY');
  if World.Bison = Session.Room then WriteLn('NIEWINNY BIZON MORDUJE WLASNIE PUBLICZNOSC');
  if World.Panther = Session.Room then WriteLn('ZWINNA PANTERA NUDZI SIE POLYKAJAC RESZTKI LUDZKIEGO MIESA');
  if World.Gladiator = Session.Room then WriteLn('GLADIATOR ZDOBYWA TUTAJ KUNSZT');
  if World.Warrior = Session.Room then WriteLn('WOJOWNIK GREEN PEACE MORDUJE TUTAJ BEZBRONNE LWIATKA :( ');
  if World.Tamer = Session.Room then WriteLn('TRENER CYRKU LAPIE ZWIERZETA NA SWOJE PRZEDSTAWIENIE');
end;

procedure ShieldBlock;
begin
  Combat.Roll := Random(100);
  if Combat.Roll <= Gear.Armor then begin
    Combat.Damage := Combat.Damage - Gear.WornCount;
    if Combat.Damage < 0 then Combat.Damage := 0;
    WriteLn('OSLONILES SIE ! TRACISZ ', Combat.Damage, ' ENERGII');
  end;
end;

procedure Fight;
begin
  Combat.FightExperience := Combat.FightExperience + FightExpForEnergy(Player.MaxEnergy - Combat.EnemyEnergy);
  Combat.FightExperience := Combat.FightExperience + FightExpForStrength(Player.Strength - Combat.EnemyStrength);
  Combat.FightExperience := Combat.FightExperience + FightExpForDexterity(Player.Dexterity - Combat.EnemyDexterity);

  repeat
    Combat.EnemyDodged := 0;
    Combat.PlayerDodged := 0;
    WriteLn('WALCZYSZ - <<<<TWOJ WROG MA ', Combat.EnemyEnergy, '%>>>><<<< A TY MASZ ', Player.Energy, '% ENERGII>>>>>');
    if Player.Dexterity > Combat.EnemyDexterity then begin
      Combat.DodgeChance := Player.Dexterity - Combat.EnemyDexterity;
      Combat.Roll := Random(DodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn('UNIKASZ CIOSU WROGA TWEGO I SMIEJESZ SIE Z JEGO NIEPORADNOSCI');
        Combat.PlayerDodged := 1;
      end;
      Combat.Roll := Random(EnemyDodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn('PRZECIWNIK UNIKA TWOJEGO LAMERSKIEGO ATAKU');
        Combat.EnemyDodged := 1;
      end;
    end;
    if Combat.EnemyDexterity > Player.Dexterity then begin
      Combat.DodgeChance := Combat.EnemyDexterity - Player.Dexterity;
      Combat.Roll := Random(DodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn('PRZECIWNIK Z GRACJA UNIKA TWEGO CIOSU');
        Combat.EnemyDodged := 1;
      end;
      Combat.Roll := Random(EnemyDodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn('BEZ PARDONU OMIJASZ CIOS TWOJEGO PRZECIWNIKA');
        Combat.PlayerDodged := 1;
      end;
    end;
    if Combat.PlayerDodged = 0 then begin
      Combat.Damage := Random(Combat.EnemyStrength);
      if Combat.Damage < 6 then WriteLn('PRZECIWNIK CIE TYLKO DRASNA I TRACISZ ', Combat.Damage, '% ENERGII');
      if (Combat.Damage > 5) and (Combat.Damage < 21) then WriteLn('DOSTALES I TRACISZ ', Combat.Damage, '% ENERGII');
      if (Combat.Damage > 20) and (Combat.Damage < 51) then WriteLn('PRZECIWNIK !MASAKRUJE! CIEBIE I TRACISZ AZ ', Combat.Damage, '% ENERGII');
      if Combat.Damage > 50 then WriteLn('PRZECIWNIK !!!WYPRUWA FLAKI!!! Z CIEBIE I TRACISZ !!! ', Combat.Damage, '% ENERGII');
      Combat.FightExperience := Combat.FightExperience + 1;
      ShieldBlock;
      if (Skills.Parry > 0) and (Combat.Damage > 0) then begin
        Combat.Roll := Random(140);
        if Combat.Roll <= Skills.Parry then begin
          if Combat.Damage < 3 then begin
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ 0% ENERGI');
            Combat.Damage := 0;
          end;
          if (Combat.Damage > 2) and (Combat.Damage < 10) then begin
            Combat.Damage := Combat.Damage - 2;
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ ', Combat.Damage, '% ENERGI');
          end;
          if Combat.Damage > 9 then begin
            Combat.Damage := Combat.Damage - 3;
            WriteLn('            <<<<<ODPAROWUJESZ ATAK PRZECIWNIKA !!! TRACISZ ', Combat.Damage, '% ENERGI');
          end;
          if (Combat.Roll < 1) and (Skills.Parry < 100) then begin
            WriteLn('*************** UCZYSZ SIE ZDOLNOSCI PAROWANIE !!!!! ***************');
            Skills.Parry := Skills.Parry + 1;
            Combat.FightExperience := Combat.FightExperience + 5;
          end;
        end;
      end;
      Player.Energy := Player.Energy - Combat.Damage;
      if Combat.FireballCharges > 0 then begin
        Combat.Roll := Random(100);
        if Combat.Roll < 10 then begin
          TextColor(14);
          Combat.Roll := Random(20);
          WriteLn('PRZECIWNIK PUSZCZA FIREBALLA W TWYM KIERUNKU - TRACISZ ', Combat.Roll, '% ENERGII');
          Player.Energy := Player.Energy - Combat.Roll;
          Combat.FireballCharges := Combat.FireballCharges - 1;
          TextColor(15);
        end;
      end;
      if Combat.PoisonCharges > 0 then begin
        Combat.Roll := Random(100);
        if Combat.Roll < 10 then begin
          TextColor(4);
          WriteLn('PRZECIWNIK RZUCA CZAR "POISON" ');
          Combat.PoisonCharges := Combat.PoisonCharges - 1;
          TextColor(15);
          Combat.PoisonRounds := Combat.PoisonRounds + 10;
        end;
      end;
      if Combat.PoisonRounds > 0 then begin
        Combat.Roll := Random(5);
        WriteLn('JESTES ZATRUTY - TRACISZ ', Combat.Roll, '% ENERGI');
        Player.Energy := Player.Energy - Combat.Roll;
        Combat.PoisonRounds := Combat.PoisonRounds - 1;
      end;
    end;
    if Combat.EnemyDodged = 0 then begin
      Combat.Damage := Random(Player.Strength);
      if Combat.Damage * 10 < Gear.LuckRoll then begin
        repeat
          Combat.Damage := Random(Player.Strength);
          WriteLn('FUKSROLL FUKSROLL FUKSROLL ! ');
        until (Combat.Damage * 10) > Gear.LuckRoll;
      end;
      Combat.EnemyEnergy := Combat.EnemyEnergy - Combat.Damage;
      if Combat.Damage < 6 then
        WriteLn('MASZ PECHA : LEKKO POPCHNALES GO I STRACIL TYLKO ', Combat.Damage, '% ENERGII');

      if (Combat.Damage > 5) and (Combat.Damage < 21) then
        WriteLn('DOSTAL I STRACIL ', Combat.Damage, '% ENERGII');
      if (Combat.Damage > 20) and (Combat.Damage < 51) then WriteLn(' !MASAKRUJESZ! PRZECIWNIKA I TRACI ON AZ ', Combat.Damage, '% ENERGII');
      if Combat.Damage > 50 then WriteLn(' !!!WYPRUWASZ FLAKI!!! Z PRZECIWNIKA I TRACI ON  !!!! ', Combat.Damage, '% ENERGII');
    end;
    Delay(2000);
    if (Skills.Kick > 0) and (Player.Mana > Skills.KickMinMana) and (Player.Energy < Skills.KickMaxEnergy) then begin
      Combat.Roll := Random(100);
      if Combat.Roll <= Skills.Kick - 10 then begin
        Combat.Roll := Random(10) + Random(Player.Level);
        TextColor(14);
        WriteLn('TWOJ SUPER KOP ZABIERA ', Combat.Roll, '% ENERGI');
        TextColor(15);
        Player.Mana := Player.Mana - Random(3) - 3;
        Combat.EnemyEnergy := Combat.EnemyEnergy - Combat.Roll;
      end else WriteLn('TWOJ SUPER KOP CHYBIA PRZECIWNIKA ');
      Player.Mana := Player.Mana - Random(2) - 2;
    end;
    if (Skills.Fleeing > 0) and (Player.Energy < Skills.FleeEnergy) and (Player.Mana > 14) then begin
      Player.Mana := Player.Mana - 15;
      Combat.Roll := Random(100);
      if Combat.Roll <= Skills.Fleeing then begin
        Combat.Fled := 1;
        WriteLn('WSTYD !!! UCIEKLES Z POLA BITWY TRACISZ 20 KUNSZTU');
        Player.Experience := Player.Experience - 20;
      end else WriteLn('NIE UDALO CI SIE UCIEC !!!! WALCZYSZ DALEJ !!! ');
    end;
  until (Player.Energy < 1) or (Combat.EnemyEnergy < 1) or (Combat.Fled = 1);
  if (Combat.EnemyEnergy < 1) and (Player.Energy > 0) then begin
    if Player.MaxEnergy > 75 then Combat.FightExperience := Combat.FightExperience - 2;
    if Player.MaxEnergy > 115 then Combat.FightExperience := Combat.FightExperience - 3;
    if Skills.Parry > 50 then Combat.FightExperience := Combat.FightExperience - 2;
    if Skills.Parry > 75 then Combat.FightExperience := Combat.FightExperience - 2;
    if Skills.Parry > 95 then Combat.FightExperience := Combat.FightExperience - 1;
    if Skills.Kick > 50 then Combat.FightExperience := Combat.FightExperience - 5;
    if Skills.Kick > 95 then Combat.FightExperience := Combat.FightExperience - 2;
    if Combat.FightExperience < 0 then Combat.FightExperience := 0;
    WriteLn('ZABILES GO ! ZYSKUJESZ ZA TO ', Combat.FightExperience, ' KUNSZTU ');
    Player.Experience := Combat.FightExperience + Player.Experience;
    Combat.FireballCharges := 0;
    Combat.PoisonCharges := 0;

    if World.Quest > 0 then World.QuestKills := World.QuestKills - 1;
    if Skills.Cooking > 0 then begin
      Combat.Roll := Random(100);
      if Skills.Cooking > Combat.Roll then begin
        WriteLn('ROBISZ SOBIE PYSZNY PYSZNY BIGOS Z KAPUSTA Z WROGA');
        Bag.Bigos := Bag.Bigos - 10;
        Bag.Count := Bag.Count + 1;
        if (Combat.Roll < 1) and (Skills.Cooking < 100) then begin
          WriteLn('UCZYSZ SIE ZDOLNOSCI POTRAWKI !!! ');
          Skills.Cooking := Skills.Cooking + 1;
          Player.Experience := Player.Experience + 10;

        end;
      end;
    end;
  end;
  if Player.Energy < 1 then begin
    WriteLn('!!!!!!!!!!!ZOSTALES ZABITY!!!!!!!!!!!!');
    Delay(3000);
    Session.Room := 10000;
  end;
  Combat.FightExperience := 0;
end;

procedure TakeDrop;
begin
  if (Command = 'BIERZ STARY') and (Bag.OldSword = Session.OuterRoom) then begin
    WriteLn('PODNOSISZ STARY ZARDZEWIALY MIECZ I MASZ JAROWE ZE GO POSIADASZ');
    Bag.OldSword := -10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = 'BIERZ MALA') and (Bag.SmallShield = Session.OuterRoom) then begin
    WriteLn('PODNOSISZ MALA TARCZA (JEST OKRAGLA)');
    Bag.SmallShield := -10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = 'BIERZ SERCE') and (Bag.Heart = Session.OuterRoom) then begin
    WriteLn('PODNOSISZ ZAKRWAWIONE SERCE (BLEEEE)');
    Bag.Heart := -10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = 'BIERZ DYPLOM') and (Bag.Diploma = Session.OuterRoom) then begin
    WriteLn('PODNOSISZ DYPLOM MUD SZKOLY , I CZUJESZ PRZEPLYWAJACA PRZEZ CIEBIE MOC');
    Bag.Diploma := -10;
    Player.MaxEnergy := Player.MaxEnergy + 5;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = 'BIERZ FAJKA') and (Bag.Pipe = Session.OuterRoom) then begin
    WriteLn('PODNOSISZ FAJKE ');
    Bag.Pipe := -10;
    Bag.Count := Bag.Count + 1;
    if Player.Wisdom < Player.MaxWisdom then Player.Wisdom := Player.Wisdom + 1;
  end;
  if (Command = 'ODRZUC STARY') and (Bag.OldSword = -10) then begin
    WriteLn('ODRZUCASZ STARY ZARDZEWIALY MIECZ I MASZ JAROWE ZE GO NIE POSIADASZ');
    Bag.OldSword := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = 'ODRZUC FAJKA') and (Bag.Pipe = -10) then begin
    WriteLn('WYRZUCASZ FAJKE ');
    Bag.Pipe := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
    Player.Wisdom := Player.Wisdom - 1;
  end;
  if (Command = 'ODRZUC MALA') and (Bag.SmallShield = -10) then begin
    WriteLn('ODRZUCASZ MALA ZWYKLA TARCZE ');
    Bag.SmallShield := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = 'ODRZUC SERCE') and (Bag.Heart = -10) then begin
    WriteLn('ODRZUCASZ ZAKRWAWIONE SERCE ');
    Bag.Heart := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = 'ODRZUC DYPLOM') and (Bag.Diploma = -10) then begin
    WriteLn('ODRZUCASZ DYPLOM MUD SZKOLY , I PRZESTAJESZ CZUC PRZEPLYWAJACA PRZEZ CIEBIE MOC');
    Bag.Diploma := Session.OuterRoom;
    Player.MaxEnergy := Player.MaxEnergy - 5;
    Bag.Count := Bag.Count - 1;
  end;
end;
procedure UseItems;
begin
  if (Command = 'UZYJ FAJKA') and (Bag.Pipe = -10) then WriteLn('ZAPALASZ FAJECZKE I PYKASZ Z ZADOWOLENIEM');
  if (Command = 'UZYJ SERCE') and (Bag.Heart = -10) then begin
    Bag.Heart := 0;
    WriteLn('ZJADASZ ZAKRWAWIONE SERCE I ODZYSKUJESZ 5% ENERGII');
    Player.Energy := Player.Energy + 5;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = 'UZYJ DYPLOM') and (Bag.Diploma = -10) then begin
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
  if (Command = 'UZYJ PACZEK') and (Bag.Doughnut <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Doughnut := Bag.Doughnut + 10;
    WriteLn('ZJADASZ PACZKA I TYJESZ 1 KILO (DOSTAJESZ 8%ENERGII)');
    Player.Energy := Player.Energy + 8;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = 'UZYJ CIASTKO') and (Bag.Cookie <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Cookie := Bag.Cookie + 10;
    WriteLn('ZJADASZ CIASTKO I TYJESZ 2 KILO (DOSTAJESZ 12% ENERGII)');
    Player.Energy := Player.Energy + 12;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = 'UZYJ SUCHA RACJA') and (Bag.DryRation <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.DryRation := Bag.DryRation + 10;
    WriteLn('ZJADASZ SUCHA RACJE I CHUDNIESZ 3 KILO (DOSTAJESZ 16% ENERGII)');
    Player.Energy := Player.Energy + 16;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = 'UZYJ BULKA') and (Bag.BreadRoll <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.BreadRoll := Bag.BreadRoll + 10;
    WriteLn('ZJADASZ BULKE I STWIERDZASZ ZE ZYSKALES 20%');
    Player.Energy := Player.Energy + 20;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = 'ZNISZCZ PRZEPUSTKA') and (Bag.Permit <= -10) then begin
    WriteLn('GRRRRRRRRR .... GLUPIA PRZEPUSTKA');
    Bag.Permit := Bag.Permit + 10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = 'PATRZ PRZEPUSTKA') and (Bag.Permit <= -10) then begin
    WriteLn('|========================|');
    WriteLn('| Niniejszym zaswiadczam |');
    WriteLn('|  Iz osoba posiadajaca  |');
    WriteLn('|      Ten dokument      |');
    WriteLn('|   Ukonczyla pozytywnie |');
    WriteLn('| Jeden z moich quest'#162'w  |');
    WriteLn('|========================|');
  end;
  if (Command = 'UZYJ CHLEB') and (Bag.Bread <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Bread := Bag.Bread + 10;
    WriteLn('ZJADASZ DUZY CIEPLY CHLEB I JESTES PELEN (ZYSKUJESZ 26%)');
    Player.Energy := Player.Energy + 26;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if Command = 'UZYJ KASETA' then WriteLn('TEN PRZEMIOT JEST TYPU : SMIEC . S.Z -8 MAXE +5 ZRE +1 ');
  if (Command = 'UZYJ WEKA') and (Bag.Sausage <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Sausage := Bag.Sausage + 10;
    WriteLn('ZJADASZ DLUGASNA WEKE I TYJAC 15 KILO ZYSKUJESZ 34%');
    Player.Energy := Player.Energy + 34;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = 'UZYJ MALA BUTELKA MANY') and (Bag.ManaBottle <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.ManaBottle := Bag.ManaBottle + 10;
    WriteLn('WYPIJASZ MALA BUTELKE MANY I ODZYSKUJESZ 30 MANY');
    Player.Mana := Player.Mana + 30;
    if Player.Mana > Player.MaxMana then Player.Mana := Player.MaxMana;
  end;
  if (Command = 'UZYJ BIGOS') and (Bag.Bigos <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Bigos := Bag.Bigos + 10;
    WriteLn('ZJADASZ BIGOS Z WROGA I ODZYSKUJESZ 20% ENERGI');
    Player.Energy := Player.Energy + 20;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;

  end;
  if (Command = 'UZYJ KOMPLET') and (Bag.Tracksuit <= -10) and (Gear.WornGarment = '') then begin
    WriteLn('NAKLADASZ KOMPLET UBRAN FIRMY "SYF"');
    Gear.Armor := Gear.Armor + 7;
    Gear.Wearing := 1;
    Gear.WornGarment := 'SYF';
  end;
  if (Command = 'ODLORZ KOMPLET') and (Bag.Tracksuit <= -10) and (Gear.WornGarment = 'SYF') then begin
    WriteLn('ZDEJMUJESZ KOMPLET UBRAN FIRMY "SYF"');
    Gear.Wearing := 0;
    Gear.Armor := Gear.Armor - 7;
    Gear.WornGarment := '';
  end;
  if (Command = 'UZYJ LISTEK') and (Bag.LuckyLeaf <= -10) then WriteLn('LISTEK JEST TYPU SMIEC MAX PRZEDMIOTOW + 3 ');
  if (Command = 'UZYJ GARNITUR') and (Bag.SpikedSuit <= -10) and (Gear.WornGarment = '') then begin
    WriteLn('NAKLADASZ GARNITUR Z KOLCAMI NA SWE (NIE)WYSPORTOWANE CIALO');
    Gear.Wearing := 1;
    Gear.WornCount := Gear.WornCount + 1;
    Gear.Armor := Gear.Armor + 10;
    Gear.LuckRoll := Gear.LuckRoll + 15;
    Gear.WornGarment := 'GARNITUR';
  end;
  if (Command = 'UZYJ PIGULKA') and (Bag.TeleportPill <= -10) then begin
    WriteLn('WSZYSTKO ZACZYNA WIROWAC , POTEM NAGLY BLYSK I ZNAJDUJESZ SIE W PRZESZLOSCI');
    Bag.TeleportPill := Bag.TeleportPill + 10;
    SpawnMonsters;
    if Player.Wisdom < 10 then begin
      WriteLn('BRAK OBYCIA W POSLUGIWANIU SIE MAGICZNYMI PRZEDMIOTAMI SPRAWIL ZE ');
      WriteLn('ZNACZNIE OPADLES Z SIL I STALES SIE BARDZO ZMECZONY');
      Player.MaxEnergy := Player.MaxEnergy - 1;
      Player.Energy := 1;
      Player.Experience := Player.Experience - 50;
    end;
    if (Player.Wisdom > 9) and (Player.Wisdom < 16) then begin
      WriteLn('MASZ PEWNE OBYCIE W MAGICZNYCH PRZEDMIOTACH ALE MIMO WSZYSTKO');
      WriteLn('OPADLES Z SIL I STALES SIE ZMECZONY');
      Player.Energy := Player.Energy - 40;
      if Player.Energy < 1 then Player.Energy := 1;
      Player.Experience := Player.Experience - 30;
    end;
    if Player.Wisdom > 15 then WriteLn('ZNASZ SIE NA TEGO TYPU PRZEDMIOTACH , WYSZEDLES Z TEGO BEZ SZWANKU');
  end;
  if (Command = 'ODLORZ GARNITUR') and (Bag.SpikedSuit <= -10) and (Gear.WornGarment = 'GARNITUR') then begin
    WriteLn('ZDEJMUJESZ GARNITUR Z KOLCAMI ZE SWEGO (NIE)WYSPORTOWANEGO CIALA');
    Gear.Wearing := 0;
    Gear.WornCount := Gear.WornCount - 1;
    Gear.Armor := Gear.Armor - 10;
    Gear.LuckRoll := Gear.LuckRoll - 15;
    Gear.WornGarment := '';
  end;
end;

procedure DisplayPrefs;
begin
  if Command = 'ZMIEN KOLOR' then begin
    WriteLn('PODAJ LICZBE KOLORU');
    ReadLn(Combat.Roll);
    TextColor(Combat.Roll);
  end;
  if Command = 'ZMIEN TLO' then begin
    WriteLn('PODAJ LICZBE TLA');
    ReadLn(Combat.Roll);
    TextBackground(Combat.Roll);
  end;
end;
procedure ArenaMaze;
begin
  if (Session.Room = 33) or (Session.Room = 34) or (Session.Room = 35) or (Session.Room = 36) or (Session.Room = 37) or
     (Session.Room = 38) or (Session.Room = 39) or (Session.Room = 40) or (Session.Room = 41) or (Session.Room = 42) or
     (Session.Room = 43) or (Session.Room = 44) or (Session.Room = 45) or (Session.Room = 46) or (Session.Room = 47) or
     (Session.Room = 48) or (Session.Room = 49) or (Session.Room = 50) or (Session.Room = 51) or (Session.Room = 52) or
     (Session.Room = 53) or (Session.Room = 54) or (Session.Room = 55) or (Session.Room = 56) or (Session.Room = 57) then
  begin
    Session.InArena := 1;
    WriteLn('JESTES NA ARENIE I CZUJESZ POTRZEBE ZABIJANIA');
    DescribeBeasts;
    repeat
      write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if (Command = 'ZABIJ BAKTERIA') and (Session.Room = World.Bacterium) then
      begin FightWeak;
        World.Bacterium := 0;
        WriteLn('BUUUUU! BIEDNA BAKTERIA ');
      end;
      if (Command = 'ZABIJ SLIMAK') and (Session.Room = World.Snail) then
      begin FightWeak;
        if Combat.Fled = 0 then World.Snail := 0;
      end;
      if (Command = 'ZABIJ KORNIK') and (Session.Room = World.Woodworm) then
      begin FightWeak;
        if Combat.Fled = 0 then World.Woodworm := 0;
      end;
      if (Command = 'ZABIJ MUCHA') and (Session.Room = World.Fly) then
      begin FightWeak;
        if Combat.Fled = 0 then World.Fly := 0;
      end;

      if (Command = 'ZABIJ ZUK') and (Session.Room = World.Beetle) then
      begin FightWeak;
        if Combat.Fled = 0 then World.Beetle := 0;
      end;
      if (Command = 'ZABIJ KARALUCH') and (Session.Room = World.Cockroach) then
      begin FightWeak;
        World.Cockroach := 0;
      end;
      if (Command = 'ZABIJ MROWKA') and (Session.Room = World.Ant) then
      begin FightWeak;
        World.Ant := 0;
      end;
      if (Command = 'ZABIJ PAJAK') and (Session.Room = World.Spider) then
      begin FightWeak;
        World.Spider := 0;
      end;
      if (Command = 'ZABIJ DZIK') and (Session.Room = World.Boar) then
      begin FightWeakish;
        World.Boar := 0;
      end;
      if (Command = 'ZABIJ WILCZUR') and (Session.Room = World.Mongrel) then
      begin WriteLn('WILCZUR PRZYJA PROPOZYCJE Z GODNOSCIA');
        FightWeakish;
        World.Mongrel := 0;
      end;

      if (Command = 'ZABIJ SZCZUR') and (Session.Room = World.Rat) then
      begin FightWeakish;
        World.Rat := 0;
      end;
      if (Command = 'ZABIJ LIS') and (Session.Room = World.Fox) then
      begin FightWeakish;
        World.Fox := 0;
      end;
      if (Command = 'ZABIJ KUROPATWA') and (Session.Room = World.Partridge) then
      begin FightWeakish;
        World.Partridge := 0;
      end;
      if (Command = 'ZABIJ ZAJAC') and (Session.Room = World.Hare) then
      begin FightWeakish;
        World.Hare := 0;
      end;
      if (Command = 'ZABIJ ORZEL') and (Session.Room = World.Eagle) then
      begin FightWeakish;
        World.Eagle := 0;
      end;
      if (Command = 'ZABIJ SARNA') and (Session.Room = World.Deer) then
      begin FightWeakish;
        World.Deer := 0;
      end;
      if (Command = 'ZABIJ SLON') and (Session.Room = World.Elephant) then
      begin FightMedium;
        World.Elephant := 0;
      end;
      if (Command = 'ZABIJ LEW') and (Session.Room = World.Lion) then
      begin FightMedium;
        World.Lion := 0;
      end;
      if (Command = 'ZABIJ ZYRAFA') and (Session.Room = World.Giraffe) then
      begin FightMedium;
        World.Giraffe := 0;
      end;
      if (Command = 'ZABIJ WILK') and (Session.Room = World.Wolf) then
      begin FightMedium;
        World.Wolf := 0;
      end;
      if (Command = 'ZABIJ WIELBLAD') and (Session.Room = World.Camel) then
      begin FightMedium;
        World.Camel := 0;
      end;
      if (Command = 'ZABIJ STRUS') and (Session.Room = World.Ostrich) then
      begin FightMedium;
        World.Ostrich := 0;
      end;
      if (Command = 'ZABIJ BOA') and (Session.Room = World.Boa) then
      begin FightMedium;
        World.Boa := 0;
      end;
      if (Command = 'ZABIJ BIZON') and (Session.Room = World.Bison) then
      begin FightMedium;
        World.Bison := 0;
      end;
      if (Command = 'ZABIJ PANTERA') and (Session.Room = World.Panther) then
      begin FightMedium;
        World.Panther := 0;
      end;
      if (Command = 'ZABIJ GLADIATOR') and (Session.Room = World.Gladiator) then
      begin FightHard;
        World.Gladiator := 0;
        PillGain;
      end;
      if (Command = 'ZABIJ WOJOWNIK') and (Session.Room = World.Warrior) then
      begin FightHard;
        World.Warrior := 0;
        PillGain;
      end;
      if (Command = 'ZABIJ TRENER') and (Session.Room = World.Tamer) then
      begin FightHard;
        World.Tamer := 0;
        SuitGain;
      end;
      if Command = 'EXIT' then begin
        if Session.Room = 33 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLODNIE-WEJSCIE NA ARENE');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (Session.Room = 34) or (Session.Room = 37) or (Session.Room = 38) or (Session.Room = 39) or
                (Session.Room = 42) or (Session.Room = 43) or (Session.Room = 44) or (Session.Room = 48) or
                (Session.Room = 49) then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (Session.Room = 35) or (Session.Room = 36) then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Session.Room = 40 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Session.Room = 41 then begin
          WriteLn('DOSTEPNE WYJSCIA:');
          WriteLn('POLNOC-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
        if (Session.Room = 45) or (Session.Room = 50) or (Session.Room = 54) then begin
          WriteLn('MOZESZ WYJSC NA :');
          WriteLn('POLNOC-ARENA');
          WriteLn('POLODNIE-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if (Session.Room = 46) or (Session.Room = 51) or (Session.Room = 55) then begin
          WriteLn('MOZESZ WYJSC NA :');
          WriteLn('POLNOC-ARENA');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
        if (Session.Room = 47) or (Session.Room = 52) or (Session.Room = 53) then begin
          WriteLn('MOZESZ ISC NA :');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Session.Room = 56 then begin
          WriteLn('DOSTEPNE WYJSCIE:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('ZACHOD-ARENA');
        end;
        if Session.Room = 57 then begin
          WriteLn('DOSTEPNE WYJSCIE:');
          WriteLn('POLODNIE-ARENA');
          WriteLn('WSCHOD-ARENA');
        end;
      end;
      if Command = 'WYJSCIE' then exit;
      if Command = 'POLODNIE' then begin
        Session.InArena := 0;
        if Session.Room = 33 then Session.Room := 32;
        if Session.Room = 34 then Session.Room := 33;
        if (Session.Room = 35) or (Session.Room = 36) or (Session.Room = 40) or (Session.Room = 41) then Session.InArena := 1;
        if Session.Room = 37 then Session.Room := 34;
        if Session.Room = 38 then Session.Room := 35;
        if Session.Room = 39 then Session.Room := 36;
        if Session.Room = 42 then Session.Room := 37;
        if Session.Room = 43 then Session.Room := 38;
        if Session.Room = 44 then Session.Room := 39;
        if Session.Room = 45 then Session.Room := 40;
        if Session.Room = 46 then Session.Room := 41;
        if Session.Room = 47 then Session.Room := 42;
        if Session.Room = 48 then Session.Room := 43;
        if Session.Room = 49 then Session.Room := 44;
        if Session.Room = 50 then Session.Room := 45;
        if Session.Room = 51 then Session.Room := 46;
        if Session.Room = 52 then Session.Room := 48;
        if Session.Room = 53 then Session.Room := 49;
        if Session.Room = 54 then Session.Room := 50;
        if Session.Room = 55 then Session.Room := 51;
        if Session.Room = 56 then Session.Room := 54;
        if Session.Room = 57 then Session.Room := 55;
      end;
      if Command = 'POLNOC' then begin
        Session.InArena := 0;
        if Session.Room = 33 then begin Session.Room := 34; Session.MoveGuard := 1; end;
        if (Session.Room = 34) and (Session.MoveGuard = 0) then begin Session.Room := 37; Session.MoveGuard := 1; end;
        if (Session.Room = 35) and (Session.MoveGuard = 0) then begin Session.Room := 38; Session.MoveGuard := 1; end;
        if (Session.Room = 36) and (Session.MoveGuard = 0) then begin Session.Room := 39; Session.MoveGuard := 1; end;
        if (Session.Room = 37) and (Session.MoveGuard = 0) then begin Session.Room := 42; Session.MoveGuard := 1; end;
        if (Session.Room = 38) and (Session.MoveGuard = 0) then begin Session.Room := 43; Session.MoveGuard := 1; end;
        if (Session.Room = 39) and (Session.MoveGuard = 0) then begin Session.Room := 44; Session.MoveGuard := 1; end;
        if (Session.Room = 40) and (Session.MoveGuard = 0) then begin Session.Room := 45; Session.MoveGuard := 1; end;
        if (Session.Room = 41) and (Session.MoveGuard = 0) then begin Session.Room := 46; Session.MoveGuard := 1; end;
        if (Session.Room = 42) and (Session.MoveGuard = 0) then begin Session.Room := 47; Session.MoveGuard := 1; end;
        if (Session.Room = 43) and (Session.MoveGuard = 0) then begin Session.Room := 48; Session.MoveGuard := 1; end;
        if (Session.Room = 44) and (Session.MoveGuard = 0) then begin Session.Room := 49; Session.MoveGuard := 1; end;
        if (Session.Room = 45) and (Session.MoveGuard = 0) then begin Session.Room := 50; Session.MoveGuard := 1; end;
        if (Session.Room = 46) and (Session.MoveGuard = 0) then begin Session.Room := 51; Session.MoveGuard := 1; end;
        if (Session.Room = 47) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 48) and (Session.MoveGuard = 0) then begin Session.Room := 52; Session.MoveGuard := 1; end;
        if (Session.Room = 49) and (Session.MoveGuard = 0) then begin Session.Room := 53; Session.MoveGuard := 1; end;
        if (Session.Room = 50) and (Session.MoveGuard = 0) then begin Session.Room := 54; Session.MoveGuard := 1; end;
        if (Session.Room = 51) and (Session.MoveGuard = 0) then begin Session.Room := 55; Session.MoveGuard := 1; end;
        if (Session.Room = 52) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 53) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 54) and (Session.MoveGuard = 0) then begin Session.Room := 56; Session.MoveGuard := 1; end;
        if (Session.Room = 55) and (Session.MoveGuard = 0) then begin Session.Room := 57; Session.MoveGuard := 1; end;
        if (Session.Room = 56) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 57) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
      end;
      if Command = 'WSCHOD' then begin
        Session.InArena := 0;
        if (Session.Room = 33) and (Session.MoveGuard = 0) then begin Session.Room := 35; Session.MoveGuard := 1; end;
        if (Session.Room = 34) and (Session.MoveGuard = 0) then begin Session.Room := 38; Session.MoveGuard := 1; end;
        if (Session.Room = 35) and (Session.MoveGuard = 0) then begin Session.Room := 40; Session.MoveGuard := 1; end;
        if (Session.Room = 36) and (Session.MoveGuard = 0) then begin Session.Room := 33; Session.MoveGuard := 1; end;
        if (Session.Room = 37) and (Session.MoveGuard = 0) then begin Session.Room := 43; Session.MoveGuard := 1; end;
        if (Session.Room = 38) and (Session.MoveGuard = 0) then begin Session.Room := 45; Session.MoveGuard := 1; end;
        if (Session.Room = 39) and (Session.MoveGuard = 0) then begin Session.Room := 34; Session.MoveGuard := 1; end;
        if (Session.Room = 40) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 41) and (Session.MoveGuard = 0) then begin Session.Room := 36; Session.MoveGuard := 1; end;
        if (Session.Room = 42) and (Session.MoveGuard = 0) then begin Session.Room := 48; Session.MoveGuard := 1; end;
        if (Session.Room = 43) and (Session.MoveGuard = 0) then begin Session.Room := 50; Session.MoveGuard := 1; end;
        if (Session.Room = 44) and (Session.MoveGuard = 0) then begin Session.Room := 37; Session.MoveGuard := 1; end;
        if (Session.Room = 45) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 46) and (Session.MoveGuard = 0) then begin Session.Room := 39; Session.MoveGuard := 1; end;
        if (Session.Room = 47) and (Session.MoveGuard = 0) then begin Session.Room := 52; Session.MoveGuard := 1; end;
        if (Session.Room = 48) and (Session.MoveGuard = 0) then begin Session.Room := 54; Session.MoveGuard := 1; end;
        if (Session.Room = 49) and (Session.MoveGuard = 0) then begin Session.Room := 42; Session.MoveGuard := 1; end;
        if (Session.Room = 50) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 51) and (Session.MoveGuard = 0) then begin Session.Room := 44; Session.MoveGuard := 1; end;
        if (Session.Room = 52) and (Session.MoveGuard = 0) then begin Session.Room := 56; Session.MoveGuard := 1; end;
        if (Session.Room = 53) and (Session.MoveGuard = 0) then begin Session.Room := 47; Session.MoveGuard := 1; end;
        if (Session.Room = 54) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 55) and (Session.MoveGuard = 0) then begin Session.Room := 49; Session.MoveGuard := 1; end;
        if (Session.Room = 56) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 57) and (Session.MoveGuard = 0) then begin Session.Room := 53; Session.MoveGuard := 1; end;
      end;
      if Command = 'ZACHOD' then begin
        Session.InArena := 0;
        if (Session.Room = 33) and (Session.MoveGuard = 0) then begin Session.Room := 36; Session.MoveGuard := 1; end;
        if (Session.Room = 34) and (Session.MoveGuard = 0) then begin Session.Room := 39; Session.MoveGuard := 1; end;
        if (Session.Room = 35) and (Session.MoveGuard = 0) then begin Session.Room := 33; Session.MoveGuard := 1; end;
        if (Session.Room = 36) and (Session.MoveGuard = 0) then begin Session.Room := 41; Session.MoveGuard := 1; end;
        if (Session.Room = 37) and (Session.MoveGuard = 0) then begin Session.Room := 44; Session.MoveGuard := 1; end;
        if (Session.Room = 38) and (Session.MoveGuard = 0) then begin Session.Room := 34; Session.MoveGuard := 1; end;
        if (Session.Room = 39) and (Session.MoveGuard = 0) then begin Session.Room := 46; Session.MoveGuard := 1; end;
        if (Session.Room = 40) and (Session.MoveGuard = 0) then begin Session.Room := 35; Session.MoveGuard := 1; end;
        if (Session.Room = 41) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 42) and (Session.MoveGuard = 0) then begin Session.Room := 49; Session.MoveGuard := 1; end;
        if (Session.Room = 43) and (Session.MoveGuard = 0) then begin Session.Room := 37; Session.MoveGuard := 1; end;
        if (Session.Room = 44) and (Session.MoveGuard = 0) then begin Session.Room := 51; Session.MoveGuard := 1; end;
        if (Session.Room = 45) and (Session.MoveGuard = 0) then begin Session.Room := 38; Session.MoveGuard := 1; end;
        if (Session.Room = 46) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 47) and (Session.MoveGuard = 0) then begin Session.Room := 53; Session.MoveGuard := 1; end;
        if (Session.Room = 48) and (Session.MoveGuard = 0) then begin Session.Room := 42; Session.MoveGuard := 1; end;
        if (Session.Room = 49) and (Session.MoveGuard = 0) then begin Session.Room := 55; Session.MoveGuard := 1; end;
        if (Session.Room = 50) and (Session.MoveGuard = 0) then begin Session.Room := 43; Session.MoveGuard := 1; end;
        if (Session.Room = 51) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 52) and (Session.MoveGuard = 0) then begin Session.Room := 47; Session.MoveGuard := 1; end;
        if (Session.Room = 53) and (Session.MoveGuard = 0) then begin Session.Room := 57; Session.MoveGuard := 1; end;
        if (Session.Room = 54) and (Session.MoveGuard = 0) then begin Session.Room := 48; Session.MoveGuard := 1; end;
        if (Session.Room = 55) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
        if (Session.Room = 56) and (Session.MoveGuard = 0) then begin Session.Room := 52; Session.MoveGuard := 1; end;
        if (Session.Room = 57) and (Session.MoveGuard = 0) then begin Session.InArena := 1; Session.MoveGuard := 1; end;
      end;
      Session.MoveGuard := 0;
      until (Session.InArena = 0) or (Session.Room = 1000);
  end;
end;
procedure StageFights;
begin
  if (Command = 'ZABIJ PERKUSISTA') and (World.Drummer = Session.Room) then begin
    FightVeryEasy;
    World.Drummer := 0;
    CassetteGain;
  end;
  if (Command = 'ZABIJ GITARZYSTA') and (World.Guitarist = Session.Room) then begin
    FightVeryEasy;
    World.Guitarist := 0;
    CassetteGain;
  end;
  if (Command = 'ZABIJ LIROY') and (World.Liroy = Session.Room) then begin
    FightNotEasy;
    if (Session.Room <> 10000) and (Player.Energy > 0) and (Combat.Fled = 0) then begin
      WriteLn('GRATULACJE !!! ZABILES LIROYA DOSTAJESZ ZA DARMO 30 KASY');
      Player.Money := Player.Money + 30;
      CassetteGain;
      if World.Quest > 1 then World.QuestKills := World.QuestKills - 150;
      World.Liroy := 0;
    end;
  end;
  if (Command = 'ZABIJ ORGANISTA') and (World.Keyboardist = Session.Room) then begin
    FightVeryEasy;
    World.Keyboardist := 0;
    CassetteGain;
  end;
end;
procedure KillPlant(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Session.Room) then begin
    FightVeryEasy;
    Plant := 0;
  end;
end;

procedure KillPlantIfAlive(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Session.Room) then begin
    FightVeryEasy;
    if Player.Energy > 0 then Plant := 0;
  end;
end;

procedure KillPlantEasyIfAlive(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Session.Room) then begin
    FightEasy;
    if Player.Energy > 0 then Plant := 0;
  end;
end;

procedure PlantFights;
begin
  if (Command = 'ZABIJ DUNCAN') and (World.Duncan = Session.Room) then begin
    FightEasy;
    if Combat.EnemyEnergy < 1 then World.Duncan := 0;
  end;
  if (Command = 'SECRET LISTA') and (World.Duncan = Session.Room) then begin
    WriteLn('OTO CO AKTUALNIE MAM DO ZAOFEROWANIA : PAMIETAJ U MNIE TYLKO KUPUJEMY');
    WriteLn('MARCHEWKA Z SADU DUNCANA   : 7000');
    WriteLn('PRZEPUSTKA QUEST-MASTERA   :  400');
    WriteLn('PLECAK                     : 4800');
  end;
  if Command = 'KUP DOKUMENT' then begin if Player.Money > 399 then begin
      WriteLn('OTO PODROBIONA PRZEPUSTKA HE , HE NAWET QUEST-MASTER SIE NIE POKAPUJE');
      Bag.Permit := Bag.Permit - 10;
      Player.Money := Player.Money - 400;
      Bag.Count := Bag.Count + 1; end;
  end;
  if (Command = 'KUP PLECAK') and (World.Duncan = Session.Room) then begin if Player.Money > 4799 then begin
      WriteLn('HE HE HE MILO SIE Z TOBA ROBI INTERESY');
      Player.Money := Player.Money - 4800;
      Bag.Backpack := Bag.Backpack - 10;
      Bag.Count := Bag.Count + 1; end;
  end;
  if (Command = 'ROZMAWIAJ DUNCAN') and (World.Duncan = Session.Room) then begin
    if World.DuncanQuest = 0 then begin
      WriteLn('UCH A COZ TO ZA STRASZNA ROSLINA - PRZELAKL SIE DUNCAN WIDZAC CIEBIE');
      WriteLn('AAA TO JAKIS WAL A NIE ROSLINA , MOWI PO CHWILI,JAK CI SIE NUDZI TO ');
      WriteLn('MOZESZ POMOC MI WYRYWAC CHWASTY , SZCZEGOLNIA ZABOJCZA DLA MOICH MARCHEWECZEK');
      WriteLn('JEST TA WREDNA POKRZYWA , SZKODA ZE TAK JAK INNE POTWORY SIE ODREGENEROWUJE');
      WriteLn('ALE JAK JA ZABIJESZ , POWIEDZMY ... 4 RAZY TO MOZE DA SOBIE SPOKOJ');
      WriteLn('CO CI DAM W ZAMIAN ? TROCHE KUNSZTU , A MOJ STARY PRACUJE NA CZARNYM RYNKU');
      World.DuncanQuest := 75;
    end;
    if World.DuncanQuest <> 0 then
      WriteLn('TO CO ZABIJESZ TE ROSLINY CZY BEDZIEMY TU STAC JAK OSTATNIE LOSIE?');

    if World.DuncanQuest = -125 then begin
      WriteLn('DZIEKI DZIEKI , TO BYLA DOBRA ROBOTA , OD TERAZ MOZESZ PISAC PRZY MNIE :');
      WriteLn('SECRET LISTA , TO MOZE AKURAT BEDE COS MIAL NA ZBYCIU , ADIOS');
      World.DuncanQuest := 0;
      Player.Experience := Player.Experience + 125;
      WriteLn('--------- ZDOBYLES 125 KUNSZTU ------------------------');

    end;
  end;

  KillPlant('ZABIJ SZCZAW', World.Sorrel);
  KillPlant('ZABIJ KONICZYNKA', World.Clover);
  KillPlant('ZABIJ MLECZ', World.SowThistle);
  KillPlant('ZABIJ DMUCHAWIEC', World.Dandelion);

  KillPlantIfAlive('ZABIJ STOKROTKA', World.Daisy);

  KillPlantEasyIfAlive('ZABIJ ROZA', World.Rose);
  KillPlantEasyIfAlive('ZABIJ OSET', World.Thistle);
  KillPlantEasyIfAlive('ZABIJ MALINA', World.Raspberry);
  KillPlantEasyIfAlive('ZABIJ AGREST', World.Gooseberry);
  KillPlantEasyIfAlive('ZABIJ JEZYNA', World.Blackberry);

  if (Command = 'ZABIJ TRAWA') and (World.Grass = Session.Room) then begin
    WriteLn('HA HA HA WOLAJA SETKI LISCI TRAWY - TO BEDZIE WALKA');
    FightHard;
    if Player.Energy > 0 then FightHard;
    if Player.Energy > 0 then FightHard;
    if Player.Energy > 0 then FightHard;
    if (Player.Energy > 0) and (Combat.Fled = 0) then
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

type
  TRace = record
    name: string;
    baseStrength, baseDexterity, baseWisdom: Integer;
    baseMaxStrength, baseMaxDexterity, baseMaxWisdom: Integer;
    MaxManaBonus, MoneyBonus, MaxEnergyBonus, EnergyBonus: Integer;
  end;

  TDexterityLimit = record
    gate: Integer;
    limit: Integer;
  end;

  TCommandHandler = procedure;
  TCommandEntry = record
    cmd: string;
    run: TCommandHandler;
  end;

  TRoomEntry = record
    id: Integer;
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
    (name:'CZLOWIEK'; baseStrength:10; baseDexterity:10; baseWisdom:10;
     baseMaxStrength:15; baseMaxDexterity:15; baseMaxWisdom:15;
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'OLBRZYM'; baseStrength:13; baseDexterity:13; baseWisdom:5;
     baseMaxStrength:20; baseMaxDexterity:20; baseMaxWisdom:7;
     MaxManaBonus:-30; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'NIMFA'; baseStrength:10; baseDexterity:13; baseWisdom:7;
     baseMaxStrength:15; baseMaxDexterity:20; baseMaxWisdom:11;
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'POL-ELF'; baseStrength:6; baseDexterity:16; baseWisdom:8;
     baseMaxStrength:10; baseMaxDexterity:24; baseMaxWisdom:12;
     MaxManaBonus:-20; MoneyBonus:30; MaxEnergyBonus:-5; EnergyBonus:-5),
    (name:'UFOK'; baseStrength:9; baseDexterity:9; baseWisdom:13;
     baseMaxStrength:13; baseMaxDexterity:14; baseMaxWisdom:20;
     MaxManaBonus:50; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:'CZAROMIL'; baseStrength:6; baseDexterity:7; baseWisdom:16;
     baseMaxStrength:9; baseMaxDexterity:11; baseMaxWisdom:25;
     MaxManaBonus:150; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0)
  );

  DexterityItemLimits: array[1..7] of TDexterityLimit = (
    (gate: 0; limit: 10), (gate: 11; limit: 11), (gate: 13; limit: 12),
    (gate: 16; limit: 13), (gate: 19; limit: 14), (gate: 21; limit: 15),
    (gate: 25; limit: 16));

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
    if Player.Dexterity >= DexterityItemLimits[i].gate then begin
      Bag.Limit := DexterityItemLimits[i].limit;
      Break;
    end;
  if Bag.Backpack < 0 then Bag.Limit := Bag.Limit + 4;
  WriteLn('NOSISZ ZE SOBA:');
  ShowItem(Bag.OldSword, 'STARY ZARDZEWIALY MIECZ', 0);
  ShowItem(Bag.SmallShield, 'OKRAGLA MALA TARCZA', 0);
  ShowItem(Bag.Heart, 'ZAKRWAWIONE SERCE', 0);
  ShowItem(Bag.Diploma, 'DYPLOM MUD SZKOLY', 0);
  ShowItem(Bag.Doughnut, 'SMACZNY POLANY LIKIEREM PACZEK', 10);
  ShowItem(Bag.Cookie, 'SMACZNE CIASTKO ', 10);
  ShowItem(Bag.DryRation, 'TWARDA SUCHA RACJE', 10);
  ShowItem(Bag.BreadRoll, 'OKRAGLA PACHNACA BULKA', 10);
  ShowItem(Bag.Bread, 'DUZY CIEPLY CHLEB', 10);
  ShowItem(Bag.Sausage, 'DLUGA I SMACZNA WEKE', 10);
  ShowItem(Bag.Bigos, 'PYSZNY BIGOS Z KAPUSTA Z WROGA', 10);
  ShowItemDiv10(Bag.Beer, 'OZEWIAJACE PIWSKO Z KONKRETNYM KLIMATEM');
  ShowItemPlain(Bag.Pipe, 'CIEZKA FAJKA OD DZIADA MROZA');
  ShowItemPlain(Bag.Tracksuit, 'KOMPLET UBRAN FIRMY "SYF"');
  ShowItemPlain(Bag.SpikedSuit, 'GARNITUR Z KOLCAMI');
  ShowItemPlain(Bag.ManaBottle, 'MALA BUTELKE MANY');
  ShowItemPlain(Bag.LuckyLeaf, 'DELIKATNY CHOC SZORSTKI LISTEK');
  ShowItemPlain(Bag.Cassette, 'KASETA LIROYA : L - JAK LIROY ');
  ShowItemPlain(Bag.TeleportPill, 'PIGULKA TRANSPORTUJACA (M:G) ');
  ShowItemPlain(Bag.Permit, 'PRZEPUSTKA WLASNORECZNIE PODPISANA PRZEZ QUEST-MASTERA ');
  ShowItemPlain(Bag.CompareScroll, 'SCROLL Z CZAREM : POROWNYWANIE ');
  ShowItemPlain(Bag.ReturnScroll, 'SCROLL Z CZAREM : POWROT ');
  WriteLn('W SUMIE MASZ ', Bag.Count, '/', Bag.Limit, ' PRZEDMIOTOW');
  if Gear.WeaponKind = 0 then WriteLn('BIJESZ SIE NA PIESCI');
  if Gear.ShieldKind = 0 then WriteLn('NIE MASZ ZADNEJ OCHRONY');
  if Gear.WornGarment = '' then WriteLn('JESTES NAGI !!!!!!!!');
  if Gear.WornGarment = 'SYF' then WriteLn('MASZ NA SOBIE KOMPLET UBRAN FIRMY "SYF"');
  if Gear.WornGarment = 'GARNITUR' then WriteLn('MASZ NA SOBIE GRANITUR Z KOLCAMI ');
  if (Gear.ShieldKind = 1) and (Bag.SmallShield = -100) then
    WriteLn('TWOJA OCHRONA JEST MALA TARCZA');
  if (Gear.WeaponKind = 1) and (Bag.OldSword = -100) then
    WriteLn('JAKO BRONI UZYWASZ STAREGO MIECZA');
  WriteLn('MASZ ', Player.Money, ' MONET I ', Player.Practice, ' PRAKTYK');

  gap := LevelThreshold(Player.Level) - Player.Experience;
  case Player.Level of
    1: WriteLn('JESTES NA PIERWSZYM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    2: WriteLn('JESTES NA DRUGIM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    3: WriteLn('JESTES NA TRZECIM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, 'KUNSZTU');
    4..8: WriteLn('JESTES NA ', LevelName(Player.Level), ' LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    9..13: WriteLn('JESTES NA ', LevelName(Player.Level), ' LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
  end;
  if Player.Level > 13 then
    WriteLn('JESTES NA BARDZO WYSOKIM LEVELU A DO NASTEPNEGO BRAKUJE CI TYLKO', gap, ' KUNSZTU');

  WriteLn('TWOJE PARAMETRY : SILA - ', Player.Strength, '/', Player.MaxStrength,
         ' ZRECZNOSC - ', Player.Dexterity, '/', Player.MaxDexterity,
         ' MADROSC - ', Player.Wisdom, '/', Player.MaxWisdom);
  Gear.ArmorRating := 10 * Gear.WornCount + Gear.Armor;
  WriteLn('S.Z-', Gear.ArmorRating,
         '                    FUKSROLL-', Gear.LuckRoll);
  WriteLn('MASZ ', Player.Mana, '/', Player.MaxMana, ' MANY');
  WriteLn('MASZ ', Player.Energy, '/', Player.MaxEnergy, ' ENERGII');
  if World.Quest = 1 then WriteLn('TWOJ AKTUALNY QUEST - ZABIC MUSISZ JESZCZE ', World.QuestKills, ' POTWOROW');
  if World.Quest > 1 then WriteLn('TWOJ AKTUALNY QUEST - ZABIC MUSISZ JESZCZE ', World.QuestKills - 150, ' POTWOROW');
  if World.DuncanQuest <> 0 then WriteLn('NIE ZAPOMNIALES O POKRZYWIE W SADACH DUNCANA???');
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
      Player.Strength := Races[chosen].baseStrength;
      Player.Dexterity := Races[chosen].baseDexterity;
      Player.Wisdom := Races[chosen].baseWisdom;
      Player.MaxStrength := Races[chosen].baseMaxStrength;
      Player.MaxDexterity := Races[chosen].baseMaxDexterity;
      Player.MaxWisdom := Races[chosen].baseMaxWisdom;
      Player.MaxMana := Player.MaxMana + Races[chosen].MaxManaBonus;
      Player.Money := Player.Money + Races[chosen].MoneyBonus;
      Player.MaxEnergy := Player.MaxEnergy + Races[chosen].MaxEnergyBonus;
      Player.Energy := Player.Energy + Races[chosen].EnergyBonus;
    end;
  until chosen > 0;
  WriteLn('PODAJE SWE IMIE (I TAK MNIE TO NIE OBCHODZI)');
  ReadLn(Command);
  Player.Energy := 50;
  Player.Practice := 10;
  World.CageWeakling := 12;

  World.CageStrong := 13;
  World.CageAgile := 14;
  World.CageTough := 15;
  World.CageHuge := 16;

  Player.Level := 1;
  Player.MaxMana := Player.MaxMana + 100;
  Player.Mana := Player.MaxMana;
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
  if (Command = cmd) and (Dog = Session.Room) then begin
    FightDog;
    Dog := 0;
    if extraMsg then begin
      WriteLn('GDY NAGLE!!!! NIEBIOSA SIE OTWIERAJA');
      WriteLn('A SPANIEL PRZEMAWIA DO CIEBIE LUDZKIM GLOSEM !!!!!');
      WriteLn('HAU HAU CHAMIE PO CO MNIE ZABILES ??? ');
    end;
  end;
end;

procedure KillTownsfolk(cmd: string; var npc: Integer; suitLoot: Boolean);

begin
  if (Command = cmd) and (npc = Session.Room) then begin
    FightVeryEasy;
    npc := 0;
    if suitLoot then SuitGain;
  end;
end;

procedure KillSweeper;

begin
  if (Command = 'ZABIJ ZAMIATACZ') and (World.Sweeper = Session.Room) then begin
    FightVeryEasy;
    World.Sweeper := 0;
    Combat.Roll := Random(100);
    if (Combat.Roll < 35) and (Bag.Tracksuit = 0) then begin
      WriteLn('ZYSKALES KOMPLET OBRABIAJAC ZAMIATACZA');
      Bag.Tracksuit := Bag.Tracksuit - 10;
    end;
  end;
end;

procedure KillSickMan;

begin
  if (Command = 'ZABIJ ZEBRAK') and (World.SickMan = Session.Room) then begin
    FightVeryEasy;
    if Player.Energy > 0 then begin
      Combat.Roll := Random(10);
      WriteLn('Z GRUBEGO PORTFELA ZEBRAKA WYCIAGASZ BONUS !!! ',
              Combat.Roll, ' MONET!');
      Player.Money := Player.Money + Combat.Roll;
      World.SickMan := 0;
    end;
  end;
end;

procedure StreetFights;

begin

  KillDog('ZABIJ OWCZAREK', World.Shepherd, False);
  KillDog('ZABIJ PIESEK', World.Pooch, False);
  KillDog('ZABIJ JAMNIK', World.Dachshund, False);
  KillDog('ZABIJ SPANIEL', World.Spaniel, True);
  KillDog('ZABIJ PUDEL', World.Poodle, False);

  KillTownsfolk('ZABIJ TAKSOWKARZ', World.Cabman, True);
  KillTownsfolk('ZABIJ SPRZEDAWCA', World.Vendor, True);
  KillSweeper;
  KillTownsfolk('ZABIJ PIJAK', World.Drunkard, False);
  KillSickMan;
end;

procedure Training;

begin
  if Command = 'PATRZ PLAKAT' then begin
    WriteLn('NA PLAKACIE PISZE:');
    WriteLn('MOZESZ CWICZYC UZYWAJAC KOMENDY CWICZ RAZEM Z ');
    if Player.Wisdom < 11 then WriteLn('Z NICZYM BO MASZ ZA MALA MADROSC');
    if (Player.Wisdom > 10) and (Player.Strength > 11) then WriteLn('KOPAC - KOMENDA:KOP ');
    if (Player.Wisdom > 10) and (Player.Dexterity > 10) then WriteLn('UCIEKAC - KOMENDA : ZWIEJ ');
    if (Player.Wisdom > 15) and (Player.Dexterity > 11) then WriteLn('PAROWANIE - SAMOCZYNNIE ');
    if Player.Wisdom > 11 then WriteLn('POROWNANIE-KOMEDA POROWNAJ');
    if Player.Wisdom > 18 then WriteLn('POTRAWKI-SAMOCZYNNIE , PO WALCE');
    if Player.Wisdom > 17 then WriteLn('POWROT-KOMEDA POWROT');
    if Player.Dexterity > 20 then WriteLn('ZRECZNE RECE - KOMENDA : RECE');
    if (Player.Strength > 20) and (Player.Dexterity > 10) then WriteLn('KRZEPA : SAMOCZYNNIE');
    if (Player.Wisdom > 19) and (Player.Dexterity > 10) and (Player.Strength > 10) then
      WriteLn('TARGOWANIE SIE : SAMOCZYNNIE');
    if (Player.Strength > 25) and (Player.Wisdom > 12) then WriteLn('WIROWANIE - SAMOCZYNNIE ');
    if (Player.Strength > 29) and (Player.Wisdom > 14) then WriteLn('FATALITY - SAMOCZYNNIE ');
    if Player.Dexterity > 22 then WriteLn('COMBO - SAMOCZYNNIE ');
    if Player.Dexterity > 28 then WriteLn('SUPER COMBO - SAMOCZYNNIE ');
    if Player.Wisdom > 22 then WriteLn('TRUCIZNA - SAMOCZYNNIE');
    if Player.Wisdom > 23 then WriteLn('UZDRAWIANIE - KOMENDA UZDROW');
    if (Player.Dexterity > 24) and (Player.Wisdom > 14) and (Player.Strength > 14) then
      WriteLn('MOCNY SEN - SAMOCZYNNIE ');
    if Player.Wisdom > 24 then WriteLn('OSLEPIANIE  - KOMEDA OSLEP ');
    if Player.Wisdom > 26 then WriteLn('NEKROMANCJA - SAMOCZYNNIE ');
    if (Player.Strength > 12) and (Player.Wisdom > 19) and (Player.Dexterity > 12) then
      WriteLn('SZAL - KOMEDNA SZAL');
    if (Player.Dexterity > 22) and (Player.Wisdom > 16) then WriteLn('SIATKA - KOMENDA SIATKA');
    if Player.Dexterity > 30 then WriteLn('CIOS W PLECY - KOMENDA CIOS W (COS)');
    if Player.Wisdom > 29 then WriteLn('ROZPALANIE OGNISKA - KOMENDA ROZPAL');
    if Player.Wisdom > 19 then WriteLn('HIPER SPEED - KOMENDA SPEED');
    if (Player.Wisdom > 23) and (Player.Dexterity > 12) then WriteLn('PIECZENIE - KOMENDA PIECZ');
    WriteLn('W STANIE PODSWIADOMOSCI KOMEDA ZDOLNOSCI SPRAWDZI TWE ZDOLNOSCI');
  end;

  if Command = 'CWICZ KOPAC' then
    if (Player.Wisdom > 10) and (Player.Strength > 11) and (Player.Practice > 0) then begin
      Skills.Kick := Skills.Kick + Player.Wisdom;
      Player.Practice := Player.Practice - 1;
      WriteLn('CWICZYSZ KOPANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Skills.Kick,
              '% MASZ ', Player.Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ UCIEKAC' then begin
    if Player.Wisdom > 10 then
      if Player.Dexterity > 10 then
        if (Player.Practice > 0) and (Skills.Fleeing < 85) then begin
          Skills.Fleeing := Skills.Fleeing + Player.Wisdom + Player.Dexterity - 5;
          Player.Practice := Player.Practice - 1;
          WriteLn('CWICZYSZ UCIEKANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Skills.Fleeing,
                  '% MASZ ', Player.Practice, ' PRAKTYK');
        end else
          WriteLn('ALBO MASZ ZA DOBRZE WYTRENOWANE ALBO ZA MALO PRAKTYK');
  end;

  if Command = 'CWICZ POWROT' then
    if (Player.Wisdom > 17) and (Skills.Returning < 90) and (Player.Practice > 0) then begin
      Skills.Returning := Skills.Returning + 2 * Player.Wisdom - 3;
      Player.Practice := Player.Practice - 1;
      WriteLn('CWICZYSZ POWRACANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Skills.Returning,
              '% MASZ ', Player.Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ PAROWANIE' then
    if (Player.Wisdom > 15) and (Player.Dexterity > 11) and (Skills.Parry < 90) and (Player.Practice > 0) then begin
      Skills.Parry := Skills.Parry + Player.Wisdom + Player.Dexterity - 14;
      Player.Practice := Player.Practice - 1;
      WriteLn('CWICZYSZ PAROWANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Skills.Parry,
              '% MASZ ', Player.Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ POROWNANIE' then
    if (Player.Wisdom > 11) and (Skills.Comparing < 90) and (Player.Practice > 0) then begin
      Skills.Comparing := Skills.Comparing + 3 * Player.Wisdom - 9;
      Player.Practice := Player.Practice - 1;
      WriteLn('CWICZYSZ POROWNYWANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Skills.Comparing,
              '% MASZ ', Player.Practice, ' PRAKTYK');
    end;

  if Command = 'CWICZ POTRAWKI' then
    if (Player.Wisdom > 18) and (Skills.Cooking < 90) and (Player.Practice > 0) then begin
      Skills.Cooking := Skills.Cooking + Player.Wisdom + 1;
      Player.Practice := Player.Practice - 1;
      WriteLn('CWICZYSZ POTRAWKI - PRAWDOPODOBIENSTWO JEST TERAZ ', Skills.Cooking,
              '% MASZ ', Player.Practice, ' PRAKTYK');
    end;
end;

procedure SaveCharacter;
begin
  Command := 'JA';
  Session.SavedFlag := 1;
  WriteLn('ALL RIGHT !!! GRA ZAPISANA! ;)');
  ClrScr;
  Assign(Session.SaveFile, 'pliki.tpu');
  Rewrite(Session.SaveFile);
  WriteLn(Session.SaveFile, Player.Mana * 4);
  WriteLn(Session.SaveFile, Player.Level + $17);
  WriteLn(Session.SaveFile, Bag.OldSword);
  WriteLn(Session.SaveFile, Bag.Pipe);
  WriteLn(Session.SaveFile, Bag.Diploma);
  WriteLn(Session.SaveFile, Bag.SmallShield);
  WriteLn(Session.SaveFile, Bag.SpikedSuit);
  WriteLn(Session.SaveFile, Player.Experience);
  WriteLn(Session.SaveFile, (Player.Energy + $28) * 4);
  WriteLn(Session.SaveFile, Session.OuterRoom);
  WriteLn(Session.SaveFile, Player.Dexterity + 12);
  WriteLn(Session.SaveFile, Player.Strength - 24);
  WriteLn(Session.SaveFile, Player.Wisdom);
  WriteLn(Session.SaveFile, Player.Practice);
  WriteLn(Session.SaveFile, Session.CheckpointStage);
  WriteLn(Session.SaveFile, 0);
  WriteLn(Session.SaveFile, 0);
  WriteLn(Session.SaveFile, Player.Money * Player.Wisdom);
  WriteLn(Session.SaveFile, Combat.Loot);
  WriteLn(Session.SaveFile, Player.MaxEnergy);
  WriteLn(Session.SaveFile, Bag.Limit);
  WriteLn(Session.SaveFile, Skills.Comparing);
  WriteLn(Session.SaveFile, Player.MaxMana);
  WriteLn(Session.SaveFile, Player.MaxStrength);
  WriteLn(Session.SaveFile, Player.MaxDexterity);
  WriteLn(Session.SaveFile, Player.MaxWisdom);
  WriteLn(Session.SaveFile, Bag.Count);
  WriteLn(Session.SaveFile, Gear.Armor);
  WriteLn(Session.SaveFile, Gear.LuckRoll);
  WriteLn(Session.SaveFile, Gear.WeaponKind);
  WriteLn(Session.SaveFile, Gear.Wearing);
  WriteLn(Session.SaveFile, Session.Overall);
  WriteLn(Session.SaveFile, Session.SavedFlag);
  WriteLn(Session.SaveFile, World.CageWeakling);
  WriteLn(Session.SaveFile, World.CageStrong);
  WriteLn(Session.SaveFile, World.CageAgile);
  WriteLn(Session.SaveFile, World.CageTough);
  WriteLn(Session.SaveFile, World.CageHuge);
  WriteLn(Session.SaveFile, Gear.ShieldKind);
  WriteLn(Session.SaveFile, Gear.ArmorRating);
  WriteLn(Session.SaveFile, Skills.Cooking);
  WriteLn(Session.SaveFile, Skills.CookingDisplayBug);
  WriteLn(Session.SaveFile, 0);
  WriteLn(Session.SaveFile, Bag.Heart);
  WriteLn(Session.SaveFile, Bag.ManaBottle);
  WriteLn(Session.SaveFile, Bag.Cookie);
  WriteLn(Session.SaveFile, Bag.DryRation);
  WriteLn(Session.SaveFile, Bag.Bread);
  WriteLn(Session.SaveFile, Bag.BreadRoll);
  WriteLn(Session.SaveFile, Bag.Sausage);
  WriteLn(Session.SaveFile, Bag.Bread);
  WriteLn(Session.SaveFile, Bag.BreadRoll);
  WriteLn(Session.SaveFile, Gear.WornCount);
  WriteLn(Session.SaveFile, Skills.Parry);
  WriteLn(Session.SaveFile, Skills.Kick);
  WriteLn(Session.SaveFile, Skills.KickMinMana);
  WriteLn(Session.SaveFile, Skills.KickMaxEnergy);
  WriteLn(Session.SaveFile, Skills.Fleeing);
  WriteLn(Session.SaveFile, Skills.FleeEnergy);
  WriteLn(Session.SaveFile, Combat.Fled);
  WriteLn(Session.SaveFile, Session.InArena);
  WriteLn(Session.SaveFile, Bag.Tracksuit);
  WriteLn(Session.SaveFile, Bag.Cassette);
  WriteLn(Session.SaveFile, Bag.TeleportPill);
  WriteLn(Session.SaveFile, World.Woodworm);
  WriteLn(Session.SaveFile, World.Fly);
  WriteLn(Session.SaveFile, World.Bacterium);
  WriteLn(Session.SaveFile, World.Quest);
  WriteLn(Session.SaveFile, World.QuestKills);
  WriteLn(Session.SaveFile, World.Snail);
  WriteLn(Session.SaveFile, Bag.LuckyLeaf);
  WriteLn(Session.SaveFile, Skills.Returning);
  WriteLn(Session.SaveFile, Bag.Bigos);
  WriteLn(Session.SaveFile, Bag.Beer);
  WriteLn(Session.SaveFile, Bag.CompareScroll);
  WriteLn(Session.SaveFile, Bag.ReturnScroll);
  WriteLn(Session.SaveFile, World.OldElf);
  WriteLn(Session.SaveFile, World.DuncanQuest);
  WriteLn(Session.SaveFile, Bag.Backpack);
  WriteLn(Session.SaveFile, World.Duncan);
  WriteLn(Session.SaveFile, Gear.WornGarment);
  Close(Session.SaveFile);
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
  if World.Quest = 1 then World.QuestKills := 50;
  if World.Quest > 1 then World.QuestKills := 200;
  Player.Energy := Player.MaxEnergy;
  Player.Experience := Player.Experience - 250 + Random(50) - (5 * Player.Level);
  Session.Room := 20;
  SpawnMonsters;
  Command := 'PAMIETAJ';
  ReadLn;
  SaveCharacter;
end;

procedure BuyItem(cmd: string; var Item: Integer; price: Integer;
                  msg: string; available: Boolean);

begin
  if (Command = cmd) and available and (Player.Money >= price) then begin
    Bag.Count := Bag.Count + 1;
    Item := Item - 10;
    Player.Money := Player.Money - price;
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
  BuyItem('KUP PACZEK', Bag.Doughnut, 8, 'KUPUJESZ PACZEK ZA 8 MONET', True);
  BuyItem('KUP CIASTKO', Bag.Cookie, 12, 'KUPUJESZ CIASTKO ZA 12 MONET', True);
  BuyItem('KUP SUCHA RACJA', Bag.DryRation, 15, 'KUPUJESZ SUCHA RACJE ZA 15 MONET', True);
  BuyItem('KUP BULKA', Bag.BreadRoll, 19, 'KUPUJESZ BULKE ZA 19 MONET', True);
  BuyItem('KUP CHLEB', Bag.Bread, 24, 'KUPUJESZ CHLEB ZA 24 MONET', True);
  BuyItem('KUP WEKA', Bag.Sausage, 29, 'KUPUJESZ WEKE ZA 29 MONET', True);
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
  CanBuyOldSword := (Bag.OldSword = 0) and (Player.Money >= 70);
end;

procedure BuyOldSword;
begin
  Bag.Count := Bag.Count + 1;
  Bag.OldSword := -10;
  Player.Money := Player.Money - 70;
  WriteLn('KUPUJESZ ZWYKLY MALY !STARY! MIECZYK ZA 70 MONET');
  Gear.SwordValue := 500;
end;

function CanSellOldSword: Boolean;
begin
  CanSellOldSword := Bag.OldSword = -10;
end;

procedure SellOldSword;
begin
  WriteLn('SPRZEDAWCA MOWI CI : WYPCHAJ SIE Z TYM MIECZEM');
  WriteLn('ALBO DOBRA KUPIE GO OD CIEBIE ZA 30 MONET');
  Player.Money := Player.Money + 30;
  Bag.OldSword := 0;
  Bag.Count := Bag.Count - 1;
end;

function CanBuySmallShield: Boolean;
begin
  CanBuySmallShield := (Bag.SmallShield = 0) and (Player.Money >= 15);
end;

procedure BuySmallShield;
begin
  Bag.Count := Bag.Count + 1;
  Bag.SmallShield := -10;
  Player.Money := Player.Money - 15;
  WriteLn('KUPUJESZ !MALA! TARCZA ZA 15 MONET');
end;

procedure SellSmallShield;

begin
  WriteLn('TA TARCZA JEST BAJER,FRAJER KUPIE JA OD CIEBIE ZA 8 MONET');
  Player.Money := Player.Money + 8;
  Bag.SmallShield := 0;
  Bag.Count := Bag.Count - 1;
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
  CanBuyPipe := (Bag.Pipe = 0) and (Player.Money >= 480);
end;

procedure BuyPipe;
begin
  WriteLn('KUPUJESZ FAJKE ZA 480 MONET');
  Player.Money := Player.Money - 480;
  Bag.Pipe := Bag.Pipe - 10;
  Bag.Count := Bag.Count + 1;
  Player.Wisdom := Player.Wisdom + 1;
end;

function CanBuyTracksuit: Boolean;
begin
  CanBuyTracksuit := (Bag.Tracksuit = 0) and (Player.Money >= 35);
end;

procedure BuyTracksuit;
begin
  WriteLn('KUPUJESZ !KOMPLET! UBRAN FIRMY "SYF" ZA 35 MONET');
  Player.Money := Player.Money - 35;
  Bag.Tracksuit := Bag.Tracksuit - 10;
  Bag.Count := Bag.Count + 1;
end;

function CanSellTracksuit: Boolean;
begin
  CanSellTracksuit := (Bag.Tracksuit <= -10) and (Gear.WornGarment <> 'SYF');
end;

procedure SellTracksuit;
begin
  WriteLn('SPRZEDAJESZ !KOMPLET! UBRAN FIRMY "SYF" ZA 15 MONET');
  Player.Money := Player.Money + 15;
  Bag.Tracksuit := Bag.Tracksuit + 10;
  Bag.Count := Bag.Count - 1;
end;

function CanSellPipe: Boolean;
begin
  CanSellPipe := Bag.Pipe = -10;
end;

procedure SellPipe;
begin
  WriteLn('SPRZEDAJESZ FAJKE ZA 120 MONET');
  Player.Money := Player.Money + 120;
  Bag.Pipe := Bag.Pipe + 10;
  Bag.Count := Bag.Count - 1;
  Player.Wisdom := Player.Wisdom - 1;
end;

function CanBuyCassette: Boolean;
begin
  CanBuyCassette := Player.Money >= 1999;
end;

procedure BuyCassette;
begin
  WriteLn('KUPUJESZ KASETE LIROYA - L JAK LIROY ZA 1999 MONET');
  Player.Money := Player.Money - 1999;
  Bag.Cassette := Bag.Cassette - 10;
  Gear.Armor := Gear.Armor - 8;
  Player.MaxEnergy := Player.MaxEnergy + 5;
  Player.Dexterity := Player.Dexterity + 1;
  Bag.Count := Bag.Count + 1;
end;

function CanBuySpikedSuit: Boolean;
begin
  CanBuySpikedSuit := Player.Money >= 1000;
end;

procedure BuySpikedSuit;
begin
  WriteLn('KUPUJESZ GARNITUR Z KOLCAMI ZA JEDYNE 1000 $');
  Player.Money := Player.Money - 1000;
  Bag.SpikedSuit := Bag.SpikedSuit - 10;
  Bag.Count := Bag.Count + 1;
end;

function CanSellSpikedSuit: Boolean;
begin
  CanSellSpikedSuit := Gear.WornGarment <> 'GARNITUR';
end;

procedure SellSpikedSuit;
begin
  WriteLn('SPRZEDAJESZ GARNITUR Z KOLCAMI ZA JEDYNE 500 $');
  Player.Money := Player.Money + 500;
  Bag.SpikedSuit := Bag.SpikedSuit + 10;
  Bag.Count := Bag.Count - 1;
end;

function CanSellCassette: Boolean;
begin
  CanSellCassette := Bag.Cassette < 0;
end;

procedure SellCassette;
begin
  WriteLn('SPRZEDAJESZ KASETE LIROYA - L JAK LIROY ZA 1000 MONET');
  Player.Money := Player.Money + 1000;
  Bag.Cassette := Bag.Cassette + 10;
  Gear.Armor := Gear.Armor + 8;
  Player.MaxEnergy := Player.MaxEnergy - 5;
  Player.Dexterity := Player.Dexterity - 1;
  Bag.Count := Bag.Count - 1;
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
  CanBuyManaBottle := Player.Money >= 15;
end;

procedure BuyManaBottle;
begin
  WriteLn('KUPUJESZ MALA BUTELKA MANY ZA 20 MONET ( AHHHH TA INFLACJA ) ');
  Player.Money := Player.Money - 20;
  Bag.ManaBottle := Bag.ManaBottle - 10;
  Bag.Count := Bag.Count + 1;
end;

function CanBuyLuckyLeaf: Boolean;
begin
  CanBuyLuckyLeaf := Player.Money >= 820;
end;

procedure BuyLuckyLeaf;
begin
  WriteLn('KUPUJESZ LISTEK KTORY PRZYNOSCI SZCZESCIE ZA 820 KESZU');
  Player.Money := Player.Money - 830;
  Bag.LuckyLeaf := Bag.LuckyLeaf - 10;
  Bag.Count := Bag.Count + 1;
  Player.MaxMana := Player.MaxMana + 40;
end;

function CanSellLuckyLeaf: Boolean;
begin
  CanSellLuckyLeaf := Player.Money >= 820;
end;

procedure SellLuckyLeaf;
begin
  WriteLn('SPRZEDAJESZ LISTEK ZA 400 !!! CIESZ SIE');
  Player.Money := Player.Money + 400;
  Bag.LuckyLeaf := Bag.LuckyLeaf + 10;
  Bag.Count := Bag.Count - 1;
  Player.MaxMana := Player.MaxMana - 40;
end;

function CanBuyTeleportPill: Boolean;
begin
  CanBuyTeleportPill := Player.Money >= 235;
end;

procedure BuyTeleportPill;
begin
  WriteLn('KUPUJESZ PIGULKE TRANSPORTUJACA ZA 235 MONET');
  Player.Money := Player.Money - 235;
  Bag.TeleportPill := Bag.TeleportPill - 10;
  Bag.Count := Bag.Count + 1;
end;

function CanSellTeleportPill: Boolean;
begin
  CanSellTeleportPill := Bag.TeleportPill <= 10;
end;

procedure SellTeleportPill;
begin
  WriteLn('SPRZEDAWCA KUPUJE OD CIEBIE PIGULKE ZA 170 MONET');
  Player.Money := Player.Money + 170;
  Bag.TeleportPill := Bag.TeleportPill + 10;
  Bag.Count := Bag.Count - 1;
end;

function CanBuyCompareScroll: Boolean;
begin
  CanBuyCompareScroll := Player.Money > 39;
end;

procedure BuyCompareScroll;
begin
  WriteLn('SPRZEDAWCA SPRZEDAJE CI SCROLL ZA 40 MONET');
  Player.Money := Player.Money - 40;
  Bag.CompareScroll := Bag.CompareScroll - 10;
  Bag.Count := Bag.Count + 1;
end;

function CanSellCompareScroll: Boolean;
begin
  CanSellCompareScroll := Bag.CompareScroll < 0;
end;

procedure SellCompareScroll;
begin
  WriteLn('SPRZEDAWCA KUPUJE OD CIEBIE SCROLL ZA NEDZNE 18 MONET');
  Player.Money := Player.Money + 18;
  Bag.CompareScroll := Bag.CompareScroll + 10;
  Bag.Count := Bag.Count - 1;
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
    if Bag.OldSword = 0 then
      WriteLn('!STARY! MIECZ           :   70  10%-50%');
    if Bag.SmallShield = 0 then
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
    if Bag.Pipe = 0 then WriteLn('FAJKA                      :  480');
    if Bag.Tracksuit = 0 then
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
  if (Command = 'ZABIJ DZIECKO') and (World.Kid = Session.Room) then begin
    FightWeakish;
    if Combat.EnemyEnergy < 1 then World.Kid := 0;
  end;
  if (Command = 'ZABIJ DZIADEK') and (World.OldMan = Session.Room) then begin
    FightWeakish;
    if Combat.EnemyEnergy < 1 then begin
      World.OldMan := 0;
      Combat.Roll := Random(100);
      if (Combat.Roll < 5) and (Bag.Pipe = 0) then begin
        WriteLn('WYCIAGASZ FAJKE Z UST DZIADKA ');
        WriteLn('TEN PRZEDMIOT JEST UNIQE 5%');
        Bag.Pipe := Bag.Pipe - 10;
        Player.Wisdom := Player.Wisdom + 1;
      end;
    end;
  end;
  if (Command = 'ZABIJ WARIAT') and (World.Lunatic = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Lunatic := 0;
  end;
  if (Command = 'ZABIJ SLUCHACZ') and (World.Listener = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Listener := 0;
  end;
  if (Command = 'ZABIJ CZLOWIEK') and (World.Man = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Man := 0;
  end;
  if (Command = 'ZABIJ FAN') and (World.Fan = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Fan := 0;
  end;
  if (Command = 'ZABIJ REPORTER') and (World.Reporter = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Reporter := 0;
  end;
  if (Command = 'ZABIJ POLICJANT') and (World.Policeman = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Policeman := 0;
  end;
  if (Command = 'ZABIJ GORYL') and (World.Gorilla = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Gorilla := 0;
    SuitGain;
  end;
  if (Command = 'ZABIJ OCHRONIARZ') and
     (World.Bouncer = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Bouncer := 0;
    SuitGain;
  end;
end;

procedure Checkpoints;

begin
  if (Player.Experience >= 400) and (Session.CheckpointStage = 0) and (Player.Strength < 20) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    Session.CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Player.Experience >= 180) and (Session.CheckpointStage = 0) and (Player.Strength < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    Session.CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Player.Experience >= 360) and (Session.CheckpointStage = 1) and (Player.Strength < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    Session.CheckpointStage := 2;
    SpawnMonsters;
  end;
  if (Player.Experience >= 540) and (Session.CheckpointStage = 2) and (Player.Strength < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    Session.CheckpointStage := 3;
    SpawnMonsters;
  end;
  if (Player.Experience >= 300) and (Session.CheckpointStage = 0) and (Player.Strength > 7) and (Player.Strength < 13) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    Session.CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Player.Experience >= 500) and (Session.CheckpointStage = 1) and (Player.Strength > 7) and (Player.Strength < 13) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    Session.CheckpointStage := 2;
    SpawnMonsters;
  end;
end;

procedure Room2;

begin
  if Session.Room <> 2 then Exit;
  WriteLn('JESTES W POKOJU GDZIE RAMBO TRENUJE SWYCH UCZNOW ');
  WriteLn('WSZ'#168'DZIE S'#164' PRZEDMIOTY DO R'#224#189'NYCH RODZAJI '#143'WICZE'#227);
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-POK'#224'J CENTRALNY');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'ZACHOD' then Session.Room := 1;
    if Command = 'PATRZ PLAKAT' then begin
      WriteLn(#169' NA PLAKACIE PISZE:');
      WriteLn('ABY TRENOWA'#143' U'#189'YJ KOM'#168'DY TRENUJ RAZEM Z ');
      WriteLn('SILA , ZRECZNOSC  LUB MADROSC ');
    end;
    HandleTrain;
  until Session.Room <> 2;
end;

procedure Room3;

begin
  if Session.Room <> 3 then Exit;
  WriteLn('ZSZEDLES NA DOL GDZIE TRENUJE SIE MEDYTUJAC');
  WriteLn('NA SRODKU NA WIELKI MATERAC PRZEZNACZONY DO MEDYTACJI');
  WriteLn('NA SCIANCE JEST PIEKNIUTKI PLAKAT');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then
      WriteLn('DOSTEPNE WYJSCIE-GORA-HALA GLOWNA MUD SZKOLE ');
    if Command = 'WYJSCIE' then Exit;
    if Command = 'GORA' then Session.Room := 1;
    Training;
  until Session.Room <> 3;
end;

procedure Room9;

begin
  WriteLn('JESTES W MALUTKIM POKOJU ALE WIDZISZ WYJSCIA W DWIE STRONY ');
  WriteLn('SKADS SLYSZYSZ DZIWNE NIEPOKOJACE WRZASKI');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('DOL-MUD SZKOLA (2)');
      WriteLn('GORA-KLATKI PELNE GAJDY');
    end;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'DOL' then Session.Room := 5;
    if Command = 'GORA' then Session.Room := 11;
  until Session.Room <> 9;
end;

procedure Room12;

begin
  if Session.Room <> 12 then Exit;
  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if World.CageWeakling = 12 then
    WriteLn('POTWOR - CIENIAS STOI NA 1 NODZE POD SCIANA');
  if World.CageWeakling = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then Exit;
    if Command = 'ZACHOD' then Session.Room := 11;
    if (Command = 'ZABIJ POTWOR') and (World.CageWeakling = 12) then begin
      Combat.EnemyEnergy := 20; Combat.EnemyDexterity := 3; Combat.EnemyStrength := 3;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageWeakling := 0;
        Combat.Loot := Random(10);
        WriteLn('WYCIAGASZ ', Combat.Loot, ' MONET Z CIALA POTWORA');
        Player.Money := Player.Money + Combat.Loot;
        if Bag.OldSword = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 4 then begin
            Bag.OldSword := Session.Room;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            Gear.SwordValue := 500;
          end;
        end;
        if Bag.SmallShield = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 4 then begin
            Bag.SmallShield := Session.Room;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            Gear.ShieldValue := 300;
          end;
        end;
        if Bag.Heart = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 6 then begin
            Bag.Heart := Session.Room;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            Gear.HeartValue := 50;
          end;
        end;
      end
      else
        Combat.Fled := 0;
    end;
  until Session.Room <> 12;
end;

procedure ConcertRooms;

begin
  if Session.Room = 61 then begin

    WriteLn('KIEDY PODSZEDLES BLIZEJ ZBARANIALES - TO SALA KONCERTOWA !!!');
    WriteLn('WOKOLO TLUMY SLUCHAJA MUZYKI , DZIWNA TO MUZYKA - WLASCIWIE SAME SLOWA');
    WriteLn('!!!!!!!!!NA SCIANIE JEST PLAKAT !!!!!!!!!!!!!!!');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
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
      if Command = 'ZACHOD' then Session.Room := 60;
      if Command = 'POLNOC' then Session.Room := 63;
      if Command = 'POLODNIE' then Session.Room := 62;
      if Command = 'WSCHOD' then Session.Room := 64;
      if Command = 'PATRZ PLAKAT' then begin
        WriteLn(' NA PLAKACIE PISZE :');
        WriteLn('20 X 98 r KONCERT LIROYA - ZAPRASZAMY WSZYSTKICH  ');
      end;
    until Session.Room <> 61;
  end;
  if Session.Room = 62 then begin

    WriteLn('NA BRZEGACH TLUM JEST MNIEJSZY , MIMO TO UCZUCIE SCISKU IRYTUJE CIE');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
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
      if Command = 'POLNOC' then Session.Room := 61;
      if Command = 'WSCHOD' then Session.Room := 65;
    until Session.Room <> 62;
  end;
  if Session.Room = 63 then begin

    WriteLn('NA BRZEGACH TLUM JEST RZADSZY , BOISZ SIE POMYSLEC CO SIE DZIEJE W SRODKU');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
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
      if Command = 'POLODNIE' then Session.Room := 61;
      if Command = 'WSCHOD' then Session.Room := 66;
      if Command = 'POLNOC' then Session.Room := 67;
    until Session.Room <> 63;
  end;
  if Session.Room = 64 then begin

    WriteLn('JESTES W SRODKU TLUMU A DO TEGO PRZY BALUSTRADKACH-CO ZA TLOK');
    WriteLn('NIE MOZNA ODDYCHAC W TAKIM TLUMIE - LEPIEJ SZYBKO Z TAD IDZ');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
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
      if Command = 'POLNOC' then Session.Room := 66;
      if Command = 'ZACHOD' then Session.Room := 61;
      if Command = 'POLODNIE' then Session.Room := 65;
    until Session.Room <> 64;
  end;
  if Session.Room = 65 then begin

    WriteLn('JESTES Z BOKU ALE PRZY BALUSTRADKACH LUDZIE WPYCHAJA CIE NA TE BALUSTRADKI');
    WriteLn('NIE MOZNA ODDYCHAC W TAKIM TLUMIE - LEPIEJ SZYBKO Z TAD IDZ');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
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
      if Command = 'POLNOC' then Session.Room := 64;
      if Command = 'ZACHOD' then Session.Room := 62;
    until Session.Room <> 65;
  end;
  if Session.Room = 66 then begin

    WriteLn('JESTES PRZY BALUSTRADKACH-NIE BEDE SIE ROZWODZIL JAK CI JEST CIASNO');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
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
      if Command = 'POLODNIE' then Session.Room := 64;
      if Command = 'ZACHOD' then Session.Room := 63;
    until Session.Room <> 66;
  end;
  if Session.Room = 67 then begin

    WriteLn('JESTES W PIWIARNI - WOKOLO CIEBIE UNOSI SIE ZAPACH PIWA , TY NIE PIJASZ PIWA');
    WriteLn('TY PIJASZ JABOLA !!! , NIE REZYGNUJAC ZE SWYCH PRZYZWYCZAJEN ROZGLADASZ SIE:');
    if World.Minibarman = 67 then
      WriteLn('I WIDZISZ MINI-BARMANA SPIESZACEGO SIE ABY PODAC WSZYSTKIM NAWARZONE PIWO');
    if World.Fatso = 67 then
      WriteLn('I WIDZISZ GRUBASA KTORY PO WYPICIU 18 PIW WYRAZNIE MA PEWNE OBJAWY SPICIA');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);
      ExpandAbbrev;
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('WSCHOD-WEJSCIE NA ESTRADE');
        WriteLn('POLODNIE-TLUM');
      end;
      ConcertFights;
      if (Command = 'ZABIJ MINI-BARMAN') and (World.Minibarman = 67) then begin
        WriteLn('---------------  ROUND ONE --------------------');
        WriteLn('----------------  FIGHT -----------------------');
        FightVeryHard;
        if Player.Energy > 0 then begin
          World.Minibarman := 0;
          Combat.Roll := Random(100);
          if Combat.Roll < 15 then begin
            WriteLn('Z CIALA MINI-BARMANA WYCIAGASZ NAPOJ BOGOW : PIWO !!!');
            Bag.Beer := Bag.Beer - 10;
            Bag.Count := Bag.Count + 1;
          end;
        end;
      end;
      if (Command = 'ZABIJ GRUBAS') and (World.Fatso = 67) then begin
        FightVeryHard;
        if Player.Energy > 0 then begin
          World.Fatso := 0;
          if Combat.Roll < 15 then begin
            WriteLn('Z CIALA GRUBASA WYCIAGASZ NAPOJ BOGOW : PIWO !!!');
            Bag.Beer := Bag.Beer - 10;
            Bag.Count := Bag.Count + 1;
          end;
        end;
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLODNIE' then Session.Room := 63;
      if Command = 'WSCHOD' then Session.Room := 68;
    until Session.Room <> 67;
  end;
  if Session.Room = 68 then begin

    WriteLn('TO JEST WEJSCIE NA SCENE NA KTOREJ TANCZY LIROY - UWAZAJ');
    WriteLn('NA SCIANIE WISI !!!TABLICZKA!!!');
    DescribeCrowd;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
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
      if Command = 'ZACHOD' then Session.Room := 67;
      if Command = 'WSCHOD' then Session.Room := 69;
      if Command = 'PATRZ TABLICZKA' then
        WriteLn('*** NIE UPOWAZNIONYM WSTEP WZBRONIONY *** ');
    until Session.Room <> 68;
  end;
  if Session.Room = 69 then begin

    WriteLn('JESTES NA SCENIE , WLASCIWIE TO DOPIERO POCZATEK SCENY');
    WriteLn('WLASCIWIE JESTES JESZCZE ZA KULISAMI BO WIDZOWIE CIE NIE WIDZA');
    if World.DJ = 69 then
      WriteLn('D.J PILNUJE ABY WSZYSTKO PRZEBIEGALO ZGODNIE Z PLAYBACKIEM');
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-WEJSCIE NA SCENE');
        WriteLn('POLODNIE-SCENA');
      end;
      if Command = 'ZABIJ D.J' then begin
        if World.DJ = 69 then begin
          FightVeryHard;
          if Combat.EnemyEnergy < 0 then begin
            World.DJ := 0;
            Combat.Roll := Random(100);
            if Combat.Roll < 25 then begin
              WriteLn('WYCIAGASZ SUCHA RACJA Z CIALA D.J-a');
              Bag.DryRation := Bag.DryRation - 10;
              Bag.Count := Bag.Count + 1;
            end;
            if Combat.Roll < 3 then begin
              WriteLn('WYCIAGASZ KASETE LIROYA Z CIALA D.J-a');
              WriteLn('!!! PRZEDMIOT UNIQE 3% !!!');
              Bag.Cassette := Bag.Cassette - 10;
              Player.MaxEnergy := Player.MaxEnergy + 5;
              Gear.Armor := Gear.Armor - 8;
              Bag.Count := Bag.Count + 1;
              Player.Dexterity := Player.Dexterity + 1;
            end;
          end;
        end;
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'ZACHOD' then Session.Room := 68;
      if Command = 'POLODNIE' then Session.Room := 70;
    until Session.Room <> 69;
  end;
  if Session.Room = 70 then begin

    WriteLn('ALL RIGHT JESTES NA SCENIE !!! NA TWOJ WIDOK OCHRONIAZE COS MAMROCZA');
    WriteLn('TLUMY CIE PRAKTYCZNIE NIE ZAUWAZAJA BO ICH OCZY SKIEROWANE SA NA LIROYA');
    WriteLn('GDY NAGLE WSROD TLUMU ZAUWAZASZ NIEZLA LALE,JEDNAK ONA KOCHA LIROYA :(');
    DescribeStage;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SCENA');
        WriteLn('POLODNIE-SRODEK SCENY');
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Session.Room := 69;
      if Command = 'POLODNIE' then Session.Room := 71;
      StageFights;
    until Session.Room <> 70;
  end;
  if Session.Room = 71 then begin

    WriteLn('LUDZIE SIE NA CIEBIE GAPIA , JESTES NA SRODKU SCENY !!! KTOS CI MOWI:');
    WriteLn('HEY MAN IT,S COOL YEAH! . A TY NA TO: JE JE KUP KUL....');
    DescribeStage;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SCENA');
        WriteLn('POLODNIE-SCENA');
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Session.Room := 70;
      if Command = 'POLODNIE' then Session.Room := 72;
      StageFights;
    until Session.Room <> 71;
  end;
  if Session.Room = 72 then begin

    WriteLn('UFFF PRZEBIEGLES PRZEZ SRODEK SCENY WIEC TREMA CIE JUZ NIE DRECZY');
    WriteLn('DALEJ PISAC NIE MA O CZYM WIEC MOZESZ MI NASKOCZYC ');
    DescribeStage;
    repeat
      Write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);
      if Command = 'MODE' then EnterTrance;
      if Command = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SRODEK SCENY');
      end;
      if Command = 'WYJSCIE' then Exit;
      if Command = 'POLNOC' then Session.Room := 71;
      StageFights;
    until Session.Room <> 72;
  end;
end;

procedure LoadCharacter;
var
  dummy: Integer;
begin
  ReadLn(Command);
  Assign(Session.SaveFile, 'pliki.tpu');
  Reset(Session.SaveFile);
  Read(Session.SaveFile, Player.Mana);
  Player.Mana := Player.Mana div 4;
  Read(Session.SaveFile, Player.Level);
  Player.Level := Player.Level - $17;
  Read(Session.SaveFile, Bag.OldSword);
  Read(Session.SaveFile, Bag.Pipe);
  Read(Session.SaveFile, Bag.Diploma);
  Read(Session.SaveFile, Bag.SmallShield);
  Read(Session.SaveFile, Bag.SpikedSuit);
  Read(Session.SaveFile, Player.Experience);
  Read(Session.SaveFile, Player.Energy);
  Player.Energy := Player.Energy div 4;
  Player.Energy := Player.Energy - $28;
  Read(Session.SaveFile, Session.OuterRoom);
  Read(Session.SaveFile, Player.Dexterity);
  Player.Dexterity := Player.Dexterity - 12;
  Read(Session.SaveFile, Player.Strength);
  Player.Strength := Player.Strength + 24;
  Read(Session.SaveFile, Player.Wisdom);
  Read(Session.SaveFile, Player.Practice);
  Read(Session.SaveFile, Session.CheckpointStage);
  Read(Session.SaveFile, dummy);
  Read(Session.SaveFile, dummy);
  Read(Session.SaveFile, Player.Money);
  Player.Money := Player.Money div Player.Wisdom;
  Read(Session.SaveFile, Combat.Loot);
  Read(Session.SaveFile, Player.MaxEnergy);
  Read(Session.SaveFile, Bag.Limit);
  Read(Session.SaveFile, Skills.Comparing);
  Read(Session.SaveFile, Player.MaxMana);
  Read(Session.SaveFile, Player.MaxStrength);
  Read(Session.SaveFile, Player.MaxDexterity);
  Read(Session.SaveFile, Player.MaxWisdom);
  Read(Session.SaveFile, Bag.Count);
  Read(Session.SaveFile, Gear.Armor);
  Read(Session.SaveFile, Gear.LuckRoll);
  Read(Session.SaveFile, Gear.WeaponKind);
  Read(Session.SaveFile, Gear.Wearing);
  Read(Session.SaveFile, Session.Overall);
  Read(Session.SaveFile, Session.SavedFlag);
  Read(Session.SaveFile, World.CageWeakling);
  Read(Session.SaveFile, World.CageStrong);
  Read(Session.SaveFile, World.CageAgile);
  Read(Session.SaveFile, World.CageTough);
  Read(Session.SaveFile, World.CageHuge);
  Read(Session.SaveFile, Gear.ShieldKind);
  Read(Session.SaveFile, Gear.ArmorRating);
  Read(Session.SaveFile, Skills.Cooking);
  Read(Session.SaveFile, Skills.CookingDisplayBug);
  Read(Session.SaveFile, dummy);
  Read(Session.SaveFile, Bag.Heart);
  Read(Session.SaveFile, Bag.ManaBottle);
  Read(Session.SaveFile, Bag.Cookie);
  Read(Session.SaveFile, Bag.DryRation);
  Read(Session.SaveFile, Bag.Bread);
  Read(Session.SaveFile, Bag.BreadRoll);
  Read(Session.SaveFile, Bag.Sausage);
  Read(Session.SaveFile, Bag.Bread);
  Read(Session.SaveFile, Bag.BreadRoll);
  Read(Session.SaveFile, Gear.WornCount);
  Read(Session.SaveFile, Skills.Parry);
  Read(Session.SaveFile, Skills.Kick);
  Read(Session.SaveFile, Skills.KickMinMana);
  Read(Session.SaveFile, Skills.KickMaxEnergy);
  Read(Session.SaveFile, Skills.Fleeing);
  Read(Session.SaveFile, Skills.FleeEnergy);
  Read(Session.SaveFile, Combat.Fled);
  Read(Session.SaveFile, Session.InArena);
  Read(Session.SaveFile, Bag.Tracksuit);
  Read(Session.SaveFile, Bag.Cassette);
  Read(Session.SaveFile, Bag.TeleportPill);
  Read(Session.SaveFile, World.Woodworm);
  Read(Session.SaveFile, World.Fly);
  Read(Session.SaveFile, World.Bacterium);
  Read(Session.SaveFile, World.Quest);
  Read(Session.SaveFile, World.QuestKills);
  Read(Session.SaveFile, World.Snail);
  Read(Session.SaveFile, Bag.LuckyLeaf);
  Read(Session.SaveFile, Skills.Returning);
  Read(Session.SaveFile, Bag.Bigos);
  Read(Session.SaveFile, Bag.Beer);
  Read(Session.SaveFile, Bag.CompareScroll);
  Read(Session.SaveFile, Bag.ReturnScroll);
  Read(Session.SaveFile, World.OldElf);
  Read(Session.SaveFile, World.DuncanQuest);
  Read(Session.SaveFile, Bag.Backpack);
  ReadLn(Session.SaveFile, World.Duncan);
  Read(Session.SaveFile, Gear.WornGarment);
  Close(Session.SaveFile);
  WriteLn('suckemall:', Gear.WornGarment);
end;

procedure CheckLevelUp;

var
  threshold: Integer;
begin
  if Player.Level < 1 then Exit;
  threshold := LevelThreshold(Player.Level);
  if Player.Experience < threshold then Exit;

  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');

  if Player.Level = 1 then Player.Experience := Player.Experience - 725
  else if Player.Level = 2 then Player.Experience := Player.Experience - 730
  else if Player.Level = 3 then Player.Experience := Player.Experience - 735
  else if Player.Level <= 8 then Player.Experience := (Player.Experience - Lvl4_Base) - Player.Level
  else Player.Experience := (Player.Experience - (Player.Level * 2)) - Lvl9_Base;
  if Player.Wisdom < 11 then Player.Practice := Player.Practice + 3;
  if (Player.Wisdom > 10) and (Player.Wisdom < 16) then Player.Practice := Player.Practice + 4;
  if (Player.Wisdom > 15) and (Player.Wisdom < 23) then Player.Practice := Player.Practice + 5;
  if Player.Wisdom > 22 then Player.Practice := Player.Practice + 6;
  WriteLn('<<<<<<<<<<<<ZYSKALES ', Player.Practice, ' PRAKTYK >>>>>>>>>>>>>>>');
  if Player.Dexterity > 12 then Player.MaxEnergy := Player.MaxEnergy + 11
  else Player.MaxEnergy := Player.MaxEnergy + 10;
  if Player.Dexterity > 16 then Player.MaxEnergy := Player.MaxEnergy + 1;
  if Player.Dexterity > 21 then Player.MaxEnergy := Player.MaxEnergy + 1;
  if (Player.Dexterity > 26) and (Player.Strength > 20) then Player.MaxEnergy := Player.MaxEnergy + 1;
  WriteLn('<<<<<<<<<<<<ZYSKALES ', Player.MaxEnergy, ' MAXIMUM ENERGI >>>>>>>>>>>>>');
  Player.MaxMana := Player.MaxMana + Player.Wisdom + 2;
   WriteLn('<<<<<<<<<<<<<<ZYSKALES ', Player.Wisdom + 2, 'MANY >>>>>>>>>>>>>>>>>');
  Player.Level := Player.Level + 1;
  Session.CheckpointStage := 0;
  if Player.Level = 12 then begin
    WriteLn('HURRRA TO JUZ DWUNASTY POZIOM , CZAS PODWYZSZYC MAXYMALNE PARAMETRY');
    if Player.Strength >= Player.MaxStrength then Player.MaxStrength := Player.MaxStrength + 3;
    if Player.Dexterity >= Player.MaxDexterity then Player.MaxDexterity := Player.MaxDexterity + 3;
    if Player.Wisdom >= Player.MaxWisdom then Player.MaxWisdom := Player.MaxWisdom + 3;
    if Player.Strength < Player.MaxStrength then Player.MaxStrength := Player.MaxStrength + 2;
    if Player.Dexterity < Player.MaxDexterity then Player.MaxDexterity := Player.MaxDexterity + 2;
    if Player.Wisdom < Player.MaxWisdom then Player.MaxWisdom := Player.MaxWisdom + 2;
    if (Player.MaxWisdom > Player.MaxStrength) and (Player.MaxWisdom > Player.MaxDexterity) then
      Player.MaxWisdom := Player.MaxWisdom + 3;
    if (Player.MaxStrength > Player.MaxWisdom) and (Player.MaxStrength > Player.MaxDexterity) then
      Player.MaxStrength := Player.MaxStrength + 3;
    if (Player.MaxDexterity > Player.MaxStrength) and (Player.MaxDexterity > Player.MaxWisdom) then
      Player.MaxDexterity := Player.MaxDexterity + 3;
    if (Player.MaxDexterity = Player.MaxStrength) and (Player.MaxStrength = Player.MaxWisdom) then begin
      Player.MaxDexterity := Player.MaxDexterity + 1;
      Player.MaxWisdom := Player.MaxWisdom + 1;
      Player.MaxStrength := Player.MaxStrength + 1;
    end;
    if (Player.MaxDexterity > Player.MaxWisdom) and (Player.MaxDexterity = Player.MaxStrength) then begin
      Player.MaxStrength := Player.MaxStrength + 2;
      Player.MaxDexterity := Player.MaxDexterity + 1;
    end;
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', Player.MaxStrength,
          ' MAXYMALNIE SILY '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', Player.MaxDexterity,
          ' MAXYMALNIE ZRECZNOSCI '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', Player.MaxWisdom,
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
  Player.Energy := Player.Energy + 200;
end;

procedure CmdTakeMoney;
begin
  Player.Money := Player.Money - 100;
end;

procedure CmdResetArmor;
begin
  Gear.WornCount := 0;
  Gear.Armor := 0;
  Gear.LuckRoll := 0;
end;

procedure CmdStrip;
begin
  Gear.Wearing := 0;
  Gear.WeaponKind := 0;
  Gear.ShieldKind := 0;
  Gear.WornGarment := '';
  Bag.OldSword := -10;
  Bag.SmallShield := -10;
  Player.Strength := Player.Strength - 1;
end;

procedure CmdNoExit;
begin
  WriteLn('NAPISZ UNMODE ');
end;

procedure CmdQuitGame;
begin
  Session.ExitRequested := True;
end;

procedure CmdJustSaved;
begin
  if Session.SavedFlag = 1 then begin
    Command := 'ZDOLNOSCI';
    Session.SavedFlag := 0;
    WriteLn(Session.OuterRoom, ' MIECHO!');
  end;
end;

procedure CmdDrinkBeer;
begin
  if Bag.Beer <= -10 then begin
    Bag.Beer := Bag.Beer + 10;
    WriteLn('GDY POCZULES AMBROZJE W USTACH ODZYSKALES 10 MANY ZAS GDY GO WYPILES 10% E.');
    Bag.Count := Bag.Count - 1;
    Player.Energy := Player.Energy + 10;
    Player.Mana := Player.Mana + 10;
  end;
end;

procedure CmdWieldOldSword;
begin
  if (Bag.OldSword = -10) and (Gear.WeaponKind = 0) then begin
    Bag.OldSword := -100;
    Gear.WeaponKind := 1;
    WriteLn('UZYWASZ STAREGO ZARDZEWIALEGO MIECZA JAKO BRONI');
    Player.Strength := Player.Strength + 1;
    Gear.LuckRoll := Gear.LuckRoll + 3;
  end;
end;

procedure CmdUnwieldOldSword;
begin
  if (Bag.OldSword = -100) and (Gear.WeaponKind = 1) then begin
    Bag.OldSword := -10;
    Gear.WeaponKind := 0;
    WriteLn('CHOWASZ STARY ZARDZEWIALY MIECZ I NIE UZYWASZ GO JAKO BRONI');
    Player.Strength := Player.Strength - 1;
    Gear.LuckRoll := Gear.LuckRoll - 3;
  end;
end;

procedure CmdWieldSmallShield;
begin
  if (Gear.ShieldKind = 0) and (Bag.SmallShield = -10) then begin
    Gear.ShieldKind := 1;
    Gear.Armor := Gear.Armor + 15;
    Gear.WornCount := Gear.WornCount + 1;
    Bag.SmallShield := -100;
    WriteLn('UZYWASZ MALEJ TARCZY JAKO TARCZY');
  end;
end;

procedure CmdUnwieldSmallShield;
begin
  if (Gear.ShieldKind = 1) and (Bag.SmallShield = -100) then begin
    Gear.ShieldKind := 0;
    Gear.Armor := Gear.Armor - 15;
    Gear.WornCount := Gear.WornCount - 1;
    Bag.SmallShield := -10;
    WriteLn('JUZ NIE UZYWASZ MALEJ TARCZY JAKO TARCZY');
  end;
end;

procedure CmdSetFleeEnergy;
begin
  if Skills.Fleeing > 0 then begin
    WriteLn('PONIZEJ ILU ENERGII CHCESZ UCIEKAC?');
    ReadLn(Skills.FleeEnergy);
  end;
end;

procedure CmdSleep;
begin
  Session.SleepHours := 0;
  repeat
    Session.SleepHours := Session.SleepHours + 1;
    Delay(5000);
    WriteLn('SPISZ JUZ ', Session.SleepHours, ' GODZIN');
    Player.Experience := Player.Experience - 20;
    Player.Energy := Player.Energy + 10;
  until KeyPressed;
  WriteLn('PO OBUDZENIU STWIERDZILES ZE ZYSKALES ', Session.SleepHours * 10,
      ' ENERGI I STRACILES ', (20 * Session.SleepHours) - Random(2 * Session.SleepHours), ' KUNSZTU');
  Player.Experience := Player.Experience + Random(2 * Session.SleepHours);
  if Session.SleepHours > 4 then begin
    WriteLn('DLUGI SEN DODATKOWO POZWOLIL CI ODPOCZAC : ZYSKALES ', Player.Wisdom, 'ENERGI');
    Player.Energy := Player.Energy + Player.Wisdom;
  end;
  if Session.SleepHours > 8 then begin
    WriteLn('PELNOWARTOSCIOWY SEN SPOWODOWAL SUPER ZYSK : ', Player.Wisdom * 2, 'ENERGI');
    Player.Energy := Player.Energy + (Player.Wisdom * 2);
  end;
  if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
end;

procedure CmdCompare;
begin
  if Skills.Comparing > 0 then begin
    Combat.Roll := Random(100);
    if Skills.Comparing > Combat.Roll then begin
      CompareFoe;
      Player.Mana := Player.Mana - 10;
    end
  else begin
      WriteLn('POPELNILES PEWNE BLEDY I NIE UDALO SIE WYKONAC CZARU');
      Player.Mana := Player.Mana - 5;
    end;
  end;
end;

procedure CmdGiveMoney;
begin
  Player.Money := Player.Money + 5000;
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
  if ((Command = 'POWROT') and (Skills.Returning > 0)) or
   ((Command = 'UZYJ SCROLL POWROT') and (Bag.ReturnScroll < 0)) then begin
    Combat.Roll := Random(100);
    if Command = 'UZYJ SCROLL POWROT' then begin
      Combat.Roll := Random(1);
      Bag.ReturnScroll := Bag.ReturnScroll + 10;
      Bag.Count := Bag.Count - 1;
    end;
    if Combat.Roll <= Skills.Returning then begin
      WriteLn('OTWIERASZ MAGICZNY PORTAL KTORY PRZENOSI CIE DO MIASTA');
      Player.Mana := Player.Mana - 15;
      Session.OuterRoom := 20;
    end;
    if (Combat.Roll > Skills.Returning) and (Skills.Returning + 30 > Combat.Roll) then begin
      WriteLn('NIE UDAJE CI SIE OTWORZYC MAGICZNEGO PORTALU');
      Player.Mana := Player.Mana - 5;
    end;
    if Skills.Returning + 29 < Combat.Roll then begin
      WriteLn('OTWIERASZ MAGICZNY PORTAL KTORY JEDNAK PRZENOSI CIE DO INNEGO MIEJSCA');
      Player.Mana := Player.Mana - 10;
      Session.OuterRoom := Random(100) + 1;
    end;
  end;
end;

procedure CmdUseCompareScroll;
begin
  if Bag.CompareScroll < 0 then begin
    CompareFoe;
    Player.Mana := Player.Mana - 10;
    Bag.CompareScroll := Bag.CompareScroll + 10;
    Bag.Count := Bag.Count - 1;
  end;
end;

procedure CmdSetKickThresholds;
begin
  if Skills.Kick > 0 then begin
    WriteLn('ZADAM CI PARE PYTAN:');
    WriteLn('1)PONIZEJ JAKIEJ ENERGI CHCESZ ZACZAC KOPAC');
    ReadLn(Skills.KickMaxEnergy);
    WriteLn('2)DO JAKIECH ILOSCI MANA CHCESZ KOPAC');
    ReadLn(Skills.KickMinMana);
  end;
end;

procedure CmdSpeede;
begin
  Bag.Permit := Bag.Permit - 10;
end;

procedure CmdShowSkills;
begin
  if (Player.Wisdom > 10) and (Player.Strength > 11) then WriteLn('KOPANIE       - ', Skills.Kick, '%');
  if (Player.Wisdom > 10) and (Player.Dexterity > 10) then WriteLn('UCIEKANIE     - ', Skills.Fleeing, '%');
  if (Player.Wisdom > 15) and (Player.Dexterity > 11) then WriteLn('PAROWANIE     - ', Skills.Parry, '%');
  if Player.Wisdom > 11 then WriteLn('POROWNYWANIE  - ', Skills.Comparing, '%');
  if Player.Wisdom > 18 then WriteLn('POTRAWKI      - ', Skills.CookingDisplayBug, '%');
  if Player.Wisdom > 19 then WriteLn('POWROT        - ', Skills.Returning, '%');
end;

procedure CmdLeaveTrance;
begin
  Session.Room := Session.OuterRoom;
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
  if World.CageAgile = 14 then
    WriteLn('ZRECZNY POTWOR SMIGA MIEDZY SCIANAMI');
  if World.CageAgile = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SMIERDZA DOSYC MOCNO');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Session.Room := 11;
    if (Command = 'ZABIJ POTWOR') and (World.CageAgile = 14) then begin
      Combat.EnemyEnergy := 20; Combat.EnemyDexterity := 30; Combat.EnemyStrength := 3;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageAgile := 0;
        Combat.Loot := Random(15);
        WriteLn('WYCIAGASZ ', Combat.Loot, ' MONET Z CIALA POTWORA');
        Player.Money := Player.Money + Combat.Loot;
        if Bag.OldSword = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 7 then begin
            Bag.OldSword := Session.Room;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            Gear.SwordValue := 500;
          end;
        end;
        if Bag.SmallShield = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 7 then begin
            Bag.SmallShield := Session.Room;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            Gear.ShieldValue := 300;
          end;
        end;
        if Bag.Heart = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 6 then begin
            Bag.Heart := Session.Room;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            Gear.HeartValue := 50;
          end;
        end;
      end else
        Combat.Fled := 0;
    end;
  until Session.Room <> 14;

end;
procedure Room15;

begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if World.CageTough = 15 then
    WriteLn('POWOLNY ACZ ODPORNY NA BOL POTWOR SPOKOJNIE LEZY POD SCIANA');
  if World.CageTough = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Session.Room := 11;
    if (Command = 'ZABIJ POTWOR') and (World.CageTough = 15) then begin
      Combat.EnemyEnergy := 40; Combat.EnemyDexterity := 3; Combat.EnemyStrength := 3;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageTough := 0;
        Combat.Loot := Random(15);
        WriteLn('WYCIAGASZ ', Combat.Loot, ' MONET Z CIALA POTWORA');
        Player.Money := Player.Money + Combat.Loot;
        if Bag.OldSword = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 7 then begin
            Bag.OldSword := Session.Room;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            Gear.SwordValue := 500;
          end;
        end;
        if Bag.SmallShield = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 7 then begin
            Bag.SmallShield := Session.Room;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            Gear.ShieldValue := 300;
          end;
        end;
        if Bag.Heart = 0 then begin
          Combat.Roll := Random(20);
          if Combat.Roll < 6 then begin
            Bag.Heart := Session.Room;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            Gear.HeartValue := 50;
          end;
        end;
      end else
        Combat.Fled := 0;
    end;
  until Session.Room <> 15;

end;
procedure Room16;

label
  L1027_Flee, L1028_AfterFlee;
begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if World.CageHuge = 16 then
    WriteLn('OGROMNY POTWOR WIDZAC MIESO RZUCA SIE NA CIEBIE');
  if World.CageHuge = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    if World.CageHuge = 16 then begin
      Combat.EnemyEnergy := 40; Combat.EnemyDexterity := 11; Combat.EnemyStrength := 10;
      Fight;
      if Combat.Fled <> 0 then goto L1027_Flee;
      World.CageHuge := 0;
      Combat.Loot := Random(30);
      WriteLn('WYCIAGASZ ', Combat.Loot, ' MONET Z CIALA POTWORA');
      Player.Money := Player.Money + Combat.Loot;
      if Bag.OldSword = 0 then begin
        Combat.Roll := Random(20);
        if Combat.Roll < 10 then begin
          Bag.OldSword := Session.Room;
          WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
          Gear.SwordValue := 500;
        end;
      end;
      if Bag.SmallShield = 0 then begin
        Combat.Roll := Random(20);
        if Combat.Roll < 10 then begin
          Bag.SmallShield := Session.Room;
          WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
          Gear.ShieldValue := 300;
        end;
      end;
      if Bag.Heart = 0 then begin
        Combat.Roll := Random(20);
        if Combat.Roll < 6 then begin
          Bag.Heart := Session.Room;
          WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
          Gear.HeartValue := 50;
        end;
      end;
      goto L1028_AfterFlee;
      L1027_Flee:
      Combat.Fled := 0;
      Session.Room := 11;
      L1028_AfterFlee:
    end;
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('DOL-KLATKI PELNE GAJDY');
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'DOL' then Session.Room := 11;
  until Session.Room <> 16;

end;
procedure Room17;

begin

  WriteLn('JESTES W POKOJU W KTORYM !JEST! !PLAKAT (SMIERDZI TU) ');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
      if (World.CageWeakling = 0) and (World.CageAgile = 0) and
      (World.CageStrong = 0) and (World.CageTough = 0) and
      (World.CageHuge = 0) and (Bag.Diploma = 0) then
        Bag.Diploma := 17;
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'GORA' then Session.Room := 11;
    if Command = 'DOL' then Session.Room := 18;
  until Session.Room <> 17;

end;
procedure Room18;

begin

  WriteLn('BBBBBBBBZBZBZBZBZZZZZZZzzzzzzzzzbbzbBbzbzbzBZZZ');
  WriteLn('===-------......_________.....----------....._______....-------======');
  WriteLn('T***E***L***E***P***O***R***T***O***W***A***L***E***S***** *****S***I***E!');
  WriteLn('==========================================================================');
  Session.Room := 1;

end;
procedure Room20;

begin

  WriteLn('JESTES W CENTRUM MIASTA : NA SCIANIE JEST PLAKAT (DUZY RUCH) ');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WYJSC0IE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Session.Room := 1;
    if Command = 'POLNOC' then Session.Room := 21;
    if Command = 'ZACHOD' then Session.Room := 30;
    if Command = 'WSCHOD' then Session.Room := 75;
    StreetFights;
  until Session.Room <> 20;

end;
procedure Room76;

begin

  WriteLn('JESTES W BARZE POD DWOMA PEDALAMI CHCAC ROZWIKLAC TA DZIWNA NAZWE');
  WriteLn('PYTASZ SIE BARMANA : PRZEPRASZAM DLACZEGO TEN BAR NAZYWA SIE  ');
  WriteLn('"POD DWOMA PEDALAMI"? A ON NA TO -WLASCIWIE TO NIE WIEM');
  WriteLn(' ALE SPYTAM SIE ZONY:MAREEEK!!.......(teraz ju'#190' wiesz) ');
  if World.Maciek = 76 then
    WriteLn('MACIEK , TUTEJSZY BARMAN SERWUJE TUTAJ DRINKI (MOZLIWA LISTA!');
  if World.Pedal = 76 then
    WriteLn(' PEDAL CZEKA TU NA TEGO JEDYNEGO');
  if World.Couple = 76 then
    WriteLn('PARA-JACEK I JUREK OBMYSLAJA MIESIAC MIODOWY');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA CIEMNA');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Session.Room := 75;
    if Command = 'LISTA' then begin
      WriteLn('DRINK        CENA');
      WriteLn('ORAL DRINK     130');
      WriteLn('ONANISOFT      180');
      WriteLn('PEDAL&SPRZEGLO 220');
    end;
    if Command = 'ZABIJ PEDAL' then begin
      FightEasy;
      World.Pedal := 0;
      PillGain;
    end;
    if Command = 'ZABIJ PARA' then begin
      FightVeryHard;
      World.Couple := 0;
      FightVeryHard;
    end;
    if Command = 'ZABIJ MACIEK' then begin
      FightEasy;
      World.Maciek := 0;
    end;
    if Command = 'MAM 18 LAT' then begin
      WriteLn('I CO Z TEGO ??? A JA MAM 100 LAT I ZYJE !!!');
    end;
  until Session.Room <> 76;

end;
procedure Room77;

begin

  WriteLn('ZNALAZLES SIE WSROD BLUSZCZU , WOKOLO CIEBIE TAJEMNICZE ROSLINY ');
  WriteLn('MUSISZ BARDZO UWAZAC,TU NAWET STOKROTKA MOZE BYC ZABOJCZA');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Session.Room := 75;
    if Command = 'WSCHOD' then Session.Room := 78;
    if Command = 'ZACHOD' then Session.Room := 79;
    if Command = 'POLODNIE' then Session.Room := 80;
  until Session.Room <> 77;

end;
procedure Room78;

begin

  WriteLn('WSZEDLES W GASZCZ ROSLIN I KWIATOW');
  WriteLn('NIE MA CO OPISYWAC WYSTARCZY POWIEDZIEC ZE JEST TU BYDLO CHWASTOW');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Session.Room := 77;
  until Session.Room <> 78;

end;
procedure Room79;

begin

  WriteLn('SLYSZYSZ POKRZYWE KTORA POZERA BEZBRONNY SZCZAW .... OHYDA');
  WriteLn('WOKOLO TAK CIEMNO,ZE GDYBY NIE JA JUZ DAWNO BYS ZGINA');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 77;
  until Session.Room <> 79;

end;
procedure Room80;

begin

  WriteLn('CHOC TO MALO PRAWDOPODOBNE TUTAJ JEST JESZCZE CIEMNIEJ');
  WriteLn('PONADTO W NIEKTORYCH MIEJSCACH ZNAJDUJE SIE BLOTO I INNE BZDURY');
  WriteLn('NA SRODKU ZNAJDUJE SIE STUDNIA I MALO CZYTELNY NAPIS');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Session.Room := 77;
    if Command = 'ZACHOD' then Session.Room := 81;
    if Command = 'WSCHOD' then Session.Room := 82;
    if Command = 'POLODNIE' then Session.Room := 83;
    if Command = 'PATRZ NAPIS' then
      WriteLn('PISZE TUTAJ : '#2'A'#2'RZY'#2' D'#2' S'#2'UDN'#2' (MOWILEM ZE MALO CZYTELNY)');
    if Command = 'PATRZ STUDNIA' then begin
      Combat.Roll := Random(3) + 1;
      WriteLn('ZAGLADASZ DO SRODKA STUDNI,COS TAM JEST,WYCI'#164'GASZ ', Combat.Roll,
          ' MONET!');
      Player.Money := Player.Money + Combat.Roll;
      Combat.Roll := Random(100);
      if Combat.Roll < 10 then begin
        WriteLn('JAK SMIESZ PODBIERAC MOJE SWIETOSCI , GIN CHAMIE , GIN');
        Player.Energy := Player.Energy - 40;
        WriteLn('ODDAWAJ MOJE PIENIADZE !!!');
        Player.Money := Player.Money - 100;
        if Player.Money < 0 then Player.Money := 0;
      end;
    end;
  until Session.Room <> 80;

end;
procedure Room81;

begin

  WriteLn('PRZEDZIERASZ SIE PRZEZ CALY TEN SYF I NAJCHETNIEJ BYS');
  WriteLn('TERAZ PORZYCZY'#157' KOSIARKI OD SWEGO KOLEGI TOMKA');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 80;
  until Session.Room <> 81;

end;
procedure Room82;

begin

  WriteLn('W TEJ KOMNACIE JEST ZNACZNIE JASNIEJ A TO DLATEGO ZE NAPROMIENIOWANE');
  WriteLn('I ZMUTOWANE ROSLINY ID'#164' W TWYM KIERUNKU');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-BLUSZCZ');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Session.Room := 80;
  until Session.Room <> 82;

end;
procedure Room84;

begin

  WriteLn('TO CIEKAWE ZE WCZESNIEJ NIE ZAUWAZYLES TYCH KRARZAKOW PRZEDZIERASZ');
  WriteLn('SIE PRZEZ ICH GASZCZ WYGLADA TO NA NIEZBYT MILA KRAINE');
  WriteLn('DALES NA ZACHOD WIDZISZ JAKIES PODEJRZANE BUDOWLE , A NA POLODNIE BRRRR.');
  WriteLn('NA POLODNIE JAK GDYBY KTOS SIE OBZERAL , ALE BARDZO GLOSNO I NIEBEZPIECZNIE');
  DescribePlants;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 83;
    if Command = 'ZACHOD' then Session.Room := 85;
    if Command = 'POLODNIE' then Session.Room := 87;
  until Session.Room <> 84;

end;
procedure Room87;

begin

  WriteLn('MLASK , MLASK KTOS RZECZYWISCIE SIE OBZERA CZY JESTES 100% PEWNY IZ');
  WriteLn('CHCESZ SIE ZAGLEBIC W TE NIEBADANE CZELUSCIE PIEKIELNE?, MOZE LEPIEJ WROC');
  Combat.Roll := Random(100);
  if Combat.Roll < 40 then begin
    WriteLn('NO PIEKNIE WLAZLES W JAKIES TOKSYCZNE SUBSTANCJE ,AAA, TO PARZY TRACISZ ',
       25 - Player.Dexterity, '%');
    Player.Energy := Player.Energy - 25 + Player.Dexterity;
  end;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-GROTA');
      WriteLn('POLNOC-PODEJRZANE KRZAKI');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLNOC' then Session.Room := 84;
    if Command = 'POLODNIE' then Session.Room := 88;
  until Session.Room <> 87;

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
    Combat.EnemyEnergy := 200; Combat.EnemyDexterity := 15; Combat.EnemyStrength := 18;
    Combat.FireballCharges := 5; Combat.PoisonCharges := 1;
    Fight;
    if Combat.EnemyEnergy < 0 then begin
      LeafGain;
      PillGain;
      ScrollGain;
      if World.DuncanQuest <> 0 then World.DuncanQuest := World.DuncanQuest - 50;
    end;
    if Player.Energy > 0 then begin
      WriteLn('UFFF,TO BYLA PRZYGODA,WOKOL GROMADZILY SIE SETKI MLECZOW - NIE MIALBYS SZANS');
      Session.Room := 87;
    end;
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-WEJSCIE DO GROTY');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Session.Room := 87;
  until Session.Room <> 88;

end;
procedure Room85;

begin

  WriteLn('DO DOBRA WYGLADA TO NA JAKIS DOM , WEJDZMY DO SRODKA ');
  WriteLn('GOD DAMN , A NIECH MNIE MA MATEUSZ W SWOJEJ OPIECE , TE DRZWI ZYJA !!!');
  if World.Door <> 0 then
    WriteLn('DRZWI WYCIAGAJA SWE DREWNIANE RECE W TWYM KIERUNKU MOWIAC : NIE WPUSZCZE');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'ZABIJ DRZWI' then begin
      if World.Door <> 0 then begin
        FightNotEasy;
        if Player.Energy > 0 then World.Door := 0;
      end;
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-PODEJRZANE KRZAKI');
      if World.Door <> 0 then
        WriteLn('ZACHOD-GDYBY NIE TE CHOLERNE DRZWI ... ');
      if World.Door = 0 then
        WriteLn('ZACHOD-WEJSCIE DO DOMKU');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 84;
    if (Command = 'ZACHOD') and (World.Door = 0) then Session.Room := 86;
    if (Command = 'ZACHOD') and (World.Door <> 0) then
      WriteLn('SPROBOJ OMINAC TE MEGA-PRZYPAKOWANE DRZWI KTORYCH BY SIE HE-MAN NIE POWSTYDZIL');
  until Session.Room <> 85;

end;
procedure Room86;

begin

  WriteLn('DOBRA JESTES W SRODKU BRAK OSWIETLENIA CIE NIE WZRUSZA , DOOKOLA ROZNE GARNKI');
  if World.OldElf <> 0 then
    WriteLn('W ROGU ZAUWAZASZ MALEGO WYGLODZONEGO ELFIEGO STARUCHA');
  if World.OldElf = 0 then
    WriteLn('WIDZISZ TU TYLKO PLASZCZ PO STARUCHU KTORY ZNIKNA W PRZESTRZEN');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ExpandAbbrev;
    if Command = 'DAWAJ KUNSZT' then Player.Experience := Player.Experience + 500;
    if Command = 'PATRZ GARNKI' then
      WriteLn('Z JEZOREM NA WIERZCHU PATRZYSZ DO GARNKOW LECZ NIC W NICH NIE MA');
    if Command = 'ROZMAWIAJ STARUCH' then begin
      if (Bag.Sausage > -30) and (Player.Money < 200) and (Bag.ReturnScroll = 0) then begin
        WriteLn('STARUCH MOWI CI : HEJ KTO TY JESTES CZY ZE MAGICZNE DRZWI NIE POWSTRZYMALY CIE?');
        WriteLn('MUSISZ BYC NIEZLYM WOJOWNIKIEM ,SPOXOLANDIA, GLODNY JESTEM PRZYNIES MI 4 WEKI ');
        WriteLn('ORAZ OKOLO 200 KASY , A DAM CI TAKIE NUMERY O JAKICH CI SIE NIE SNILO....');
      end;
    end;
    if Command = 'ROZMAWIAJ STARUCH' then begin
      if (Bag.Sausage < -30) and (Player.Money > 199) then begin
        WriteLn('STARUCH MOWI CI : OOO JAKA PIEKNA WEKA ... MNIAM I DRUGA TRZECIA I CZWARTA');
        WriteLn('TO BYLO DOBRE ZARCIE !!! , DAWAJ KASE , PIENIADZE !!! , CO SIE TAK GAPISZ?');
        WriteLn('WYNOCHA STAD !!! MRAMMMARAMMARAMAAMMARAM BUM !! -T-E-L-E-P-O-R-T-Y');
        WriteLn('WYGLADA ZE ZROBIL CIE W BUCA , A MOZE JEDNAK NIE , CO TO ? , SCROLL POWROTU');
        WriteLn('I PIWSKO NA OSLODZENIE ZYCIA , NO TRUDNO PRZYNAJMNIEJ CZEGOS SIE NAUCZYLES');
        Session.Room := 20;
        Bag.Beer := Bag.Beer - 10;
        Bag.Sausage := Bag.Sausage + 40;
        Player.Money := Player.Money - 200;
        Bag.ReturnScroll := Bag.ReturnScroll - 10;
        Player.Experience := Player.Experience + 50;
        Bag.Count := Bag.Count - 2;
      end;
    end;
    if Command = 'ROZMAWIAJ STARUCH' then begin
      if Bag.ReturnScroll < 0 then begin
        WriteLn('AAAA SPADAJ STAD BO CI KOSCI POLAMIE');
        Session.Room := 16;
      end;
    end;
    if Command = 'ZABIJ STARUCH' then begin
      if World.OldElf <> 0 then begin
        FightWeak;
        World.OldElf := 0;
        WriteLn('HMMM UBRANIE JEST , ALE CIALO GDZIES ZNIKNELO , WTEM SLYSZYSZ GLOS :');
        WriteLn('--- TO BYL TWOJ BLAD --- , DOSTAJESZ OCMIENIA LECZ NIE WIESZ CO TO BYLO');
        Player.Level := Player.Level - 1;
      end;
    end;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BUDYNEK');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 85;
  until Session.Room <> 86;

end;
procedure Room21;

begin

  WriteLn('JESTES NA ULICY NA ULICY SKLEPIKOWEJ - JAK SAMA NAZWA WZKAZUJE  ');
  WriteLn('JEST TU PARE SKLEPIKOW KTORE BYC MOZE CI SIE PRZYDADZA');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-CENTRUM MIASTA');
      WriteLn('POLNOC-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-PIEKARNIA');
      WriteLn('ZACHOD-ZBROJOWNIA');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Session.Room := 20;
    if Command = 'POLNOC' then Session.Room := 22;
    if Command = 'WSCHOD' then Session.Room := 23;
    if Command = 'ZACHOD' then Session.Room := 24;
    StreetFights;
  until Session.Room <> 21;

end;
procedure Room22;

begin

  WriteLn('CIAGNIE SIE TEDY ULICA SKLEPIKOWA JEST TU JESZCZE PARE  ');
  WriteLn('INTERESUJACYCH SKLEPOW. DALEJ CIAGNIE SIE KILKA ULIC....');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-UL.SKLEPIKOWA');
      WriteLn('POLNOC-ROZJAZD!');
      WriteLn('WSCHOD-SKLEP WIELOBRANZOWY');
      WriteLn('ZACHOD-SKLEP MAGICZNY  ');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Session.Room := 21;
    if Command = 'WSCHOD' then Session.Room := 25;
    if Command = 'ZACHOD' then Session.Room := 26;
    if Command = 'POLNOC' then Session.Room := 100;
    StreetFights;
  until Session.Room <> 22;

end;
procedure Room101;

begin

  WriteLn('IDZIESZ DROGA , MIASTA PO DRODZE MIJASZ DROGOWSKAZ . JEST TU O WIELE ');
  WriteLn('NIEBEZPIECZNIEJ NIZ W MIESCIE PELNO TU ZEZIMIERZKOW ROZNEGO RODZAJU');
  WriteLn('JESLI NIE CHCESZ MIEC KLOPOTOW LEPIEJ DOBRZE TRYMAJ SIE DROGI....');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 100;
    if Command = 'ZACHOD' then Session.Room := 102;
    if Command = 'POLNOC' then Session.Room := 104;
  until Session.Room <> 101;

end;
procedure Room102;

begin

  WriteLn('IDZIESZ DALEJ KAMIENISTA DROGA , BRZYDALA BI CI SIE JAKA BRYCZKA NALEPIEJ ');
  WriteLn('MODEL SZKAPA 2000 , ALE COZ KONIE SA TYLKO DLA NAJBOGATSZYCH');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-DROGA');
      WriteLn('ZACHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 101;
    if Command = 'ZACHOD' then Session.Room := 103;
  until Session.Room <> 102;

end;
procedure Room103;

begin

  WriteLn('CO TO ZA GLUPOTA ? DROGA SKRECA TROCHE W LEWO , TROCHE W PRAWO ALE ');
  WriteLn('PRZECIEZ ROWNIE DOBRZE MOGLA BY ISC SRODKIEM , ZYSKALI BY NA TYM WSZYSCY');
  WriteLn('A SZCZEGOLNIE TY ,  BO BOLA CIE NOGI OD TEGO CHODZENIA NIEMOZEBNIE');
  WriteLn('UPS DROGA SIE KONCZY NA TEJ NIEPRZEPASTNEJ RZECE O DALSZEJ PODROZY NIE MA MOWY');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 102;
  until Session.Room <> 103;

end;
procedure Room23;

begin

  WriteLn('JESTES W PIEKARNI , SKLEP PRZESIAKNIETY JEST PRZYJEMNYM ZAPACHEM CHLEBA ');
  WriteLn('PIEKARZ MILO SIE NA CIEBIE PATRZY WYCIERAJAC MAKE Z TWARZY');
  WriteLn('NA SCIANIE  JEST PLAKAT CALY W MACE');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Session.Room := 21;
    BakeryShop;
  until Session.Room <> 23;

end;
procedure Room24;

begin

  WriteLn('JESTES W ZBROJOWNI - SKLEP NIEDAWNO ZOSTAL OTWARTY');
  WriteLn('SPRZEDAWCA(BRZYDKA AURA) STARA SIE WCISNAC CI JAKIS TOWAR ');
  WriteLn('NA SCIANIE WISI PLAKAT');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    ArmouryShop;
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA SKLEPIKOWA');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 21;
    if Command = 'PATRZ PLAKAT' then
      WriteLn('LISTA,KUP XXX I SPRZEDAJ XXX TO JEST DOSTEPNE W TYM SKLEPIE ');
    StreetFights;
  until Session.Room <> 24;

end;
procedure Room25;

begin

  WriteLn('WSZEDLES DO SKLEPU WIELOBRANZOWEGO,STWIERDZASZ OBECNOSC SPRZEDAWCY');
  WriteLn('NA DRZWIACH ZOSTALA WYWIESZONA WYWIESZKA');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-ULICA SKLEPIKOWA');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'ZACHOD' then Session.Room := 22;
    if Command = 'PATRZ WYWIESZKA' then
      WriteLn('* SKLEP OTWARTY DO ODWOLANIA *');
    StreetFights;
    GeneralStoreShop;
  until Session.Room <> 25;

end;
procedure Room26;

begin

  WriteLn('WCHODZISZ DO SKLEPU ALE NICZEGO TU NIE MA POZA SPRZEDAWCA I JEGO TOWAREM');
  DescribeStreet;
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA SKLEPIKOWA');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 22;
    if Command = 'PATRZ PLAKAT' then
      WriteLn('* OTWARTE Z POWODU CHOROBY *');
    MagicShop;
    StreetFights;
  until Session.Room <> 26;

end;
procedure Room31;

begin

  WriteLn('IDAC ULICA DLUGA NA POLNOC SPOSTRZEGASZ DOLINE ROZRYWEK');
  WriteLn('A NA POLODNIE BASNIOWY GAJ...........');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
    ReadLn(Command);
    if Command = 'MODE' then EnterTrance;
    if Command = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA DLUGA');
      WriteLn('POLNOC-DOLINA ROZRYWEK');
    end;
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'WSCHOD' then Session.Room := 30;
    if Command = 'POLNOC' then Session.Room := 60;
  until Session.Room <> 31;

end;
procedure Room32;

begin

  WriteLn('CZESC TO ARENA PRZYCHODZA TU TACY JAK TY PO TO ABY MORDOWAC');
  WriteLn('!!!!!O NIE!!!!!!!! TO STRASZNE!!! ( SIE DAL NABRAC ) (NAPISZ PATRZ PLAKAT');
  repeat
    Write(Player.Energy, '%.', Player.Experience, '>');
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
    if Command = 'WYJSCIE' then begin Session.ExitRequested := True; Exit; end;
    if Command = 'POLODNIE' then Session.Room := 30;
    if Command = 'POLNOC' then Session.Room := 33;
  until Session.Room <> 32;

end;

const

  RoomDispatch: array[1..46] of TRoomEntry = (
    (id: 0; run:Room0),
    (id: 1; run:Room1),
    (id: 2; run:Room2),
    (id: 3; run:Room3),
    (id: 4; run:Room4),
    (id: 5; run:Room5),

    (id: -1; run:PlainRooms),
    (id: 9; run:Room9),
    (id: 11; run:Room11),
    (id: 12; run:Room12),
    (id: 13; run:Room13),
    (id: 14; run:Room14),
    (id: 15; run:Room15),
    (id: 16; run:Room16),
    (id: 17; run:Room17),
    (id: 18; run:Room18),
    (id: 20; run:Room20),
    (id: 75; run:Room75),
    (id: 30; run:Room30),
    (id: 76; run:Room76),
    (id: 77; run:Room77),
    (id: 78; run:Room78),
    (id: 79; run:Room79),
    (id: 80; run:Room80),
    (id: 81; run:Room81),
    (id: 82; run:Room82),
    (id: 83; run:Room83),
    (id: 84; run:Room84),
    (id: 87; run:Room87),
    (id: 88; run:Room88),
    (id: 85; run:Room85),
    (id: 86; run:Room86),
    (id: 21; run:Room21),
    (id: 22; run:Room22),
    (id: 101; run:Room101),
    (id: 102; run:Room102),
    (id: 103; run:Room103),
    (id: 100; run:Room100),
    (id: 23; run:Room23),
    (id: 24; run:Room24),
    (id: 25; run:Room25),
    (id: 26; run:Room26),
    (id: 31; run:Room31),
    (id: 60; run:Room60),

    (id: -1; run:ConcertRooms),
    (id: 32; run:Room32)
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

    if Bag.Count > Bag.Limit then begin
      WriteLn('JESTES OBLADOWANY !!! MASZ O ', Bag.Count - Bag.Limit, ' ZA DUZO');
      WriteLn('TRACISZ ', (Bag.Count - Bag.Limit) * 10, '% ENERGI');
      Player.Energy := Player.Energy - ((Bag.Count - Bag.Limit) * 10);
    end;

    if Combat.PoisonRounds > 0 then begin
      Combat.Roll := Random(5);
      WriteLn('JESTES ZATRUTY TRACISZ ', Combat.Roll, ' % ENERGI');
      Combat.PoisonRounds := Combat.PoisonRounds - 1;
    end;

    Session.ExitRequested := False;
    for ri := Low(RoomDispatch) to High(RoomDispatch) do
      if (RoomDispatch[ri].id = -1) or (Session.Room = RoomDispatch[ri].id) then begin
        RoomDispatch[ri].run;
        if Session.ExitRequested then goto L1025_Exit;
      end;

    ArenaMaze;
    if Session.Room = DeadRoom then Death;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
    if Session.Room = TranceRoom then begin
      if Bag.OldSword = Session.OuterRoom then
        WriteLn('W TWYM POKOJU LEZY !STARY! ZARDZEWIALY MIECZ');
      if Bag.SmallShield = Session.OuterRoom then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE !MALA! TARCZA');
      if Bag.Heart = Session.OuterRoom then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE ZAKRWAWIONE !SERCE!');
      if Bag.Diploma = Session.OuterRoom then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE !DYPLOM! MUD SZKOLY');
      if Bag.Pipe = Session.OuterRoom then
        WriteLn('TU LEZY !FAJKA!');
      L1012_TrancePrompt: Write(Player.Energy, '%.', Player.Experience, '>');
      ReadLn(Command);

      Session.ExitRequested := False;
      for gi := Low(GroundCommands) to High(GroundCommands) do
        if (GroundCommands[gi].cmd = '') or (Command = GroundCommands[gi].cmd) then begin
          GroundCommands[gi].run;
          if Session.ExitRequested then goto L1025_Exit;
        end;
      if Session.Room = TranceRoom then goto L1012_TrancePrompt;
    end;

    Combat.Fled := 0;

  until Session.Room = 193;

  L1025_Exit: ;

end;

end.
