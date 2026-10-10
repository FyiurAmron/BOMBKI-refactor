unit GRA;

interface
uses crt;

var MAXE, JAMNIK, OWCZAREK, SPANIEL, PUDEL, PIESEK, TAKSOWKARZ, SPRZEDAWCA, ZAMIATACZ: Integer;
var PIJAK, ZEBRAK, MINIBARMAN, GRUBAS, DJ, PEDAL, PARA, MACIEK, OGOL, DRZWI, STARUCH: Integer;
var SILNY: Integer;
procedure WSTEP;

var MMIECZ, MIECHO2, PRZED, MTARCZA, SERCE, DYPLOM, FAJKA, MAD, SIL, ZRE, MBUTELKA, PRA: Integer;
var MAXMAD, MAXSIL, MAXZRE, ENERGIA, FUKS, PACZEK, CIASTKO, SUCHA, CHLEB, BULKA, WEKA: Integer;
var MANA, MAXMANA, WROGEN, MINIKUNSZT, WROGSIL, WROGZRE, ON, TY, SZANSA, WPYSK: Integer;
var PRO, ILOSC, PAR, KOP, KOPM, KOPHP, ZWIEJ, WIMP, PASZOL, KUNSZT, MIECHO, ARENA: Integer;
var KORNIK, MUCHA, BAKTERIA, SLIMAK, ZUK, KARALUCH, MROWKA, PAJAK, DZIK, SZCZUR, LIS: Integer;
var KUROPATWA, ZAJAC, WILCZUR, ORZEL, SARNA, SLON, LEW, ZYRAFA, WIELBLAD, STRUS, BOA: Integer;
var WILK, BIZON, PANTERA, GLADIATOR, WOJOWNIK, TRENER, CZY, STOP, KOMPLET, CIALO: Integer;
var FORSA, PRZEPUSTKA: Longint;
var GARNITUR, FUKSROLL, GITARZYSTA, PERKUSISTA, ORGANISTA, LIROY, kaseta, SCROLLPOR: Integer;
var SZCZAW, STOKROTKA, KONICZYNKA, MLECZ, DMUCHAWIEC, ROZA, JEZYNA, OSET, AGREST, MALINA, TRAWA, QUEST, QUESTWYK: Integer;
var DZIECKO, WARIAT, SLUCHACZ, FAN, CZLOWIEK, POLICJANT, OCHRONIARZ, DZIADEK, GORYL, PLECAK: Shortint;
var REPORTER, PIGULKA, POTRAWKI, BIGOS, LISTEK, POZIOM, POR, FIREBALL, POISON, ILEPOI, DUNCAN, DUNQ: Shortint;
var JAKIEUB: string;
var wpisz: string;
  procedure BRANIE;
  procedure UZYWANIE;
  procedure PIERDOLY;
  procedure TARCZA;
  procedure WALKA;
  procedure MINIARENA;
  procedure KTO;
  procedure MODE;
  procedure SLABO;
  procedure MNIEJSLABO;
  procedure SREDNIO;
  procedure TRUDNO;
  procedure BTRUDNO;
  procedure VEASY;
  procedure EASY;
  procedure NEASY;
  procedure GARNITURZYSK;
  procedure PIGULKAZYSK;
  procedure KASETAZYSK;
  procedure LISTEKZYSK;
  procedure SCROLLPORZYSK;
  procedure SCENA;
  procedure FIGHTSCENA;
  procedure TLUM;
  procedure POTWORY;
  procedure BLUSZCZ;
  procedure KOMENDY;
  procedure FIGHTBLUSZCZ;
  procedure WALKAPIES;
  procedure ULSKLEPIKOWA;
  procedure POROWNANIE;
  procedure TRAIN;
  procedure save;

  procedure POKOJ0;
  procedure POKOJ1;
  procedure POKOJ4;
  procedure POKOJ13;
  procedure POKOJE;
  procedure POKOJ5;
  procedure POKOJ11;
  procedure POKOJ30;
  procedure POKOJ60;
  procedure POKOJ75;
  procedure POKOJ100;
  procedure POKOJ83;

procedure Start;

implementation

procedure WSTEP;
begin
  ClrScr;
  MAXE := 50;
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

procedure POKOJ5;
begin
  WriteLn('SZOK!! AAA UPSI  O NIE FUJ ACH AJ OCH NEIN EEE UGH   ');
  WriteLn('STWIERDZASZ ZE W TYM POKOJU JEST X POKOI O NIE !! JAK SIE WYDOSTAC?');
  WriteLn('AHA (NA SCIANIE JEST PLAKAT)');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-MUD SZKOLA');
      WriteLn('ZACHOD-POKOJ');
      WriteLn('POLNOC-POKOJ');
      WriteLn('POLODNIE-POKOJ');
      WriteLn('GORA-POKOJ');
      WriteLn('DOL-POKOJ');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'WSCHOD' then MIECHO := 4;
    if wpisz = 'ZACHOD' then MIECHO := 6;
    if wpisz = 'POLNOC' then MIECHO := 7;
    if wpisz = 'POLODNIE' then MIECHO := 8;
    if wpisz = 'GORA' then MIECHO := 9;
    if wpisz = 'DOL' then MIECHO := 10;
    if wpisz = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE BYNAJMNIEJ PISZE');
      WriteLn('TO JEST POKOJ DO ORIETACJI W TERENIE ORAZ W KIERUNKACH');
    end;
  until MIECHO <> 5;
end;

procedure POKOJ0;
begin
  WriteLn('TU ZACZYNA SIE GRE');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'EXIT' then WriteLn('DOSTEPNE WYJSCIE-POLNOC-HALA GLOWNA MUD SZKOLE ');
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'POLNOC' then MIECHO := 1;
  until MIECHO <> 0;
end;
procedure POKOJ1;
begin
  WriteLn('JESTES W OKROGLYM SALONIE WYPELNIONYM WITRAZAMI ');
  WriteLn('W POWIETRZU UNOSZA SIE ZAPACHY I SO TO ZAPACHY OK');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  WriteLn('NAPISZ PATRZ PLAKAT ABY GO ODCZYTA'#143' ');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-TAM GDZIE ZACZYNASZ GRE');
      WriteLn('POLNOC-MIASTO');
      WriteLn('WSCHOD-POKOJ TRENINGOWY 1');
      WriteLn('ZACHOD-MUD SZKOLA');
      WriteLn('DOL-PODDZIEMNY POKOJ TRENINGOWY(2)');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'POLODNIE' then MIECHO := 0;
    if wpisz = 'WSCHOD' then MIECHO := 2;
    if wpisz = 'DOL' then MIECHO := 3;
    if wpisz = 'ZACHOD' then MIECHO := 4;
    if wpisz = 'POLNOC' then MIECHO := 20;
    if wpisz = 'PATRZ PLAKAT' then begin
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
  until MIECHO <> 1;
end;
procedure POKOJ4;
begin
  if MIECHO <> 4 then Exit;
  WriteLn('JESTES W HALLU MUD SZKOLY- OGARNIA CIE CYKORIA  ');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! AFISZ!!!');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-POKOJ CENTRALNY');
      WriteLn('ZACHOD-MUD SZKOLA (2)');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'WSCHOD' then MIECHO := 1;
    if wpisz = 'ZACHOD' then MIECHO := 5;
    if wpisz = 'PATRZ AFISZ' then begin
      WriteLn(#169' NA AFISZU BYNAJMNIEJ PISZE');
      WriteLn('TO JEST MUD SZKOLA KUJ KOMEDY ALBO ZGINIESZ!!!!!!!!');
      WriteLn('JESLI CHODZI O EKWIPUNEK TO BIERZ (PRZEDMIOT)=BIERZESZ PRZEDMIOT');
      WriteLn('UZYJ (PRZEDMIOT) = UZYWASZ PRZEDMIOTU ODRZUC (PRZEDMIOT) = ODRZUCASZ');
      WriteLn('BRONIE I TARCZE I UBRONIA MOZNA ZDJAC KOMENDA ODLORZ (PRZEDMIOT) ');
    end;
  until MIECHO <> 4;

end;
procedure POKOJ13;
begin
  if MIECHO <> 13 then Exit;
  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if SILNY = 13 then WriteLn('SILNY , NAPAKOWANY POTWOR STOI POD SCIANA');
  if SILNY = 0 then WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-KLATKI PELNE GAJDY');
    end;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'WSCHOD' then MIECHO := 11;
    if (wpisz = 'ZABIJ POTWOR') and (SILNY = 13) then begin
      WROGEN := 20;
      WROGZRE := 3;
      WROGSIL := 10;
      WALKA;
      if PASZOL = 0 then begin
        SILNY := 0;
        CZY := Random(15);
        WriteLn('WYCIAGASZ ', CZY, ' MONET Z CIALA POTWORA');
        FORSA := FORSA + CZY;
        if MMIECZ = 0 then begin
          FUKS := Random(20);
          if FUKS < 7 then begin MMIECZ := MIECHO; WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA'); end;
        end;
        if MTARCZA = 0 then begin
          FUKS := Random(20);
          if FUKS < 7 then begin MTARCZA := MIECHO; WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA'); end;
        end;
        if SERCE = 0 then begin
          FUKS := Random(20);
          if FUKS < 6 then begin SERCE := MIECHO; WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA'); end;
        end;
      end else PASZOL := 0;
    end;
  until MIECHO <> 13;

end;
procedure ProstyPokoj(numer, cel: Integer; kierunek, opisWyjscia: string);

begin
  if MIECHO = numer then begin
    WriteLn('JESTES W DOSYC CIASNYM POKOJU I NICZEGO TU NIEMA ');
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn(kierunek + '-' + opisWyjscia);
      end;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = kierunek then MIECHO := cel;
    until MIECHO <> numer;
  end;
end;

procedure POKOJE;
begin
  ProstyPokoj(6, 5, 'WSCHOD', 'MUD SZKOLA(2)');
  ProstyPokoj(8, 5, 'POLNOC', 'MUD SZKOLA(2)');
  ProstyPokoj(7, 5, 'POLODNIE', 'MUD SZKOLA(2)');
  ProstyPokoj(10, 5, 'GORA', 'MUD SZKOLA(2)');
end;
procedure POKOJ11;
begin
  if MIECHO <> 11 then Exit;
  WriteLn('JESTES W POKOJU PROWADZACYM DO KLATEK');
  WriteLn('DRZWI POD TOBA SIE ZATRZASNELY I NIE MASZ ODWROTU');
  WriteLn('WE WSZYSTKICH KIERUNKACH SA KLATKI I UJADAJACE SIE W NICH POTWORY');
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-KLATKA CIENIASA');
      WriteLn('ZACHOD-KLATKA SILNEGO');
      WriteLn('POLNOC-KLATKA ZRECZNEGO');
      WriteLn('POLODNIE-KLATKA ODPORNEGO');
      WriteLn('GORA-KLATKA SILNEGO,ODPORNEGO I ZRECZNEGO ');
      WriteLn('DOL-JEDYNA DROGA NIE PROWADZACA DO KLATEK');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'WSCHOD' then MIECHO := 12;
    if wpisz = 'ZACHOD' then MIECHO := 13;
    if wpisz = 'POLNOC' then MIECHO := 14;
    if wpisz = 'POLODNIE' then MIECHO := 15;
    if wpisz = 'GORA' then MIECHO := 16;
    if wpisz = 'DOL' then MIECHO := 17;
    if wpisz = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE PISZE:');
      WriteLn('W KLATKACH SA POTWORKI - ZABIJ JE! KOMEDA : ZABIJ [COS] - ZABIJA ');
      WriteLn('CZASAMI COS WYPADNIE Z POTWORKA MOZE CI SIE TO PRZYDAC');
    end;
  until MIECHO <> 11;

end;
procedure POKOJ30;
begin
  if MIECHO <> 30 then Exit;
  WriteLn('ULICA DLUGA CIAGNIE SIE W NIESKONCZONOSC,SORKI');
  WriteLn('NA POLNOCY ZNAJDUJESZ OGROMNA BUDOWLE=TO ARENA PRZEZNACZONA DO WALKI');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-CENTRUM MIASTA');
      WriteLn('ZACHOD-ULICA DLUGA');
      WriteLn('POLNOC-WEJSCIE NA ARENE');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'WSCHOD' then MIECHO := 20;
    if wpisz = 'ZACHOD' then MIECHO := 31;
    if wpisz = 'POLNOC' then MIECHO := 32;
  until MIECHO <> 30;

end;
procedure POKOJ60;
begin
  if MIECHO <> 60 then Exit;
  WriteLn('JESTES W DOLINIE ROZRYWEK DOLINA CIAGNIE SIE NA POLNOC, NA WSCHODZIE');
  WriteLn('JEST SLYSZALNY JAKIS DZIWNY  HALAS , NA ZACHODZIE ZAS "LA LA LA LA" ');
  WriteLn('ZAWSZE MOZESZ WROCIC SIE IDAC NA POLODNIE ;)');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA DLUGA');
      WriteLn('WSCHOD-BUDOWLA PELNA HALASU');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'POLODNIE' then MIECHO := 31;
    if wpisz = 'WSCHOD' then MIECHO := 61;
  until MIECHO <> 60;

end;
procedure POKOJ75;
begin
  if MIECHO <> 75 then Exit;
  WriteLn('JESTES NA ULICY CIEMNEJ , WLASCIWIE NARAZIE NIE JEST TU JESZCZE TAK CIEMNO ');
  WriteLn('TA ULICA WYGLADA NA REMONTOWAN'#164' , NA POLNOC WIDZISZ JAKIS BAR ');
  WriteLn('NA POLODNIE PRZEBIEGAJA CIE DRESZCZE , JEST TAM NAPRAWDE CIEMNO');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-CENTRUM MIASTA');
      WriteLn('POLNOC-BAR POD DWOMA PEDALAMI');
      WriteLn('POLODNIE-BLUSZCZ');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'ZACHOD' then MIECHO := 20;
    if wpisz = 'POLNOC' then MIECHO := 76;
    if wpisz = 'POLODNIE' then MIECHO := 77;
  until MIECHO <> 75;

end;
procedure POKOJ83;
begin
  if MIECHO <> 83 then Exit;
  WriteLn('............................. PIERDUT...........PIERDUT......PIERDUT');
  WriteLn('DOPIERO TERAZ SIE ZORIENTOWALES ZE NA SRODKU STOI WIELKIE DRZEWO');
  WriteLn('HMMM ALE ZARAZ ... TE KRZAKI NA ZACHOD WYGLADAJA BARDZO PODEJRZANIE....');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-BLUSZCZ');
      WriteLn('ZACHOD-PODEJRZANE KRZAKI');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'POLNOC' then MIECHO := 80;
    if wpisz = 'ZACHOD' then MIECHO := 84;
  until MIECHO <> 83;

end;
procedure POKOJ100;
begin
  if MIECHO <> 100 then Exit;
  WriteLn('ZNALAZLES SIE NA ROZJEZDZIE DROG , DROGI PILNUJE QUEST-MASTER ');
  WriteLn('QUEST-MASTER NIE POSCI CIE DALEJ DOPOKI NIE KUPISZ I ROZWIAZESZ QUESTA');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-DROGA O KTOREJ MOZESZ POMAZYC ( BO JEST W PRODUKCJI !!! )');
      if PRZEPUSTKA = 0 then WriteLn('ZACHOD-DROGA ( ZABLOKOWANA PRZEZ QUEST-MASTERA)');
      if PRZEPUSTKA < 0 then WriteLn('ZACHOD-DROGA');
    end;
    if wpisz = 'LISTA' then begin
      WriteLn('LATWY QUEST      - 200');
      WriteLn('PRZECIETNY QUEST - 100');
      WriteLn('TRUDNY QUEST     - 50');
      WriteLn('KOMEDA - SPRZEDAJ QUEST - OZNACZA IZ QUEST ZOSTAL WYKONANY');
    end;
    if (wpisz = 'KUP LATWY QUEST') and (FORSA > 199) then begin
      WriteLn('ZABIJ 75 POTWOROW');
      QUEST := 1;
      QUESTWYK := 75;
      FORSA := FORSA - 200;
    end;
    if (wpisz = 'KUP PRZECIETNY QUEST') and (FORSA > 99) then begin
      WriteLn('ZABIJ 50 POTWOROW W TYM LIROYA I DAJ MI DYPLOM MUD SZKOLY');
      QUEST := 2;
      QUESTWYK := 200;
      FORSA := FORSA - 100;
    end;
    if (wpisz = 'KUP TRUDNY QUEST') and (FORSA > 49) then begin
      WriteLn('ZABIJ 50 POTWOROW W TYM LIROYA I DAJ MI FAJKE I POSWIEC 1 PRAKTYKE');
      QUEST := 3;
      QUESTWYK := 200;
      FORSA := FORSA - 50;
    end;
    if (wpisz = 'SPRZEDAJ QUEST') and (QUEST > 0) then begin
      if (QUEST = 1) and (QUESTWYK < 1) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 100 KUNSZTU -----');
        KUNSZT := KUNSZT + 100;
        QUEST := 0;
        QUESTWYK := 0;
        PRZEPUSTKA := PRZEPUSTKA - 10;
        PRZED := PRZED + 1;
      end;
      if (QUEST = 2) and (QUESTWYK < 1) and (DYPLOM <= -10) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 250 KUNSZTU -----');
        KUNSZT := KUNSZT + 250;
        QUEST := 0;
        QUESTWYK := 0;
        DYPLOM := 0;
        MAXE := MAXE - 5;
        PRZEPUSTKA := PRZEPUSTKA - 10;
      end;
      if (QUEST = 3) and (QUESTWYK < 1) and (FAJKA <= -10) and (PRA > 0) then begin
        WriteLn('AAAAA BARDZO MI MILO ZE UDALO CI SIE WYKONAC TEN QUEST');
        WriteLn(' ------ OTRZYMUJESZ 425 KUNSZTU -----');
        KUNSZT := KUNSZT + 425;
        PRZED := PRZED - 1;
        MAD := MAD - 1;
        QUEST := 0;
        QUESTWYK := 0;
        FAJKA := FAJKA + 10;
        PRA := PRA - 1;
        PRZEPUSTKA := PRZEPUSTKA - 10;
      end;

    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'POLODNIE' then MIECHO := 22;
    if (wpisz = 'ZACHOD') and (PRZEPUSTKA <= -10) then MIECHO := 101;
if (wpisz = 'ZACHOD') and (PRZEPUSTKA = 0) then WriteLn('QUEST-MASTER MOWI CI : BARDZO MI PRZYKRO ALE MUSISZ MIEC PRZEPUSTKE');
    if wpisz = 'ZABIJ QUEST-MASTER' then begin
      POISON := 10;
      FIREBALL := 20;
      WROGSIL := 10;
      WROGZRE := 26;
      WROGEN := 188;
      WALKA;
      if WROGEN < 1 then PRZEPUSTKA := PRZEPUSTKA - 10;
    end;
  until MIECHO <> 100;

end;

function MinikunsztMaxe(diff: Integer): Integer;

begin
  if diff > 0 then begin
    case diff of
      1, 2: MinikunsztMaxe := 10;
      3: MinikunsztMaxe := 19;
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

begin
  if zre >= 8 then OGOL_ZRE_Bonus := zre div 2
  else OGOL_ZRE_Bonus := 0;
end;

function OGOL_PAR_Bonus(par: Integer): Integer;

var bonus: Integer;
begin
  bonus := 0;
  if par > 75 then bonus := bonus + 1;
  if par > 50 then bonus := bonus + 1;
  OGOL_PAR_Bonus := bonus;
end;

function OGOL_KOP_Bonus(kop: Integer): Integer;

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
    JAMNIK := Random(7) + 20;
    OWCZAREK := Random(7) + 20;
    PIESEK := Random(7) + 20;
    SPANIEL := Random(7) + 20;
    PUDEL := Random(7) + 20;
  until (JAMNIK > 19) and (OWCZAREK > 19) and (PIESEK > 19)
    and (SPANIEL > 19) and (PUDEL > 19);
  repeat TAKSOWKARZ := Random(7) + 20;
    SPRZEDAWCA := Random(7) + 20;
    ZAMIATACZ := Random(7) + 20;
    PIJAK := Random(7) + 20;
    ZEBRAK := Random(7) + 20;
  until (TAKSOWKARZ > 19) and (SPRZEDAWCA > 19)
    and (ZAMIATACZ > 19) and (PIJAK > 19) and (ZEBRAK > 19);
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
  MINIBARMAN := 67;
  GRUBAS := 67;
  DJ := 69;
  PEDAL := 76;
  PARA := 76;
  MACIEK := 76;
  DRZWI := 1;
  STARUCH := 1;
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
    OGOL := POZIOM + SIL + OGOL_ZRE_Bonus(ZRE) + OGOL_PAR_Bonus(PAR) + OGOL_KOP_Bonus(KOP);
    if (wpisz = 'DZIK') or (wpisz = 'SZCZUR') or (wpisz = 'LIS') or
       (wpisz = 'KUROPATWA') or (wpisz = 'ZAJAC') or (wpisz = 'WILCZUR') or
       (wpisz = 'ORZEL') or (wpisz = 'SARNA') or (wpisz = 'DZIECKO') or (wpisz = 'DZIADEK') then
        begin if OGOL < 16 then WriteLn('NICZEGO NIE MOGE ZAGWARANTOWAC ..... MACIE PODOBNE PARAMETRY');
        if (SIL > 15) and (SIL < 19) then WriteLn('PRZECIWNIK GODNY TWEJ DUMY , RACZEJ NIE POGRASZ');
        if SIL > 18 then WriteLn('WSTYD MI ZA CIEBIE ... JESZCZE TU JESTES ! NA CO CZEKASZ ? KILLUJ');
        end;
    if (wpisz = 'SLON') or (wpisz = 'LEW') or (wpisz = 'ZYRAFA') or (wpisz = 'WIELBLAD') or
       (wpisz = 'STRUS') or (wpisz = 'BOA') or (wpisz = 'WILK') or (wpisz = 'BIZON') or
       (wpisz = 'PANTERA') or (wpisz = 'WARIAT') or (wpisz = 'SLUCHACZ') or (wpisz = 'FAN') or
       (wpisz = 'CZLOWIEK') or (wpisz = 'REPORTER') then
      begin if OGOL < 16 then WriteLn('TAK  TAK MAMA KUPI BERECIK GLOWKA W PORZADKU ? ');
      if (SIL > 15) and (SIL < 21) then WriteLn(' NA TWOIM MIEJSCU BYM SIE NIE ZAPUSZCZAL ');
      if (SIL > 20) and (SIL < 23) then WriteLn(' RYZYK FIZYK - TAK NA 50% - WALKA NA SMIERC I ZYCIE');
      if SIL > 22 then WriteLn('SPOX KILLUJ BEZ UPRZEDZEN');
    end;
    if (wpisz = 'GLADIATOR') or (wpisz = 'WOJOWNIK') or (wpisz = 'TRENER') or
       (wpisz = 'POLICJANT') or (wpisz = 'GORYL') or (wpisz = 'OCHRONIARZ') then begin
      if OGOL < 15 then WriteLn('HA HA NIE NA SERJO . DAJ SE W ZYLE OKI? TO DOWCIP? HA HA HA');
      if (OGOL > 14) and (OGOL < 18) then WriteLn('POMARZ SOBIE WARIACIE . MOZE CI SIE PRZYSNI');
      if (OGOL > 17) and (OGOL < 23) then WriteLn('POWIEM  BEZ OGRODEK-TO GLUPI POMYSL');
      if (OGOL > 22) and (OGOL < 26) then WriteLn('TO DOSC RYZYKOWNE ZE TAK POWIEM');
      if OGOL > 25 then WriteLn('TO BEDZIE TAK PROSTE JAK ZABICIE DZIECKA TOPOREM !!!');
    end;
    if (wpisz = 'MINI-BARMAN') or (wpisz = 'GRUBAS') or (wpisz = 'D.J') then begin
      if OGOL < 24 then WriteLn('SMIERC PODZIEKUJE CI ZA TWOJ DAR (ALE ZGAPIAM)');
      if (OGOL > 23) and (OGOL < 26) then WriteLn('NIE UDAWAJ BISTY-BOYS PRZEGRASZ NA 99%');
      if (OGOL > 25) and (OGOL < 29) then WriteLn('PERFEKCYJNY MECZ NA SMIERC I ZYCIE !!!');
      if OGOL > 28 then WriteLn('JESTES ZNACZNIE SILNIEJSZY !!!(ALE GLUPSZY)');
      if OGOL > 34 then WriteLn('UWAZAJ DOSTANIESZ MALO KUNSZTU !!!');
    end;
    if (wpisz = 'TAKSOWKARZ') or (wpisz = 'SPRZEDAWCA') or (wpisz = 'GITARZYSTA') or (wpisz = 'PERKUSISTA') or
       (wpisz = 'ORGANISTA') or (wpisz = 'ZEBRAK') or (wpisz = 'PIJAK') or (wpisz = 'ZAMIATACZ') or (wpisz = 'SZCZAW') or
       (wpisz = 'STOKROTKA') or (wpisz = 'KONICZYNKA') or (wpisz = 'MLECZ') or (wpisz = 'DMUCHAWIEC') then begin
      if OGOL < 21 then WriteLn('NIE');
      if (OGOL > 22) and (OGOL < 28) then WriteLn('RACZEJ NIE , CHOC MOZNA ZARYZYKOWAC(NIE POLECAM)');
      if OGOL > 27 then WriteLn('TAK');
    end;
    if (wpisz='PEDAL') or (wpisz='PARA') or (wpisz='MACIEK') or (wpisz='ROZA') or
       (wpisz='MALINA') or (wpisz='TRAWA') or (wpisz = 'AGREST') or (wpisz = 'JEZYNA') then begin
      if OGOL < 20 then WriteLn('WIERZ MI ALE TO NAPRAWDE WIERZ MI ZE NIE MASZ SZANS');
      if (OGOL > 19) and (OGOL < 26) then WriteLn('RACZEJ NIE WYGRASZ WIEC LEPIEJ NIE ATAKUJ');
      if (OGOL > 25) and (OGOL < 30) then WriteLn('JESTESCIE SOBIE ROWNI (NAPRAWDE !!!) - WIEC 50% SZANS');
      if OGOL > 29 then WriteLn('JESTES SILNIEJSZY STAD WNIOSEK ZE SOBIE PORADZISZ');
      if OGOL > 35 then WriteLn('P.S - JESTES DUZO DUZO SILNIEJSZY ZABIJ BEZ OGRODEK!!!');
    end;
    if wpisz = 'LIROY' then begin
      if OGOL < 28 then WriteLn('HAHAHAHAHAHAHAHAHAHHAHOHOHOHHOHOHOHOHOHOHOHOAHAHAHAHAHAHAH');
      if (OGOL > 27) and (OGOL < 33) then WriteLn('HIHIHIHIHIHIHIHHEHEHEHE :))))))');
      if (OGOL > 32) and (OGOL < 44) then WriteLn('SPROOB'#224'J A MO'#189'E WYGRAC SIE UDA......');
    if (OGOL > 43) and (OGOL < 48) then WriteLn('NIE PRZEJMUJ SIE JEGO MORD'#164' JESTES SILNIEJSZY I BASTA');
      if OGOL > 47 then WriteLn('UWAZAJ ... NA CHLAPIACE MOZGI FLAKI PRZECIWNIKA');
    end;
    if wpisz = 'POKRZYWA' then begin
      if OGOL < 40 then WriteLn('NIE MASZ NAJMNIEJSZYCH SZANS');
      if OGOL > 39 then WriteLn('JEST PEWNE PRAWDOPODOBIENSTWO WYGRANIA TEGO STARCIA');

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
  if JAMNIK = MIECHO then WriteLn('DLUGI JAMNIK GRYZIE CI PODESZWY');
  if OWCZAREK = MIECHO then WriteLn('PUCHATY OWCZAREK WYLEGUJE SIE W SLONCU');
  if PIESEK = MIECHO then WriteLn('PIESEK SZUKA DRZEWKA ABY ULZYC SOBIE');
  if SPANIEL = MIECHO then WriteLn('SPANIEL SLINI SIE AZ MILO');
  if PUDEL = MIECHO then WriteLn('PUDEL JE KITIKET WIEC CHYBA MU NIE PRZERWIESZ.....?');
  if TAKSOWKARZ = MIECHO then WriteLn('TAKSOWKARZ WTARGNA TU ZE SWOJA BRYKA , I CZEKA NA KLIENTOW');
  if SPRZEDAWCA = MIECHO then
    WriteLn('SPRZEDAWCA PRECELKOW WLASNIE SPRZEDAL OSTATNIEGO , CZYM DOPROWADZA DO SZALENSTWA LATAJACE WOKOLO NIEGO KRUKI');
  if ZAMIATACZ = MIECHO then WriteLn('ZAMIATACZ ULIC SPRAWIA ZE JEST TU CZYSTO JAK W CHLEWIE');
  if PIJAK = MIECHO then WriteLn('PIJAK TU STOI(DOBRE SOBIE) I SMIERDZI MU Z GEBY');
  if ZEBRAK = MIECHO then WriteLn('ZEBRAK UDOWADNIA PRZECHODNIOM ZE ON NAPRAWDE JEST CHORY NA AIDS');
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
  MINIKUNSZT := MINIKUNSZT + MinikunsztMaxe(MAXE - WROGEN);
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
    if MAXE > 75 then MINIKUNSZT := MINIKUNSZT - 2;
    if MAXE > 115 then MINIKUNSZT := MINIKUNSZT - 3;
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
    MAXE := MAXE + 5;
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
    MAXE := MAXE - 5;
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
    if ENERGIA > MAXE then ENERGIA := MAXE;
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
    if ENERGIA > MAXE then ENERGIA := MAXE;
  end;
  if (wpisz = 'UZYJ CIASTKO') and (CIASTKO <= -10) then begin
    PRZED := PRZED - 1;
    CIASTKO := CIASTKO + 10;
    WriteLn('ZJADASZ CIASTKO I TYJESZ 2 KILO (DOSTAJESZ 12% ENERGII)');
    ENERGIA := ENERGIA + 12;
    if ENERGIA > MAXE then ENERGIA := MAXE;
  end;
  if (wpisz = 'UZYJ SUCHA RACJA') and (SUCHA <= -10) then begin
    PRZED := PRZED - 1;
    SUCHA := SUCHA + 10;
    WriteLn('ZJADASZ SUCHA RACJE I CHUDNIESZ 3 KILO (DOSTAJESZ 16% ENERGII)');
    ENERGIA := ENERGIA + 16;
    if ENERGIA > MAXE then ENERGIA := MAXE;
  end;
  if (wpisz = 'UZYJ BULKA') and (BULKA <= -10) then begin
    PRZED := PRZED - 1;
    BULKA := BULKA + 10;
    WriteLn('ZJADASZ BULKE I STWIERDZASZ ZE ZYSKALES 20%');
    ENERGIA := ENERGIA + 20;
    if ENERGIA > MAXE then ENERGIA := MAXE;
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
    if ENERGIA > MAXE then ENERGIA := MAXE;
  end;
  if wpisz = 'UZYJ KASETA' then WriteLn('TEN PRZEMIOT JEST TYPU : SMIEC . S.Z -8 MAXE +5 ZRE +1 ');
  if (wpisz = 'UZYJ WEKA') and (WEKA <= -10) then begin
    PRZED := PRZED - 1;
    WEKA := WEKA + 10;
    WriteLn('ZJADASZ DLUGASNA WEKE I TYJAC 15 KILO ZYSKUJESZ 34%');
    ENERGIA := ENERGIA + 34;
    if ENERGIA > MAXE then ENERGIA := MAXE;
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
    if ENERGIA > MAXE then ENERGIA := MAXE;

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
      MAXE := MAXE - 1;
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

begin
  if (wpisz = cmd) and (roslin = MIECHO) then begin
    VEASY;
    roslin := 0;
  end;
end;

procedure ZabijRoslineVEASYEnergy(cmd: string; var roslin: Integer);

begin
  if (wpisz = cmd) and (roslin = MIECHO) then begin
    VEASY;
    if ENERGIA > 0 then roslin := 0;
  end;
end;

procedure ZabijRoslineEASYEnergy(cmd: string; var roslin: Integer);

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

  ZabijRoslineVEASY('ZABIJ SZCZAW', SZCZAW);
  ZabijRoslineVEASY('ZABIJ KONICZYNKA', KONICZYNKA);
  ZabijRoslineVEASY('ZABIJ MLECZ', MLECZ);
  ZabijRoslineVEASY('ZABIJ DMUCHAWIEC', DMUCHAWIEC);

  ZabijRoslineVEASYEnergy('ZABIJ STOKROTKA', STOKROTKA);

  ZabijRoslineEASYEnergy('ZABIJ ROZA', ROZA);
  ZabijRoslineEASYEnergy('ZABIJ OSET', OSET);
  ZabijRoslineEASYEnergy('ZABIJ MALINA', MALINA);
  ZabijRoslineEASYEnergy('ZABIJ AGREST', AGREST);
  ZabijRoslineEASYEnergy('ZABIJ JEZYNA', JEZYNA);

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

const
  MIECHO_Podswiadomosc = 1000;
  MIECHO_Smierc = 10000;

  Lvl1_Threshold = 700;
  Lvl2_Threshold = 725;
  Lvl3_Threshold = 730;
  Lvl4_Base = 735;
  Lvl9_Base = 735;
var
  Unused0052: Integer;
  JakaBron: Integer;
  ZapisanoGre: Integer;
  StanCieniasa: Integer;
  StanZrecznego: Integer;
  StanOdpornego: Integer;
  StanOgromnego: Integer;
  JakaTarcza: Integer;
  LimitPrzedmiotow: Integer;
  WartoscMiecza: Integer;
  WartoscTarczy: Integer;
  WartoscSerca: Integer;
  PunktKontrolny: Integer;
  SilaZbroi: Integer;
  GodzinySnu: Integer;
  PotrawkiNiepotrzebnaZmiennaBug: Integer;
  Unused0076: Integer;
  _dummy_int: Integer;
  Powracanie: Integer;
  PrzedmScrollPowrot: Integer;
  PrzedmPiwo: Integer;
  WyjscieZadane: Boolean;
  plik: Text;

type
  TRace = record
    name: string;
    sil, zre, mad: Integer;
    maxsil, maxzre, maxmad: Integer;
    dmaxmana, dforsa, dmaxe, denergia: Integer;
  end;

  TZreLimit = record
    zre: Integer;
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
    (name:'CZLOWIEK'; sil:10; zre:10; mad:10;
     maxsil:15; maxzre:15; maxmad:15;
     dmaxmana:0; dforsa:0; dmaxe:0; denergia:0),
    (name:'OLBRZYM'; sil:13; zre:13; mad:5;
     maxsil:20; maxzre:20; maxmad:7;
     dmaxmana:-30; dforsa:0; dmaxe:0; denergia:0),
    (name:'NIMFA'; sil:10; zre:13; mad:7;
     maxsil:15; maxzre:20; maxmad:11;
     dmaxmana:0; dforsa:0; dmaxe:0; denergia:0),
    (name:'POL-ELF'; sil:6; zre:16; mad:8;
     maxsil:10; maxzre:24; maxmad:12;
     dmaxmana:-20; dforsa:30; dmaxe:-5; denergia:-5),
    (name:'UFOK'; sil:9; zre:9; mad:13;
     maxsil:13; maxzre:14; maxmad:20;
     dmaxmana:50; dforsa:0; dmaxe:0; denergia:0),
    (name:'CZAROMIL'; sil:6; zre:7; mad:16;
     maxsil:9; maxzre:11; maxmad:25;
     dmaxmana:150; dforsa:0; dmaxe:0; denergia:0)
  );

  ZreItemLimits: array[1..7] of TZreLimit = (
    (zre: 0; limit: 10), (zre: 11; limit: 11), (zre: 13; limit: 12),
    (zre: 16; limit: 13), (zre: 19; limit: 14), (zre: 21; limit: 15),
    (zre: 25; limit: 16));

procedure WalkaKoncert; forward;
procedure WybierzRase; forward;
procedure PunktyKontrolne; forward;
procedure SprawdzCzyZdobylesLevel; forward;
procedure Trening; forward;
procedure Pokoj2; forward;
procedure Pokoj3; forward;
procedure Pokoj9; forward;
procedure Pokoj12; forward;
procedure WalkaMiasto; forward;
procedure ZakupyPiekarnia; forward;
procedure ZakupyZbrojownia; forward;
procedure ZakupySklepWielobranzowy; forward;
procedure ZakupySklepMagiczny; forward;
procedure PokojeKoncertowe; forward;
procedure ZapiszPostac; forward;
procedure Smierc; forward;
procedure WczytajPostac; forward;
procedure PokazPostac; forward;

function LevelName(lvl: Integer): string;

const
  Names: array[4..13] of string = (
    'CZWARTYM', 'PIATYM', 'SZ'#224'STYM', 'SIODMYM', 'OSMYM',
    'DZIEWIATYM', 'DZIESIATYM', 'JEDENASTYM', 'DWUNASTYM', 'TRZYNASTYM');
begin
  if (lvl >= 4) and (lvl <= 13) then LevelName := Names[lvl]
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

procedure PokazPostac;

var
  i, gap: Integer;
begin

  for i := High(ZreItemLimits) downto Low(ZreItemLimits) do
    if ZRE >= ZreItemLimits[i].zre then begin
      LimitPrzedmiotow := ZreItemLimits[i].limit;
      Break;
    end;
  if PLECAK < 0 then LimitPrzedmiotow := LimitPrzedmiotow + 4;
  WriteLn('NOSISZ ZE SOBA:');
  ShowItem(MMIECZ, 'STARY ZARDZEWIALY MIECZ', 0);
  ShowItem(MTARCZA, 'OKRAGLA MALA TARCZA', 0);
  ShowItem(SERCE, 'ZAKRWAWIONE SERCE', 0);
  ShowItem(DYPLOM, 'DYPLOM MUD SZKOLY', 0);
  ShowItem(PACZEK, 'SMACZNY POLANY LIKIEREM PACZEK', 10);
  ShowItem(CIASTKO, 'SMACZNE CIASTKO ', 10);
  ShowItem(SUCHA, 'TWARDA SUCHA RACJE', 10);
  ShowItem(BULKA, 'OKRAGLA PACHNACA BULKA', 10);
  ShowItem(CHLEB, 'DUZY CIEPLY CHLEB', 10);
  ShowItem(WEKA, 'DLUGA I SMACZNA WEKE', 10);
  ShowItem(BIGOS, 'PYSZNY BIGOS Z KAPUSTA Z WROGA', 10);
  ShowItemDiv10(PrzedmPiwo, 'OZEWIAJACE PIWSKO Z KONKRETNYM KLIMATEM');
  ShowItemPlain(FAJKA, 'CIEZKA FAJKA OD DZIADA MROZA');
  ShowItemPlain(KOMPLET, 'KOMPLET UBRAN FIRMY "SYF"');
  ShowItemPlain(GARNITUR, 'GARNITUR Z KOLCAMI');
  ShowItemPlain(MBUTELKA, 'MALA BUTELKE MANY');
  ShowItemPlain(LISTEK, 'DELIKATNY CHOC SZORSTKI LISTEK');
  ShowItemPlain(kaseta, 'KASETA LIROYA : L - JAK LIROY ');
  ShowItemPlain(PIGULKA, 'PIGULKA TRANSPORTUJACA (M:G) ');
  ShowItemPlain(PRZEPUSTKA, 'PRZEPUSTKA WLASNORECZNIE PODPISANA PRZEZ QUEST-MASTERA ');
  ShowItemPlain(SCROLLPOR, 'SCROLL Z CZAREM : POROWNYWANIE ');
  ShowItemPlain(PrzedmScrollPowrot, 'SCROLL Z CZAREM : POWROT ');
  WriteLn('W SUMIE MASZ ', PRZED, '/', LimitPrzedmiotow, ' PRZEDMIOTOW');
  if JakaBron = 0 then WriteLn('BIJESZ SIE NA PIESCI');
  if JakaTarcza = 0 then WriteLn('NIE MASZ ZADNEJ OCHRONY');
  if JAKIEUB = '' then WriteLn('JESTES NAGI !!!!!!!!');
  if JAKIEUB = 'SYF' then WriteLn('MASZ NA SOBIE KOMPLET UBRAN FIRMY "SYF"');
  if JAKIEUB = 'GARNITUR' then WriteLn('MASZ NA SOBIE GRANITUR Z KOLCAMI ');
  if (JakaTarcza = 1) and (MTARCZA = -100) then
    WriteLn('TWOJA OCHRONA JEST MALA TARCZA');
  if (JakaBron = 1) and (MMIECZ = -100) then
    WriteLn('JAKO BRONI UZYWASZ STAREGO MIECZA');
  WriteLn('MASZ ', FORSA, ' MONET I ', PRA, ' PRAKTYK');

  gap := LevelThreshold(POZIOM) - KUNSZT;
  case POZIOM of
    1: WriteLn('JESTES NA PIERWSZYM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    2: WriteLn('JESTES NA DRUGIM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    3: WriteLn('JESTES NA TRZECIM LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, 'KUNSZTU');
    4..8: WriteLn('JESTES NA ', LevelName(POZIOM), ' LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
    9..13: WriteLn('JESTES NA ', LevelName(POZIOM), ' LEVELU A DO NASTEPNEGO BRAKUJE CI ', gap, ' KUNSZTU');
  end;
  if POZIOM > 13 then
    WriteLn('JESTES NA BARDZO WYSOKIM LEVELU A DO NASTEPNEGO BRAKUJE CI TYLKO', gap, ' KUNSZTU');

  WriteLn('TWOJE PARAMETRY : SILA - ', SIL, '/', MAXSIL,
         ' ZRECZNOSC - ', ZRE, '/', MAXZRE,
         ' MADROSC - ', MAD, '/', MAXMAD);
  SilaZbroi := 10 * ILOSC + PRO;
  WriteLn('S.Z-', SilaZbroi,
         '                    FUKSROLL-', FUKSROLL);
  WriteLn('MASZ ', MANA, '/', MAXMANA, ' MANY');
  WriteLn('MASZ ', ENERGIA, '/', MAXE, ' ENERGII');
  if QUEST = 1 then WriteLn('TWOJ AKTUALNY QUEST - ZABIC MUSISZ JESZCZE ', QUESTWYK, ' POTWOROW');
  if QUEST > 1 then WriteLn('TWOJ AKTUALNY QUEST - ZABIC MUSISZ JESZCZE ', QUESTWYK - 150, ' POTWOROW');
  if DUNQ <> 0 then WriteLn('NIE ZAPOMNIALES O POKRZYWIE W SADACH DUNCANA???');
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

procedure WybierzRase;

var
  chosen: Integer;
begin
  WSTEP;
  repeat
    WriteLn('NAPISZ SWA RASE : OLBRZYM , NIMFA , UFOK , CZAROMIL , CZLOWIEK , POL-ELF');
    ReadLn(wpisz);
    chosen := FindRace(wpisz);
    if chosen > 0 then begin
      SIL := Races[chosen].sil;
      ZRE := Races[chosen].zre;
      MAD := Races[chosen].mad;
      MAXSIL := Races[chosen].maxsil;
      MAXZRE := Races[chosen].maxzre;
      MAXMAD := Races[chosen].maxmad;
      MAXMANA := MAXMANA + Races[chosen].dmaxmana;
      FORSA := FORSA + Races[chosen].dforsa;
      MAXE := MAXE + Races[chosen].dmaxe;
      ENERGIA := ENERGIA + Races[chosen].denergia;
    end;
  until chosen > 0;
  WriteLn('PODAJE SWE IMIE (I TAK MNIE TO NIE OBCHODZI)');
  ReadLn(wpisz);
  ENERGIA := 50;
  PRA := 10;
  StanCieniasa := 12;

  SILNY := 13;
  StanZrecznego := 14;
  StanOdpornego := 15;
  StanOgromnego := 16;

  POZIOM := 1;
  MAXMANA := MAXMANA + 100;
  MANA := MAXMANA;
  POTWORY;
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

procedure ZabijPsa(cmd: string; var ps: Integer; extraMsg: Boolean);

begin
  if (wpisz = cmd) and (ps = MIECHO) then begin
    WALKAPIES;
    ps := 0;
    if extraMsg then begin
      WriteLn('GDY NAGLE!!!! NIEBIOSA SIE OTWIERAJA');
      WriteLn('A SPANIEL PRZEMAWIA DO CIEBIE LUDZKIM GLOSEM !!!!!');
      WriteLn('HAU HAU CHAMIE PO CO MNIE ZABILES ??? ');
    end;
  end;
end;

procedure ZabijMieszkancaVEASY(cmd: string; var npc: Integer; garnitur: Boolean);

begin
  if (wpisz = cmd) and (npc = MIECHO) then begin
    VEASY;
    npc := 0;
    if garnitur then GARNITURZYSK;
  end;
end;

procedure ZabijZamiatacz;

begin
  if (wpisz = 'ZABIJ ZAMIATACZ') and (ZAMIATACZ = MIECHO) then begin
    VEASY;
    ZAMIATACZ := 0;
    FUKS := Random(100);
    if (FUKS < 35) and (KOMPLET = 0) then begin
      WriteLn('ZYSKALES KOMPLET OBRABIAJAC ZAMIATACZA');
      KOMPLET := KOMPLET - 10;
    end;
  end;
end;

procedure ZabijZebrak;

begin
  if (wpisz = 'ZABIJ ZEBRAK') and (ZEBRAK = MIECHO) then begin
    VEASY;
    if ENERGIA > 0 then begin
      FUKS := Random(10);
      WriteLn('Z GRUBEGO PORTFELA ZEBRAKA WYCIAGASZ BONUS !!! ',
              FUKS, ' MONET!');
      FORSA := FORSA + FUKS;
      ZEBRAK := 0;
    end;
  end;
end;

procedure WalkaMiasto;

begin

  ZabijPsa('ZABIJ OWCZAREK', OWCZAREK, False);
  ZabijPsa('ZABIJ PIESEK', PIESEK, False);
  ZabijPsa('ZABIJ JAMNIK', JAMNIK, False);
  ZabijPsa('ZABIJ SPANIEL', SPANIEL, True);
  ZabijPsa('ZABIJ PUDEL', PUDEL, False);

  ZabijMieszkancaVEASY('ZABIJ TAKSOWKARZ', TAKSOWKARZ, True);
  ZabijMieszkancaVEASY('ZABIJ SPRZEDAWCA', SPRZEDAWCA, True);
  ZabijZamiatacz;
  ZabijMieszkancaVEASY('ZABIJ PIJAK', PIJAK, False);
  ZabijZebrak;
end;

procedure Trening;

begin
  if wpisz = 'PATRZ PLAKAT' then begin
    WriteLn('NA PLAKACIE PISZE:');
    WriteLn('MOZESZ CWICZYC UZYWAJAC KOMENDY CWICZ RAZEM Z ');
    if MAD < 11 then WriteLn('Z NICZYM BO MASZ ZA MALA MADROSC');
    if (MAD > 10) and (SIL > 11) then WriteLn('KOPAC - KOMENDA:KOP ');
    if (MAD > 10) and (ZRE > 10) then WriteLn('UCIEKAC - KOMENDA : ZWIEJ ');
    if (MAD > 15) and (ZRE > 11) then WriteLn('PAROWANIE - SAMOCZYNNIE ');
    if MAD > 11 then WriteLn('POROWNANIE-KOMEDA POROWNAJ');
    if MAD > 18 then WriteLn('POTRAWKI-SAMOCZYNNIE , PO WALCE');
    if MAD > 17 then WriteLn('POWROT-KOMEDA POWROT');
    if ZRE > 20 then WriteLn('ZRECZNE RECE - KOMENDA : RECE');
    if (SIL > 20) and (ZRE > 10) then WriteLn('KRZEPA : SAMOCZYNNIE');
    if (MAD > 19) and (ZRE > 10) and (SIL > 10) then
      WriteLn('TARGOWANIE SIE : SAMOCZYNNIE');
    if (SIL > 25) and (MAD > 12) then WriteLn('WIROWANIE - SAMOCZYNNIE ');
    if (SIL > 29) and (MAD > 14) then WriteLn('FATALITY - SAMOCZYNNIE ');
    if ZRE > 22 then WriteLn('COMBO - SAMOCZYNNIE ');
    if ZRE > 28 then WriteLn('SUPER COMBO - SAMOCZYNNIE ');
    if MAD > 22 then WriteLn('TRUCIZNA - SAMOCZYNNIE');
    if MAD > 23 then WriteLn('UZDRAWIANIE - KOMENDA UZDROW');
    if (ZRE > 24) and (MAD > 14) and (SIL > 14) then
      WriteLn('MOCNY SEN - SAMOCZYNNIE ');
    if MAD > 24 then WriteLn('OSLEPIANIE  - KOMEDA OSLEP ');
    if MAD > 26 then WriteLn('NEKROMANCJA - SAMOCZYNNIE ');
    if (SIL > 12) and (MAD > 19) and (ZRE > 12) then
      WriteLn('SZAL - KOMEDNA SZAL');
    if (ZRE > 22) and (MAD > 16) then WriteLn('SIATKA - KOMENDA SIATKA');
    if ZRE > 30 then WriteLn('CIOS W PLECY - KOMENDA CIOS W (COS)');
    if MAD > 29 then WriteLn('ROZPALANIE OGNISKA - KOMENDA ROZPAL');
    if MAD > 19 then WriteLn('HIPER SPEED - KOMENDA SPEED');
    if (MAD > 23) and (ZRE > 12) then WriteLn('PIECZENIE - KOMENDA PIECZ');
    WriteLn('W STANIE PODSWIADOMOSCI KOMEDA ZDOLNOSCI SPRAWDZI TWE ZDOLNOSCI');
  end;

  if wpisz = 'CWICZ KOPAC' then
    if (MAD > 10) and (SIL > 11) and (PRA > 0) then begin
      KOP := KOP + MAD;
      PRA := PRA - 1;
      WriteLn('CWICZYSZ KOPANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', KOP,
              '% MASZ ', PRA, ' PRAKTYK');
    end;

  if wpisz = 'CWICZ UCIEKAC' then begin
    if MAD > 10 then
      if ZRE > 10 then
        if (PRA > 0) and (ZWIEJ < 85) then begin
          ZWIEJ := ZWIEJ + MAD + ZRE - 5;
          PRA := PRA - 1;
          WriteLn('CWICZYSZ UCIEKANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', ZWIEJ,
                  '% MASZ ', PRA, ' PRAKTYK');
        end else
          WriteLn('ALBO MASZ ZA DOBRZE WYTRENOWANE ALBO ZA MALO PRAKTYK');
  end;

  if wpisz = 'CWICZ POWROT' then
    if (MAD > 17) and (Powracanie < 90) and (PRA > 0) then begin
      Powracanie := Powracanie + 2 * MAD - 3;
      PRA := PRA - 1;
      WriteLn('CWICZYSZ POWRACANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', Powracanie,
              '% MASZ ', PRA, ' PRAKTYK');
    end;

  if wpisz = 'CWICZ PAROWANIE' then
    if (MAD > 15) and (ZRE > 11) and (PAR < 90) and (PRA > 0) then begin
      PAR := PAR + MAD + ZRE - 14;
      PRA := PRA - 1;
      WriteLn('CWICZYSZ PAROWANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', PAR,
              '% MASZ ', PRA, ' PRAKTYK');
    end;

  if wpisz = 'CWICZ POROWNANIE' then
    if (MAD > 11) and (POR < 90) and (PRA > 0) then begin
      POR := POR + 3 * MAD - 9;
      PRA := PRA - 1;
      WriteLn('CWICZYSZ POROWNYWANIE - PRAWDOPODOBIENSTWO JEST TERAZ ', POR,
              '% MASZ ', PRA, ' PRAKTYK');
    end;

  if wpisz = 'CWICZ POTRAWKI' then
    if (MAD > 18) and (POTRAWKI < 90) and (PRA > 0) then begin
      POTRAWKI := POTRAWKI + MAD + 1;
      PRA := PRA - 1;
      WriteLn('CWICZYSZ POTRAWKI - PRAWDOPODOBIENSTWO JEST TERAZ ', POTRAWKI,
              '% MASZ ', PRA, ' PRAKTYK');
    end;
end;

procedure ZapiszPostac;
begin
  wpisz := 'JA';
  ZapisanoGre := 1;
  WriteLn('ALL RIGHT !!! GRA ZAPISANA! ;)');
  save;
  ClrScr;
  Assign(plik, 'pliki.tpu');
  Rewrite(plik);
  WriteLn(plik, MANA * 4);
  WriteLn(plik, POZIOM + $17);
  WriteLn(plik, MMIECZ);
  WriteLn(plik, FAJKA);
  WriteLn(plik, DYPLOM);
  WriteLn(plik, MTARCZA);
  WriteLn(plik, GARNITUR);
  WriteLn(plik, KUNSZT);
  WriteLn(plik, (ENERGIA + $28) * 4);
  WriteLn(plik, MIECHO2);
  WriteLn(plik, ZRE + 12);
  WriteLn(plik, SIL - 24);
  WriteLn(plik, MAD);
  WriteLn(plik, PRA);
  WriteLn(plik, PunktKontrolny);
  WriteLn(plik, Unused0052);
  WriteLn(plik, 0);
  WriteLn(plik, FORSA * MAD);
  WriteLn(plik, CZY);
  WriteLn(plik, MAXE);
  WriteLn(plik, LimitPrzedmiotow);
  WriteLn(plik, POR);
  WriteLn(plik, MAXMANA);
  WriteLn(plik, MAXSIL);
  WriteLn(plik, MAXZRE);
  WriteLn(plik, MAXMAD);
  WriteLn(plik, PRZED);
  WriteLn(plik, PRO);
  WriteLn(plik, FUKSROLL);
  WriteLn(plik, JakaBron);
  WriteLn(plik, CIALO);
  WriteLn(plik, OGOL);
  WriteLn(plik, ZapisanoGre);
  WriteLn(plik, StanCieniasa);
  WriteLn(plik, SILNY);
  WriteLn(plik, StanZrecznego);
  WriteLn(plik, StanOdpornego);
  WriteLn(plik, StanOgromnego);
  WriteLn(plik, JakaTarcza);
  WriteLn(plik, SilaZbroi);
  WriteLn(plik, POTRAWKI);
  WriteLn(plik, PotrawkiNiepotrzebnaZmiennaBug);
  WriteLn(plik, Unused0076);
  WriteLn(plik, SERCE);
  WriteLn(plik, MBUTELKA);
  WriteLn(plik, CIASTKO);
  WriteLn(plik, SUCHA);
  WriteLn(plik, CHLEB);
  WriteLn(plik, BULKA);
  WriteLn(plik, WEKA);
  WriteLn(plik, CHLEB);
  WriteLn(plik, BULKA);
  WriteLn(plik, ILOSC);
  WriteLn(plik, PAR);
  WriteLn(plik, KOP);
  WriteLn(plik, KOPM);
  WriteLn(plik, KOPHP);
  WriteLn(plik, ZWIEJ);
  WriteLn(plik, WIMP);
  WriteLn(plik, PASZOL);
  WriteLn(plik, ARENA);
  WriteLn(plik, KOMPLET);
  WriteLn(plik, kaseta);
  WriteLn(plik, PIGULKA);
  WriteLn(plik, KORNIK);
  WriteLn(plik, MUCHA);
  WriteLn(plik, BAKTERIA);
  WriteLn(plik, QUEST);
  WriteLn(plik, QUESTWYK);
  WriteLn(plik, SLIMAK);
  WriteLn(plik, LISTEK);
  WriteLn(plik, Powracanie);
  WriteLn(plik, BIGOS);
  WriteLn(plik, PrzedmPiwo);
  WriteLn(plik, SCROLLPOR);
  WriteLn(plik, PrzedmScrollPowrot);
  WriteLn(plik, STARUCH);
  WriteLn(plik, DUNQ);
  WriteLn(plik, PLECAK);
  WriteLn(plik, DUNCAN);
  WriteLn(plik, JAKIEUB);
  Close(plik);
end;

procedure Smierc;

begin
  WriteLn('AJAJAJAJ TWOJA GLOWA NAWALA JAK TESCIOWA!!!');
  WriteLn('NIC NA TO NIE PORADZE , TRZEBA BYLO SIE STARAC');
  WriteLn('NAGLE REFLEKSJA - DO JASNEJ CENZURY JAK SIE WALCZYLO TYM MIECZEM?');
  WriteLn('NIESTETY WRAZ ZE SMIERCIA TRACISZ KUNSZT ADEKWATNIE DO TWOJEGO LEVELKA');
  WriteLn('POJAWISZ SIE W CENTRUM MIASTA ..... POWODZENIA');
  WriteLn('P.S : AHA POTWORY SIE ODREGENEROWALY');
  WriteLn('P.S.2 : Z OSTATNIEJ CHWILI : HE HE HE SPROBOJ ODLOADOWAC POSTAC >:)');
  if QUEST = 1 then QUESTWYK := 50;
  if QUEST > 1 then QUESTWYK := 200;
  ENERGIA := MAXE;
  KUNSZT := KUNSZT - 250 + Random(50) - (5 * POZIOM);
  MIECHO := 20;
  POTWORY;
  wpisz := 'PAMIETAJ';
  ReadLn;
  ZapiszPostac;
end;

procedure KupItem(cmd: string; var itemVar: Integer; price: Integer;
                  msg: string; available: Boolean);

begin
  if (wpisz = cmd) and available and (FORSA >= price) then begin
    PRZED := PRZED + 1;
    itemVar := itemVar - 10;
    FORSA := FORSA - price;
    WriteLn(msg);
  end;
end;

procedure ZakupyPiekarnia;

begin
  if wpisz = 'LISTA' then begin
    WriteLn('NAZWA         CENA');
    WriteLn('PACZEK     :   8  ');
    WriteLn('CIASTKO    :   12 ');
    WriteLn('SUCHA RACJA:   15 ');
    WriteLn('BULKA      :   19 ');
    WriteLn('CHLEB      :   24 ');
    WriteLn('WEKA       :   29 ');
  end;
  WalkaMiasto;
  KupItem('KUP PACZEK', PACZEK, 8, 'KUPUJESZ PACZEK ZA 8 MONET', True);
  KupItem('KUP CIASTKO', CIASTKO, 12, 'KUPUJESZ CIASTKO ZA 12 MONET', True);
  KupItem('KUP SUCHA RACJA', SUCHA, 15, 'KUPUJESZ SUCHA RACJE ZA 15 MONET', True);
  KupItem('KUP BULKA', BULKA, 19, 'KUPUJESZ BULKE ZA 19 MONET', True);
  KupItem('KUP CHLEB', CHLEB, 24, 'KUPUJESZ CHLEB ZA 24 MONET', True);
  KupItem('KUP WEKA', WEKA, 29, 'KUPUJESZ WEKE ZA 29 MONET', True);
end;

procedure ZrealizujZakupy(const rules: array of TShopRule);
var
  i: Integer;
begin
  for i := Low(rules) to High(rules) do
    if wpisz = rules[i].cmd then begin
      if rules[i].allowed then
        rules[i].act;
      Break;
    end;
end;

function Zawsze: Boolean;
begin
  Zawsze := True;
end;

function MoznaKupicStary: Boolean;
begin
  MoznaKupicStary := (MMIECZ = 0) and (FORSA >= 70);
end;

procedure KupStary;
begin
  PRZED := PRZED + 1;
  MMIECZ := -10;
  FORSA := FORSA - 70;
  WriteLn('KUPUJESZ ZWYKLY MALY !STARY! MIECZYK ZA 70 MONET');
  WartoscMiecza := 500;
end;

function MoznaSprzedacStary: Boolean;
begin
  MoznaSprzedacStary := MMIECZ = -10;
end;

procedure SprzedajStary;
begin
  WriteLn('SPRZEDAWCA MOWI CI : WYPCHAJ SIE Z TYM MIECZEM');
  WriteLn('ALBO DOBRA KUPIE GO OD CIEBIE ZA 30 MONET');
  FORSA := FORSA + 30;
  MMIECZ := 0;
  PRZED := PRZED - 1;
end;

function MoznaKupicMala: Boolean;
begin
  MoznaKupicMala := (MTARCZA = 0) and (FORSA >= 15);
end;

procedure KupMala;
begin
  PRZED := PRZED + 1;
  MTARCZA := -10;
  FORSA := FORSA - 15;
  WriteLn('KUPUJESZ !MALA! TARCZA ZA 15 MONET');
end;

procedure SprzedajMala;

begin
  WriteLn('TA TARCZA JEST BAJER,FRAJER KUPIE JA OD CIEBIE ZA 8 MONET');
  FORSA := FORSA + 8;
  MTARCZA := 0;
  PRZED := PRZED - 1;
end;

const
  ZbrojowniaRules: array[1..4] of TShopRule = (
    (cmd:'KUP STARY'; allowed:MoznaKupicStary; act:KupStary),
    (cmd:'SPRZEDAJ STARY'; allowed:MoznaSprzedacStary; act:SprzedajStary),
    (cmd:'KUP MALA'; allowed:MoznaKupicMala; act:KupMala),
    (cmd:'SPRZEDAJ MALA'; allowed:Zawsze; act:SprzedajMala)
  );

function MoznaKupicFajka: Boolean;
begin
  MoznaKupicFajka := (FAJKA = 0) and (FORSA >= 480);
end;

procedure KupFajka;
begin
  WriteLn('KUPUJESZ FAJKE ZA 480 MONET');
  FORSA := FORSA - 480;
  FAJKA := FAJKA - 10;
  PRZED := PRZED + 1;
  MAD := MAD + 1;
end;

function MoznaKupicKomplet: Boolean;
begin
  MoznaKupicKomplet := (KOMPLET = 0) and (FORSA >= 35);
end;

procedure KupKomplet;
begin
  WriteLn('KUPUJESZ !KOMPLET! UBRAN FIRMY "SYF" ZA 35 MONET');
  FORSA := FORSA - 35;
  KOMPLET := KOMPLET - 10;
  PRZED := PRZED + 1;
end;

function MoznaSprzedacKomplet: Boolean;
begin
  MoznaSprzedacKomplet := (KOMPLET <= -10) and (JAKIEUB <> 'SYF');
end;

procedure SprzedajKomplet;
begin
  WriteLn('SPRZEDAJESZ !KOMPLET! UBRAN FIRMY "SYF" ZA 15 MONET');
  FORSA := FORSA + 15;
  KOMPLET := KOMPLET + 10;
  PRZED := PRZED - 1;
end;

function MoznaSprzedacFajka: Boolean;
begin
  MoznaSprzedacFajka := FAJKA = -10;
end;

procedure SprzedajFajka;
begin
  WriteLn('SPRZEDAJESZ FAJKE ZA 120 MONET');
  FORSA := FORSA + 120;
  FAJKA := FAJKA + 10;
  PRZED := PRZED - 1;
  MAD := MAD - 1;
end;

function MoznaKupicKaseta: Boolean;
begin
  MoznaKupicKaseta := FORSA >= 1999;
end;

procedure KupKaseta;
begin
  WriteLn('KUPUJESZ KASETE LIROYA - L JAK LIROY ZA 1999 MONET');
  FORSA := FORSA - 1999;
  kaseta := kaseta - 10;
  PRO := PRO - 8;
  MAXE := MAXE + 5;
  ZRE := ZRE + 1;
  PRZED := PRZED + 1;
end;

function MoznaKupicGarnitur: Boolean;
begin
  MoznaKupicGarnitur := FORSA >= 1000;
end;

procedure KupGarnitur;
begin
  WriteLn('KUPUJESZ GARNITUR Z KOLCAMI ZA JEDYNE 1000 $');
  FORSA := FORSA - 1000;
  GARNITUR := GARNITUR - 10;
  PRZED := PRZED + 1;
end;

function MoznaSprzedacGarnitur: Boolean;
begin
  MoznaSprzedacGarnitur := JAKIEUB <> 'GARNITUR';
end;

procedure SprzedajGarnitur;
begin
  WriteLn('SPRZEDAJESZ GARNITUR Z KOLCAMI ZA JEDYNE 500 $');
  FORSA := FORSA + 500;
  GARNITUR := GARNITUR + 10;
  PRZED := PRZED - 1;
end;

function MoznaSprzedacKaseta: Boolean;
begin
  MoznaSprzedacKaseta := kaseta < 0;
end;

procedure SprzedajKaseta;
begin
  WriteLn('SPRZEDAJESZ KASETE LIROYA - L JAK LIROY ZA 1000 MONET');
  FORSA := FORSA + 1000;
  kaseta := kaseta + 10;
  PRO := PRO + 8;
  MAXE := MAXE - 5;
  ZRE := ZRE - 1;
  PRZED := PRZED - 1;
end;

const
  SklepWielobranzowyRules: array[1..8] of TShopRule = (
    (cmd:'KUP FAJKA'; allowed:MoznaKupicFajka; act:KupFajka),
    (cmd:'KUP KOMPLET'; allowed:MoznaKupicKomplet; act:KupKomplet),
    (cmd:'SPRZEDAJ KOMPLET'; allowed:MoznaSprzedacKomplet; act:SprzedajKomplet),
    (cmd:'SPRZEDAJ FAJKA'; allowed:MoznaSprzedacFajka; act:SprzedajFajka),
    (cmd:'KUP KASETA'; allowed:MoznaKupicKaseta; act:KupKaseta),
    (cmd:'KUP GARNITUR'; allowed:MoznaKupicGarnitur; act:KupGarnitur),
    (cmd:'SPRZEDAJ GARNITUR'; allowed:MoznaSprzedacGarnitur; act:SprzedajGarnitur),
    (cmd:'SPRZEDAJ KASETA'; allowed:MoznaSprzedacKaseta; act:SprzedajKaseta)
  );

function MoznaKupicMalaButelka: Boolean;
begin
  MoznaKupicMalaButelka := FORSA >= 15;
end;

procedure KupMalaButelka;
begin
  WriteLn('KUPUJESZ MALA BUTELKA MANY ZA 20 MONET ( AHHHH TA INFLACJA ) ');
  FORSA := FORSA - 20;
  MBUTELKA := MBUTELKA - 10;
  PRZED := PRZED + 1;
end;

function MoznaKupicListek: Boolean;
begin
  MoznaKupicListek := FORSA >= 820;
end;

procedure KupListek;
begin
  WriteLn('KUPUJESZ LISTEK KTORY PRZYNOSCI SZCZESCIE ZA 820 KESZU');
  FORSA := FORSA - 830;
  LISTEK := LISTEK - 10;
  PRZED := PRZED + 1;
  MAXMANA := MAXMANA + 40;
end;

function MoznaSprzedacListek: Boolean;
begin
  MoznaSprzedacListek := FORSA >= 820;
end;

procedure SprzedajListek;
begin
  WriteLn('SPRZEDAJESZ LISTEK ZA 400 !!! CIESZ SIE');
  FORSA := FORSA + 400;
  LISTEK := LISTEK + 10;
  PRZED := PRZED - 1;
  MAXMANA := MAXMANA - 40;
end;

function MoznaKupicPigulka: Boolean;
begin
  MoznaKupicPigulka := FORSA >= 235;
end;

procedure KupPigulka;
begin
  WriteLn('KUPUJESZ PIGULKE TRANSPORTUJACA ZA 235 MONET');
  FORSA := FORSA - 235;
  PIGULKA := PIGULKA - 10;
  PRZED := PRZED + 1;
end;

function MoznaSprzedacPigulka: Boolean;
begin
  MoznaSprzedacPigulka := PIGULKA <= 10;
end;

procedure SprzedajPigulka;
begin
  WriteLn('SPRZEDAWCA KUPUJE OD CIEBIE PIGULKE ZA 170 MONET');
  FORSA := FORSA + 170;
  PIGULKA := PIGULKA + 10;
  PRZED := PRZED - 1;
end;

function MoznaKupicScrollPorownanie: Boolean;
begin
  MoznaKupicScrollPorownanie := FORSA > 39;
end;

procedure KupScrollPorownanie;
begin
  WriteLn('SPRZEDAWCA SPRZEDAJE CI SCROLL ZA 40 MONET');
  FORSA := FORSA - 40;
  SCROLLPOR := SCROLLPOR - 10;
  PRZED := PRZED + 1;
end;

function MoznaSprzedacScrollPorownanie: Boolean;
begin
  MoznaSprzedacScrollPorownanie := SCROLLPOR < 0;
end;

procedure SprzedajScrollPorownanie;
begin
  WriteLn('SPRZEDAWCA KUPUJE OD CIEBIE SCROLL ZA NEDZNE 18 MONET');
  FORSA := FORSA + 18;
  SCROLLPOR := SCROLLPOR + 10;
  PRZED := PRZED - 1;
end;

const
  SklepMagicznyRules: array[1..7] of TShopRule = (
    (cmd:'KUP MALA BUTELKA MANY'; allowed:MoznaKupicMalaButelka; act:KupMalaButelka),
    (cmd:'KUP LISTEK'; allowed:MoznaKupicListek; act:KupListek),
    (cmd:'SPRZEDAJ LISTEK'; allowed:MoznaSprzedacListek; act:SprzedajListek),
    (cmd:'KUP PIGULKA TRANSPORTUJACA'; allowed:MoznaKupicPigulka; act:KupPigulka),
    (cmd:'SPRZEDAJ PIGULKA TRANSPORTUJACA'; allowed:MoznaSprzedacPigulka; act:SprzedajPigulka),
    (cmd:'KUP SCROLL POROWNYWANIE'; allowed:MoznaKupicScrollPorownanie; act:KupScrollPorownanie),
    (cmd:'SPRZEDAJ SCROLL POROWNYWANIE'; allowed:MoznaSprzedacScrollPorownanie; act:SprzedajScrollPorownanie)
  );

procedure ZakupyZbrojownia;

begin
  if wpisz = 'LISTA' then begin
    WriteLn('NAZWA         CENA');
    if MMIECZ = 0 then
      WriteLn('!STARY! MIECZ           :   70  10%-50%');
    if MTARCZA = 0 then
      WriteLn('!MALA! TARCZA           :   15  10%-50%');
    WriteLn('DLUGI MIECZ GLADIATORA  : 3200  2%');
  end;
  WalkaMiasto;
  ZrealizujZakupy(ZbrojowniaRules);
end;

procedure ZakupySklepWielobranzowy;

begin
  if wpisz = 'LISTA' then begin
    WriteLn('NAZWA                        CENA');
    if FAJKA = 0 then WriteLn('FAJKA                      :  480');
    if KOMPLET = 0 then
      WriteLn('!KOMPLET! UBRAN FIRMY "SYF":   35 ');
    WriteLn('!KASETA! LIROYA            : 1999 4%');
    WriteLn('GARNITUR Z KOLCAMI(3)      : 1000 2,5%');
  end;
  if wpisz = 'PATRZ POSTER' then
    WriteLn('OKAZJA !!! PRZY ZAKUPIE GARNITURU KOMPLET UBRAN GRATIS !!!(ZART)');
  ZrealizujZakupy(SklepWielobranzowyRules);
end;

procedure ZakupySklepMagiczny;

begin
  if wpisz = 'LISTA' then begin
    WriteLn('NAZWA                  CENA');
    WriteLn('MALA BUTELKA MANY       :   20');
    WriteLn('SREDNIA BUTELKA MANY    :   40');
    WriteLn('SPORA BUTELKA MANY      :   80');
    WriteLn('LISTEK SZCZESCIA        :  820 3%');
    WriteLn('PIERSCIONEK ZARECZYNOWY : 1800 N/A');
    WriteLn('PIGULKA TRANSPORTUJACA  :  235 ');
    WriteLn('SCROLL POROWNYWANIE     :   40 ');
  end;
  ZrealizujZakupy(SklepMagicznyRules);
end;

procedure WalkaKoncert;

begin
  if (wpisz = 'ZABIJ DZIECKO') and (DZIECKO = MIECHO) then begin
    MNIEJSLABO;
    if WROGEN < 1 then DZIECKO := 0;
  end;
  if (wpisz = 'ZABIJ DZIADEK') and (DZIADEK = MIECHO) then begin
    MNIEJSLABO;
    if WROGEN < 1 then begin
      DZIADEK := 0;
      FUKS := Random(100);
      if (FUKS < 5) and (FAJKA = 0) then begin
        WriteLn('WYCIAGASZ FAJKE Z UST DZIADKA ');
        WriteLn('TEN PRZEDMIOT JEST UNIQE 5%');
        FAJKA := FAJKA - 10;
        MAD := MAD + 1;
      end;
    end;
  end;
  if (wpisz = 'ZABIJ WARIAT') and (WARIAT = MIECHO) then begin
    SREDNIO;
    if WROGEN < 1 then WARIAT := 0;
  end;
  if (wpisz = 'ZABIJ SLUCHACZ') and (SLUCHACZ = MIECHO) then begin
    SREDNIO;
    if WROGEN < 1 then SLUCHACZ := 0;
  end;
  if (wpisz = 'ZABIJ CZLOWIEK') and (CZLOWIEK = MIECHO) then begin
    SREDNIO;
    if WROGEN < 1 then CZLOWIEK := 0;
  end;
  if (wpisz = 'ZABIJ FAN') and (FAN = MIECHO) then begin
    SREDNIO;
    if WROGEN < 1 then FAN := 0;
  end;
  if (wpisz = 'ZABIJ REPORTER') and (REPORTER = MIECHO) then begin
    SREDNIO;
    if WROGEN < 1 then REPORTER := 0;
  end;
  if (wpisz = 'ZABIJ POLICJANT') and (POLICJANT = MIECHO) then begin
    TRUDNO;
    if WROGEN < 1 then POLICJANT := 0;
  end;
  if (wpisz = 'ZABIJ GORYL') and (GORYL = MIECHO) then begin
    TRUDNO;
    if WROGEN < 1 then GORYL := 0;
    GARNITURZYSK;
  end;
  if (wpisz = 'ZABIJ OCHRONIARZ') and
     (OCHRONIARZ = MIECHO) then begin
    TRUDNO;
    if WROGEN < 1 then OCHRONIARZ := 0;
    GARNITURZYSK;
  end;
end;

procedure PunktyKontrolne;

begin
  if (KUNSZT >= 400) and (PunktKontrolny = 0) and (SIL < 20) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    PunktKontrolny := 1;
    POTWORY;
  end;
  if (KUNSZT >= 180) and (PunktKontrolny = 0) and (SIL < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    PunktKontrolny := 1;
    POTWORY;
  end;
  if (KUNSZT >= 360) and (PunktKontrolny = 1) and (SIL < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    PunktKontrolny := 2;
    POTWORY;
  end;
  if (KUNSZT >= 540) and (PunktKontrolny = 2) and (SIL < 8) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    PunktKontrolny := 3;
    POTWORY;
  end;
  if (KUNSZT >= 300) and (PunktKontrolny = 0) and (SIL > 7) and (SIL < 13) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    PunktKontrolny := 1;
    POTWORY;
  end;
  if (KUNSZT >= 500) and (PunktKontrolny = 1) and (SIL > 7) and (SIL < 13) then begin
    WriteLn('###################!!!CHECKPOINT!!!#########################');
    PunktKontrolny := 2;
    POTWORY;
  end;
end;

procedure Pokoj2;

begin
  if MIECHO <> 2 then Exit;
  WriteLn('JESTES W POKOJU GDZIE RAMBO TRENUJE SWYCH UCZNOW ');
  WriteLn('WSZ'#168'DZIE S'#164' PRZEDMIOTY DO R'#224#189'NYCH RODZAJI '#143'WICZE'#227);
  WriteLn('NO A POZA TYM NA SCIANIE JEST!!! PLAKAT!!!!');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-POK'#224'J CENTRALNY');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'ZACHOD' then MIECHO := 1;
    if wpisz = 'PATRZ PLAKAT' then begin
      WriteLn(#169' NA PLAKACIE PISZE:');
      WriteLn('ABY TRENOWA'#143' U'#189'YJ KOM'#168'DY TRENUJ RAZEM Z ');
      WriteLn('SILA , ZRECZNOSC  LUB MADROSC ');
    end;
    TRAIN;
  until MIECHO <> 2;
end;

procedure Pokoj3;

begin
  if MIECHO <> 3 then Exit;
  WriteLn('ZSZEDLES NA DOL GDZIE TRENUJE SIE MEDYTUJAC');
  WriteLn('NA SRODKU NA WIELKI MATERAC PRZEZNACZONY DO MEDYTACJI');
  WriteLn('NA SCIANCE JEST PIEKNIUTKI PLAKAT');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then
      WriteLn('DOSTEPNE WYJSCIE-GORA-HALA GLOWNA MUD SZKOLE ');
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'GORA' then MIECHO := 1;
    Trening;
  until MIECHO <> 3;
end;

procedure Pokoj9;

begin
  WriteLn('JESTES W MALUTKIM POKOJU ALE WIDZISZ WYJSCIA W DWIE STRONY ');
  WriteLn('SKADS SLYSZYSZ DZIWNE NIEPOKOJACE WRZASKI');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('DOL-MUD SZKOLA (2)');
      WriteLn('GORA-KLATKI PELNE GAJDY');
    end;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'DOL' then MIECHO := 5;
    if wpisz = 'GORA' then MIECHO := 11;
  until MIECHO <> 9;
end;

procedure Pokoj12;

begin
  if MIECHO <> 12 then Exit;
  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if StanCieniasa = 12 then
    WriteLn('POTWOR - CIENIAS STOI NA 1 NODZE POD SCIANA');
  if StanCieniasa = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-KLATKI PELNE GAJDY');
    end;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'WYJSCIE' then Exit;
    if wpisz = 'ZACHOD' then MIECHO := 11;
    if (wpisz = 'ZABIJ POTWOR') and (StanCieniasa = 12) then begin
      WROGEN := 20; WROGZRE := 3; WROGSIL := 3;
      WALKA;
      if PASZOL = 0 then begin
        StanCieniasa := 0;
        CZY := Random(10);
        WriteLn('WYCIAGASZ ', CZY, ' MONET Z CIALA POTWORA');
        FORSA := FORSA + CZY;
        if MMIECZ = 0 then begin
          FUKS := Random(20);
          if FUKS < 4 then begin
            MMIECZ := MIECHO;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            WartoscMiecza := 500;
          end;
        end;
        if MTARCZA = 0 then begin
          FUKS := Random(20);
          if FUKS < 4 then begin
            MTARCZA := MIECHO;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            WartoscTarczy := 300;
          end;
        end;
        if SERCE = 0 then begin
          FUKS := Random(20);
          if FUKS < 6 then begin
            SERCE := MIECHO;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            WartoscSerca := 50;
          end;
        end;
      end
      else
        PASZOL := 0;
    end;
  until MIECHO <> 12;
end;

procedure PokojeKoncertowe;

begin
  if MIECHO = 61 then begin

    WriteLn('KIEDY PODSZEDLES BLIZEJ ZBARANIALES - TO SALA KONCERTOWA !!!');
    WriteLn('WOKOLO TLUMY SLUCHAJA MUZYKI , DZIWNA TO MUZYKA - WLASCIWIE SAME SLOWA');
    WriteLn('!!!!!!!!!NA SCIANIE JEST PLAKAT !!!!!!!!!!!!!!!');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-DOLINA ROZRYWEK');
        WriteLn('POLNOC-TLUM');
        WriteLn('POLODNIE-TLUM');
      end;
      WalkaKoncert;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'ZACHOD' then MIECHO := 60;
      if wpisz = 'POLNOC' then MIECHO := 63;
      if wpisz = 'POLODNIE' then MIECHO := 62;
      if wpisz = 'WSCHOD' then MIECHO := 64;
      if wpisz = 'PATRZ PLAKAT' then begin
        WriteLn(' NA PLAKACIE PISZE :');
        WriteLn('20 X 98 r KONCERT LIROYA - ZAPRASZAMY WSZYSTKICH  ');
      end;
    until MIECHO <> 61;
  end;
  if MIECHO = 62 then begin

    WriteLn('NA BRZEGACH TLUM JEST MNIEJSZY , MIMO TO UCZUCIE SCISKU IRYTUJE CIE');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-TLUM');
        WriteLn('WSCHOD-TLUM');
      end;
      WalkaKoncert;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLNOC' then MIECHO := 61;
      if wpisz = 'WSCHOD' then MIECHO := 65;
    until MIECHO <> 62;
  end;
  if MIECHO = 63 then begin

    WriteLn('NA BRZEGACH TLUM JEST RZADSZY , BOISZ SIE POMYSLEC CO SIE DZIEJE W SRODKU');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLODNIE-TLUM');
        WriteLn('WSCHOD-TLUM');
        WriteLn('POLNOC-PIWIARNIA');
      end;
      WalkaKoncert;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLODNIE' then MIECHO := 61;
      if wpisz = 'WSCHOD' then MIECHO := 66;
      if wpisz = 'POLNOC' then MIECHO := 67;
    until MIECHO <> 63;
  end;
  if MIECHO = 64 then begin

    WriteLn('JESTES W SRODKU TLUMU A DO TEGO PRZY BALUSTRADKACH-CO ZA TLOK');
    WriteLn('NIE MOZNA ODDYCHAC W TAKIM TLUMIE - LEPIEJ SZYBKO Z TAD IDZ');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-TLUM');
        WriteLn('POLNOC-TLUM');
        WriteLn('POLODNIE-TLUM');
      end;
      WalkaKoncert;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLNOC' then MIECHO := 66;
      if wpisz = 'ZACHOD' then MIECHO := 61;
      if wpisz = 'POLODNIE' then MIECHO := 65;
    until MIECHO <> 64;
  end;
  if MIECHO = 65 then begin

    WriteLn('JESTES Z BOKU ALE PRZY BALUSTRADKACH LUDZIE WPYCHAJA CIE NA TE BALUSTRADKI');
    WriteLn('NIE MOZNA ODDYCHAC W TAKIM TLUMIE - LEPIEJ SZYBKO Z TAD IDZ');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-TLUM');
        WriteLn('POLNOC-TLUM');
      end;
      WalkaKoncert;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLNOC' then MIECHO := 64;
      if wpisz = 'ZACHOD' then MIECHO := 62;
    until MIECHO <> 65;
  end;
  if MIECHO = 66 then begin

    WriteLn('JESTES PRZY BALUSTRADKACH-NIE BEDE SIE ROZWODZIL JAK CI JEST CIASNO');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-TLUM');
        WriteLn('POLODNIE-TLUM');
      end;
      WalkaKoncert;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLODNIE' then MIECHO := 64;
      if wpisz = 'ZACHOD' then MIECHO := 63;
    until MIECHO <> 66;
  end;
  if MIECHO = 67 then begin

    WriteLn('JESTES W PIWIARNI - WOKOLO CIEBIE UNOSI SIE ZAPACH PIWA , TY NIE PIJASZ PIWA');
    WriteLn('TY PIJASZ JABOLA !!! , NIE REZYGNUJAC ZE SWYCH PRZYZWYCZAJEN ROZGLADASZ SIE:');
    if MINIBARMAN = 67 then
      WriteLn('I WIDZISZ MINI-BARMANA SPIESZACEGO SIE ABY PODAC WSZYSTKIM NAWARZONE PIWO');
    if GRUBAS = 67 then
      WriteLn('I WIDZISZ GRUBASA KTORY PO WYPICIU 18 PIW WYRAZNIE MA PEWNE OBJAWY SPICIA');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('WSCHOD-WEJSCIE NA ESTRADE');
        WriteLn('POLODNIE-TLUM');
      end;
      WalkaKoncert;
      if (wpisz = 'ZABIJ MINI-BARMAN') and (MINIBARMAN = 67) then begin
        WriteLn('---------------  ROUND ONE --------------------');
        WriteLn('----------------  FIGHT -----------------------');
        BTRUDNO;
        if ENERGIA > 0 then begin
          MINIBARMAN := 0;
          FUKS := Random(100);
          if FUKS < 15 then begin
            WriteLn('Z CIALA MINI-BARMANA WYCIAGASZ NAPOJ BOGOW : PIWO !!!');
            PrzedmPiwo := PrzedmPiwo - 10;
            PRZED := PRZED + 1;
          end;
        end;
      end;
      if (wpisz = 'ZABIJ GRUBAS') and (GRUBAS = 67) then begin
        BTRUDNO;
        if ENERGIA > 0 then begin
          GRUBAS := 0;
          if FUKS < 15 then begin
            WriteLn('Z CIALA GRUBASA WYCIAGASZ NAPOJ BOGOW : PIWO !!!');
            PrzedmPiwo := PrzedmPiwo - 10;
            PRZED := PRZED + 1;
          end;
        end;
      end;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLODNIE' then MIECHO := 63;
      if wpisz = 'WSCHOD' then MIECHO := 68;
    until MIECHO <> 67;
  end;
  if MIECHO = 68 then begin

    WriteLn('TO JEST WEJSCIE NA SCENE NA KTOREJ TANCZY LIROY - UWAZAJ');
    WriteLn('NA SCIANIE WISI !!!TABLICZKA!!!');
    TLUM;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      KOMENDY;
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-PIWIARNIA');
        WriteLn('WSCHOD-SCENA');
        WriteLn('P.S-HEJ DZIECI JESLI CHCECIE ZOBACZYC TAMTEN SWIAT PODLACZCIE SIE DO 1000 WAT');
      end;
      WalkaKoncert;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'ZACHOD' then MIECHO := 67;
      if wpisz = 'WSCHOD' then MIECHO := 69;
      if wpisz = 'PATRZ TABLICZKA' then
        WriteLn('*** NIE UPOWAZNIONYM WSTEP WZBRONIONY *** ');
    until MIECHO <> 68;
  end;
  if MIECHO = 69 then begin

    WriteLn('JESTES NA SCENIE , WLASCIWIE TO DOPIERO POCZATEK SCENY');
    WriteLn('WLASCIWIE JESTES JESZCZE ZA KULISAMI BO WIDZOWIE CIE NIE WIDZA');
    if DJ = 69 then
      WriteLn('D.J PILNUJE ABY WSZYSTKO PRZEBIEGALO ZGODNIE Z PLAYBACKIEM');
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('ZACHOD-WEJSCIE NA SCENE');
        WriteLn('POLODNIE-SCENA');
      end;
      if wpisz = 'ZABIJ D.J' then begin
        if DJ = 69 then begin
          BTRUDNO;
          if WROGEN < 0 then begin
            DJ := 0;
            FUKS := Random(100);
            if FUKS < 25 then begin
              WriteLn('WYCIAGASZ SUCHA RACJA Z CIALA D.J-a');
              SUCHA := SUCHA - 10;
              PRZED := PRZED + 1;
            end;
            if FUKS < 3 then begin
              WriteLn('WYCIAGASZ KASETE LIROYA Z CIALA D.J-a');
              WriteLn('!!! PRZEDMIOT UNIQE 3% !!!');
              kaseta := kaseta - 10;
              MAXE := MAXE + 5;
              PRO := PRO - 8;
              PRZED := PRZED + 1;
              ZRE := ZRE + 1;
            end;
          end;
        end;
      end;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'ZACHOD' then MIECHO := 68;
      if wpisz = 'POLODNIE' then MIECHO := 70;
    until MIECHO <> 69;
  end;
  if MIECHO = 70 then begin

    WriteLn('ALL RIGHT JESTES NA SCENIE !!! NA TWOJ WIDOK OCHRONIAZE COS MAMROCZA');
    WriteLn('TLUMY CIE PRAKTYCZNIE NIE ZAUWAZAJA BO ICH OCZY SKIEROWANE SA NA LIROYA');
    WriteLn('GDY NAGLE WSROD TLUMU ZAUWAZASZ NIEZLA LALE,JEDNAK ONA KOCHA LIROYA :(');
    SCENA;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SCENA');
        WriteLn('POLODNIE-SRODEK SCENY');
      end;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLNOC' then MIECHO := 69;
      if wpisz = 'POLODNIE' then MIECHO := 71;
      FIGHTSCENA;
    until MIECHO <> 70;
  end;
  if MIECHO = 71 then begin

    WriteLn('LUDZIE SIE NA CIEBIE GAPIA , JESTES NA SRODKU SCENY !!! KTOS CI MOWI:');
    WriteLn('HEY MAN IT,S COOL YEAH! . A TY NA TO: JE JE KUP KUL....');
    SCENA;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SCENA');
        WriteLn('POLODNIE-SCENA');
      end;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLNOC' then MIECHO := 70;
      if wpisz = 'POLODNIE' then MIECHO := 72;
      FIGHTSCENA;
    until MIECHO <> 71;
  end;
  if MIECHO = 72 then begin

    WriteLn('UFFF PRZEBIEGLES PRZEZ SRODEK SCENY WIEC TREMA CIE JUZ NIE DRECZY');
    WriteLn('DALEJ PISAC NIE MA O CZYM WIEC MOZESZ MI NASKOCZYC ');
    SCENA;
    repeat
      Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);
      if wpisz = 'MODE' then MODE;
      if wpisz = 'EXIT' then begin
        WriteLn('DOSTEPNE WYJSCIA:');
        WriteLn('POLNOC-SRODEK SCENY');
      end;
      if wpisz = 'WYJSCIE' then Exit;
      if wpisz = 'POLNOC' then MIECHO := 71;
      FIGHTSCENA;
    until MIECHO <> 72;
  end;
end;

procedure WczytajPostac;
begin
  ReadLn(wpisz);
  Assign(plik, 'pliki.tpu');
  Reset(plik);
  Read(plik, MANA);
  MANA := MANA div 4;
  Read(plik, POZIOM);
  POZIOM := POZIOM - $17;
  Read(plik, MMIECZ);
  Read(plik, FAJKA);
  Read(plik, DYPLOM);
  Read(plik, MTARCZA);
  Read(plik, GARNITUR);
  Read(plik, KUNSZT);
  Read(plik, ENERGIA);
  ENERGIA := ENERGIA div 4;
  ENERGIA := ENERGIA - $28;
  Read(plik, MIECHO2);
  Read(plik, ZRE);
  ZRE := ZRE - 12;
  Read(plik, SIL);
  SIL := SIL + 24;
  Read(plik, MAD);
  Read(plik, PRA);
  Read(plik, PunktKontrolny);
  Read(plik, Unused0052);
  Read(plik, _dummy_int);
  Read(plik, FORSA);
  FORSA := FORSA div MAD;
  Read(plik, CZY);
  Read(plik, MAXE);
  Read(plik, LimitPrzedmiotow);
  Read(plik, POR);
  Read(plik, MAXMANA);
  Read(plik, MAXSIL);
  Read(plik, MAXZRE);
  Read(plik, MAXMAD);
  Read(plik, PRZED);
  Read(plik, PRO);
  Read(plik, FUKSROLL);
  Read(plik, JakaBron);
  Read(plik, CIALO);
  Read(plik, OGOL);
  Read(plik, ZapisanoGre);
  Read(plik, StanCieniasa);
  Read(plik, SILNY);
  Read(plik, StanZrecznego);
  Read(plik, StanOdpornego);
  Read(plik, StanOgromnego);
  Read(plik, JakaTarcza);
  Read(plik, SilaZbroi);
  Read(plik, POTRAWKI);
  Read(plik, PotrawkiNiepotrzebnaZmiennaBug);
  Read(plik, Unused0076);
  Read(plik, SERCE);
  Read(plik, MBUTELKA);
  Read(plik, CIASTKO);
  Read(plik, SUCHA);
  Read(plik, CHLEB);
  Read(plik, BULKA);
  Read(plik, WEKA);
  Read(plik, CHLEB);
  Read(plik, BULKA);
  Read(plik, ILOSC);
  Read(plik, PAR);
  Read(plik, KOP);
  Read(plik, KOPM);
  Read(plik, KOPHP);
  Read(plik, ZWIEJ);
  Read(plik, WIMP);
  Read(plik, PASZOL);
  Read(plik, ARENA);
  Read(plik, KOMPLET);
  Read(plik, kaseta);
  Read(plik, PIGULKA);
  Read(plik, KORNIK);
  Read(plik, MUCHA);
  Read(plik, BAKTERIA);
  Read(plik, QUEST);
  Read(plik, QUESTWYK);
  Read(plik, SLIMAK);
  Read(plik, LISTEK);
  Read(plik, Powracanie);
  Read(plik, BIGOS);
  Read(plik, PrzedmPiwo);
  Read(plik, SCROLLPOR);
  Read(plik, PrzedmScrollPowrot);
  Read(plik, STARUCH);
  Read(plik, DUNQ);
  Read(plik, PLECAK);
  ReadLn(plik, DUNCAN);
  Read(plik, JAKIEUB);
  Close(plik);
  WriteLn('suckemall:', JAKIEUB);
end;

procedure SprawdzCzyZdobylesLevel;

var
  threshold: Integer;
begin
  if POZIOM < 1 then Exit;
  threshold := LevelThreshold(POZIOM);
  if KUNSZT < threshold then Exit;

  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');
  WriteLn('<<<<<<<<<=+=+=+!!!#####ZDOBYLES LEVEL#####!!!+=+=+=<<<<<<<<<<<<<');

  if POZIOM = 1 then KUNSZT := KUNSZT - 725
  else if POZIOM = 2 then KUNSZT := KUNSZT - 730
  else if POZIOM = 3 then KUNSZT := KUNSZT - 735
  else if POZIOM <= 8 then KUNSZT := (KUNSZT - Lvl4_Base) - POZIOM
  else KUNSZT := (KUNSZT - (POZIOM * 2)) - Lvl9_Base;
  if MAD < 11 then PRA := PRA + 3;
  if (MAD > 10) and (MAD < 16) then PRA := PRA + 4;
  if (MAD > 15) and (MAD < 23) then PRA := PRA + 5;
  if MAD > 22 then PRA := PRA + 6;
  WriteLn('<<<<<<<<<<<<ZYSKALES ', PRA, ' PRAKTYK >>>>>>>>>>>>>>>');
  if ZRE > 12 then MAXE := MAXE + 11
  else MAXE := MAXE + 10;
  if ZRE > 16 then MAXE := MAXE + 1;
  if ZRE > 21 then MAXE := MAXE + 1;
  if (ZRE > 26) and (SIL > 20) then MAXE := MAXE + 1;
  WriteLn('<<<<<<<<<<<<ZYSKALES ', MAXE, ' MAXIMUM ENERGI >>>>>>>>>>>>>');
  MAXMANA := MAXMANA + MAD + 2;
   WriteLn('<<<<<<<<<<<<<<ZYSKALES ', MAD + 2, 'MANY >>>>>>>>>>>>>>>>>');
  POZIOM := POZIOM + 1;
  PunktKontrolny := 0;
  if POZIOM = 12 then begin
    WriteLn('HURRRA TO JUZ DWUNASTY POZIOM , CZAS PODWYZSZYC MAXYMALNE PARAMETRY');
    if SIL >= MAXSIL then MAXSIL := MAXSIL + 3;
    if ZRE >= MAXZRE then MAXZRE := MAXZRE + 3;
    if MAD >= MAXMAD then MAXMAD := MAXMAD + 3;
    if SIL < MAXSIL then MAXSIL := MAXSIL + 2;
    if ZRE < MAXZRE then MAXZRE := MAXZRE + 2;
    if MAD < MAXMAD then MAXMAD := MAXMAD + 2;
    if (MAXMAD > MAXSIL) and (MAXMAD > MAXZRE) then
      MAXMAD := MAXMAD + 3;
    if (MAXSIL > MAXMAD) and (MAXSIL > MAXZRE) then
      MAXSIL := MAXSIL + 3;
    if (MAXZRE > MAXSIL) and (MAXZRE > MAXMAD) then
      MAXZRE := MAXZRE + 3;
    if (MAXZRE = MAXSIL) and (MAXSIL = MAXMAD) then begin
      MAXZRE := MAXZRE + 1;
      MAXMAD := MAXMAD + 1;
      MAXSIL := MAXSIL + 1;
    end;
    if (MAXZRE > MAXMAD) and (MAXZRE = MAXSIL) then begin
      MAXSIL := MAXSIL + 2;
      MAXZRE := MAXZRE + 1;
    end;
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', MAXSIL,
          ' MAXYMALNIE SILY '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', MAXZRE,
          ' MAXYMALNIE ZRECZNOSCI '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
    WriteLn(#2#2#2#2#2#2#2#2#2#2#2#2#2#2' MASZ TERAZ ', MAXMAD,
          ' MAXYMALNIE MADROSCI '#2#2#2#2#2#2#2#2#2#2#2#2#2#2);
  end;
end;

procedure CmdScan;
begin
  WriteLn('FUNKCJA BEDZIE DOSTEPNA ZA DWA LATA , I TAK ZGINIESZ , I TAK :) ');
end;

procedure CmdCzyscEkran;
begin
  ClrScr;
end;

procedure CmdDawajEnergie;
begin
  ENERGIA := ENERGIA + 200;
end;

procedure CmdZabierajKase;
begin
  FORSA := FORSA - 100;
end;

procedure CmdUstawSilaZbroi;
begin
  ILOSC := 0;
  PRO := 0;
  FUKSROLL := 0;
end;

procedure CmdZdejmij;
begin
  CIALO := 0;
  JakaBron := 0;
  JakaTarcza := 0;
  JAKIEUB := '';
  MMIECZ := -10;
  MTARCZA := -10;
  SIL := SIL - 1;
end;

procedure CmdNieWychodz;
begin
  WriteLn('NAPISZ UNMODE ');
end;

procedure CmdWyjdzZGry;
begin
  WyjscieZadane := True;
end;

procedure CmdZapisanoGre;
begin
  if ZapisanoGre = 1 then begin
    wpisz := 'ZDOLNOSCI';
    ZapisanoGre := 0;
    WriteLn(MIECHO2, ' MIECHO!');
  end;
end;

procedure CmdWypijPiwo;
begin
  if PrzedmPiwo <= -10 then begin
    PrzedmPiwo := PrzedmPiwo + 10;
    WriteLn('GDY POCZULES AMBROZJE W USTACH ODZYSKALES 10 MANY ZAS GDY GO WYPILES 10% E.');
    PRZED := PRZED - 1;
    ENERGIA := ENERGIA + 10;
    MANA := MANA + 10;
  end;
end;

procedure CmdUzyjStaryMiecz;
begin
  if (MMIECZ = -10) and (JakaBron = 0) then begin
    MMIECZ := -100;
    JakaBron := 1;
    WriteLn('UZYWASZ STAREGO ZARDZEWIALEGO MIECZA JAKO BRONI');
    SIL := SIL + 1;
    FUKSROLL := FUKSROLL + 3;
  end;
end;

procedure CmdZlozStaryMiecz;
begin
  if (MMIECZ = -100) and (JakaBron = 1) then begin
    MMIECZ := -10;
    JakaBron := 0;
    WriteLn('CHOWASZ STARY ZARDZEWIALY MIECZ I NIE UZYWASZ GO JAKO BRONI');
    SIL := SIL - 1;
    FUKSROLL := FUKSROLL - 3;
  end;
end;

procedure CmdUzyjMalaTarcza;
begin
  if (JakaTarcza = 0) and (MTARCZA = -10) then begin
    JakaTarcza := 1;
    PRO := PRO + 15;
    ILOSC := ILOSC + 1;
    MTARCZA := -100;
    WriteLn('UZYWASZ MALEJ TARCZY JAKO TARCZY');
  end;
end;

procedure CmdZlozMalaTarcze;
begin
  if (JakaTarcza = 1) and (MTARCZA = -100) then begin
    JakaTarcza := 0;
    PRO := PRO - 15;
    ILOSC := ILOSC - 1;
    MTARCZA := -10;
    WriteLn('JUZ NIE UZYWASZ MALEJ TARCZY JAKO TARCZY');
  end;
end;

procedure CmdUstawUcieczke;
begin
  if ZWIEJ > 0 then begin
    WriteLn('PONIZEJ ILU ENERGII CHCESZ UCIEKAC?');
    ReadLn(WIMP);
  end;
end;

procedure CmdSpij;
begin
  GodzinySnu := 0;
  repeat
    GodzinySnu := GodzinySnu + 1;
    Delay(5000);
    WriteLn('SPISZ JUZ ', GodzinySnu, ' GODZIN');
    KUNSZT := KUNSZT - 20;
    ENERGIA := ENERGIA + 10;
  until KeyPressed;
  WriteLn('PO OBUDZENIU STWIERDZILES ZE ZYSKALES ', GodzinySnu * 10,
      ' ENERGI I STRACILES ', (20 * GodzinySnu) - Random(2 * GodzinySnu), ' KUNSZTU');
  KUNSZT := KUNSZT + Random(2 * GodzinySnu);
  if GodzinySnu > 4 then begin
    WriteLn('DLUGI SEN DODATKOWO POZWOLIL CI ODPOCZAC : ZYSKALES ', MAD, 'ENERGI');
    ENERGIA := ENERGIA + MAD;
  end;
  if GodzinySnu > 8 then begin
    WriteLn('PELNOWARTOSCIOWY SEN SPOWODOWAL SUPER ZYSK : ', MAD * 2, 'ENERGI');
    ENERGIA := ENERGIA + (MAD * 2);
  end;
  if ENERGIA > MAXE then ENERGIA := MAXE;
end;

procedure CmdPorownaj;
begin
  if POR > 0 then begin
    FUKS := Random(100);
    if POR > FUKS then begin
      POROWNANIE;
      MANA := MANA - 10;
    end
  else begin
      WriteLn('POPELNILES PEWNE BLEDY I NIE UDALO SIE WYKONAC CZARU');
      MANA := MANA - 5;
    end;
  end;
end;

procedure CmdDawajKase;
begin
  FORSA := FORSA + 5000;
end;

procedure CmdOdrzucJedzenie;
begin
  if (wpisz = 'ODRZUC PACZEK') or (wpisz = 'ODRZUC CIASTKO') or
   (wpisz = 'ODRZUC SUCHA RACJA') or (wpisz = 'ODRZUC BULKA') or
   (wpisz = 'ODRZUC CHLEB') or (wpisz = 'ODRZUC WEKA') or
   (wpisz = 'ODRZUC SERCE') or (wpisz = 'ODRZUC BIGOS') then
    WriteLn('JAK SMIESZ WYRZUCAC JEDZENIE!!! WSTYD MI ZA CIEBIE !!! NIE POZWOLE !!!');
end;

procedure CmdOtworzPortal;
begin
  if ((wpisz = 'POWROT') and (Powracanie > 0)) or
   ((wpisz = 'UZYJ SCROLL POWROT') and (PrzedmScrollPowrot < 0)) then begin
    FUKS := Random(100);
    if wpisz = 'UZYJ SCROLL POWROT' then begin
      FUKS := Random(1);
      PrzedmScrollPowrot := PrzedmScrollPowrot + 10;
      PRZED := PRZED - 1;
    end;
    if FUKS <= Powracanie then begin
      WriteLn('OTWIERASZ MAGICZNY PORTAL KTORY PRZENOSI CIE DO MIASTA');
      MANA := MANA - 15;
      MIECHO2 := 20;
    end;
    if (FUKS > Powracanie) and (Powracanie + 30 > FUKS) then begin
      WriteLn('NIE UDAJE CI SIE OTWORZYC MAGICZNEGO PORTALU');
      MANA := MANA - 5;
    end;
    if Powracanie + 29 < FUKS then begin
      WriteLn('OTWIERASZ MAGICZNY PORTAL KTORY JEDNAK PRZENOSI CIE DO INNEGO MIEJSCA');
      MANA := MANA - 10;
      MIECHO2 := Random(100) + 1;
    end;
  end;
end;

procedure CmdScrollPorownanie;
begin
  if SCROLLPOR < 0 then begin
    POROWNANIE;
    MANA := MANA - 10;
    SCROLLPOR := SCROLLPOR + 10;
    PRZED := PRZED - 1;
  end;
end;

procedure CmdUstawKopanie;
begin
  if KOP > 0 then begin
    WriteLn('ZADAM CI PARE PYTAN:');
    WriteLn('1)PONIZEJ JAKIEJ ENERGI CHCESZ ZACZAC KOPAC');
    ReadLn(KOPHP);
    WriteLn('2)DO JAKIECH ILOSCI MANA CHCESZ KOPAC');
    ReadLn(KOPM);
  end;
end;

procedure CmdPrzepustkaSpeede;
begin
  PRZEPUSTKA := PRZEPUSTKA - 10;
end;

procedure CmdPokazZdolnosci;
begin
  if (MAD > 10) and (SIL > 11) then WriteLn('KOPANIE       - ', KOP, '%');
  if (MAD > 10) and (ZRE > 10) then WriteLn('UCIEKANIE     - ', ZWIEJ, '%');
  if (MAD > 15) and (ZRE > 11) then WriteLn('PAROWANIE     - ', PAR, '%');
  if MAD > 11 then WriteLn('POROWNYWANIE  - ', POR, '%');
  if MAD > 18 then WriteLn('POTRAWKI      - ', PotrawkiNiepotrzebnaZmiennaBug, '%');
  if MAD > 19 then WriteLn('POWROT        - ', Powracanie, '%');
end;

procedure CmdWyjdzZPodswiadomosci;
begin
  MIECHO := MIECHO2;
end;

const
  GroundCommands: array[1..32] of TCommandEntry = (
    (cmd:'PAMIETAJ'; run:ZapiszPostac),
    (cmd:'SCAN'; run:CmdScan),
    (cmd:'CZYSC EKRAN'; run:CmdCzyscEkran),
    (cmd:'DAWAJ EN'; run:CmdDawajEnergie),
    (cmd:'ZABIERAJ KASE'; run:CmdZabierajKase),
    (cmd:'USTAW SZ'; run:CmdUstawSilaZbroi),
    (cmd:'ZDEJMUJ'; run:CmdZdejmij),
    (cmd:'EXIT'; run:CmdNieWychodz),
    (cmd:'WYJSCIE'; run:CmdWyjdzZGry),
    (cmd:'JA'; run:PokazPostac),

    (cmd:''; run:BRANIE),
    (cmd:''; run:CmdZapisanoGre),
    (cmd:'UZYJ PIWO'; run:CmdWypijPiwo),
    (cmd:'UZYJ STARY'; run:CmdUzyjStaryMiecz),
    (cmd:'ODLOZ STARY'; run:CmdZlozStaryMiecz),
    (cmd:'UZYJ MALA'; run:CmdUzyjMalaTarcza),
    (cmd:'ODLOZ MALA'; run:CmdZlozMalaTarcze),

    (cmd:''; run:UZYWANIE),
    (cmd:'ZWIEJ'; run:CmdUstawUcieczke),
    (cmd:'SPIJ'; run:CmdSpij),
    (cmd:'POROWNAJ'; run:CmdPorownaj),
    (cmd:'DAWAJ KASE'; run:CmdDawajKase),
    (cmd:''; run:CmdOdrzucJedzenie),
    (cmd:''; run:CmdOtworzPortal),
    (cmd:'UZYJ SCROLL POROWNYWANIE'; run:CmdScrollPorownanie),
    (cmd:'KOP'; run:CmdUstawKopanie),
    (cmd:'JESTEM SPEEDE'; run:CmdPrzepustkaSpeede),
    (cmd:'ZDOLNOSCI'; run:CmdPokazZdolnosci),

    (cmd:''; run:PIERDOLY),
    (cmd:'WLACZ POSTAC'; run:WczytajPostac),
    (cmd:'UNMODE'; run:CmdWyjdzZPodswiadomosci),
    (cmd:'UM'; run:CmdWyjdzZPodswiadomosci)
  );

var
  gi, ri: Integer;
procedure Pokoj14;

begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if StanZrecznego = 14 then
    WriteLn('ZRECZNY POTWOR SMIGA MIEDZY SCIANAMI');
  if StanZrecznego = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SMIERDZA DOSYC MOCNO');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-KLATKI PELNE GAJDY');
    end;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLODNIE' then MIECHO := 11;
    if (wpisz = 'ZABIJ POTWOR') and (StanZrecznego = 14) then begin
      WROGEN := 20; WROGZRE := 30; WROGSIL := 3;
      WALKA;
      if PASZOL = 0 then begin
        StanZrecznego := 0;
        CZY := Random(15);
        WriteLn('WYCIAGASZ ', CZY, ' MONET Z CIALA POTWORA');
        FORSA := FORSA + CZY;
        if MMIECZ = 0 then begin
          FUKS := Random(20);
          if FUKS < 7 then begin
            MMIECZ := MIECHO;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            WartoscMiecza := 500;
          end;
        end;
        if MTARCZA = 0 then begin
          FUKS := Random(20);
          if FUKS < 7 then begin
            MTARCZA := MIECHO;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            WartoscTarczy := 300;
          end;
        end;
        if SERCE = 0 then begin
          FUKS := Random(20);
          if FUKS < 6 then begin
            SERCE := MIECHO;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            WartoscSerca := 50;
          end;
        end;
      end else
        PASZOL := 0;
    end;
  until MIECHO <> 14;

end;
procedure Pokoj15;

begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if StanOdpornego = 15 then
    WriteLn('POWOLNY ACZ ODPORNY NA BOL POTWOR SPOKOJNIE LEZY POD SCIANA');
  if StanOdpornego = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-KLATKI PELNE GAJDY');
    end;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLNOC' then MIECHO := 11;
    if (wpisz = 'ZABIJ POTWOR') and (StanOdpornego = 15) then begin
      WROGEN := 40; WROGZRE := 3; WROGSIL := 3;
      WALKA;
      if PASZOL = 0 then begin
        StanOdpornego := 0;
        CZY := Random(15);
        WriteLn('WYCIAGASZ ', CZY, ' MONET Z CIALA POTWORA');
        FORSA := FORSA + CZY;
        if MMIECZ = 0 then begin
          FUKS := Random(20);
          if FUKS < 7 then begin
            MMIECZ := MIECHO;
            WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
            WartoscMiecza := 500;
          end;
        end;
        if MTARCZA = 0 then begin
          FUKS := Random(20);
          if FUKS < 7 then begin
            MTARCZA := MIECHO;
            WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
            WartoscTarczy := 300;
          end;
        end;
        if SERCE = 0 then begin
          FUKS := Random(20);
          if FUKS < 6 then begin
            SERCE := MIECHO;
            WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
            WartoscSerca := 50;
          end;
        end;
      end else
        PASZOL := 0;
    end;
  until MIECHO <> 15;

end;
procedure Pokoj16;

label
  L1027_Ucieczka16, L1028_PoUcieczce16;
begin

  WriteLn('TEN POKOJ JEST CALY OBRYZGANY KRWIA NA SCIANACH FLAKI I MOZGI LODZKIE ');
  if StanOgromnego = 16 then
    WriteLn('OGROMNY POTWOR WIDZAC MIESO RZUCA SIE NA CIEBIE');
  if StanOgromnego = 0 then
    WriteLn('PAROJACE WNETRZNOSCI POTWORA SA ROZWLECZONE DOOKOLA');
  repeat
    if StanOgromnego = 16 then begin
      WROGEN := 40; WROGZRE := 11; WROGSIL := 10;
      WALKA;
      if PASZOL <> 0 then goto L1027_Ucieczka16;
      StanOgromnego := 0;
      CZY := Random(30);
      WriteLn('WYCIAGASZ ', CZY, ' MONET Z CIALA POTWORA');
      FORSA := FORSA + CZY;
      if MMIECZ = 0 then begin
        FUKS := Random(20);
        if FUKS < 10 then begin
          MMIECZ := MIECHO;
          WriteLn('WYCIAGASZ STARY ZARDZEWIALY MIECZ Z CIALA POTWORA');
          WartoscMiecza := 500;
        end;
      end;
      if MTARCZA = 0 then begin
        FUKS := Random(20);
        if FUKS < 10 then begin
          MTARCZA := MIECHO;
          WriteLn('WYCIAGASZ ZWYKLA MALA TARCZA Z CIALA POTWORA');
          WartoscTarczy := 300;
        end;
      end;
      if SERCE = 0 then begin
        FUKS := Random(20);
        if FUKS < 6 then begin
          SERCE := MIECHO;
          WriteLn('WYCIAGASZ ZAKRWAWIONE SERCE Z CIALA POTWORA');
          WartoscSerca := 50;
        end;
      end;
      goto L1028_PoUcieczce16;
      L1027_Ucieczka16:
      PASZOL := 0;
      MIECHO := 11;
      L1028_PoUcieczce16:
    end;
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('DOL-KLATKI PELNE GAJDY');
    end;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'DOL' then MIECHO := 11;
  until MIECHO <> 16;

end;
procedure Pokoj17;

begin

  WriteLn('JESTES W POKOJU W KTORYM !JEST! !PLAKAT (SMIERDZI TU) ');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('GORA-KLATKI PELNE GAJDY');
      WriteLn('DOL-TELEPORT!!!');
    end;
    if wpisz = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE PISZE:');
      WriteLn('SORRY ZE NIE UMYLEM POKOJU ALE NIE MAM NA TO CZASU');
      WriteLn('JEZELI BYLES AKTYWNY TO POWINIENES LICZYC NA NAGRODE');
      WriteLn('SPRAWDZ CZY LEZY TU COS , POTEM MOZESZ ZEJZD DO TELEPORTU ');
      if (StanCieniasa = 0) and (StanZrecznego = 0) and
      (SILNY = 0) and (StanOdpornego = 0) and
      (StanOgromnego = 0) and (DYPLOM = 0) then
        DYPLOM := 17;
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'GORA' then MIECHO := 11;
    if wpisz = 'DOL' then MIECHO := 18;
  until MIECHO <> 17;

end;
procedure Pokoj18;

begin

  WriteLn('BBBBBBBBZBZBZBZBZZZZZZZzzzzzzzzzbbzbBbzbzbzBZZZ');
  WriteLn('===-------......_________.....----------....._______....-------======');
  WriteLn('T***E***L***E***P***O***R***T***O***W***A***L***E***S***** *****S***I***E!');
  WriteLn('==========================================================================');
  MIECHO := 1;

end;
procedure Pokoj20;

begin

  WriteLn('JESTES W CENTRUM MIASTA : NA SCIANIE JEST PLAKAT (DUZY RUCH) ');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'PATRZ PLAKAT' then
      WriteLn('TO JEST MIASTO : RADZ SOBIE SAM!');
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-POKOJ CENTRALNY');
      WriteLn('POLNOC-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-UL.CIEMNA');
      WriteLn('ZACHOD-UL.DLUGA');
    end;
    if wpisz = 'WYJSC0IE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLODNIE' then MIECHO := 1;
    if wpisz = 'POLNOC' then MIECHO := 21;
    if wpisz = 'ZACHOD' then MIECHO := 30;
    if wpisz = 'WSCHOD' then MIECHO := 75;
    WalkaMiasto;
  until MIECHO <> 20;

end;
procedure Pokoj76;

begin

  WriteLn('JESTES W BARZE POD DWOMA PEDALAMI CHCAC ROZWIKLAC TA DZIWNA NAZWE');
  WriteLn('PYTASZ SIE BARMANA : PRZEPRASZAM DLACZEGO TEN BAR NAZYWA SIE  ');
  WriteLn('"POD DWOMA PEDALAMI"? A ON NA TO -WLASCIWIE TO NIE WIEM');
  WriteLn(' ALE SPYTAM SIE ZONY:MAREEEK!!.......(teraz ju'#190' wiesz) ');
  if MACIEK = 76 then
    WriteLn('MACIEK , TUTEJSZY BARMAN SERWUJE TUTAJ DRINKI (MOZLIWA LISTA!');
  if PEDAL = 76 then
    WriteLn(' PEDAL CZEKA TU NA TEGO JEDYNEGO');
  if PARA = 76 then
    WriteLn('PARA-JACEK I JUREK OBMYSLAJA MIESIAC MIODOWY');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA CIEMNA');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLODNIE' then MIECHO := 75;
    if wpisz = 'LISTA' then begin
      WriteLn('DRINK        CENA');
      WriteLn('ORAL DRINK     130');
      WriteLn('ONANISOFT      180');
      WriteLn('PEDAL&SPRZEGLO 220');
    end;
    if wpisz = 'ZABIJ PEDAL' then begin
      EASY;
      PEDAL := 0;
      PIGULKAZYSK;
    end;
    if wpisz = 'ZABIJ PARA' then begin
      BTRUDNO;
      PARA := 0;
      BTRUDNO;
    end;
    if wpisz = 'ZABIJ MACIEK' then begin
      EASY;
      MACIEK := 0;
    end;
    if wpisz = 'MAM 18 LAT' then begin
      WriteLn('I CO Z TEGO ??? A JA MAM 100 LAT I ZYJE !!!');
    end;
  until MIECHO <> 76;

end;
procedure Pokoj77;

begin

  WriteLn('ZNALAZLES SIE WSROD BLUSZCZU , WOKOLO CIEBIE TAJEMNICZE ROSLINY ');
  WriteLn('MUSISZ BARDZO UWAZAC,TU NAWET STOKROTKA MOZE BYC ZABOJCZA');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-UL.CIEMNA');
      WriteLn('WSCHOD-BLUSZCZ');
      WriteLn('ZACHOD-BLUSZCZ');
      WriteLn('POLODNIE-BLUSZCZ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLNOC' then MIECHO := 75;
    if wpisz = 'WSCHOD' then MIECHO := 78;
    if wpisz = 'ZACHOD' then MIECHO := 79;
    if wpisz = 'POLODNIE' then MIECHO := 80;
  until MIECHO <> 77;

end;
procedure Pokoj78;

begin

  WriteLn('WSZEDLES W GASZCZ ROSLIN I KWIATOW');
  WriteLn('NIE MA CO OPISYWAC WYSTARCZY POWIEDZIEC ZE JEST TU BYDLO CHWASTOW');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-BLUSZCZ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'ZACHOD' then MIECHO := 77;
  until MIECHO <> 78;

end;
procedure Pokoj79;

begin

  WriteLn('SLYSZYSZ POKRZYWE KTORA POZERA BEZBRONNY SZCZAW .... OHYDA');
  WriteLn('WOKOLO TAK CIEMNO,ZE GDYBY NIE JA JUZ DAWNO BYS ZGINA');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 77;
  until MIECHO <> 79;

end;
procedure Pokoj80;

begin

  WriteLn('CHOC TO MALO PRAWDOPODOBNE TUTAJ JEST JESZCZE CIEMNIEJ');
  WriteLn('PONADTO W NIEKTORYCH MIEJSCACH ZNAJDUJE SIE BLOTO I INNE BZDURY');
  WriteLn('NA SRODKU ZNAJDUJE SIE STUDNIA I MALO CZYTELNY NAPIS');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLNOC-BLUSZCZ');
      WriteLn('WSCHOD-BLUSZCZ');
      WriteLn('ZACHOD-BLUSZCZ');
      WriteLn('POLODNIE-BLUSZCZ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLNOC' then MIECHO := 77;
    if wpisz = 'ZACHOD' then MIECHO := 81;
    if wpisz = 'WSCHOD' then MIECHO := 82;
    if wpisz = 'POLODNIE' then MIECHO := 83;
    if wpisz = 'PATRZ NAPIS' then
      WriteLn('PISZE TUTAJ : '#2'A'#2'RZY'#2' D'#2' S'#2'UDN'#2' (MOWILEM ZE MALO CZYTELNY)');
    if wpisz = 'PATRZ STUDNIA' then begin
      FUKS := Random(3) + 1;
      WriteLn('ZAGLADASZ DO SRODKA STUDNI,COS TAM JEST,WYCI'#164'GASZ ', FUKS,
          ' MONET!');
      FORSA := FORSA + FUKS;
      FUKS := Random(100);
      if FUKS < 10 then begin
        WriteLn('JAK SMIESZ PODBIERAC MOJE SWIETOSCI , GIN CHAMIE , GIN');
        ENERGIA := ENERGIA - 40;
        WriteLn('ODDAWAJ MOJE PIENIADZE !!!');
        FORSA := FORSA - 100;
        if FORSA < 0 then FORSA := 0;
      end;
    end;
  until MIECHO <> 80;

end;
procedure Pokoj81;

begin

  WriteLn('PRZEDZIERASZ SIE PRZEZ CALY TEN SYF I NAJCHETNIEJ BYS');
  WriteLn('TERAZ PORZYCZY'#157' KOSIARKI OD SWEGO KOLEGI TOMKA');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 80;
  until MIECHO <> 81;

end;
procedure Pokoj82;

begin

  WriteLn('W TEJ KOMNACIE JEST ZNACZNIE JASNIEJ A TO DLATEGO ZE NAPROMIENIOWANE');
  WriteLn('I ZMUTOWANE ROSLINY ID'#164' W TWYM KIERUNKU');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-BLUSZCZ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'ZACHOD' then MIECHO := 80;
  until MIECHO <> 82;

end;
procedure Pokoj84;

begin

  WriteLn('TO CIEKAWE ZE WCZESNIEJ NIE ZAUWAZYLES TYCH KRARZAKOW PRZEDZIERASZ');
  WriteLn('SIE PRZEZ ICH GASZCZ WYGLADA TO NA NIEZBYT MILA KRAINE');
  WriteLn('DALES NA ZACHOD WIDZISZ JAKIES PODEJRZANE BUDOWLE , A NA POLODNIE BRRRR.');
  WriteLn('NA POLODNIE JAK GDYBY KTOS SIE OBZERAL , ALE BARDZO GLOSNO I NIEBEZPIECZNIE');
  BLUSZCZ;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    FIGHTBLUSZCZ;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BLUSZCZ');
      WriteLn('ZACHOD-BUDYNEK');
      WriteLn('POLODNIE-WEJSCIE DO GROTY ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 83;
    if wpisz = 'ZACHOD' then MIECHO := 85;
    if wpisz = 'POLODNIE' then MIECHO := 87;
  until MIECHO <> 84;

end;
procedure Pokoj87;

begin

  WriteLn('MLASK , MLASK KTOS RZECZYWISCIE SIE OBZERA CZY JESTES 100% PEWNY IZ');
  WriteLn('CHCESZ SIE ZAGLEBIC W TE NIEBADANE CZELUSCIE PIEKIELNE?, MOZE LEPIEJ WROC');
  FUKS := Random(100);
  if FUKS < 40 then begin
    WriteLn('NO PIEKNIE WLAZLES W JAKIES TOKSYCZNE SUBSTANCJE ,AAA, TO PARZY TRACISZ ',
       25 - ZRE, '%');
    ENERGIA := ENERGIA - 25 + ZRE;
  end;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-GROTA');
      WriteLn('POLNOC-PODEJRZANE KRZAKI');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLNOC' then MIECHO := 84;
    if wpisz = 'POLODNIE' then MIECHO := 88;
  until MIECHO <> 87;

end;
procedure Pokoj88;

begin

  WriteLn('MOJ BOZE , COZ TO JEST , NA TRONIE SIEDZI 20 RAZY WIEKSZA OD CIEBIE POKRZYWA');
  WriteLn('WOKOL NIEJ UWIJAJA SIE PRACOWITE MLECZE DOSTARCZAJAC JEJ SWIEZEGO ');
  WriteLn('MIESA LUDZKIEGO !!! , UWIELBIA ONA MOZGI KTORE WYSSYSA JAK PYSZNY PUDDING ');
  WriteLn('W PEWNYM MOMECIE ZAUWAZA CIEBIE - WITAJ WEDROWCZE PODOBAM CI SIE? - (TAK,NIE)');
  Write('TAK lub NIE >');
  ReadLn(wpisz);
  WriteLn('NO TO GIN!!!');
  repeat
    WROGEN := 200; WROGZRE := 15; WROGSIL := 18;
    FIREBALL := 5; POISON := 1;
    WALKA;
    if WROGEN < 0 then begin
      LISTEKZYSK;
      PIGULKAZYSK;
      SCROLLPORZYSK;
      if DUNQ <> 0 then DUNQ := DUNQ - 50;
    end;
    if ENERGIA > 0 then begin
      WriteLn('UFFF,TO BYLA PRZYGODA,WOKOL GROMADZILY SIE SETKI MLECZOW - NIE MIALBYS SZANS');
      MIECHO := 87;
    end;
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-WEJSCIE DO GROTY');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLODNIE' then MIECHO := 87;
  until MIECHO <> 88;

end;
procedure Pokoj85;

begin

  WriteLn('DO DOBRA WYGLADA TO NA JAKIS DOM , WEJDZMY DO SRODKA ');
  WriteLn('GOD DAMN , A NIECH MNIE MA MATEUSZ W SWOJEJ OPIECE , TE DRZWI ZYJA !!!');
  if DRZWI <> 0 then
    WriteLn('DRZWI WYCIAGAJA SWE DREWNIANE RECE W TWYM KIERUNKU MOWIAC : NIE WPUSZCZE');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    if wpisz = 'ZABIJ DRZWI' then begin
      if DRZWI <> 0 then begin
        NEASY;
        if ENERGIA > 0 then DRZWI := 0;
      end;
    end;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-PODEJRZANE KRZAKI');
      if DRZWI <> 0 then
        WriteLn('ZACHOD-GDYBY NIE TE CHOLERNE DRZWI ... ');
      if DRZWI = 0 then
        WriteLn('ZACHOD-WEJSCIE DO DOMKU');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 84;
    if (wpisz = 'ZACHOD') and (DRZWI = 0) then MIECHO := 86;
    if (wpisz = 'ZACHOD') and (DRZWI <> 0) then
      WriteLn('SPROBOJ OMINAC TE MEGA-PRZYPAKOWANE DRZWI KTORYCH BY SIE HE-MAN NIE POWSTYDZIL');
  until MIECHO <> 85;

end;
procedure Pokoj86;

begin

  WriteLn('DOBRA JESTES W SRODKU BRAK OSWIETLENIA CIE NIE WZRUSZA , DOOKOLA ROZNE GARNKI');
  if STARUCH <> 0 then
    WriteLn('W ROGU ZAUWAZASZ MALEGO WYGLODZONEGO ELFIEGO STARUCHA');
  if STARUCH = 0 then
    WriteLn('WIDZISZ TU TYLKO PLASZCZ PO STARUCHU KTORY ZNIKNA W PRZESTRZEN');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    KOMENDY;
    if wpisz = 'DAWAJ KUNSZT' then KUNSZT := KUNSZT + 500;
    if wpisz = 'PATRZ GARNKI' then
      WriteLn('Z JEZOREM NA WIERZCHU PATRZYSZ DO GARNKOW LECZ NIC W NICH NIE MA');
    if wpisz = 'ROZMAWIAJ STARUCH' then begin
      if (WEKA > -30) and (FORSA < 200) and (PrzedmScrollPowrot = 0) then begin
        WriteLn('STARUCH MOWI CI : HEJ KTO TY JESTES CZY ZE MAGICZNE DRZWI NIE POWSTRZYMALY CIE?');
        WriteLn('MUSISZ BYC NIEZLYM WOJOWNIKIEM ,SPOXOLANDIA, GLODNY JESTEM PRZYNIES MI 4 WEKI ');
        WriteLn('ORAZ OKOLO 200 KASY , A DAM CI TAKIE NUMERY O JAKICH CI SIE NIE SNILO....');
      end;
    end;
    if wpisz = 'ROZMAWIAJ STARUCH' then begin
      if (WEKA < -30) and (FORSA > 199) then begin
        WriteLn('STARUCH MOWI CI : OOO JAKA PIEKNA WEKA ... MNIAM I DRUGA TRZECIA I CZWARTA');
        WriteLn('TO BYLO DOBRE ZARCIE !!! , DAWAJ KASE , PIENIADZE !!! , CO SIE TAK GAPISZ?');
        WriteLn('WYNOCHA STAD !!! MRAMMMARAMMARAMAAMMARAM BUM !! -T-E-L-E-P-O-R-T-Y');
        WriteLn('WYGLADA ZE ZROBIL CIE W BUCA , A MOZE JEDNAK NIE , CO TO ? , SCROLL POWROTU');
        WriteLn('I PIWSKO NA OSLODZENIE ZYCIA , NO TRUDNO PRZYNAJMNIEJ CZEGOS SIE NAUCZYLES');
        MIECHO := 20;
        PrzedmPiwo := PrzedmPiwo - 10;
        WEKA := WEKA + 40;
        FORSA := FORSA - 200;
        PrzedmScrollPowrot := PrzedmScrollPowrot - 10;
        KUNSZT := KUNSZT + 50;
        PRZED := PRZED - 2;
      end;
    end;
    if wpisz = 'ROZMAWIAJ STARUCH' then begin
      if PrzedmScrollPowrot < 0 then begin
        WriteLn('AAAA SPADAJ STAD BO CI KOSCI POLAMIE');
        MIECHO := 16;
      end;
    end;
    if wpisz = 'ZABIJ STARUCH' then begin
      if STARUCH <> 0 then begin
        SLABO;
        STARUCH := 0;
        WriteLn('HMMM UBRANIE JEST , ALE CIALO GDZIES ZNIKNELO , WTEM SLYSZYSZ GLOS :');
        WriteLn('--- TO BYL TWOJ BLAD --- , DOSTAJESZ OCMIENIA LECZ NIE WIESZ CO TO BYLO');
        POZIOM := POZIOM - 1;
      end;
    end;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-BUDYNEK');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 85;
  until MIECHO <> 86;

end;
procedure Pokoj21;

begin

  WriteLn('JESTES NA ULICY NA ULICY SKLEPIKOWEJ - JAK SAMA NAZWA WZKAZUJE  ');
  WriteLn('JEST TU PARE SKLEPIKOW KTORE BYC MOZE CI SIE PRZYDADZA');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-CENTRUM MIASTA');
      WriteLn('POLNOC-UL.SKLEPIKOWA');
      WriteLn('WSCHOD-PIEKARNIA');
      WriteLn('ZACHOD-ZBROJOWNIA');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLODNIE' then MIECHO := 20;
    if wpisz = 'POLNOC' then MIECHO := 22;
    if wpisz = 'WSCHOD' then MIECHO := 23;
    if wpisz = 'ZACHOD' then MIECHO := 24;
    WalkaMiasto;
  until MIECHO <> 21;

end;
procedure Pokoj22;

begin

  WriteLn('CIAGNIE SIE TEDY ULICA SKLEPIKOWA JEST TU JESZCZE PARE  ');
  WriteLn('INTERESUJACYCH SKLEPOW. DALEJ CIAGNIE SIE KILKA ULIC....');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-UL.SKLEPIKOWA');
      WriteLn('POLNOC-ROZJAZD!');
      WriteLn('WSCHOD-SKLEP WIELOBRANZOWY');
      WriteLn('ZACHOD-SKLEP MAGICZNY  ');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLODNIE' then MIECHO := 21;
    if wpisz = 'WSCHOD' then MIECHO := 25;
    if wpisz = 'ZACHOD' then MIECHO := 26;
    if wpisz = 'POLNOC' then MIECHO := 100;
    WalkaMiasto;
  until MIECHO <> 22;

end;
procedure Pokoj101;

begin

  WriteLn('IDZIESZ DROGA , MIASTA PO DRODZE MIJASZ DROGOWSKAZ . JEST TU O WIELE ');
  WriteLn('NIEBEZPIECZNIEJ NIZ W MIESCIE PELNO TU ZEZIMIERZKOW ROZNEGO RODZAJU');
  WriteLn('JESLI NIE CHCESZ MIEC KLOPOTOW LEPIEJ DOBRZE TRYMAJ SIE DROGI....');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ROZJAZD!');
      WriteLn('ZACHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if wpisz = 'PATRZ DROGOWSKAZ' then
      WriteLn('WSCHOD - MIASTO , ZACHOD - SHIGGHLERATHR');
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 100;
    if wpisz = 'ZACHOD' then MIECHO := 102;
    if wpisz = 'POLNOC' then MIECHO := 104;
  until MIECHO <> 101;

end;
procedure Pokoj102;

begin

  WriteLn('IDZIESZ DALEJ KAMIENISTA DROGA , BRZYDALA BI CI SIE JAKA BRYCZKA NALEPIEJ ');
  WriteLn('MODEL SZKAPA 2000 , ALE COZ KONIE SA TYLKO DLA NAJBOGATSZYCH');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-DROGA');
      WriteLn('ZACHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 101;
    if wpisz = 'ZACHOD' then MIECHO := 103;
  until MIECHO <> 102;

end;
procedure Pokoj103;

begin

  WriteLn('CO TO ZA GLUPOTA ? DROGA SKRECA TROCHE W LEWO , TROCHE W PRAWO ALE ');
  WriteLn('PRZECIEZ ROWNIE DOBRZE MOGLA BY ISC SRODKIEM , ZYSKALI BY NA TYM WSZYSCY');
  WriteLn('A SZCZEGOLNIE TY ,  BO BOLA CIE NOGI OD TEGO CHODZENIA NIEMOZEBNIE');
  WriteLn('UPS DROGA SIE KONCZY NA TEJ NIEPRZEPASTNEJ RZECE O DALSZEJ PODROZY NIE MA MOWY');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-DROGA');
      WriteLn('POLNOC-LAS');
      WriteLn('POLODNIE-LAS');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 102;
  until MIECHO <> 103;

end;
procedure Pokoj23;

begin

  WriteLn('JESTES W PIEKARNI , SKLEP PRZESIAKNIETY JEST PRZYJEMNYM ZAPACHEM CHLEBA ');
  WriteLn('PIEKARZ MILO SIE NA CIEBIE PATRZY WYCIERAJAC MAKE Z TWARZY');
  WriteLn('NA SCIANIE  JEST PLAKAT CALY W MACE');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'PATRZ PLAKAT' then begin
      WriteLn('LISTA-LISTA DOSTEPNYCH RZECZY,KUP (PRZEDMIOT)-KUPUJESZ GO ');
      WriteLn('PO ODEJSCIU OD LADY REKLAMACJI NIE UWZGLEDNIA SIE');
    end;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-ULICA SKLEPIKOWA');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'ZACHOD' then MIECHO := 21;
    ZakupyPiekarnia;
  until MIECHO <> 23;

end;
procedure Pokoj24;

begin

  WriteLn('JESTES W ZBROJOWNI - SKLEP NIEDAWNO ZOSTAL OTWARTY');
  WriteLn('SPRZEDAWCA(BRZYDKA AURA) STARA SIE WCISNAC CI JAKIS TOWAR ');
  WriteLn('NA SCIANIE WISI PLAKAT');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    ZakupyZbrojownia;
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA SKLEPIKOWA');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 21;
    if wpisz = 'PATRZ PLAKAT' then
      WriteLn('LISTA,KUP XXX I SPRZEDAJ XXX TO JEST DOSTEPNE W TYM SKLEPIE ');
    WalkaMiasto;
  until MIECHO <> 24;

end;
procedure Pokoj25;

begin

  WriteLn('WSZEDLES DO SKLEPU WIELOBRANZOWEGO,STWIERDZASZ OBECNOSC SPRZEDAWCY');
  WriteLn('NA DRZWIACH ZOSTALA WYWIESZONA WYWIESZKA');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('ZACHOD-ULICA SKLEPIKOWA');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'ZACHOD' then MIECHO := 22;
    if wpisz = 'PATRZ WYWIESZKA' then
      WriteLn('* SKLEP OTWARTY DO ODWOLANIA *');
    WalkaMiasto;
    ZakupySklepWielobranzowy;
  until MIECHO <> 25;

end;
procedure Pokoj26;

begin

  WriteLn('WCHODZISZ DO SKLEPU ALE NICZEGO TU NIE MA POZA SPRZEDAWCA I JEGO TOWAREM');
  ULSKLEPIKOWA;
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA SKLEPIKOWA');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 22;
    if wpisz = 'PATRZ PLAKAT' then
      WriteLn('* OTWARTE Z POWODU CHOROBY *');
    ZakupySklepMagiczny;
    WalkaMiasto;
  until MIECHO <> 26;

end;
procedure Pokoj31;

begin

  WriteLn('IDAC ULICA DLUGA NA POLNOC SPOSTRZEGASZ DOLINE ROZRYWEK');
  WriteLn('A NA POLODNIE BASNIOWY GAJ...........');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('WSCHOD-ULICA DLUGA');
      WriteLn('POLNOC-DOLINA ROZRYWEK');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'WSCHOD' then MIECHO := 30;
    if wpisz = 'POLNOC' then MIECHO := 60;
  until MIECHO <> 31;

end;
procedure Pokoj32;

begin

  WriteLn('CZESC TO ARENA PRZYCHODZA TU TACY JAK TY PO TO ABY MORDOWAC');
  WriteLn('!!!!!O NIE!!!!!!!! TO STRASZNE!!! ( SIE DAL NABRAC ) (NAPISZ PATRZ PLAKAT');
  repeat
    Write(ENERGIA, '%.', KUNSZT, '>');
    ReadLn(wpisz);
    if wpisz = 'MODE' then MODE;
    if wpisz = 'PATRZ PLAKAT' then begin
      WriteLn('NA PLAKACIE PISZE');
      WriteLn('NIE ATAKUJ LUDZI I ZWIERZAT Z ZOO CHYBA ZE MASZ 3 LEVEL( LUB WYZEJ :P)');
    end;
    if wpisz = 'EXIT' then begin
      WriteLn('DOSTEPNE WYJSCIA:');
      WriteLn('POLODNIE-ULICA DLUGA');
      WriteLn('POLNOC-ARENA');
    end;
    if wpisz = 'WYJSCIE' then begin WyjscieZadane := True; Exit; end;
    if wpisz = 'POLODNIE' then MIECHO := 30;
    if wpisz = 'POLNOC' then MIECHO := 33;
  until MIECHO <> 32;

end;

const

  RoomDispatch: array[1..46] of TRoomEntry = (
    (room: 0; run:POKOJ0),
    (room: 1; run:POKOJ1),
    (room: 2; run:Pokoj2),
    (room: 3; run:Pokoj3),
    (room: 4; run:POKOJ4),
    (room: 5; run:POKOJ5),

    (room: -1; run:POKOJE),
    (room: 9; run:Pokoj9),
    (room: 11; run:POKOJ11),
    (room: 12; run:Pokoj12),
    (room: 13; run:POKOJ13),
    (room: 14; run:Pokoj14),
    (room: 15; run:Pokoj15),
    (room: 16; run:Pokoj16),
    (room: 17; run:Pokoj17),
    (room: 18; run:Pokoj18),
    (room: 20; run:Pokoj20),
    (room: 75; run:POKOJ75),
    (room: 30; run:POKOJ30),
    (room: 76; run:Pokoj76),
    (room: 77; run:Pokoj77),
    (room: 78; run:Pokoj78),
    (room: 79; run:Pokoj79),
    (room: 80; run:Pokoj80),
    (room: 81; run:Pokoj81),
    (room: 82; run:Pokoj82),
    (room: 83; run:POKOJ83),
    (room: 84; run:Pokoj84),
    (room: 87; run:Pokoj87),
    (room: 88; run:Pokoj88),
    (room: 85; run:Pokoj85),
    (room: 86; run:Pokoj86),
    (room: 21; run:Pokoj21),
    (room: 22; run:Pokoj22),
    (room: 101; run:Pokoj101),
    (room: 102; run:Pokoj102),
    (room: 103; run:Pokoj103),
    (room: 100; run:POKOJ100),
    (room: 23; run:Pokoj23),
    (room: 24; run:Pokoj24),
    (room: 25; run:Pokoj25),
    (room: 26; run:Pokoj26),
    (room: 31; run:Pokoj31),
    (room: 60; run:POKOJ60),

    (room: -1; run:PokojeKoncertowe),
    (room: 32; run:Pokoj32)
  );

procedure Start;
label
  L1012_ZachetaPodswiadomosc, L1025_Wyjscie;
var
  gi, ri: Integer;
begin

  Randomize;
  WybierzRase;
  ReadKey;
  repeat
    PunktyKontrolne;
    SprawdzCzyZdobylesLevel;

    if PRZED > LimitPrzedmiotow then begin
      WriteLn('JESTES OBLADOWANY !!! MASZ O ', PRZED - LimitPrzedmiotow, ' ZA DUZO');
      WriteLn('TRACISZ ', (PRZED - LimitPrzedmiotow) * 10, '% ENERGI');
      ENERGIA := ENERGIA - ((PRZED - LimitPrzedmiotow) * 10);
    end;

    if ILEPOI > 0 then begin
      FUKS := Random(5);
      WriteLn('JESTES ZATRUTY TRACISZ ', FUKS, ' % ENERGI');
      ILEPOI := ILEPOI - 1;
    end;

    WyjscieZadane := False;
    for ri := Low(RoomDispatch) to High(RoomDispatch) do
      if (RoomDispatch[ri].room = -1) or (MIECHO = RoomDispatch[ri].room) then begin
        RoomDispatch[ri].run;
        if WyjscieZadane then goto L1025_Wyjscie;
      end;

    MINIARENA;
    if MIECHO = MIECHO_Smierc then Smierc;
    if ENERGIA > MAXE then ENERGIA := MAXE;
    if MIECHO = MIECHO_Podswiadomosc then begin
      if MMIECZ = MIECHO2 then
        WriteLn('W TWYM POKOJU LEZY !STARY! ZARDZEWIALY MIECZ');
      if MTARCZA = MIECHO2 then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE !MALA! TARCZA');
      if SERCE = MIECHO2 then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE ZAKRWAWIONE !SERCE!');
      if DYPLOM = MIECHO2 then
        WriteLn('W TYM POKOJU ZNAJDUJE SIE !DYPLOM! MUD SZKOLY');
      if FAJKA = MIECHO2 then
        WriteLn('TU LEZY !FAJKA!');
      L1012_ZachetaPodswiadomosc: Write(ENERGIA, '%.', KUNSZT, '>');
      ReadLn(wpisz);

      WyjscieZadane := False;
      for gi := Low(GroundCommands) to High(GroundCommands) do
        if (GroundCommands[gi].cmd = '') or (wpisz = GroundCommands[gi].cmd) then begin
          GroundCommands[gi].run;
          if WyjscieZadane then goto L1025_Wyjscie;
        end;
      if MIECHO = MIECHO_Podswiadomosc then goto L1012_ZachetaPodswiadomosc;
    end;

    PASZOL := 0;

  until MIECHO = 193;

  L1025_Wyjscie: ;

end;

end.
