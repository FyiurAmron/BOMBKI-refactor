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

{$I rooms.inc}
{$I texts.inc}

procedure WriteExits(const items: array of string);
var
  i: Integer;
begin
  WriteLn(items[0]);
  for i := 1 to High(items) div 2 do begin
    Write(items[2 * i - 1]);
    WriteLn(items[2 * i]);
  end;
end;

type
  TMovement = record
    cmd: string;
    dest: Integer;
  end;

function Go(cmd: string; dest: Integer): TMovement;
begin
  Go.cmd := cmd;
  Go.dest := dest;
end;

procedure MoveWhen(const moves: array of TMovement);
var
  i: Integer;
begin
  for i := Low(moves) to High(moves) do
    if Command = moves[i].cmd then
      Session.Room := moves[i].dest;
end;

function MoveWhenOrExit(const moves: array of TMovement): Boolean;
begin
  MoveWhenOrExit := False;
  if Command = CmdWyjscie then begin
    MoveWhenOrExit := True;
    Exit;
  end;
  MoveWhen(moves);
end;

function MoveWhenOrQuit(const moves: array of TMovement): Boolean;
var
  leave: Boolean;
begin
  leave := MoveWhenOrExit(moves);
  if leave then
    Session.ExitRequested := True;
  MoveWhenOrQuit := leave;
end;

procedure WriteLines(const lines: array of string);
var
  i: Integer;
begin
  for i := Low(lines) to High(lines) do
    WriteLn(lines[i]);
end;

{ The plain room shell, fully parametrized: posterCmd names the poster
  command and poster carries its lines; an empty array means the room
  has no poster. On WYJSCIE the room is left and shown again on the
  next dispatch pass. }
procedure BasicRoomGeneric(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; posterCmd: string;
  const poster: array of string);
begin
  if Session.Room <> RoomNo then Exit;
  WriteLines(intro);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits(exits);
    if MoveWhenOrExit(moves) then Exit;
    if (Low(poster) <= High(poster)) and (Command = posterCmd) then
        WriteLines(poster);
  until Session.Room <> RoomNo;
end;

{ The shell with the standard PATRZ PLAKAT poster. }
procedure BasicRoomPoster(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; const poster: array of string);
begin
  BasicRoomGeneric(RoomNo, intro, exits, moves, CmdPatrz + CmdPlakat, poster);
end;

{ The shell without a poster. }
procedure BasicRoomSimple(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement);
begin
  BasicRoomGeneric(RoomNo, intro, exits, moves, '', []);
end;

{ The quit shell, fully parametrized: WYJSCIE requests the game exit;
  posterCmd and poster carry an optional poster as in BasicRoomGeneric. }
procedure BasicRoomQuitGeneric(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; posterCmd: string;
  const poster: array of string);
begin
  if Session.Room <> RoomNo then Exit;
  WriteLines(intro);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits(exits);
    if MoveWhenOrQuit(moves) then Exit;
    if (Low(poster) <= High(poster)) and (Command = posterCmd) then
        WriteLines(poster);
  until Session.Room <> RoomNo;
end;

{ The quit shell with the standard PATRZ PLAKAT poster. }
procedure BasicRoomQuitPoster(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; const poster: array of string);
begin
  BasicRoomQuitGeneric(RoomNo, intro, exits, moves, CmdPatrz + CmdPlakat,
    poster);
end;

{ The quit shell without a poster. }
procedure BasicRoomQuit(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement);
begin
  BasicRoomQuitGeneric(RoomNo, intro, exits, moves, '', []);
end;

{ One bag slot of the fight loot: an empty slot rolls Random(20) and,
  below the threshold, marks the find with the current room and
  announces it. }
procedure TryLoot(var slot: Integer; threshold: Integer; foundMsg: string);
begin
  if slot = 0 then begin
    Combat.Roll := Random(20);
    if Combat.Roll < threshold then begin
      slot := Session.Room;
      WriteLn(TxtShared_08, foundMsg);
    end;
  end;
end;

{ The cage loot roll: the sword and shield slots share the threshold,
  the heart rolls against 6. }
procedure TryCageLoot(threshold: Integer);
begin
  TryLoot(Bag.OldSword, threshold, TxtShared_10);
  TryLoot(Bag.SmallShield, threshold, TxtShared_11);
  TryLoot(Bag.Heart, 6, TxtShared_12);
end;

{ An item carried into the trance: if its recorded room is the room the
  player left, announce it. }
procedure TranceItemLine(itemRoom: Integer; line: string);
begin
  if itemRoom = Session.OuterRoom then
    WriteLn(line);
end;

type
  TTranceItem = record
    item: ^Integer;
    line: string;
  end;

const
  { The items carried into the trance, announced in dispatch order. }
  TranceItems: array[1..5] of TTranceItem = (
    (item: @Bag.OldSword; line: TxtStart_07),
    (item: @Bag.SmallShield; line: TxtTranceItemLabel + TxtStart_08),
    (item: @Bag.Heart; line: TxtTranceItemLabel + TxtStart_09),
    (item: @Bag.Diploma; line: TxtTranceItemLabel + TxtStart_10),
    (item: @Bag.Pipe; line: TxtStart_11)
  );


procedure ShowIntro;
var
  tone, step: Integer;
begin
  ClrScr;
  Player.MaxEnergy := 50;
  WriteLines(TxtShowIntroLines1);
  tone := 100;
  step := 100;
  repeat
    Sound(tone);
    Delay(100);
    if tone = 600 then step := -100;
    tone := tone + step;
    if tone = 100 then begin
      WriteLn(TxtShowIntro_15);
      step := 100;
    end;
  until (tone = 100) and KeyPressed;
  NoSound;
end;

procedure Room5;
begin
  BasicRoomPoster(RoomLost,
            TxtRoom5Lines1,
            [TxtShared_03,
             TxtExitWschod, TxtPlaceMudSzkola,
             TxtExitZachod, TxtPlacePokoj,
             TxtExitPolnoc, TxtPlacePokoj,
             TxtExitPolodnie, TxtPlacePokoj,
             TxtExitGora, TxtPlacePokoj,
             TxtExitDol, TxtPlacePokoj],
            [Go(CmdWschod, RoomSchoolHall),
             Go(CmdZachod, RoomSchoolSide1),
             Go(CmdPolnoc, RoomSchoolSide2),
             Go(CmdPolodnie, RoomSchoolSide3),
             Go(CmdGora, RoomSchoolLanding),
             Go(CmdDol, RoomSchoolSide4)],
            [TxtRoom5_10, TxtRoom5_11]);
end;

procedure Room0;
begin
  WriteLn(TxtRoom0_01);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdExit then WriteLn(TxtRoom0_02);
    if MoveWhenOrExit([Go(CmdPolnoc, RoomSalon)]) then Exit;
  until Session.Room <> RoomStart;
end;
procedure Room1;
begin
  BasicRoomPoster(RoomSalon,
            [TxtYouAreIn + TxtRoom1_01, TxtRoom1Lines1[1], TxtRoom1Lines1[2],
             TxtRoom1Lines1[3]],
            [TxtShared_03,
             TxtExitPolodnie, TxtPlaceTamGdzieZaczynaszGre,
             TxtExitPolnoc, TxtPlaceMiasto,
             TxtExitWschod, TxtPlacePokojTreningowy1,
             TxtExitZachod, TxtPlaceMudSzkola,
             TxtExitDol, TxtPlacePoddziemnyPokojTreningowy2],
            [Go(CmdPolodnie, RoomStart),
             Go(CmdWschod, RoomTraining),
             Go(CmdDol, RoomMeditation),
             Go(CmdZachod, RoomSchoolHall),
             Go(CmdPolnoc, RoomCityCentre)],
            TxtRoom1Lines2);
end;
procedure Room4;
begin
  BasicRoomGeneric(RoomSchoolHall,
            [TxtYouAreIn + TxtRoom4_01, TxtRoom4_02],
            [TxtShared_03,
             TxtExitWschod, TxtPlacePokojCentralny,
             TxtExitZachod, TxtPlaceMudSzkola2],
            [Go(CmdWschod, RoomSalon), Go(CmdZachod, RoomLost)],
            CmdPatrz + CmdAfisz,
            TxtRoom4Lines1);
end;
procedure Room13;
begin
  if Session.Room <> RoomCageStrong then Exit;
  WriteLn(TxtShared_06);
  case World.CageStrong of
    RoomCageStrong: WriteLn(TxtRoom13_01);
    0: WriteLn(TxtShared_07);
  end;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceKlatkiPelneGajdy]);
    if Command = CmdMode then EnterTrance;
    if MoveWhenOrExit([Go(CmdWschod, RoomCageCorridor)]) then Exit;
    if (Command = CmdZabij + CmdPotwor) and (World.CageStrong = RoomCageStrong) then begin
      Combat.EnemyEnergy := 20;
      Combat.EnemyDexterity := 3;
      Combat.EnemyStrength := 10;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageStrong := 0;
        Combat.Loot := Random(15);
        WriteLn(TxtShared_08, Combat.Loot, TxtShared_09);
        Player.Money := Player.Money + Combat.Loot;
        TryCageLoot(7);
      end else Combat.Fled := 0;
    end;
  until Session.Room <> RoomCageStrong;

end;
procedure SimpleRoom(RoomNo, DestRoom: Integer; Direction, ExitDesc: string);

begin
  if Session.Room = RoomNo then begin
    WriteLn(TxtYouAreIn, TxtSimpleRoom_01);
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then begin
        WriteLn(TxtShared_03);
        WriteLn(Direction + TxtSimpleRoom_02 + ExitDesc);
      end;
      if MoveWhenOrExit([Go(Direction, DestRoom)]) then Exit;
    until Session.Room <> RoomNo;
  end;
end;

type
  TSideRoom = record
    room, dest: Integer;
    direction, exitDesc: string;
  end;

const
  { The four plain side rooms off the lost room, in dispatch order. }
  SideRooms: array[1..4] of TSideRoom = (
    (room: RoomSchoolSide1; dest: RoomLost; direction: CmdWschod; exitDesc: CmdMudSzkola2),
    (room: RoomSchoolSide3; dest: RoomLost; direction: CmdPolnoc; exitDesc: CmdMudSzkola2),
    (room: RoomSchoolSide2; dest: RoomLost; direction: CmdPolodnie; exitDesc: CmdMudSzkola2),
    (room: RoomSchoolSide4; dest: RoomLost; direction: CmdGora; exitDesc: CmdMudSzkola2)
  );

procedure PlainRooms;
var
  i: Integer;
begin
  for i := Low(SideRooms) to High(SideRooms) do
    with SideRooms[i] do
      SimpleRoom(room, dest, direction, exitDesc);
end;
procedure Room11;
begin
  if Session.Room <> RoomCageCorridor then Exit;
  WriteLn(TxtYouAreIn, TxtRoom11_01);
  WriteLines(TxtRoom11Lines1);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceKlatkaCieniasa,
                    TxtExitZachod, TxtPlaceKlatkaSilnego,
                    TxtExitPolnoc, TxtPlaceKlatkaZrecznego,
                    TxtExitPolodnie, TxtPlaceKlatkaOdpornego,
                    TxtExitGora, TxtPlaceKlatkaSilnegoOdpornegoIZrecznego,
                    TxtExitDol, TxtPlaceJedynaDrogaNieProwadzacaDoKlatek]);
    if MoveWhenOrExit([Go(CmdWschod, RoomCageWeakling),
              Go(CmdZachod, RoomCageStrong),
              Go(CmdPolnoc, RoomCageAgile),
              Go(CmdPolodnie, RoomCageTough),
              Go(CmdGora, RoomCageHuge),
              Go(CmdDol, RoomCageReward)]) then Exit;
    if Command = CmdPatrz + CmdPlakat then begin
      WriteLines(TxtRoom11Lines2);
    end;
  until Session.Room <> RoomCageCorridor;

end;
procedure Room30;
begin
  BasicRoomSimple(RoomLongStreet,
            [TxtRoom30_01, TxtRoom30_02],
            [TxtShared_03,
             TxtExitWschod, TxtPlaceCentrumMiasta,
             TxtExitZachod, TxtPlaceUlicaDluga,
             TxtExitPolnoc, TxtPlaceWejscieNaArene],
            [Go(CmdWschod, RoomCityCentre),
             Go(CmdZachod, RoomLongStreet2),
             Go(CmdPolnoc, RoomArenaEntrance)]);
end;
procedure Room60;
begin
  BasicRoomSimple(RoomValley,
            [TxtYouAreIn + TxtRoom60_01, TxtRoom60_02, TxtRoom60_03],
            [TxtShared_03,
             TxtExitPolodnie, TxtPlaceUlicaDluga,
             TxtExitWschod, TxtPlaceBudowlaPelnaHalasu],
            [Go(CmdPolodnie, RoomLongStreet2), Go(CmdWschod, RoomCrowd1)]);
end;
procedure Room75;
begin
  BasicRoomSimple(RoomDarkStreet,
            TxtRoom75Lines1,
            [TxtShared_03,
             TxtExitZachod, TxtPlaceCentrumMiasta,
             TxtExitPolnoc, TxtPlaceBarPodDwomaPedalami,
             TxtExitPolodnie, TxtPlaceBluszcz],
            [Go(CmdZachod, RoomCityCentre), Go(CmdPolnoc, RoomBar),
             Go(CmdPolodnie, RoomIvy1)]);
end;
procedure Room83;
begin
  if Session.Room <> RoomClearing then Exit;
  WriteLines(TxtRoom83Lines1);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolnoc, TxtPlaceBluszcz,
                    TxtExitZachod, TxtPlacePodejrzaneKrzaki]);
    if MoveWhenOrExit([Go(CmdPolnoc, RoomIvy4), Go(CmdZachod, RoomCavePath)]) then Exit;
  until Session.Room <> RoomClearing;

end;
procedure Room100;
begin
  if Session.Room <> RoomQuestMaster then Exit;
  WriteLn(TxtRoom100_01);
  WriteLn(TxtRoom100_02);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then begin
      WriteExits([TxtShared_03,
                  TxtExitPolodnie, TxtPlaceUlSklepikowa,
                  TxtExitWschod, TxtPlaceDrogaOKtorejMozeszPomazycBoJestWProdukcji]);
      if Bag.Permit = 0 then WriteLn(TxtExitZachod, TxtPlaceDrogaZablokowanaPrzezQuestMastera);
      if Bag.Permit < 0 then WriteLn(TxtExitZachod, TxtPlaceDroga);
    end;
    if Command = CmdLista then begin
      WriteLines(TxtRoom100Lines1);
    end;
    if (Command = CmdKup + CmdLatwyQuest) and (Player.Money > 199) then begin
      WriteLn(TxtRoom100_09);
      World.Quest := 1;
      World.QuestKills := 75;
      Player.Money := Player.Money - 200;
    end;
    if (Command = CmdKup + CmdPrzecietnyQuest) and (Player.Money > 99) then begin
      WriteLn(TxtRoom100_10);
      World.Quest := 2;
      World.QuestKills := 200;
      Player.Money := Player.Money - 100;
    end;
    if (Command = CmdKup + CmdTrudnyQuest) and (Player.Money > 49) then begin
      WriteLn(TxtRoom100_11);
      World.Quest := 3;
      World.QuestKills := 200;
      Player.Money := Player.Money - 50;
    end;
    if (Command = CmdSprzedaj + CmdQuest) and (World.Quest > 0) then begin
      case World.Quest of
        1: if World.QuestKills < 1 then begin
             WriteLn(TxtRoom100_12);
             WriteLn(TxtQuestReward, 100, TxtSpaceKunsztDashes);
             Player.Experience := Player.Experience + 100;
             World.Quest := 0;
             World.QuestKills := 0;
             Bag.Permit := Bag.Permit - 10;
             Bag.Count := Bag.Count + 1;
           end;
        2: if (World.QuestKills < 1) and (Bag.Diploma <= -10) then begin
             WriteLn(TxtRoom100_12);
             WriteLn(TxtQuestReward, 250, TxtSpaceKunsztDashes);
             Player.Experience := Player.Experience + 250;
             World.Quest := 0;
             World.QuestKills := 0;
             Bag.Diploma := 0;
             Player.MaxEnergy := Player.MaxEnergy - 5;
             Bag.Permit := Bag.Permit - 10;
           end;
        3: if (World.QuestKills < 1) and (Bag.Pipe <= -10) and (Player.Practice > 0) then begin
             WriteLn(TxtRoom100_12);
             WriteLn(TxtQuestReward, 425, TxtSpaceKunsztDashes);
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

    end;
    if MoveWhenOrExit([Go(CmdPolodnie, RoomShopStreet2)]) then Exit;
    if (Command = CmdZachod) and (Bag.Permit <= -10) then Session.Room := RoomRoad1;
if (Command = CmdZachod) and (Bag.Permit = 0) then WriteLn(TxtRoom100_16);
    if Command = CmdZabij + CmdQuestMaster then begin
      Combat.PoisonCharges := 10;
      Combat.FireballCharges := 20;
      Combat.EnemyStrength := 10;
      Combat.EnemyDexterity := 26;
      Combat.EnemyEnergy := 188;
      Fight;
      if Combat.EnemyEnergy < 1 then Bag.Permit := Bag.Permit - 10;
    end;
  until Session.Room <> RoomQuestMaster;

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
  WriteLn(TxtShared_08, Combat.Loot, TxtFightDog_01);
  Player.Money := Player.Money + Combat.Loot;
  TryLoot(Bag.Heart, 5, TxtFightDog_02);
end;

type
  PInteger = ^Integer;
  PShortint = ^Shortint;

procedure SpawnGroup(const targets: array of PInteger; spread, base: Integer);
var
  i: Integer;
begin
  for i := Low(targets) to High(targets) do
    targets[i]^ := Random(spread) + base;
end;

procedure SpawnGroupShort(const targets: array of PShortint; spread, base: Integer);
var
  i: Integer;
begin
  for i := Low(targets) to High(targets) do
    targets[i]^ := Random(spread) + base;
end;

procedure SpawnMonsters;
begin
  repeat
    SpawnGroup([@World.Bacterium, @World.Snail, @World.Beetle, @World.Cockroach, @World.Ant,
                @World.Spider, @World.Boar, @World.Fox, @World.Rat, @World.Partridge], 38, RoomCityCentre);
  until (World.Bacterium > RoomArenaEntrance) and (World.Snail > RoomArenaEntrance) and (World.Beetle > RoomArenaEntrance) and (World.Cockroach > RoomArenaEntrance)
    and (World.Ant > RoomArenaEntrance) and (World.Spider > RoomArenaEntrance) and (World.Boar > RoomArenaEntrance) and (World.Fox > RoomArenaEntrance)
    and (World.Rat > RoomArenaEntrance) and (World.Partridge > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Deer, @World.Eagle, @World.Hare, @World.Mongrel, @World.Woodworm, @World.Fly], 38, RoomCityCentre);
  until (World.Deer > RoomArenaEntrance) and (World.Eagle > RoomArenaEntrance) and (World.Hare > RoomArenaEntrance) and (World.Mongrel > RoomArenaEntrance)
    and (World.Woodworm > RoomArenaEntrance) and (World.Fly > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Elephant, @World.Lion, @World.Giraffe, @World.Camel, @World.Ostrich,
                @World.Boa, @World.Wolf, @World.Bison, @World.Panther], 38, RoomCityCentre);
  until (World.Elephant > RoomArenaEntrance) and (World.Lion > RoomArenaEntrance) and (World.Giraffe > RoomArenaEntrance) and (World.Camel > RoomArenaEntrance)
    and (World.Ostrich > RoomArenaEntrance) and (World.Boa > RoomArenaEntrance) and (World.Wolf > RoomArenaEntrance) and (World.Bison > RoomArenaEntrance)
    and (World.Panther > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Gladiator, @World.Warrior, @World.Tamer], 38, RoomCityCentre);
  until (World.Gladiator > RoomArenaEntrance) and (World.Warrior > RoomArenaEntrance) and (World.Tamer > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Dachshund, @World.Shepherd, @World.Pooch, @World.Spaniel, @World.Poodle], 7, RoomCityCentre);
  until (World.Dachshund > 19) and (World.Shepherd > 19) and (World.Pooch > 19)
    and (World.Spaniel > 19) and (World.Poodle > 19);
  repeat
    SpawnGroup([@World.Cabman, @World.Vendor, @World.Sweeper, @World.Drunkard, @World.SickMan], 7, RoomCityCentre);
  until (World.Cabman > 19) and (World.Vendor > 19)
    and (World.Sweeper > 19) and (World.Drunkard > 19) and (World.SickMan > 19);
  repeat
    SpawnGroupShort([@World.Kid], 7, RoomValley);
    SpawnGroupShort([@World.Lunatic, @World.Listener, @World.Fan, @World.Man], 8, RoomValley);
  until (World.Kid > RoomValley) and (World.Lunatic > RoomValley) and (World.Listener > RoomValley) and (World.Fan > RoomValley)
    and (World.Man > RoomValley);
  repeat
    SpawnGroupShort([@World.Policeman, @World.Bouncer, @World.Gorilla], 9, RoomValley);
    SpawnGroupShort([@World.OldMan], 8, RoomValley);
    SpawnGroupShort([@World.Reporter], 7, RoomValley);
  until (World.Policeman > RoomValley) and (World.Bouncer > RoomValley) and (World.Gorilla > RoomValley) and (World.OldMan > RoomValley)
    and (World.Reporter > RoomValley);
    SpawnGroup([@World.Guitarist, @World.Drummer, @World.Keyboardist, @World.Liroy], 3, RoomStage1);
  World.Minibarman := RoomPub;
  World.Fatso := RoomPub;
  World.DJ := RoomBackstage;
  World.Pedal := RoomBar;
  World.Couple := RoomBar;
  World.Maciek := RoomBar;
  World.Door := 1;
  World.OldElf := 1;
  repeat
    SpawnGroup([@World.Sorrel, @World.Clover, @World.Daisy, @World.SowThistle, @World.Dandelion,
                @World.Rose, @World.Thistle, @World.Raspberry, @World.Gooseberry, @World.Blackberry,
                @World.Grass], 8, RoomIvy1);
    SpawnGroupShort([@World.Duncan], 8, RoomIvy1);
  until (World.Sorrel < RoomCavePath) and (World.Daisy < RoomCavePath) and (World.Clover < RoomCavePath) and (World.SowThistle < RoomCavePath)
    and (World.Dandelion < RoomCavePath) and (World.Rose < RoomCavePath) and (World.Thistle < RoomCavePath) and (World.Raspberry < RoomCavePath);
end;
procedure TrainAttribute(var Attribute, MaxAttribute: Integer; MinPractice, PracticeCost: Integer; cmdForm, nounForm: string);

begin
  if (Player.Practice > MinPractice) and (Attribute < MaxAttribute) then begin
    Attribute := Attribute + 1;
    Player.Practice := Player.Practice - PracticeCost;
    WriteLn(TxtTrainAttribute_01, cmdForm, TxtTrainAttribute_02, Attribute, TxtTrainAttribute_03, nounForm, TxtTrainAttribute_04, Player.Practice, TxtShared_19);
  end;
end;

procedure HandleTrain;
begin
  if Command = CmdTrenuj then WriteLn(TxtHandleTrain_01);
  if Command = CmdTrenuj2 + CmdSila then
    TrainAttribute(Player.Strength, Player.MaxStrength, 2, 3, CmdSile, CmdSily);
  if Command = CmdTrenuj2 + CmdZrecznosc then
    TrainAttribute(Player.Dexterity, Player.MaxDexterity, 1, 2, CmdZrecznosc, CmdZrecznosci);
  if Command = CmdTrenuj2 + CmdMadrosc then
    TrainAttribute(Player.Wisdom, Player.MaxWisdom, 2, 3, CmdMadrosc, CmdMadrosci);
end;

type
  TSpot = record
    where: PInteger;
    text: string;
  end;
  TCrowdSpot = record
    where: PShortint;
    text: string;
  end;

const
  PlantSpots: array[1..11] of TSpot = (
    (where: @World.Sorrel; text: TxtDescribePlants_01),
    (where: @World.Daisy; text: TxtDescribePlants_02),
    (where: @World.Clover; text: TxtDescribePlants_03),
    (where: @World.SowThistle; text: TxtDescribePlants_04),
    (where: @World.Dandelion; text: TxtDescribePlants_05),
    (where: @World.Rose; text: TxtDescribePlants_06),
    (where: @World.Thistle; text: TxtDescribePlants_07),
    (where: @World.Blackberry; text: TxtDescribePlants_08),
    (where: @World.Gooseberry; text: TxtDescribePlants_09),
    (where: @World.Raspberry; text: TxtDescribePlants_10),
    (where: @World.Grass; text: TxtDescribePlants_11)
  );
  BeastSpots: array[1..28] of TSpot = (
    (where: @World.Woodworm; text: TxtDescribeBeasts_01),
    (where: @World.Fly; text: TxtDescribeBeasts_02),
    (where: @World.Bacterium; text: TxtDescribeBeasts_03),
    (where: @World.Snail; text: TxtDescribeBeasts_04),
    (where: @World.Beetle; text: TxtDescribeBeasts_05),
    (where: @World.Cockroach; text: TxtDescribeBeasts_06),
    (where: @World.Ant; text: TxtDescribeBeasts_07),
    (where: @World.Spider; text: TxtDescribeBeasts_08),
    (where: @World.Boar; text: TxtDescribeBeasts_09),
    (where: @World.Rat; text: TxtDescribeBeasts_10),
    (where: @World.Fox; text: TxtDescribeBeasts_11),
    (where: @World.Partridge; text: TxtDescribeBeasts_12),
    (where: @World.Hare; text: TxtDescribeBeasts_13),
    (where: @World.Mongrel; text: TxtDescribeBeasts_14),
    (where: @World.Eagle; text: TxtDescribeBeasts_15),
    (where: @World.Deer; text: TxtDescribeBeasts_16),
    (where: @World.Elephant; text: TxtDescribeBeasts_17),
    (where: @World.Lion; text: TxtDescribeBeasts_18),
    (where: @World.Giraffe; text: TxtDescribeBeasts_19),
    (where: @World.Camel; text: TxtDescribeBeasts_20),
    (where: @World.Ostrich; text: TxtDescribeBeasts_21),
    (where: @World.Boa; text: TxtDescribeBeasts_22),
    (where: @World.Wolf; text: TxtDescribeBeasts_23),
    (where: @World.Bison; text: TxtDescribeBeasts_24),
    (where: @World.Panther; text: TxtDescribeBeasts_25),
    (where: @World.Gladiator; text: TxtDescribeBeasts_26),
    (where: @World.Warrior; text: TxtDescribeBeasts_27),
    (where: @World.Tamer; text: TxtDescribeBeasts_28)
  );
  StreetSpots: array[1..10] of TSpot = (
    (where: @World.Dachshund; text: TxtDescribeStreet_01),
    (where: @World.Shepherd; text: TxtDescribeStreet_02),
    (where: @World.Pooch; text: TxtDescribeStreet_03),
    (where: @World.Spaniel; text: TxtDescribeStreet_04),
    (where: @World.Poodle; text: TxtDescribeStreet_05),
    (where: @World.Cabman; text: TxtDescribeStreet_06),
    (where: @World.Vendor; text: TxtDescribeStreet_07),
    (where: @World.Sweeper; text: TxtDescribeStreet_08),
    (where: @World.Drunkard; text: TxtDescribeStreet_09),
    (where: @World.SickMan; text: TxtDescribeStreet_10)
  );
  StageSpots: array[1..4] of TSpot = (
    (where: @World.Guitarist; text: TxtDescribeStage_01),
    (where: @World.Drummer; text: TxtDescribeStage_02),
    (where: @World.Keyboardist; text: TxtDescribeStage_03),
    (where: @World.Liroy; text: TxtDescribeStage_04)
  );
  CrowdSpots: array[1..10] of TCrowdSpot = (
    (where: @World.Kid; text: TxtDescribeCrowd_01),
    (where: @World.Lunatic; text: TxtDescribeCrowd_02),
    (where: @World.Listener; text: TxtDescribeCrowd_03),
    (where: @World.Fan; text: TxtDescribeCrowd_04),
    (where: @World.Man; text: TxtDescribeCrowd_05),
    (where: @World.Policeman; text: TxtDescribeCrowd_06),
    (where: @World.Bouncer; text: TxtDescribeCrowd_07),
    (where: @World.Gorilla; text: TxtDescribeCrowd_08),
    (where: @World.OldMan; text: TxtDescribeCrowd_09),
    (where: @World.Reporter; text: TxtDescribeCrowd_10)
  );



procedure DescribePlants;
var
  i: Integer;
begin
  for i := Low(PlantSpots) to High(PlantSpots) do
    if PlantSpots[i].where^ = Session.Room then
      WriteLn(PlantSpots[i].text);
  if Session.Room = World.Duncan then
    WriteLn(TxtDescribePlants_12);
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
    WriteLn(TxtShared_08, Combat.Loot, TxtCompositeFight_01);
    Player.Money := Player.Money + Combat.Loot;
    if AntDoughnut then begin
      if Command = CmdZabij + CmdMrowka then begin
        Combat.Roll := Random(10);
        if (Combat.Roll < 7) and (Bag.Doughnut <> -10) then begin
          WriteLn(TxtShared_08, TxtCompositeFight_02);
          Bag.Doughnut := -10;
          Bag.Count := Bag.Count + 1;
        end;
      end;
    end else if (HeartChance > 0) and (Bag.Heart = 0) then begin
      Combat.Roll := Random(20);
      if (Combat.Roll < HeartChance) and (Bag.Heart <> -10) then begin
        WriteLn(TxtShared_08, TxtCompositeFight_03);
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

type
  TFight = procedure;

{ One arena beast: the kill command in the beast's room starts the
  given fight and the beast is removed when it falls. }
procedure KillBeast(cmd: string; var beast: Integer; fight: TFight);
begin
  if (Command = cmd) and (Session.Room = beast) then begin
    fight;
    beast := 0;
  end;
end;

{ The same, but a beast that fled the fight stays in the room. }
procedure KillBeastUnlessFled(cmd: string; var beast: Integer; fight: TFight);
begin
  if (Command = cmd) and (Session.Room = beast) then begin
    fight;
    if Combat.Fled = 0 then
      beast := 0;
  end;
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
    WriteLn(TxtCompareFoe_01);
    ReadLn(Command);
    Session.Overall := Player.Level + Player.Strength + DexterityBonus(Player.Dexterity) + ParryBonus(Skills.Parry) + KickBonus(Skills.Kick);
    if (Command = CmdDzik) or (Command = CmdSzczur) or (Command = CmdLis) or
       (Command = CmdKuropatwa) or (Command = CmdZajac) or (Command = CmdWilczur) or
       (Command = CmdOrzel) or (Command = CmdSarna) or (Command = CmdDziecko) or (Command = CmdDziadek) then
        begin if Session.Overall < 16 then WriteLn(TxtCompareFoe_02);
        if (Player.Strength > 15) and (Player.Strength < 19) then WriteLn(TxtEnemy, TxtCompareFoe_03);
        if Player.Strength > 18 then WriteLn(TxtCompareFoe_04);
        end;
    if (Command = CmdSlon) or (Command = CmdLew) or (Command = CmdZyrafa) or (Command = CmdWielblad) or
       (Command = CmdStrus) or (Command = CmdBoa) or (Command = CmdWilk) or (Command = CmdBizon) or
       (Command = CmdPantera) or (Command = CmdWariat) or (Command = CmdSluchacz) or (Command = CmdFan) or
       (Command = CmdCzlowiek) or (Command = CmdReporter) then
      begin if Session.Overall < 16 then WriteLn(TxtCompareFoe_05);
      if (Player.Strength > 15) and (Player.Strength < 21) then WriteLn(TxtCompareFoe_06);
      if (Player.Strength > 20) and (Player.Strength < 23) then WriteLn(TxtCompareFoe_07);
      if Player.Strength > 22 then WriteLn(TxtCompareFoe_08);
    end;
    if (Command = CmdGladiator) or (Command = CmdWojownik) or (Command = CmdTrener) or
       (Command = CmdPolicjant) or (Command = CmdGoryl) or (Command = CmdOchroniarz) then begin
      if Session.Overall < 15 then WriteLn(TxtCompareFoe_09);
      if (Session.Overall > 14) and (Session.Overall < 18) then WriteLn(TxtCompareFoe_10);
      if (Session.Overall > 17) and (Session.Overall < 23) then WriteLn(TxtCompareFoe_11);
      if (Session.Overall > 22) and (Session.Overall < 26) then WriteLn(TxtCompareFoe_12);
      if Session.Overall > 25 then WriteLn(TxtCompareFoe_13);
    end;
    if (Command = CmdMiniBarman) or (Command = CmdGrubas) or (Command = CmdDJ) then begin
      if Session.Overall < 24 then WriteLn(TxtCompareFoe_14);
      if (Session.Overall > 23) and (Session.Overall < 26) then WriteLn(TxtCompareFoe_15);
      if (Session.Overall > 25) and (Session.Overall < 29) then WriteLn(TxtCompareFoe_16);
      if Session.Overall > 28 then WriteLn(TxtCompareFoe_17);
      if Session.Overall > 34 then WriteLn(TxtCompareFoe_18);
    end;
    if (Command = CmdTaksowkarz) or (Command = CmdSprzedawca) or (Command = CmdGitarzysta) or (Command = CmdPerkusista) or
       (Command = CmdOrganista) or (Command = CmdZebrak) or (Command = CmdPijak) or (Command = CmdZamiatacz) or (Command = CmdSzczaw) or
       (Command = CmdStokrotka) or (Command = CmdKoniczynka) or (Command = CmdMlecz) or (Command = CmdDmuchawiec) then begin
      if Session.Overall < 21 then WriteLn(TxtCompareFoe_19);
      if (Session.Overall > 22) and (Session.Overall < 28) then WriteLn(TxtCompareFoe_20);
      if Session.Overall > 27 then WriteLn(TxtCompareFoe_21);
    end;
    if (Command=CmdPedal) or (Command=CmdPara) or (Command=CmdMaciek) or (Command=CmdRoza) or
       (Command=CmdMalina) or (Command=CmdTrawa) or (Command = CmdAgrest) or (Command = CmdJezyna) then begin
      if Session.Overall < 20 then WriteLn(TxtCompareFoe_22);
      if (Session.Overall > 19) and (Session.Overall < 26) then WriteLn(TxtCompareFoe_23);
      if (Session.Overall > 25) and (Session.Overall < 30) then WriteLn(TxtCompareFoe_24);
      if Session.Overall > 29 then WriteLn(TxtCompareFoe_25);
      if Session.Overall > 35 then WriteLn(TxtCompareFoe_26);
    end;
    if Command = CmdLiroy then begin
      if Session.Overall < 28 then WriteLn(TxtCompareFoe_27);
      if (Session.Overall > 27) and (Session.Overall < 33) then WriteLn(TxtCompareFoe_28);
      if (Session.Overall > 32) and (Session.Overall < 44) then WriteLn(TxtCompareFoe_29);
    if (Session.Overall > 43) and (Session.Overall < 48) then WriteLn(TxtCompareFoe_30);
      if Session.Overall > 47 then WriteLn(TxtCompareFoe_31);
    end;
    if Command = CmdPokrzywa then begin
      if Session.Overall < 40 then WriteLn(TxtCompareFoe_32);
      if Session.Overall > 39 then WriteLn(TxtCompareFoe_33);

    end;
    if (Command = CmdSpaniel) or (Command = CmdOwczarek) or (Command = CmdPiesek) or (Command=CmdJamnik) or (Command=CmdPudel) then
      WriteLn(TxtCompareFoe_34);
    if (Combat.Roll < 3) and (Skills.Comparing < 100) then begin
      WriteLn(TxtFightStars17, TxtLearnVerb, TxtCompareFoe_35);
      Skills.Comparing := Skills.Comparing + 1;
      Player.Experience := Player.Experience + 5;
    end;
    if Command = CmdBakteria then begin
      WriteLn(TxtCompareFoe_36);
      Player.Mana := Player.Mana + 5;
    end;
  end;
end;


procedure DescribeStreet;
var
  i: Integer;
begin
  for i := Low(StreetSpots) to High(StreetSpots) do
    if StreetSpots[i].where^ = Session.Room then
      WriteLn(StreetSpots[i].text);
end;

procedure SuitGain;
begin
  Combat.Roll := Random(1000);
  if Combat.Roll <= 25 then begin
    WriteLn(TxtSuitGain_01);
    WriteLn(TxtUniqeItem, TxtSuitGain_02);
    Bag.SpikedSuit := Bag.SpikedSuit - 10;
    Bag.Count := Bag.Count + 1;
  end;
end;
procedure PillGain;
begin
  Combat.Roll := Random(1000);
  if Combat.Roll <= 42 then begin
    WriteLn(TxtPillGain_01);
    Bag.TeleportPill := Bag.TeleportPill - 10;
    Bag.Count := Bag.Count + 1;
  end;
end;
procedure CassetteGain;
begin
  Combat.Roll := Random(100);
  if (Combat.Roll < 2) and (Session.Room <> DeadRoom) then begin
    WriteLn(TxtShared_08, TxtCassetteGain_01);
    WriteLn(TxtBang, TxtUniqeItem, TxtCassetteGain_02);
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
  if (Combat.Roll < 6) and (Session.Room <> DeadRoom) then begin
    WriteLn(TxtShared_08, TxtLeafGain_01);
    WriteLn(TxtBang, TxtUniqeItem, TxtLeafGain_02);
    Bag.LuckyLeaf := Bag.LuckyLeaf - 10;
    Bag.Count := Bag.Count + 1;
    Player.MaxMana := Player.MaxMana + 40;
  end;
end;
procedure ScrollGain;
begin
  Combat.Roll := Random(100);
  if (Combat.Roll < 10) and (Session.Room <> DeadRoom) then begin
    WriteLn(TxtShared_08, TxtScrollGain_01);
    Bag.CompareScroll := Bag.CompareScroll - 10;
    Bag.Count := Bag.Count + 1;
  end;
end;

procedure EnterTrance;
begin
  Session.OuterRoom := Session.Room;
  Session.Room := TranceRoom;
end;

procedure DescribeStage;
var
  i: Integer;
begin
  for i := Low(StageSpots) to High(StageSpots) do
    if StageSpots[i].where^ = Session.Room then
      WriteLn(StageSpots[i].text);
end;

procedure DescribeCrowd;
var
  i: Integer;
begin
  for i := Low(CrowdSpots) to High(CrowdSpots) do
    if CrowdSpots[i].where^ = Session.Room then
      WriteLn(CrowdSpots[i].text);
end;



procedure DescribeBeasts;
var
  i: Integer;
begin
  for i := Low(BeastSpots) to High(BeastSpots) do
    if BeastSpots[i].where^ = Session.Room then
      WriteLn(BeastSpots[i].text);
end;

procedure ShieldBlock;
begin
  Combat.Roll := Random(100);
  if Combat.Roll <= Gear.Armor then begin
    Combat.Damage := Combat.Damage - Gear.WornCount;
    if Combat.Damage < 0 then Combat.Damage := 0;
    WriteLn(TxtShieldBlock_01, Combat.Damage, TxtShared_20);
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
    WriteLn(TxtFightEngagedEnemy, Combat.EnemyEnergy, TxtFightEngagedYou, Player.Energy, TxtFightEngagedEnd);
    if Player.Dexterity > Combat.EnemyDexterity then begin
      Combat.DodgeChance := Player.Dexterity - Combat.EnemyDexterity;
      Combat.Roll := Random(DodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn(TxtFightYouDodgeMocking);
        Combat.PlayerDodged := 1;
      end;
      Combat.Roll := Random(EnemyDodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn(TxtEnemy, TxtFightEnemyDodgesLamersAttack);
        Combat.EnemyDodged := 1;
      end;
    end;
    if Combat.EnemyDexterity > Player.Dexterity then begin
      Combat.DodgeChance := Combat.EnemyDexterity - Player.Dexterity;
      Combat.Roll := Random(DodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn(TxtEnemy, TxtFightEnemyDodgesWithGrace);
        Combat.EnemyDodged := 1;
      end;
      Combat.Roll := Random(EnemyDodgeBound(Combat.DodgeChance));
      if Combat.Roll < 10 then begin
        WriteLn(TxtFightYouDodgeWithoutPardon);
        Combat.PlayerDodged := 1;
      end;
    end;
    if Combat.PlayerDodged = 0 then begin
      Combat.Damage := Random(Combat.EnemyStrength);
      case Combat.Damage of
        0..5: WriteLn(TxtEnemy, TxtFightScratchedLabel, Combat.Damage, TxtFightTailEnergii);
        6..20: WriteLn(TxtFightTakenLabel, Combat.Damage, TxtFightTailEnergii);
        21..50: WriteLn(TxtEnemy, TxtFightMassacredYouLabel, Combat.Damage, TxtFightTailEnergii);
        else WriteLn(TxtEnemy, TxtFightGougedYouLabel, Combat.Damage, TxtFightTailEnergii);
      end;
      Combat.FightExperience := Combat.FightExperience + 1;
      ShieldBlock;
      if (Skills.Parry > 0) and (Combat.Damage > 0) then begin
        Combat.Roll := Random(140);
        if Combat.Roll <= Skills.Parry then begin
          case Combat.Damage of
            0..2: begin
              WriteLn(TxtFightParryLabel, TxtFightParryZeroTail);
              Combat.Damage := 0;
            end;
            3..9: begin
              Combat.Damage := Combat.Damage - 2;
              WriteLn(TxtFightParryLabel, Combat.Damage, TxtFightTailEnergi);
            end;
            else begin
              Combat.Damage := Combat.Damage - 3;
              WriteLn(TxtFightParryLabel, Combat.Damage, TxtFightTailEnergi);
            end;
          end;
          if (Combat.Roll < 1) and (Skills.Parry < 100) then begin
            WriteLn(TxtFightStars15, TxtLearnVerb, TxtFightParryLearn);
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
          WriteLn(TxtEnemy, TxtFightFireballLabel, Combat.Roll, TxtFightTailEnergii);
          Player.Energy := Player.Energy - Combat.Roll;
          Combat.FireballCharges := Combat.FireballCharges - 1;
          TextColor(15);
        end;
      end;
      if Combat.PoisonCharges > 0 then begin
        Combat.Roll := Random(100);
        if Combat.Roll < 10 then begin
          TextColor(4);
          WriteLn(TxtEnemy, TxtFightCastsPoison);
          Combat.PoisonCharges := Combat.PoisonCharges - 1;
          TextColor(15);
          Combat.PoisonRounds := Combat.PoisonRounds + 10;
        end;
      end;
      if Combat.PoisonRounds > 0 then begin
        Combat.Roll := Random(5);
        WriteLn(TxtFightPoisonedLabel, Combat.Roll, TxtFightTailEnergi);
        Player.Energy := Player.Energy - Combat.Roll;
        Combat.PoisonRounds := Combat.PoisonRounds - 1;
      end;
    end;
    if Combat.EnemyDodged = 0 then begin
      Combat.Damage := Random(Player.Strength);
      if Combat.Damage * 10 < Gear.LuckRoll then begin
        repeat
          Combat.Damage := Random(Player.Strength);
          WriteLn(TxtFightLuckRoll);
        until (Combat.Damage * 10) > Gear.LuckRoll;
      end;
      Combat.EnemyEnergy := Combat.EnemyEnergy - Combat.Damage;
      case Combat.Damage of
        0..5:
          WriteLn(TxtFightPushedLabel, Combat.Damage, TxtFightTailEnergii);
        6..20:
          WriteLn(TxtFightHitLabel, Combat.Damage, TxtFightTailEnergii);
        21..50: WriteLn(TxtFightMassacredHimLabel, Combat.Damage, TxtFightTailEnergii);
        else WriteLn(TxtFightGougedHimLabel, Combat.Damage, TxtFightTailEnergii);
      end;
    end;
    Delay(2000);
    if (Skills.Kick > 0) and (Player.Mana > Skills.KickMinMana) and (Player.Energy < Skills.KickMaxEnergy) then begin
      Combat.Roll := Random(100);
      if Combat.Roll <= Skills.Kick - 10 then begin
        Combat.Roll := Random(10) + Random(Player.Level);
        TextColor(14);
        WriteLn(TxtFightKickVerb, TxtFightSuperKickLabel, Combat.Roll, TxtFightTailEnergi);
        TextColor(15);
        Player.Mana := Player.Mana - Random(3) - 3;
        Combat.EnemyEnergy := Combat.EnemyEnergy - Combat.Roll;
      end else WriteLn(TxtFightKickVerb, TxtFightSuperKickMiss);
      Player.Mana := Player.Mana - Random(2) - 2;
    end;
    if (Skills.Fleeing > 0) and (Player.Energy < Skills.FleeEnergy) and (Player.Mana > 14) then begin
      Player.Mana := Player.Mana - 15;
      Combat.Roll := Random(100);
      if Combat.Roll <= Skills.Fleeing then begin
        Combat.Fled := 1;
        WriteLn(TxtFightFled);
        Player.Experience := Player.Experience - 20;
      end else WriteLn(TxtFightFleeFailed);
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
    WriteLn(TxtFightVictoryLabel, Combat.FightExperience, TxtFightVictoryTail);
    Player.Experience := Combat.FightExperience + Player.Experience;
    Combat.FireballCharges := 0;
    Combat.PoisonCharges := 0;

    if World.Quest > 0 then World.QuestKills := World.QuestKills - 1;
    if Skills.Cooking > 0 then begin
      Combat.Roll := Random(100);
      if Skills.Cooking > Combat.Roll then begin
        WriteLn(TxtFightMadeBigos);
        Bag.Bigos := Bag.Bigos - 10;
        Bag.Count := Bag.Count + 1;
        if (Combat.Roll < 1) and (Skills.Cooking < 100) then begin
          WriteLn(TxtFightCookingLearn);
          Skills.Cooking := Skills.Cooking + 1;
          Player.Experience := Player.Experience + 10;

        end;
      end;
    end;
  end;
  if Player.Energy < 1 then begin
    WriteLn(TxtFightKilled);
    Delay(3000);
    Session.Room := DeadRoom;
  end;
  Combat.FightExperience := 0;
end;

procedure TakeDrop;
begin
  if (Command = CmdBierz + CmdStary) and (Bag.OldSword = Session.OuterRoom) then begin
    WriteLn(TxtPickUpVerb, TxtTakeDrop_01);
    Bag.OldSword := -10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = CmdBierz + CmdMala) and (Bag.SmallShield = Session.OuterRoom) then begin
    WriteLn(TxtPickUpVerb, TxtTakeDrop_02);
    Bag.SmallShield := -10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = CmdBierz + CmdSerce) and (Bag.Heart = Session.OuterRoom) then begin
    WriteLn(TxtPickUpVerb, TxtTakeDrop_03);
    Bag.Heart := -10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = CmdBierz + CmdDyplom) and (Bag.Diploma = Session.OuterRoom) then begin
    WriteLn(TxtPickUpVerb, TxtTakeDrop_04);
    Bag.Diploma := -10;
    Player.MaxEnergy := Player.MaxEnergy + 5;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = CmdBierz + CmdFajka) and (Bag.Pipe = Session.OuterRoom) then begin
    WriteLn(TxtPickUpVerb, TxtTakeDrop_05);
    Bag.Pipe := -10;
    Bag.Count := Bag.Count + 1;
    if Player.Wisdom < Player.MaxWisdom then Player.Wisdom := Player.Wisdom + 1;
  end;
  if (Command = CmdOdrzuc + CmdStary) and (Bag.OldSword = -10) then begin
    WriteLn(TxtDropVerb, TxtTakeDrop_06);
    Bag.OldSword := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = CmdOdrzuc + CmdFajka) and (Bag.Pipe = -10) then begin
    WriteLn(TxtTakeDrop_07);
    Bag.Pipe := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
    Player.Wisdom := Player.Wisdom - 1;
  end;
  if (Command = CmdOdrzuc + CmdMala) and (Bag.SmallShield = -10) then begin
    WriteLn(TxtDropVerb, TxtTakeDrop_08);
    Bag.SmallShield := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = CmdOdrzuc + CmdSerce) and (Bag.Heart = -10) then begin
    WriteLn(TxtDropVerb, TxtTakeDrop_09);
    Bag.Heart := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = CmdOdrzuc + CmdDyplom) and (Bag.Diploma = -10) then begin
    WriteLn(TxtDropVerb, TxtTakeDrop_10);
    Bag.Diploma := Session.OuterRoom;
    Player.MaxEnergy := Player.MaxEnergy - 5;
    Bag.Count := Bag.Count - 1;
  end;
end;
procedure UseItems;
begin
  if (Command = CmdUzyj + CmdFajka) and (Bag.Pipe = -10) then WriteLn(TxtUseItems_01);
  if (Command = CmdUzyj + CmdSerce) and (Bag.Heart = -10) then begin
    Bag.Heart := 0;
    WriteLn(TxtEatVerb, TxtUseItems_02);
    Player.Energy := Player.Energy + 5;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = CmdUzyj + CmdDyplom) and (Bag.Diploma = -10) then begin
    WriteLines(TxtUseItemsLines1);
  end;
  if (Command = CmdUzyj + CmdPaczek) and (Bag.Doughnut <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Doughnut := Bag.Doughnut + 10;
    WriteLn(TxtEatVerb, TxtUseItems_12);
    Player.Energy := Player.Energy + 8;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = CmdUzyj + CmdCiastko) and (Bag.Cookie <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Cookie := Bag.Cookie + 10;
    WriteLn(TxtEatVerb, TxtUseItems_13);
    Player.Energy := Player.Energy + 12;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = CmdUzyj + CmdSuchaRacja) and (Bag.DryRation <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.DryRation := Bag.DryRation + 10;
    WriteLn(TxtEatVerb, TxtUseItems_14);
    Player.Energy := Player.Energy + 16;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = CmdUzyj + CmdBulka) and (Bag.BreadRoll <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.BreadRoll := Bag.BreadRoll + 10;
    WriteLn(TxtEatVerb, TxtUseItems_15);
    Player.Energy := Player.Energy + 20;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = CmdZniszcz + CmdPrzepustka) and (Bag.Permit <= -10) then begin
    WriteLn(TxtUseItems_16);
    Bag.Permit := Bag.Permit + 10;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = CmdPatrz + CmdPrzepustka) and (Bag.Permit <= -10) then begin
    WriteLines(TxtUseItemsLines2);
  end;
  if (Command = CmdUzyj + CmdChleb) and (Bag.Bread <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Bread := Bag.Bread + 10;
    WriteLn(TxtEatVerb, TxtUseItems_23);
    Player.Energy := Player.Energy + 26;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if Command = CmdUzyj + CmdKaseta then WriteLn(TxtUseItems_24);
  if (Command = CmdUzyj + CmdWeka) and (Bag.Sausage <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Sausage := Bag.Sausage + 10;
    WriteLn(TxtEatVerb, TxtUseItems_25);
    Player.Energy := Player.Energy + 34;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;
  end;
  if (Command = CmdUzyj + CmdMalaButelkaMany) and (Bag.ManaBottle <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.ManaBottle := Bag.ManaBottle + 10;
    WriteLn(TxtUseItems_26);
    Player.Mana := Player.Mana + 30;
    if Player.Mana > Player.MaxMana then Player.Mana := Player.MaxMana;
  end;
  if (Command = CmdUzyj + CmdBigos) and (Bag.Bigos <= -10) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Bigos := Bag.Bigos + 10;
    WriteLn(TxtEatVerb, TxtUseItems_27);
    Player.Energy := Player.Energy + 20;
    if Player.Energy > Player.MaxEnergy then Player.Energy := Player.MaxEnergy;

  end;
  if (Command = CmdUzyj + CmdKomplet) and (Bag.Tracksuit <= -10) and (Gear.WornGarment = TxtEmpty) then begin
    WriteLn(TxtUseItems_28);
    Gear.Armor := Gear.Armor + 7;
    Gear.Wearing := 1;
    Gear.WornGarment := TxtWornSyf;
  end;
  if (Command = CmdOdlorz + CmdKomplet) and (Bag.Tracksuit <= -10) and (Gear.WornGarment = TxtWornSyf) then begin
    WriteLn(TxtUseItems_29);
    Gear.Wearing := 0;
    Gear.Armor := Gear.Armor - 7;
    Gear.WornGarment := TxtEmpty;
  end;
  if (Command = CmdUzyj + CmdListek) and (Bag.LuckyLeaf <= -10) then WriteLn(TxtUseItems_30);
  if (Command = CmdUzyj + TxtWornGarnitur) and (Bag.SpikedSuit <= -10) and (Gear.WornGarment = TxtEmpty) then begin
    WriteLn(TxtUseItems_31);
    Gear.Wearing := 1;
    Gear.WornCount := Gear.WornCount + 1;
    Gear.Armor := Gear.Armor + 10;
    Gear.LuckRoll := Gear.LuckRoll + 15;
    Gear.WornGarment := TxtWornGarnitur;
  end;
  if (Command = CmdUzyj + CmdPigulka) and (Bag.TeleportPill <= -10) then begin
    WriteLn(TxtUseItems_32);
    Bag.TeleportPill := Bag.TeleportPill + 10;
    SpawnMonsters;
    if Player.Wisdom < 10 then begin
      WriteLn(TxtUseItems_33);
      WriteLn(TxtUseItems_34);
      Player.MaxEnergy := Player.MaxEnergy - 1;
      Player.Energy := 1;
      Player.Experience := Player.Experience - 50;
    end;
    if (Player.Wisdom > 9) and (Player.Wisdom < 16) then begin
      WriteLn(TxtUseItems_35);
      WriteLn(TxtUseItems_36);
      Player.Energy := Player.Energy - 40;
      if Player.Energy < 1 then Player.Energy := 1;
      Player.Experience := Player.Experience - 30;
    end;
    if Player.Wisdom > 15 then WriteLn(TxtUseItems_37);
  end;
  if (Command = CmdOdlorz + TxtWornGarnitur) and (Bag.SpikedSuit <= -10) and (Gear.WornGarment = TxtWornGarnitur) then begin
    WriteLn(TxtUseItems_38);
    Gear.Wearing := 0;
    Gear.WornCount := Gear.WornCount - 1;
    Gear.Armor := Gear.Armor - 10;
    Gear.LuckRoll := Gear.LuckRoll - 15;
    Gear.WornGarment := TxtEmpty;
  end;
end;

procedure DisplayPrefs;
begin
  if Command = CmdZmien + CmdKolor then begin
    WriteLn(TxtDisplayPrefs_01);
    ReadLn(Combat.Roll);
    TextColor(Combat.Roll);
  end;
  if Command = CmdZmien + CmdTlo then begin
    WriteLn(TxtDisplayPrefs_02);
    ReadLn(Combat.Roll);
    TextBackground(Combat.Roll);
  end;
end;
type
  TBeastKill = record
    cmd: string;
    beast: ^Integer;
    fight: TFight;
    unlessFled: Boolean;
  end;

const
  { The arena beasts: the kill command in the beast's room starts the
    tier's fight; unlessFled leaves a beast that fled standing. The
    blocks with extra side effects stay hand-written in ArenaMaze. }
  BeastKills: array[1..23] of TBeastKill = (
    (cmd: CmdZabij + CmdSlimak; beast: @World.Snail; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdKornik; beast: @World.Woodworm; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdMucha; beast: @World.Fly; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdZuk; beast: @World.Beetle; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdKaraluch; beast: @World.Cockroach; fight: FightWeak; unlessFled: False),
    (cmd: CmdZabij + CmdMrowka; beast: @World.Ant; fight: FightWeak; unlessFled: False),
    (cmd: CmdZabij + CmdPajak; beast: @World.Spider; fight: FightWeak; unlessFled: False),
    (cmd: CmdZabij + CmdDzik; beast: @World.Boar; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdSzczur; beast: @World.Rat; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdLis; beast: @World.Fox; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdKuropatwa; beast: @World.Partridge; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdZajac; beast: @World.Hare; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdOrzel; beast: @World.Eagle; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdSarna; beast: @World.Deer; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdSlon; beast: @World.Elephant; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdLew; beast: @World.Lion; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdZyrafa; beast: @World.Giraffe; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdWilk; beast: @World.Wolf; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdWielblad; beast: @World.Camel; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdStrus; beast: @World.Ostrich; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdBoa; beast: @World.Boa; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdBizon; beast: @World.Bison; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdPantera; beast: @World.Panther; fight: FightMedium; unlessFled: False)
  );

procedure ArenaMaze;
var
  bi: Integer;
begin
  if (Session.Room = RoomArena33) or (Session.Room = RoomArena34) or (Session.Room = RoomArena35) or (Session.Room = RoomArena36) or (Session.Room = RoomArena37) or
     (Session.Room = RoomArena38) or (Session.Room = RoomArena39) or (Session.Room = RoomArena40) or (Session.Room = RoomArena41) or (Session.Room = RoomArena42) or
     (Session.Room = RoomArena43) or (Session.Room = RoomArena44) or (Session.Room = RoomArena45) or (Session.Room = RoomArena46) or (Session.Room = RoomArena47) or
     (Session.Room = RoomArena48) or (Session.Room = RoomArena49) or (Session.Room = RoomArena50) or (Session.Room = RoomArena51) or (Session.Room = RoomArena52) or
     (Session.Room = RoomArena53) or (Session.Room = RoomArena54) or (Session.Room = RoomArena55) or (Session.Room = RoomArena56) or (Session.Room = RoomArena57) then
  begin
    Session.InArena := 1;
    WriteLn(TxtArenaMaze_01);
    DescribeBeasts;
    repeat
      write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if (Command = CmdZabij + CmdBakteria) and (Session.Room = World.Bacterium) then
      begin FightWeak;
        World.Bacterium := 0;
        WriteLn(TxtArenaMaze_02);
      end;
      for bi := Low(BeastKills) to High(BeastKills) do
        with BeastKills[bi] do
          if unlessFled then
            KillBeastUnlessFled(cmd, beast^, fight)
          else
            KillBeast(cmd, beast^, fight);
      if (Command = CmdZabij + CmdWilczur) and (Session.Room = World.Mongrel) then
      begin WriteLn(TxtArenaMaze_03);
        FightWeakish;
        World.Mongrel := 0;
      end;

      if (Command = CmdZabij + CmdGladiator) and (Session.Room = World.Gladiator) then
      begin FightHard;
        World.Gladiator := 0;
        PillGain;
      end;
      if (Command = CmdZabij + CmdWojownik) and (Session.Room = World.Warrior) then
      begin FightHard;
        World.Warrior := 0;
        PillGain;
      end;
      if (Command = CmdZabij + CmdTrener) and (Session.Room = World.Tamer) then
      begin FightHard;
        World.Tamer := 0;
        SuitGain;
      end;
      if Command = CmdExit then begin
        if Session.Room = RoomArena33 then
            WriteExits([TxtShared_03,
                        TxtExitPolodnie, TxtPlaceWejscieNaArene,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
        if (Session.Room = RoomArena34) or (Session.Room = RoomArena37) or (Session.Room = RoomArena38) or (Session.Room = RoomArena39) or
                (Session.Room = RoomArena42) or (Session.Room = RoomArena43) or (Session.Room = RoomArena44) or (Session.Room = RoomArena48) or
                (Session.Room = RoomArena49) then begin
          WriteExits([TxtShared_03,
                      TxtExitPolodnie, TxtPlaceArena,
                      TxtExitPolnoc, TxtPlaceArena,
                      TxtExitWschod, TxtPlaceArena,
                      TxtExitZachod, TxtPlaceArena]);
        end;
        if (Session.Room = RoomArena35) or (Session.Room = RoomArena36) then
            WriteExits([TxtShared_03,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
        if Session.Room = RoomArena40 then
            WriteExits([TxtShared_03,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
        if Session.Room = RoomArena41 then
            WriteExits([TxtShared_03,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena]);
        if (Session.Room = RoomArena45) or (Session.Room = RoomArena50) or (Session.Room = RoomArena54) then
            WriteExits([TxtArenaMaze_08,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
        if (Session.Room = RoomArena46) or (Session.Room = RoomArena51) or (Session.Room = RoomArena55) then
            WriteExits([TxtArenaMaze_08,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena]);
        if (Session.Room = RoomArena47) or (Session.Room = RoomArena52) or (Session.Room = RoomArena53) then
            WriteExits([TxtArenaMaze_09,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
        if Session.Room = RoomArena56 then
            WriteExits([TxtArenaMaze_10,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
        if Session.Room = RoomArena57 then
            WriteExits([TxtArenaMaze_10,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena]);
      end;
      if Command = CmdWyjscie then exit;
      if Command = CmdPolodnie then begin
        Session.InArena := 0;
        case Session.Room of
          33: Session.Room := RoomArenaEntrance;
          34: Session.Room := RoomArena33;
          35, 36, 40, 41: Session.InArena := 1;
          37: Session.Room := RoomArena34;
          38: Session.Room := RoomArena35;
          39: Session.Room := RoomArena36;
          42: Session.Room := RoomArena37;
          43: Session.Room := RoomArena38;
          44: Session.Room := RoomArena39;
          45: Session.Room := RoomArena40;
          46: Session.Room := RoomArena41;
          47: Session.Room := RoomArena42;
          48: Session.Room := RoomArena43;
          49: Session.Room := RoomArena44;
          50: Session.Room := RoomArena45;
          51: Session.Room := RoomArena46;
          52: Session.Room := RoomArena48;
          53: Session.Room := RoomArena49;
          54: Session.Room := RoomArena50;
          55: Session.Room := RoomArena51;
          56: Session.Room := RoomArena54;
          57: Session.Room := RoomArena55;
        end;
      end;
      if Command = CmdPolnoc then begin
        Session.InArena := 0;
        case Session.Room of
          33: Session.Room := RoomArena34;
          34: Session.Room := RoomArena37;
          35: Session.Room := RoomArena38;
          36: Session.Room := RoomArena39;
          37: Session.Room := RoomArena42;
          38: Session.Room := RoomArena43;
          39: Session.Room := RoomArena44;
          40: Session.Room := RoomArena45;
          41: Session.Room := RoomArena46;
          42: Session.Room := RoomArena47;
          43: Session.Room := RoomArena48;
          44: Session.Room := RoomArena49;
          45: Session.Room := RoomArena50;
          46: Session.Room := RoomArena51;
          47: Session.InArena := 1;
          48: Session.Room := RoomArena52;
          49: Session.Room := RoomArena53;
          50: Session.Room := RoomArena54;
          51: Session.Room := RoomArena55;
          52: Session.InArena := 1;
          53: Session.InArena := 1;
          54: Session.Room := RoomArena56;
          55: Session.Room := RoomArena57;
          56: Session.InArena := 1;
          57: Session.InArena := 1;
        end;
        Session.MoveGuard := 1;
      end;
      if Command = CmdWschod then begin
        Session.InArena := 0;
        case Session.Room of
          33: Session.Room := RoomArena35;
          34: Session.Room := RoomArena38;
          35: Session.Room := RoomArena40;
          36: Session.Room := RoomArena33;
          37: Session.Room := RoomArena43;
          38: Session.Room := RoomArena45;
          39: Session.Room := RoomArena34;
          40: Session.InArena := 1;
          41: Session.Room := RoomArena36;
          42: Session.Room := RoomArena48;
          43: Session.Room := RoomArena50;
          44: Session.Room := RoomArena37;
          45: Session.InArena := 1;
          46: Session.Room := RoomArena39;
          47: Session.Room := RoomArena52;
          48: Session.Room := RoomArena54;
          49: Session.Room := RoomArena42;
          50: Session.InArena := 1;
          51: Session.Room := RoomArena44;
          52: Session.Room := RoomArena56;
          53: Session.Room := RoomArena47;
          54: Session.InArena := 1;
          55: Session.Room := RoomArena49;
          56: Session.InArena := 1;
          57: Session.Room := RoomArena53;
        end;
        Session.MoveGuard := 1;
      end;
      if Command = CmdZachod then begin
        Session.InArena := 0;
        case Session.Room of
          33: Session.Room := RoomArena36;
          34: Session.Room := RoomArena39;
          35: Session.Room := RoomArena33;
          36: Session.Room := RoomArena41;
          37: Session.Room := RoomArena44;
          38: Session.Room := RoomArena34;
          39: Session.Room := RoomArena46;
          40: Session.Room := RoomArena35;
          41: Session.InArena := 1;
          42: Session.Room := RoomArena49;
          43: Session.Room := RoomArena37;
          44: Session.Room := RoomArena51;
          45: Session.Room := RoomArena38;
          46: Session.InArena := 1;
          47: Session.Room := RoomArena53;
          48: Session.Room := RoomArena42;
          49: Session.Room := RoomArena55;
          50: Session.Room := RoomArena43;
          51: Session.InArena := 1;
          52: Session.Room := RoomArena47;
          53: Session.Room := RoomArena57;
          54: Session.Room := RoomArena48;
          55: Session.InArena := 1;
          56: Session.Room := RoomArena52;
          57: Session.InArena := 1;
        end;
        Session.MoveGuard := 1;
      end;
      Session.MoveGuard := 0;
      until (Session.InArena = 0) or (Session.Room = TranceRoom);
  end;
end;
procedure StageFights;
begin
  if (Command = CmdZabij + CmdPerkusista) and (World.Drummer = Session.Room) then begin
    FightVeryEasy;
    World.Drummer := 0;
    CassetteGain;
  end;
  if (Command = CmdZabij + CmdGitarzysta) and (World.Guitarist = Session.Room) then begin
    FightVeryEasy;
    World.Guitarist := 0;
    CassetteGain;
  end;
  if (Command = CmdZabij + CmdLiroy) and (World.Liroy = Session.Room) then begin
    FightNotEasy;
    if (Session.Room <> DeadRoom) and (Player.Energy > 0) and (Combat.Fled = 0) then begin
      WriteLn(TxtStageFights_01);
      Player.Money := Player.Money + 30;
      CassetteGain;
      if World.Quest > 1 then World.QuestKills := World.QuestKills - 150;
      World.Liroy := 0;
    end;
  end;
  if (Command = CmdZabij + CmdOrganista) and (World.Keyboardist = Session.Room) then begin
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
  if (Command = CmdZabij + CmdDuncan) and (World.Duncan = Session.Room) then begin
    FightEasy;
    if Combat.EnemyEnergy < 1 then World.Duncan := 0;
  end;
  if (Command = CmdSecret + CmdLista) and (World.Duncan = Session.Room) then begin
    WriteLines(TxtPlantFightsLines1);
  end;
  if Command = CmdKup + CmdDokument then begin if Player.Money > 399 then begin
      WriteLn(TxtPlantFights_05);
      Bag.Permit := Bag.Permit - 10;
      Player.Money := Player.Money - 400;
      Bag.Count := Bag.Count + 1; end;
  end;
  if (Command = CmdKup + CmdPlecak) and (World.Duncan = Session.Room) then begin if Player.Money > 4799 then begin
      WriteLn(TxtPlantFights_06);
      Player.Money := Player.Money - 4800;
      Bag.Backpack := Bag.Backpack - 10;
      Bag.Count := Bag.Count + 1; end;
  end;
  if (Command = CmdRozmawiaj + CmdDuncan) and (World.Duncan = Session.Room) then begin
    if World.DuncanQuest = 0 then begin
      WriteLines(TxtPlantFightsLines2);
      World.DuncanQuest := 75;
    end;
    if World.DuncanQuest <> 0 then
      WriteLn(TxtPlantFights_13);

    if World.DuncanQuest = -125 then begin
      WriteLn(TxtPlantFights_14);
      WriteLn(TxtPlantFights_15);
      World.DuncanQuest := 0;
      Player.Experience := Player.Experience + 125;
      WriteLn(TxtPlantFights_16);

    end;
  end;

  KillPlant(CmdZabij + CmdSzczaw, World.Sorrel);
  KillPlant(CmdZabij + CmdKoniczynka, World.Clover);
  KillPlant(CmdZabij + CmdMlecz, World.SowThistle);
  KillPlant(CmdZabij + CmdDmuchawiec, World.Dandelion);

  KillPlantIfAlive(CmdZabij + CmdStokrotka, World.Daisy);

  KillPlantEasyIfAlive(CmdZabij + CmdRoza, World.Rose);
  KillPlantEasyIfAlive(CmdZabij + CmdOset, World.Thistle);
  KillPlantEasyIfAlive(CmdZabij + CmdMalina, World.Raspberry);
  KillPlantEasyIfAlive(CmdZabij + CmdAgrest, World.Gooseberry);
  KillPlantEasyIfAlive(CmdZabij + CmdJezyna, World.Blackberry);

  if (Command = CmdZabij + CmdTrawa) and (World.Grass = Session.Room) then begin
    WriteLn(TxtPlantFights_17);
    FightHard;
    if Player.Energy > 0 then FightHard;
    if Player.Energy > 0 then FightHard;
    if Player.Energy > 0 then FightHard;
    if (Player.Energy > 0) and (Combat.Fled = 0) then
      WriteLn(TxtPlantFights_18);
  end;
end;
procedure ExpandAbbrev;

const
  AbbrevCount = 8;
  AbbrevFrom: array[1..AbbrevCount] of string = (CmdPn,CmdPd,CmdW,CmdZ,CmdG,CmdD,CmdE,CmdM);
  AbbrevTo:   array[1..AbbrevCount] of string = (CmdPolnoc,CmdPolodnie,CmdWschod,CmdZachod,CmdGora,CmdDol,CmdExit,CmdMode);
var i: Integer;
begin
  for i := 1 to AbbrevCount do
    if Command = AbbrevFrom[i] then begin
      Command := AbbrevTo[i];
      Exit;
    end;
end;

const

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
    (name:CmdCzlowiek; baseStrength:10; baseDexterity:10; baseWisdom:10;
     baseMaxStrength:15; baseMaxDexterity:15; baseMaxWisdom:15;
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdOlbrzym; baseStrength:13; baseDexterity:13; baseWisdom:5;
     baseMaxStrength:20; baseMaxDexterity:20; baseMaxWisdom:7;
     MaxManaBonus:-30; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdNimfa; baseStrength:10; baseDexterity:13; baseWisdom:7;
     baseMaxStrength:15; baseMaxDexterity:20; baseMaxWisdom:11;
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdPolElf; baseStrength:6; baseDexterity:16; baseWisdom:8;
     baseMaxStrength:10; baseMaxDexterity:24; baseMaxWisdom:12;
     MaxManaBonus:-20; MoneyBonus:30; MaxEnergyBonus:-5; EnergyBonus:-5),
    (name:CmdUfok; baseStrength:9; baseDexterity:9; baseWisdom:13;
     baseMaxStrength:13; baseMaxDexterity:14; baseMaxWisdom:20;
     MaxManaBonus:50; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdCzaromil; baseStrength:6; baseDexterity:7; baseWisdom:16;
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
    TxtLvlName4, TxtLvlName5, TxtLvlName6, TxtLvlName7, TxtLvlName8,
    TxtLvlName9, TxtLvlName10, TxtLvlName11, TxtLvlName12, TxtLvlName13);
begin
  if (lvl >= 4) and (lvl <= 13) then LevelName := LevelNames[lvl]
  else LevelName := TxtEmpty;
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
  WriteLn(TxtShowCharacter_01);
  ShowItem(Bag.OldSword, CmdStaryZardzewialyMiecz, 0);
  ShowItem(Bag.SmallShield, CmdOkraglaMalaTarcza, 0);
  ShowItem(Bag.Heart, CmdZakrwawioneSerce, 0);
  ShowItem(Bag.Diploma, CmdDyplomMudSzkoly, 0);
  ShowItem(Bag.Doughnut, CmdSmacznyPolanyLikieremPaczek, 10);
  ShowItem(Bag.Cookie, CmdSmaczneCiastko, 10);
  ShowItem(Bag.DryRation, CmdTwardaSuchaRacje, 10);
  ShowItem(Bag.BreadRoll, CmdOkraglaPachnacaBulka, 10);
  ShowItem(Bag.Bread, CmdDuzyCieplyChleb, 10);
  ShowItem(Bag.Sausage, CmdDlugaISmacznaWeke, 10);
  ShowItem(Bag.Bigos, CmdPysznyBigosZKapustaZWroga, 10);
  ShowItemDiv10(Bag.Beer, CmdOzewiajacePiwskoZKonkretnymKlimatem);
  ShowItemPlain(Bag.Pipe, CmdCiezkaFajkaOdDziadaMroza);
  ShowItemPlain(Bag.Tracksuit, CmdKompletUbranFirmySyf);
  ShowItemPlain(Bag.SpikedSuit, CmdGarniturZKolcami);
  ShowItemPlain(Bag.ManaBottle, CmdMalaButelkeMany);
  ShowItemPlain(Bag.LuckyLeaf, CmdDelikatnyChocSzorstkiListek);
  ShowItemPlain(Bag.Cassette, CmdKasetaLiroyaLJakLiroy);
  ShowItemPlain(Bag.TeleportPill, CmdPigulkaTransportujacaMG);
  ShowItemPlain(Bag.Permit, CmdPrzepustkaWlasnoreczniePodpisanaPrzezQuestMastera);
  ShowItemPlain(Bag.CompareScroll, CmdScrollZCzaremPorownywanie);
  ShowItemPlain(Bag.ReturnScroll, CmdScrollZCzaremPowrot);
  WriteLn(TxtShowCharacter_02, Bag.Count, TxtShowCharacter_03, Bag.Limit, TxtShowCharacter_04);
  if Gear.WeaponKind = 0 then WriteLn(TxtShowCharacter_05);
  if Gear.ShieldKind = 0 then WriteLn(TxtShowCharacter_06);
  if Gear.WornGarment = TxtEmpty then WriteLn(TxtShowCharacter_07);
  if Gear.WornGarment = TxtWornSyf then WriteLn(TxtWearingLabel, TxtShowCharacter_08);
  if Gear.WornGarment = TxtWornGarnitur then WriteLn(TxtWearingLabel, TxtShowCharacter_09);
  if (Gear.ShieldKind = 1) and (Bag.SmallShield = -100) then
    WriteLn(TxtShowCharacter_10);
  if (Gear.WeaponKind = 1) and (Bag.OldSword = -100) then
    WriteLn(TxtShowCharacter_11);
  WriteLn(TxtShowCharacter_12, Player.Money, TxtShowCharacter_13, Player.Practice, TxtShared_19);

  gap := LevelThreshold(Player.Level) - Player.Experience;
  case Player.Level of
    1: WriteLn(TxtShowCharacter_18, TxtLevelFirst, TxtShowCharacter_19, gap, TxtShared_22);
    2: WriteLn(TxtShowCharacter_18, TxtLevelSecond, TxtShowCharacter_19, gap, TxtShared_22);
    3: WriteLn(TxtShowCharacter_18, TxtLevelThird, TxtShowCharacter_19, gap, TxtShowCharacter_17);
    4..13: WriteLn(TxtShowCharacter_18, LevelName(Player.Level), TxtShowCharacter_19, gap, TxtShared_22);
  end;
  if Player.Level > 13 then
    WriteLn(TxtShowCharacter_18, TxtLevelVeryHigh, TxtShowCharacter_19, TxtLevelTylko, gap, TxtShared_22);

  WriteLn(TxtShowCharacter_21, Player.Strength, TxtShowCharacter_03, Player.MaxStrength,
         TxtShowCharacter_22, Player.Dexterity, TxtShowCharacter_03, Player.MaxDexterity,
         TxtShowCharacter_23, Player.Wisdom, TxtShowCharacter_03, Player.MaxWisdom);
  Gear.ArmorRating := 10 * Gear.WornCount + Gear.Armor;
  WriteLn(TxtShowCharacter_24, Gear.ArmorRating,
         TxtShowCharacter_25, Gear.LuckRoll);
  WriteLn(TxtShowCharacter_12, Player.Mana, TxtShowCharacter_03, Player.MaxMana, TxtShowCharacter_26);
  WriteLn(TxtShowCharacter_12, Player.Energy, TxtShowCharacter_03, Player.MaxEnergy, TxtShared_20);
  if World.Quest = 1 then WriteLn(TxtShowCharacter_27, World.QuestKills, TxtShowCharacter_28);
  if World.Quest > 1 then WriteLn(TxtShowCharacter_27, World.QuestKills - 150, TxtShowCharacter_28);
  if World.DuncanQuest <> 0 then WriteLn(TxtShowCharacter_29);
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
    WriteLn(TxtChooseRace_01);
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
  WriteLn(TxtChooseRace_02);
  ReadLn(Command);
  Player.Energy := 50;
  Player.Practice := 10;
  World.CageWeakling := RoomCageWeakling;

  World.CageStrong := RoomCageStrong;
  World.CageAgile := RoomCageAgile;
  World.CageTough := RoomCageTough;
  World.CageHuge := RoomCageHuge;

  Player.Level := 1;
  Player.MaxMana := Player.MaxMana + 100;
  Player.Mana := Player.MaxMana;
  SpawnMonsters;
  WriteLines(TxtChooseRaceLines1);
end;

procedure KillDog(cmd: string; var Dog: Integer; extraMsg: Boolean);

begin
  if (Command = cmd) and (Dog = Session.Room) then begin
    FightDog;
    Dog := 0;
    if extraMsg then begin
      WriteLines(TxtKillDogLines1);
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
  if (Command = CmdZabij + CmdZamiatacz) and (World.Sweeper = Session.Room) then begin
    FightVeryEasy;
    World.Sweeper := 0;
    Combat.Roll := Random(100);
    if (Combat.Roll < 35) and (Bag.Tracksuit = 0) then begin
      WriteLn(TxtKillSweeper_01);
      Bag.Tracksuit := Bag.Tracksuit - 10;
    end;
  end;
end;

procedure KillSickMan;

begin
  if (Command = CmdZabij + CmdZebrak) and (World.SickMan = Session.Room) then begin
    FightVeryEasy;
    if Player.Energy > 0 then begin
      Combat.Roll := Random(10);
      WriteLn(TxtKillSickMan_01,
              Combat.Roll, TxtShared_23);
      Player.Money := Player.Money + Combat.Roll;
      World.SickMan := 0;
    end;
  end;
end;

type
  TStreetKill = record
    cmd: string;
    target: ^Integer;
    extra: Boolean;
  end;

const
  { The street dogs: extraMsg adds the owner's complaint on a kill. }
  StreetDogs: array[1..5] of TStreetKill = (
    (cmd: CmdZabij + CmdOwczarek; target: @World.Shepherd; extra: False),
    (cmd: CmdZabij + CmdPiesek; target: @World.Pooch; extra: False),
    (cmd: CmdZabij + CmdJamnik; target: @World.Dachshund; extra: False),
    (cmd: CmdZabij + CmdSpaniel; target: @World.Spaniel; extra: True),
    (cmd: CmdZabij + CmdPudel; target: @World.Poodle; extra: False)
  );
  { The street townsfolk: suitLoot grants the spiked suit pieces. }
  StreetFolk: array[1..3] of TStreetKill = (
    (cmd: CmdZabij + CmdTaksowkarz; target: @World.Cabman; extra: True),
    (cmd: CmdZabij + CmdSprzedawca; target: @World.Vendor; extra: True),
    (cmd: CmdZabij + CmdPijak; target: @World.Drunkard; extra: False)
  );

procedure StreetFights;
var
  ki: Integer;
begin

  for ki := Low(StreetDogs) to High(StreetDogs) do
    with StreetDogs[ki] do
      KillDog(cmd, target^, extra);

  for ki := Low(StreetFolk) to High(StreetFolk) do
    with StreetFolk[ki] do
      KillTownsfolk(cmd, target^, extra);
  KillSweeper;
  KillSickMan;
end;

procedure Training;

begin
  if Command = CmdPatrz + CmdPlakat then begin
    WriteLn(TxtShared_13);
    WriteLn(TxtTraining_01);
    if Player.Wisdom < 11 then WriteLn(TxtTraining_02);
    if (Player.Wisdom > 10) and (Player.Strength > 11) then WriteLn(TxtTraining_03);
    if (Player.Wisdom > 10) and (Player.Dexterity > 10) then WriteLn(TxtTraining_04);
    if (Player.Wisdom > 15) and (Player.Dexterity > 11) then WriteLn(TxtTraining_05);
    if Player.Wisdom > 11 then WriteLn(TxtTraining_06);
    if Player.Wisdom > 18 then WriteLn(TxtTraining_07);
    if Player.Wisdom > 17 then WriteLn(TxtTraining_08);
    if Player.Dexterity > 20 then WriteLn(TxtTraining_09);
    if (Player.Strength > 20) and (Player.Dexterity > 10) then WriteLn(TxtTraining_10);
    if (Player.Wisdom > 19) and (Player.Dexterity > 10) and (Player.Strength > 10) then
      WriteLn(TxtTraining_11);
    if (Player.Strength > 25) and (Player.Wisdom > 12) then WriteLn(TxtTraining_12);
    if (Player.Strength > 29) and (Player.Wisdom > 14) then WriteLn(TxtTraining_13);
    if Player.Dexterity > 22 then WriteLn(TxtTraining_14);
    if Player.Dexterity > 28 then WriteLn(TxtTraining_15);
    if Player.Wisdom > 22 then WriteLn(TxtTraining_16);
    if Player.Wisdom > 23 then WriteLn(TxtTraining_17);
    if (Player.Dexterity > 24) and (Player.Wisdom > 14) and (Player.Strength > 14) then
      WriteLn(TxtTraining_18);
    if Player.Wisdom > 24 then WriteLn(TxtTraining_19);
    if Player.Wisdom > 26 then WriteLn(TxtTraining_20);
    if (Player.Strength > 12) and (Player.Wisdom > 19) and (Player.Dexterity > 12) then
      WriteLn(TxtTraining_21);
    if (Player.Dexterity > 22) and (Player.Wisdom > 16) then WriteLn(TxtTraining_22);
    if Player.Dexterity > 30 then WriteLn(TxtTraining_23);
    if Player.Wisdom > 29 then WriteLn(TxtTraining_24);
    if Player.Wisdom > 19 then WriteLn(TxtTraining_25);
    if (Player.Wisdom > 23) and (Player.Dexterity > 12) then WriteLn(TxtTraining_26);
    WriteLn(TxtTraining_27);
  end;

  if Command = CmdCwicz + CmdKopac then
    if (Player.Wisdom > 10) and (Player.Strength > 11) and (Player.Practice > 0) then begin
      Skills.Kick := Skills.Kick + Player.Wisdom;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingDigging, TxtTrainingThreshold, Skills.Kick,
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + CmdUciekac then begin
    if Player.Wisdom > 10 then
      if Player.Dexterity > 10 then
        if (Player.Practice > 0) and (Skills.Fleeing < 85) then begin
          Skills.Fleeing := Skills.Fleeing + Player.Wisdom + Player.Dexterity - 5;
          Player.Practice := Player.Practice - 1;
          WriteLn(TxtTrainingVerb, TxtTrainingFleeing, TxtTrainingThreshold, Skills.Fleeing,
                  TxtTraining_29, Player.Practice, TxtShared_19);
        end else
          WriteLn(TxtTraining_31);
  end;

  if Command = CmdCwicz + CmdPowrot then
    if (Player.Wisdom > 17) and (Skills.Returning < 90) and (Player.Practice > 0) then begin
      Skills.Returning := Skills.Returning + 2 * Player.Wisdom - 3;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingReturning, TxtTrainingThreshold, Skills.Returning,
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + TxtTrainingParrying then
    if (Player.Wisdom > 15) and (Player.Dexterity > 11) and (Skills.Parry < 90) and (Player.Practice > 0) then begin
      Skills.Parry := Skills.Parry + Player.Wisdom + Player.Dexterity - 14;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingParrying, TxtTrainingThreshold, Skills.Parry,
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + CmdPorownanie then
    if (Player.Wisdom > 11) and (Skills.Comparing < 90) and (Player.Practice > 0) then begin
      Skills.Comparing := Skills.Comparing + 3 * Player.Wisdom - 9;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingComparing, TxtTrainingThreshold, Skills.Comparing,
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + TxtTrainingCooking then
    if (Player.Wisdom > 18) and (Skills.Cooking < 90) and (Player.Practice > 0) then begin
      Skills.Cooking := Skills.Cooking + Player.Wisdom + 1;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingCooking, TxtTrainingThreshold, Skills.Cooking,
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;
end;

procedure SaveSlot(value: Longint);
begin
  WriteLn(Session.SaveFile, value);
end;

procedure SaveSlotText(const value: string);
begin
  WriteLn(Session.SaveFile, value);
end;

procedure LoadSlot(var value: Integer);
begin
  Read(Session.SaveFile, value);
end;

procedure LoadSlotShort(var value: Shortint);
begin
  Read(Session.SaveFile, value);
end;

procedure LoadSlotLong(var value: Longint);
begin
  Read(Session.SaveFile, value);
end;

procedure LoadSlotText(var value: string);
begin
  Read(Session.SaveFile, value);
end;

procedure SaveCharacter;
begin
  Command := CmdJa;
  Session.SavedFlag := 1;
  WriteLn(TxtSaveCharacter_01);
  ClrScr;
  Assign(Session.SaveFile, TxtSaveFileName);
  Rewrite(Session.SaveFile);
  SaveSlot(Player.Mana * 4);
  SaveSlot(Player.Level + $17);
  SaveSlot(Bag.OldSword);
  SaveSlot(Bag.Pipe);
  SaveSlot(Bag.Diploma);
  SaveSlot(Bag.SmallShield);
  SaveSlot(Bag.SpikedSuit);
  SaveSlot(Player.Experience);
  SaveSlot((Player.Energy + $28) * 4);
  SaveSlot(Session.OuterRoom);
  SaveSlot(Player.Dexterity + 12);
  SaveSlot(Player.Strength - 24);
  SaveSlot(Player.Wisdom);
  SaveSlot(Player.Practice);
  SaveSlot(Session.CheckpointStage);
  SaveSlot(0);
  SaveSlot(0);
  SaveSlot(Player.Money * Player.Wisdom);
  SaveSlot(Combat.Loot);
  SaveSlot(Player.MaxEnergy);
  SaveSlot(Bag.Limit);
  SaveSlot(Skills.Comparing);
  SaveSlot(Player.MaxMana);
  SaveSlot(Player.MaxStrength);
  SaveSlot(Player.MaxDexterity);
  SaveSlot(Player.MaxWisdom);
  SaveSlot(Bag.Count);
  SaveSlot(Gear.Armor);
  SaveSlot(Gear.LuckRoll);
  SaveSlot(Gear.WeaponKind);
  SaveSlot(Gear.Wearing);
  SaveSlot(Session.Overall);
  SaveSlot(Session.SavedFlag);
  SaveSlot(World.CageWeakling);
  SaveSlot(World.CageStrong);
  SaveSlot(World.CageAgile);
  SaveSlot(World.CageTough);
  SaveSlot(World.CageHuge);
  SaveSlot(Gear.ShieldKind);
  SaveSlot(Gear.ArmorRating);
  SaveSlot(Skills.Cooking);
  SaveSlot(Skills.CookingDisplayBug);
  SaveSlot(0);
  SaveSlot(Bag.Heart);
  SaveSlot(Bag.ManaBottle);
  SaveSlot(Bag.Cookie);
  SaveSlot(Bag.DryRation);
  SaveSlot(Bag.Bread);
  SaveSlot(Bag.BreadRoll);
  SaveSlot(Bag.Sausage);
  SaveSlot(Bag.Bread);
  SaveSlot(Bag.BreadRoll);
  SaveSlot(Gear.WornCount);
  SaveSlot(Skills.Parry);
  SaveSlot(Skills.Kick);
  SaveSlot(Skills.KickMinMana);
  SaveSlot(Skills.KickMaxEnergy);
  SaveSlot(Skills.Fleeing);
  SaveSlot(Skills.FleeEnergy);
  SaveSlot(Combat.Fled);
  SaveSlot(Session.InArena);
  SaveSlot(Bag.Tracksuit);
  SaveSlot(Bag.Cassette);
  SaveSlot(Bag.TeleportPill);
  SaveSlot(World.Woodworm);
  SaveSlot(World.Fly);
  SaveSlot(World.Bacterium);
  SaveSlot(World.Quest);
  SaveSlot(World.QuestKills);
  SaveSlot(World.Snail);
  SaveSlot(Bag.LuckyLeaf);
  SaveSlot(Skills.Returning);
  SaveSlot(Bag.Bigos);
  SaveSlot(Bag.Beer);
  SaveSlot(Bag.CompareScroll);
  SaveSlot(Bag.ReturnScroll);
  SaveSlot(World.OldElf);
  SaveSlot(World.DuncanQuest);
  SaveSlot(Bag.Backpack);
  SaveSlot(World.Duncan);
  SaveSlotText(Gear.WornGarment);
  Close(Session.SaveFile);
end;

procedure Death;

begin
  WriteLines(TxtDeathLines1);
  if World.Quest = 1 then World.QuestKills := 50;
  if World.Quest > 1 then World.QuestKills := 200;
  Player.Energy := Player.MaxEnergy;
  Player.Experience := Player.Experience - 250 + Random(50) - (5 * Player.Level);
  Session.Room := RoomCityCentre;
  SpawnMonsters;
  Command := CmdPamietaj;
  ReadLn;
  SaveCharacter;
end;

procedure BuyItem(cmd: string; var Item: Integer; price: Integer;
                  itemName: string; available: Boolean);

begin
  if (Command = cmd) and available and (Player.Money >= price) then begin
    Bag.Count := Bag.Count + 1;
    Item := Item - 10;
    Player.Money := Player.Money - price;
    WriteLn(TxtShopVerb, itemName, TxtSpaceZa, price, TxtSpaceMonet);
  end;
end;

procedure BakeryShop;

begin
  if Command = CmdLista then begin
    WriteLines(TxtBakeryShopLines1);
  end;
  StreetFights;
  BuyItem(CmdKup + CmdPaczek, Bag.Doughnut, 8, TxtItemPaczek, True);
  BuyItem(CmdKup + CmdCiastko, Bag.Cookie, 12, TxtItemCiastko, True);
  BuyItem(CmdKup + CmdSuchaRacja, Bag.DryRation, 15, TxtItemSuchaRacje, True);
  BuyItem(CmdKup + CmdBulka, Bag.BreadRoll, 19, TxtItemBulke, True);
  BuyItem(CmdKup + CmdChleb, Bag.Bread, 24, TxtItemChleb, True);
  BuyItem(CmdKup + CmdWeka, Bag.Sausage, 29, TxtItemWeke, True);
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
  WriteLn(TxtShopVerb, TxtBuyOldSword_01, TxtSpaceZa, 70, TxtSpaceMonet);
end;

function CanSellOldSword: Boolean;
begin
  CanSellOldSword := Bag.OldSword = -10;
end;

procedure SellOldSword;
begin
  WriteLn(TxtSellOldSword_01);
  WriteLn(TxtSellOldSword_02);
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
  WriteLn(TxtShopVerb, TxtBuySmallShield_01, TxtSpaceZa, 15, TxtSpaceMonet);
end;

procedure SellSmallShield;

begin
  WriteLn(TxtSellSmallShield_01);
  Player.Money := Player.Money + 8;
  Bag.SmallShield := 0;
  Bag.Count := Bag.Count - 1;
end;

const
  ArmouryRules: array[1..4] of TShopRule = (
    (cmd:CmdKup + CmdStary; allowed:CanBuyOldSword; act:BuyOldSword),
    (cmd:CmdSprzedaj + CmdStary; allowed:CanSellOldSword; act:SellOldSword),
    (cmd:CmdKup + CmdMala; allowed:CanBuySmallShield; act:BuySmallShield),
    (cmd:CmdSprzedaj + CmdMala; allowed:Always; act:SellSmallShield)
  );

function CanBuyPipe: Boolean;
begin
  CanBuyPipe := (Bag.Pipe = 0) and (Player.Money >= 480);
end;

procedure BuyPipe;
begin
  WriteLn(TxtShopVerb, TxtBuyPipe_01, TxtSpaceZa, 480, TxtSpaceMonet);
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
  WriteLn(TxtShopVerb, TxtBuyTracksuit_01, TxtSpaceZa, 35, TxtSpaceMonet);
  Player.Money := Player.Money - 35;
  Bag.Tracksuit := Bag.Tracksuit - 10;
  Bag.Count := Bag.Count + 1;
end;

function CanSellTracksuit: Boolean;
begin
  CanSellTracksuit := (Bag.Tracksuit <= -10) and (Gear.WornGarment <> TxtWornSyf);
end;

procedure SellTracksuit;
begin
  WriteLn(TxtSellVerb, TxtSellTracksuit_01);
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
  WriteLn(TxtSellVerb, TxtSellPipe_01);
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
  WriteLn(TxtShopVerb, TxtBuyCassette_01, TxtSpaceZa, 1999, TxtSpaceMonet);
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
  WriteLn(TxtBuySpikedSuit_01);
  Player.Money := Player.Money - 1000;
  Bag.SpikedSuit := Bag.SpikedSuit - 10;
  Bag.Count := Bag.Count + 1;
end;

function CanSellSpikedSuit: Boolean;
begin
  CanSellSpikedSuit := Gear.WornGarment <> TxtWornGarnitur;
end;

procedure SellSpikedSuit;
begin
  WriteLn(TxtSellVerb, TxtSellSpikedSuit_01);
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
  WriteLn(TxtSellVerb, TxtSellCassette_01);
  Player.Money := Player.Money + 1000;
  Bag.Cassette := Bag.Cassette + 10;
  Gear.Armor := Gear.Armor + 8;
  Player.MaxEnergy := Player.MaxEnergy - 5;
  Player.Dexterity := Player.Dexterity - 1;
  Bag.Count := Bag.Count - 1;
end;

const
  GeneralStoreRules: array[1..8] of TShopRule = (
    (cmd:CmdKup + CmdFajka; allowed:CanBuyPipe; act:BuyPipe),
    (cmd:CmdKup + CmdKomplet; allowed:CanBuyTracksuit; act:BuyTracksuit),
    (cmd:CmdSprzedaj + CmdKomplet; allowed:CanSellTracksuit; act:SellTracksuit),
    (cmd:CmdSprzedaj + CmdFajka; allowed:CanSellPipe; act:SellPipe),
    (cmd:CmdKup + CmdKaseta; allowed:CanBuyCassette; act:BuyCassette),
    (cmd:CmdKup + TxtWornGarnitur; allowed:CanBuySpikedSuit; act:BuySpikedSuit),
    (cmd:CmdSprzedaj + TxtWornGarnitur; allowed:CanSellSpikedSuit; act:SellSpikedSuit),
    (cmd:CmdSprzedaj + CmdKaseta; allowed:CanSellCassette; act:SellCassette)
  );

function CanBuyManaBottle: Boolean;
begin
  CanBuyManaBottle := Player.Money >= 15;
end;

procedure BuyManaBottle;
begin
  WriteLn(TxtBuyManaBottle_01);
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
  WriteLn(TxtBuyLuckyLeaf_01);
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
  WriteLn(TxtSellVerb, TxtSellLuckyLeaf_01);
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
  WriteLn(TxtShopVerb, TxtBuyTeleportPill_01, TxtSpaceZa, 235, TxtSpaceMonet);
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
  WriteLn(TxtSellTeleportPill_01);
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
  WriteLn(TxtBuyCompareScroll_01);
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
  WriteLn(TxtSellCompareScroll_01);
  Player.Money := Player.Money + 18;
  Bag.CompareScroll := Bag.CompareScroll + 10;
  Bag.Count := Bag.Count - 1;
end;

const
  MagicShopRules: array[1..7] of TShopRule = (
    (cmd:CmdKup + CmdMalaButelkaMany; allowed:CanBuyManaBottle; act:BuyManaBottle),
    (cmd:CmdKup + CmdListek; allowed:CanBuyLuckyLeaf; act:BuyLuckyLeaf),
    (cmd:CmdSprzedaj + CmdListek; allowed:CanSellLuckyLeaf; act:SellLuckyLeaf),
    (cmd:CmdKup + CmdPigulkaTransportujaca; allowed:CanBuyTeleportPill; act:BuyTeleportPill),
    (cmd:CmdSprzedaj + CmdPigulkaTransportujaca; allowed:CanSellTeleportPill; act:SellTeleportPill),
    (cmd:CmdKup + CmdScrollPorownywanie; allowed:CanBuyCompareScroll; act:BuyCompareScroll),
    (cmd:CmdSprzedaj + CmdScrollPorownywanie; allowed:CanSellCompareScroll; act:SellCompareScroll)
  );

procedure ArmouryShop;

begin
  if Command = CmdLista then begin
    WriteLn(TxtShared_24);
    if Bag.OldSword = 0 then
      WriteLn(TxtArmouryShop_01);
    if Bag.SmallShield = 0 then
      WriteLn(TxtArmouryShop_02);
    WriteLn(TxtArmouryShop_03);
  end;
  StreetFights;
  RunShopRules(ArmouryRules);
end;

procedure GeneralStoreShop;

begin
  if Command = CmdLista then begin
    WriteLn(TxtGeneralStoreShop_01);
    if Bag.Pipe = 0 then WriteLn(TxtGeneralStoreShop_02);
    if Bag.Tracksuit = 0 then
      WriteLines(TxtGeneralStoreShopLines1);
  end;
  if Command = CmdPatrz + CmdPoster then
    WriteLn(TxtGeneralStoreShop_06);
  RunShopRules(GeneralStoreRules);
end;

procedure MagicShop;

begin
  if Command = CmdLista then begin
    WriteLines(TxtMagicShopLines1);
  end;
  RunShopRules(MagicShopRules);
end;

procedure ConcertFights;

begin
  if (Command = CmdZabij + CmdDziecko) and (World.Kid = Session.Room) then begin
    FightWeakish;
    if Combat.EnemyEnergy < 1 then World.Kid := 0;
  end;
  if (Command = CmdZabij + CmdDziadek) and (World.OldMan = Session.Room) then begin
    FightWeakish;
    if Combat.EnemyEnergy < 1 then begin
      World.OldMan := 0;
      Combat.Roll := Random(100);
      if (Combat.Roll < 5) and (Bag.Pipe = 0) then begin
        WriteLn(TxtShared_08, TxtConcertFights_01);
        WriteLn(TxtConcertFights_02);
        Bag.Pipe := Bag.Pipe - 10;
        Player.Wisdom := Player.Wisdom + 1;
      end;
    end;
  end;
  if (Command = CmdZabij + CmdWariat) and (World.Lunatic = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Lunatic := 0;
  end;
  if (Command = CmdZabij + CmdSluchacz) and (World.Listener = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Listener := 0;
  end;
  if (Command = CmdZabij + CmdCzlowiek) and (World.Man = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Man := 0;
  end;
  if (Command = CmdZabij + CmdFan) and (World.Fan = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Fan := 0;
  end;
  if (Command = CmdZabij + CmdReporter) and (World.Reporter = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Reporter := 0;
  end;
  if (Command = CmdZabij + CmdPolicjant) and (World.Policeman = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Policeman := 0;
  end;
  if (Command = CmdZabij + CmdGoryl) and (World.Gorilla = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Gorilla := 0;
    SuitGain;
  end;
  if (Command = CmdZabij + CmdOchroniarz) and
     (World.Bouncer = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Bouncer := 0;
    SuitGain;
  end;
end;

procedure Checkpoints;

begin
  if (Player.Experience >= 400) and (Session.CheckpointStage = 0) and (Player.Strength < 20) then begin
    WriteLn(TxtCheckpoints_01);
    Session.CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Player.Experience >= 180) and (Session.CheckpointStage = 0) and (Player.Strength < 8) then begin
    WriteLn(TxtCheckpoints_01);
    Session.CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Player.Experience >= 360) and (Session.CheckpointStage = 1) and (Player.Strength < 8) then begin
    WriteLn(TxtCheckpoints_01);
    Session.CheckpointStage := 2;
    SpawnMonsters;
  end;
  if (Player.Experience >= 540) and (Session.CheckpointStage = 2) and (Player.Strength < 8) then begin
    WriteLn(TxtCheckpoints_01);
    Session.CheckpointStage := 3;
    SpawnMonsters;
  end;
  if (Player.Experience >= 300) and (Session.CheckpointStage = 0) and (Player.Strength > 7) and (Player.Strength < 13) then begin
    WriteLn(TxtCheckpoints_01);
    Session.CheckpointStage := 1;
    SpawnMonsters;
  end;
  if (Player.Experience >= 500) and (Session.CheckpointStage = 1) and (Player.Strength > 7) and (Player.Strength < 13) then begin
    WriteLn(TxtCheckpoints_01);
    Session.CheckpointStage := 2;
    SpawnMonsters;
  end;
end;

procedure Room2;

begin
  if Session.Room <> RoomTraining then Exit;
  WriteLn(TxtYouAreIn, TxtRoom2_01);
  WriteLn(TxtRoom2_02);
  WriteLn(TxtShared_04);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlacePok224JCentralny]);
    if MoveWhenOrExit([Go(CmdZachod, RoomSalon)]) then Exit;
    if Command = CmdPatrz + CmdPlakat then begin
      WriteLines(TxtRoom2Lines1);
    end;
    HandleTrain;
  until Session.Room <> RoomTraining;
end;

procedure Room3;

begin
  if Session.Room <> RoomMeditation then Exit;
  WriteLines(TxtRoom3Lines1);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
      WriteLn(TxtRoom3_04);
    if MoveWhenOrExit([Go(CmdGora, RoomSalon)]) then Exit;
    Training;
  until Session.Room <> RoomMeditation;
end;

procedure Room9;
begin
  BasicRoomSimple(RoomSchoolLanding,
            [TxtYouAreIn + TxtRoom9_01, TxtRoom9_02],
            [TxtShared_03,
             TxtExitDol, TxtPlaceMudSzkola2,
             TxtExitGora, TxtPlaceKlatkiPelneGajdy],
            [Go(CmdDol, RoomLost), Go(CmdGora, RoomCageCorridor)]);
end;

procedure Room12;

begin
  if Session.Room <> RoomCageWeakling then Exit;
  WriteLn(TxtShared_06);
  case World.CageWeakling of
    RoomCageWeakling: WriteLn(TxtRoom12_01);
    0: WriteLn(TxtShared_07);
  end;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceKlatkiPelneGajdy]);
    if Command = CmdMode then EnterTrance;
    if MoveWhenOrExit([Go(CmdZachod, RoomCageCorridor)]) then Exit;
    if (Command = CmdZabij + CmdPotwor) and (World.CageWeakling = RoomCageWeakling) then begin
      Combat.EnemyEnergy := 20; Combat.EnemyDexterity := 3; Combat.EnemyStrength := 3;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageWeakling := 0;
        Combat.Loot := Random(10);
        WriteLn(TxtShared_08, Combat.Loot, TxtShared_09);
        Player.Money := Player.Money + Combat.Loot;
        TryCageLoot(4);
      end
      else
        Combat.Fled := 0;
    end;
  until Session.Room <> RoomCageWeakling;
end;

procedure ConcertRooms;

begin
  if Session.Room = RoomCrowd1 then begin

    WriteLines(TxtConcertRoomsLines1);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitZachod, TxtPlaceDolinaRozrywek,
                      TxtExitPolnoc, TxtPlaceTlum,
                      TxtExitPolodnie, TxtPlaceTlum]);
      ConcertFights;
      if MoveWhenOrExit([Go(CmdZachod, RoomValley),
                Go(CmdPolnoc, RoomCrowd3),
                Go(CmdPolodnie, RoomCrowd2),
                Go(CmdWschod, RoomCrowd4)]) then Exit;
      if Command = CmdPatrz + CmdPlakat then begin
        WriteLn(TxtConcertRooms_07);
        WriteLn(TxtConcertRooms_08);
      end;
    until Session.Room <> RoomCrowd1;
  end;
  if Session.Room = RoomCrowd2 then begin

    WriteLn(TxtConcertRooms_09);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitPolnoc, TxtPlaceTlum,
                      TxtExitWschod, TxtPlaceTlum]);
      ConcertFights;
      if MoveWhenOrExit([Go(CmdPolnoc, RoomCrowd1), Go(CmdWschod, RoomCrowd5)]) then Exit;
    until Session.Room <> RoomCrowd2;
  end;
  if Session.Room = RoomCrowd3 then begin

    WriteLn(TxtConcertRooms_11);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitPolodnie, TxtPlaceTlum,
                      TxtExitWschod, TxtPlaceTlum,
                      TxtExitPolnoc, TxtPlacePiwiarnia]);
      ConcertFights;
      if MoveWhenOrExit([Go(CmdPolodnie, RoomCrowd1), Go(CmdWschod, RoomCrowd6), Go(CmdPolnoc, RoomPub)]) then Exit;
    until Session.Room <> RoomCrowd3;
  end;
  if Session.Room = RoomCrowd4 then begin

    WriteLn(TxtYouAreIn, TxtConcertRooms_13);
    WriteLn(TxtConcertRooms_14);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitZachod, TxtPlaceTlum,
                      TxtExitPolnoc, TxtPlaceTlum,
                      TxtExitPolodnie, TxtPlaceTlum]);
      ConcertFights;
      if MoveWhenOrExit([Go(CmdPolnoc, RoomCrowd6), Go(CmdZachod, RoomCrowd1), Go(CmdPolodnie, RoomCrowd5)]) then Exit;
    until Session.Room <> RoomCrowd4;
  end;
  if Session.Room = RoomCrowd5 then begin

    WriteLn(TxtConcertRooms_16);
    WriteLn(TxtConcertRooms_14);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitZachod, TxtPlaceTlum,
                      TxtExitPolnoc, TxtPlaceTlum]);
      ConcertFights;
      if MoveWhenOrExit([Go(CmdPolnoc, RoomCrowd4), Go(CmdZachod, RoomCrowd2)]) then Exit;
    until Session.Room <> RoomCrowd5;
  end;
  if Session.Room = RoomCrowd6 then begin

    WriteLn(TxtConcertRooms_17);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitZachod, TxtPlaceTlum,
                      TxtExitPolodnie, TxtPlaceTlum]);
      ConcertFights;
      if MoveWhenOrExit([Go(CmdPolodnie, RoomCrowd4), Go(CmdZachod, RoomCrowd3)]) then Exit;
    until Session.Room <> RoomCrowd6;
  end;
  if Session.Room = RoomPub then begin

    WriteLn(TxtYouAreIn, TxtConcertRooms_18);
    WriteLn(TxtConcertRooms_19);
    if World.Minibarman = 67 then
      WriteLn(TxtConcertRooms_20);
    if World.Fatso = 67 then
      WriteLn(TxtConcertRooms_21);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitWschod, TxtPlaceWejscieNaEstrade,
                      TxtExitPolodnie, TxtPlaceTlum]);
      ConcertFights;
      if (Command = CmdZabij + CmdMiniBarman) and (World.Minibarman = 67) then begin
        WriteLn(TxtConcertRooms_23);
        WriteLn(TxtConcertRooms_24);
        FightVeryHard;
        if Player.Energy > 0 then begin
          World.Minibarman := 0;
          Combat.Roll := Random(100);
          if Combat.Roll < 15 then begin
            WriteLn(TxtConcertRooms_25, TxtShared_08, TxtPiwoTail);
            Bag.Beer := Bag.Beer - 10;
            Bag.Count := Bag.Count + 1;
          end;
        end;
      end;
      if (Command = CmdZabij + CmdGrubas) and (World.Fatso = 67) then begin
        FightVeryHard;
        if Player.Energy > 0 then begin
          World.Fatso := 0;
          if Combat.Roll < 15 then begin
            WriteLn(TxtConcertRooms_26, TxtShared_08, TxtPiwoTail);
            Bag.Beer := Bag.Beer - 10;
            Bag.Count := Bag.Count + 1;
          end;
        end;
      end;
      if MoveWhenOrExit([Go(CmdPolodnie, RoomCrowd3), Go(CmdWschod, RoomStageEntrance)]) then Exit;
    until Session.Room <> RoomPub;
  end;
  if Session.Room = RoomStageEntrance then begin

    WriteLn(TxtConcertRooms_27);
    WriteLn(TxtConcertRooms_28);
    DescribeCrowd;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then begin
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlacePiwiarnia,
                    TxtExitWschod, TxtPlaceScena]);
        WriteLn(TxtConcertRooms_31);
      end;
      ConcertFights;
      if MoveWhenOrExit([Go(CmdZachod, RoomPub), Go(CmdWschod, RoomBackstage)]) then Exit;
      if Command = CmdPatrz + CmdTabliczka then
        WriteLn(TxtConcertRooms_32);
    until Session.Room <> RoomStageEntrance;
  end;
  if Session.Room = RoomBackstage then begin

    WriteLn(TxtConcertRooms_33);
    WriteLn(TxtConcertRooms_34);
    if World.DJ = 69 then
      WriteLn(TxtConcertRooms_35);
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitZachod, TxtPlaceWejscieNaScene,
                      TxtExitPolodnie, TxtPlaceScena]);
      if Command = CmdZabij + CmdDJ then begin
        if World.DJ = 69 then begin
          FightVeryHard;
          if Combat.EnemyEnergy < 0 then begin
            World.DJ := 0;
            Combat.Roll := Random(100);
            if Combat.Roll < 25 then begin
              WriteLn(TxtShared_08, TxtConcertRooms_38);
              Bag.DryRation := Bag.DryRation - 10;
              Bag.Count := Bag.Count + 1;
            end;
            if Combat.Roll < 3 then begin
              WriteLn(TxtShared_08, TxtConcertRooms_39);
              WriteLn(TxtBang, TxtUniqeItem, TxtConcertRooms_40);
              Bag.Cassette := Bag.Cassette - 10;
              Player.MaxEnergy := Player.MaxEnergy + 5;
              Gear.Armor := Gear.Armor - 8;
              Bag.Count := Bag.Count + 1;
              Player.Dexterity := Player.Dexterity + 1;
            end;
          end;
        end;
      end;
      if MoveWhenOrExit([Go(CmdZachod, RoomStageEntrance), Go(CmdPolodnie, RoomStage1)]) then Exit;
    until Session.Room <> RoomBackstage;
  end;
  if Session.Room = RoomStage1 then begin

    WriteLines(TxtConcertRoomsLines2);
    DescribeStage;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitPolnoc, TxtPlaceScena,
                      TxtExitPolodnie, TxtPlaceSrodekSceny]);
      if MoveWhenOrExit([Go(CmdPolnoc, RoomBackstage), Go(CmdPolodnie, RoomStage2)]) then Exit;
      StageFights;
    until Session.Room <> RoomStage1;
  end;
  if Session.Room = RoomStage2 then begin

    WriteLn(TxtConcertRooms_46);
    WriteLn(TxtConcertRooms_47);
    DescribeStage;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitPolnoc, TxtPlaceScena,
                      TxtExitPolodnie, TxtPlaceScena]);
      if MoveWhenOrExit([Go(CmdPolnoc, RoomStage1), Go(CmdPolodnie, RoomStage3)]) then Exit;
      StageFights;
    until Session.Room <> RoomStage2;
  end;
  if Session.Room = RoomStage3 then begin

    WriteLn(TxtConcertRooms_48);
    WriteLn(TxtConcertRooms_49);
    DescribeStage;
    repeat
      Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      if Command = CmdMode then EnterTrance;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitPolnoc, TxtPlaceSrodekSceny]);
      if MoveWhenOrExit([Go(CmdPolnoc, RoomStage2)]) then Exit;
      StageFights;
    until Session.Room <> RoomStage3;
  end;
end;

procedure LoadCharacter;
var
  dummy: Integer;
begin
  ReadLn(Command);
  Assign(Session.SaveFile, TxtSaveFileName);
  Reset(Session.SaveFile);
  LoadSlot(Player.Mana);
  Player.Mana := Player.Mana div 4;
  LoadSlotShort(Player.Level);
  Player.Level := Player.Level - $17;
  LoadSlot(Bag.OldSword);
  LoadSlot(Bag.Pipe);
  LoadSlot(Bag.Diploma);
  LoadSlot(Bag.SmallShield);
  LoadSlot(Bag.SpikedSuit);
  LoadSlot(Player.Experience);
  LoadSlot(Player.Energy);
  Player.Energy := Player.Energy div 4;
  Player.Energy := Player.Energy - $28;
  LoadSlot(Session.OuterRoom);
  LoadSlot(Player.Dexterity);
  Player.Dexterity := Player.Dexterity - 12;
  LoadSlot(Player.Strength);
  Player.Strength := Player.Strength + 24;
  LoadSlot(Player.Wisdom);
  LoadSlot(Player.Practice);
  LoadSlot(Session.CheckpointStage);
  LoadSlot(dummy);
  LoadSlot(dummy);
  LoadSlotLong(Player.Money);
  Player.Money := Player.Money div Player.Wisdom;
  LoadSlot(Combat.Loot);
  LoadSlot(Player.MaxEnergy);
  LoadSlot(Bag.Limit);
  LoadSlotShort(Skills.Comparing);
  LoadSlot(Player.MaxMana);
  LoadSlot(Player.MaxStrength);
  LoadSlot(Player.MaxDexterity);
  LoadSlot(Player.MaxWisdom);
  LoadSlot(Bag.Count);
  LoadSlot(Gear.Armor);
  LoadSlot(Gear.LuckRoll);
  LoadSlot(Gear.WeaponKind);
  LoadSlot(Gear.Wearing);
  LoadSlot(Session.Overall);
  LoadSlot(Session.SavedFlag);
  LoadSlot(World.CageWeakling);
  LoadSlot(World.CageStrong);
  LoadSlot(World.CageAgile);
  LoadSlot(World.CageTough);
  LoadSlot(World.CageHuge);
  LoadSlot(Gear.ShieldKind);
  LoadSlot(Gear.ArmorRating);
  LoadSlotShort(Skills.Cooking);
  LoadSlot(Skills.CookingDisplayBug);
  LoadSlot(dummy);
  LoadSlot(Bag.Heart);
  LoadSlot(Bag.ManaBottle);
  LoadSlot(Bag.Cookie);
  LoadSlot(Bag.DryRation);
  LoadSlot(Bag.Bread);
  LoadSlot(Bag.BreadRoll);
  LoadSlot(Bag.Sausage);
  LoadSlot(Bag.Bread);
  LoadSlot(Bag.BreadRoll);
  LoadSlot(Gear.WornCount);
  LoadSlot(Skills.Parry);
  LoadSlot(Skills.Kick);
  LoadSlot(Skills.KickMinMana);
  LoadSlot(Skills.KickMaxEnergy);
  LoadSlot(Skills.Fleeing);
  LoadSlot(Skills.FleeEnergy);
  LoadSlot(Combat.Fled);
  LoadSlot(Session.InArena);
  LoadSlot(Bag.Tracksuit);
  LoadSlot(Bag.Cassette);
  LoadSlotShort(Bag.TeleportPill);
  LoadSlot(World.Woodworm);
  LoadSlot(World.Fly);
  LoadSlot(World.Bacterium);
  LoadSlot(World.Quest);
  LoadSlot(World.QuestKills);
  LoadSlot(World.Snail);
  LoadSlotShort(Bag.LuckyLeaf);
  LoadSlot(Skills.Returning);
  LoadSlotShort(Bag.Bigos);
  LoadSlot(Bag.Beer);
  LoadSlot(Bag.CompareScroll);
  LoadSlot(Bag.ReturnScroll);
  LoadSlot(World.OldElf);
  LoadSlotShort(World.DuncanQuest);
  LoadSlotShort(Bag.Backpack);
  LoadSlotShort(World.Duncan);
  ReadLn(Session.SaveFile);
  LoadSlotText(Gear.WornGarment);
  Close(Session.SaveFile);
  WriteLn(TxtLoadCharacter_01, Gear.WornGarment);
end;

procedure CheckLevelUp;

var
  threshold: Integer;
begin
  if Player.Level < 1 then Exit;
  threshold := LevelThreshold(Player.Level);
  if Player.Experience < threshold then Exit;

  WriteLines(TxtCheckLevelUpLines1);

  case Player.Level of
    1: Player.Experience := Player.Experience - 725;
    2: Player.Experience := Player.Experience - 730;
    3: Player.Experience := Player.Experience - 735;
    4..8: Player.Experience := (Player.Experience - Lvl4_Base) - Player.Level;
    else Player.Experience := (Player.Experience - (Player.Level * 2)) - Lvl9_Base;
  end;
  case Player.Wisdom of
    -128..10: Player.Practice := Player.Practice + 3;
    11..15: Player.Practice := Player.Practice + 4;
    16..22: Player.Practice := Player.Practice + 5;
    else Player.Practice := Player.Practice + 6;
  end;
  WriteLn(TxtCheckLevelUp_02, Player.Practice, TxtCheckLevelUp_03);
  if Player.Dexterity > 12 then Player.MaxEnergy := Player.MaxEnergy + 11
  else Player.MaxEnergy := Player.MaxEnergy + 10;
  if Player.Dexterity > 16 then Player.MaxEnergy := Player.MaxEnergy + 1;
  if Player.Dexterity > 21 then Player.MaxEnergy := Player.MaxEnergy + 1;
  if (Player.Dexterity > 26) and (Player.Strength > 20) then Player.MaxEnergy := Player.MaxEnergy + 1;
  WriteLn(TxtCheckLevelUp_02, Player.MaxEnergy, TxtCheckLevelUp_04);
  Player.MaxMana := Player.MaxMana + Player.Wisdom + 2;
   WriteLn(TxtCheckLevelUp_05, Player.Wisdom + 2, TxtCheckLevelUp_06);
  Player.Level := Player.Level + 1;
  Session.CheckpointStage := 0;
  if Player.Level = 12 then begin
    WriteLn(TxtCheckLevelUp_07);
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
    WriteLn(TxtCheckLevelUp_08, Player.MaxStrength,
          TxtMaxymalnie, TxtCheckLevelUp_09);
    WriteLn(TxtCheckLevelUp_08, Player.MaxDexterity,
          TxtMaxymalnie, TxtCheckLevelUp_10);
    WriteLn(TxtCheckLevelUp_08, Player.MaxWisdom,
          TxtMaxymalnie, TxtCheckLevelUp_11);
  end;
end;

procedure CmdScan;
begin
  WriteLn(TxtCmdScan_01);
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
  Gear.WornGarment := TxtEmpty;
  Bag.OldSword := -10;
  Bag.SmallShield := -10;
  Player.Strength := Player.Strength - 1;
end;

procedure CmdNoExit;
begin
  WriteLn(TxtCmdNoExit_01);
end;

procedure CmdQuitGame;
begin
  Session.ExitRequested := True;
end;

procedure CmdJustSaved;
begin
  if Session.SavedFlag = 1 then begin
    Command := CmdZdolnosci;
    Session.SavedFlag := 0;
    WriteLn(Session.OuterRoom, TxtCmdJustSaved_01);
  end;
end;

procedure CmdDrinkBeer;
begin
  if Bag.Beer <= -10 then begin
    Bag.Beer := Bag.Beer + 10;
    WriteLn(TxtCmdDrinkBeer_01);
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
    WriteLn(TxtCmdWieldOldSword_01);
    Player.Strength := Player.Strength + 1;
    Gear.LuckRoll := Gear.LuckRoll + 3;
  end;
end;

procedure CmdUnwieldOldSword;
begin
  if (Bag.OldSword = -100) and (Gear.WeaponKind = 1) then begin
    Bag.OldSword := -10;
    Gear.WeaponKind := 0;
    WriteLn(TxtCmdUnwieldOldSword_01);
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
    WriteLn(TxtCmdWieldSmallShield_01);
  end;
end;

procedure CmdUnwieldSmallShield;
begin
  if (Gear.ShieldKind = 1) and (Bag.SmallShield = -100) then begin
    Gear.ShieldKind := 0;
    Gear.Armor := Gear.Armor - 15;
    Gear.WornCount := Gear.WornCount - 1;
    Bag.SmallShield := -10;
    WriteLn(TxtCmdUnwieldSmallShield_01);
  end;
end;

procedure CmdSetFleeEnergy;
begin
  if Skills.Fleeing > 0 then begin
    WriteLn(TxtCmdSetFleeEnergy_01);
    ReadLn(Skills.FleeEnergy);
  end;
end;

procedure CmdSleep;
begin
  Session.SleepHours := 0;
  repeat
    Session.SleepHours := Session.SleepHours + 1;
    Delay(5000);
    WriteLn(TxtCmdSleep_01, Session.SleepHours, TxtCmdSleep_02);
    Player.Experience := Player.Experience - 20;
    Player.Energy := Player.Energy + 10;
  until KeyPressed;
  WriteLn(TxtCmdSleep_03, Session.SleepHours * 10,
      TxtCmdSleep_04, (20 * Session.SleepHours) - Random(2 * Session.SleepHours), TxtShared_22);
  Player.Experience := Player.Experience + Random(2 * Session.SleepHours);
  if Session.SleepHours > 4 then begin
    WriteLn(TxtCmdSleep_05, Player.Wisdom, TxtCmdSleep_06);
    Player.Energy := Player.Energy + Player.Wisdom;
  end;
  if Session.SleepHours > 8 then begin
    WriteLn(TxtCmdSleep_07, Player.Wisdom * 2, TxtCmdSleep_06);
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
      WriteLn(TxtCmdCompare_01);
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
  if (Command = CmdOdrzuc + CmdPaczek) or (Command = CmdOdrzuc + CmdCiastko) or
   (Command = CmdOdrzuc + CmdSuchaRacja) or (Command = CmdOdrzuc + CmdBulka) or
   (Command = CmdOdrzuc + CmdChleb) or (Command = CmdOdrzuc + CmdWeka) or
   (Command = CmdOdrzuc + CmdSerce) or (Command = CmdOdrzuc + CmdBigos) then
    WriteLn(TxtCmdRefuseFoodDrop_01);
end;

procedure CmdOpenPortal;
begin
  if ((Command = CmdPowrot) and (Skills.Returning > 0)) or
   ((Command = CmdUzyj + CmdScrollPowrot) and (Bag.ReturnScroll < 0)) then begin
    Combat.Roll := Random(100);
    if Command = CmdUzyj + CmdScrollPowrot then begin
      Combat.Roll := Random(1);
      Bag.ReturnScroll := Bag.ReturnScroll + 10;
      Bag.Count := Bag.Count - 1;
    end;
    if Combat.Roll <= Skills.Returning then begin
      WriteLn(TxtCmdOpenPortal_01);
      Player.Mana := Player.Mana - 15;
      Session.OuterRoom := RoomCityCentre;
    end;
    if (Combat.Roll > Skills.Returning) and (Skills.Returning + 30 > Combat.Roll) then begin
      WriteLn(TxtCmdOpenPortal_02);
      Player.Mana := Player.Mana - 5;
    end;
    if Skills.Returning + 29 < Combat.Roll then begin
      WriteLn(TxtCmdOpenPortal_03);
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
    WriteLn(TxtCmdSetKickThresholds_01);
    WriteLn(TxtCmdSetKickThresholds_02);
    ReadLn(Skills.KickMaxEnergy);
    WriteLn(TxtCmdSetKickThresholds_03);
    ReadLn(Skills.KickMinMana);
  end;
end;

procedure CmdSpeede;
begin
  Bag.Permit := Bag.Permit - 10;
end;

procedure CmdShowSkills;
begin
  if (Player.Wisdom > 10) and (Player.Strength > 11) then WriteLn(TxtCmdShowSkills_01, Skills.Kick, TxtShared_26);
  if (Player.Wisdom > 10) and (Player.Dexterity > 10) then WriteLn(TxtCmdShowSkills_02, Skills.Fleeing, TxtShared_26);
  if (Player.Wisdom > 15) and (Player.Dexterity > 11) then WriteLn(TxtCmdShowSkills_03, Skills.Parry, TxtShared_26);
  if Player.Wisdom > 11 then WriteLn(TxtCmdShowSkills_04, Skills.Comparing, TxtShared_26);
  if Player.Wisdom > 18 then WriteLn(TxtCmdShowSkills_05, Skills.CookingDisplayBug, TxtShared_26);
  if Player.Wisdom > 19 then WriteLn(TxtCmdShowSkills_06, Skills.Returning, TxtShared_26);
end;

procedure CmdLeaveTrance;
begin
  Session.Room := Session.OuterRoom;
end;

const
  GroundCommands: array[1..32] of TCommandEntry = (
    (cmd:CmdPamietaj; run:SaveCharacter),
    (cmd:CmdScan2; run:CmdScan),
    (cmd:CmdCzysc + CmdEkran; run:CmdClearScreen),
    (cmd:CmdDawaj + CmdEn; run:CmdGiveEnergy),
    (cmd:CmdZabieraj + CmdKase; run:CmdTakeMoney),
    (cmd:CmdUstaw + CmdSz; run:CmdResetArmor),
    (cmd:CmdZdejmuj; run:CmdStrip),
    (cmd:CmdExit; run:CmdNoExit),
    (cmd:CmdWyjscie; run:CmdQuitGame),
    (cmd:CmdJa; run:ShowCharacter),

    (cmd:TxtEmpty; run:TakeDrop),
    (cmd:TxtEmpty; run:CmdJustSaved),
    (cmd:CmdUzyj + CmdPiwo; run:CmdDrinkBeer),
    (cmd:CmdUzyj + CmdStary; run:CmdWieldOldSword),
    (cmd:CmdOdloz + CmdStary; run:CmdUnwieldOldSword),
    (cmd:CmdUzyj + CmdMala; run:CmdWieldSmallShield),
    (cmd:CmdOdloz + CmdMala; run:CmdUnwieldSmallShield),

    (cmd:TxtEmpty; run:UseItems),
    (cmd:CmdZwiej; run:CmdSetFleeEnergy),
    (cmd:CmdSpij; run:CmdSleep),
    (cmd:CmdPorownaj; run:CmdCompare),
    (cmd:CmdDawaj + CmdKase; run:CmdGiveMoney),
    (cmd:TxtEmpty; run:CmdRefuseFoodDrop),
    (cmd:TxtEmpty; run:CmdOpenPortal),
    (cmd:CmdUzyj + CmdScrollPorownywanie; run:CmdUseCompareScroll),
    (cmd:CmdKop; run:CmdSetKickThresholds),
    (cmd:CmdJestem + CmdSpeede2; run:CmdSpeede),
    (cmd:CmdZdolnosci; run:CmdShowSkills),

    (cmd:TxtEmpty; run:DisplayPrefs),
    (cmd:CmdWlacz + CmdPostac; run:LoadCharacter),
    (cmd:CmdUnmode; run:CmdLeaveTrance),
    (cmd:CmdUm; run:CmdLeaveTrance)
  );

procedure Room14;

begin

  WriteLn(TxtShared_06);
  case World.CageAgile of
    RoomCageAgile: WriteLn(TxtRoom14_01);
    0: WriteLn(TxtRoom14_02);
  end;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceKlatkiPelneGajdy]);
    if Command = CmdMode then EnterTrance;
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomCageCorridor)]) then Exit;
    if (Command = CmdZabij + CmdPotwor) and (World.CageAgile = RoomCageAgile) then begin
      Combat.EnemyEnergy := 20; Combat.EnemyDexterity := 30; Combat.EnemyStrength := 3;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageAgile := 0;
        Combat.Loot := Random(15);
        WriteLn(TxtShared_08, Combat.Loot, TxtShared_09);
        Player.Money := Player.Money + Combat.Loot;
        TryCageLoot(7);
      end else
        Combat.Fled := 0;
    end;
  until Session.Room <> RoomCageAgile;

end;
procedure Room15;

begin

  WriteLn(TxtShared_06);
  case World.CageTough of
    RoomCageTough: WriteLn(TxtRoom15_01);
    0: WriteLn(TxtShared_07);
  end;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolnoc, TxtPlaceKlatkiPelneGajdy]);
    if Command = CmdMode then EnterTrance;
    if MoveWhenOrQuit([Go(CmdPolnoc, RoomCageCorridor)]) then Exit;
    if (Command = CmdZabij + CmdPotwor) and (World.CageTough = RoomCageTough) then begin
      Combat.EnemyEnergy := 40; Combat.EnemyDexterity := 3; Combat.EnemyStrength := 3;
      Fight;
      if Combat.Fled = 0 then begin
        World.CageTough := 0;
        Combat.Loot := Random(15);
        WriteLn(TxtShared_08, Combat.Loot, TxtShared_09);
        Player.Money := Player.Money + Combat.Loot;
        TryCageLoot(7);
      end else
        Combat.Fled := 0;
    end;
  until Session.Room <> RoomCageTough;

end;
procedure Room16;

label
  L1027_Flee, L1028_AfterFlee;
begin

  WriteLn(TxtShared_06);
  case World.CageHuge of
    RoomCageHuge: WriteLn(TxtRoom16_01);
    0: WriteLn(TxtShared_07);
  end;
  repeat
    if World.CageHuge = RoomCageHuge then begin
      Combat.EnemyEnergy := 40; Combat.EnemyDexterity := 11; Combat.EnemyStrength := 10;
      Fight;
      if Combat.Fled <> 0 then goto L1027_Flee;
      World.CageHuge := 0;
      Combat.Loot := Random(30);
      WriteLn(TxtShared_08, Combat.Loot, TxtShared_09);
      Player.Money := Player.Money + Combat.Loot;
      TryCageLoot(10);
      goto L1028_AfterFlee;
      L1027_Flee:
      Combat.Fled := 0;
      Session.Room := RoomCageCorridor;
      L1028_AfterFlee:
    end;
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitDol, TxtPlaceKlatkiPelneGajdy]);
    if Command = CmdMode then EnterTrance;
    if MoveWhenOrQuit([Go(CmdDol, RoomCageCorridor)]) then Exit;
  until Session.Room <> RoomCageHuge;

end;
procedure Room17;

begin

  WriteLn(TxtYouAreIn, TxtRoom17_01);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitGora, TxtPlaceKlatkiPelneGajdy,
                    TxtExitDol, TxtPlaceTeleport]);
    if Command = CmdPatrz + CmdPlakat then begin
      WriteLines(TxtRoom17Lines1);
      if (World.CageWeakling = 0) and (World.CageAgile = 0) and
      (World.CageStrong = 0) and (World.CageTough = 0) and
      (World.CageHuge = 0) and (Bag.Diploma = 0) then
        Bag.Diploma := RoomCageReward;
    end;
    if MoveWhenOrQuit([Go(CmdGora, RoomCageCorridor), Go(CmdDol, RoomTeleport)]) then Exit;
  until Session.Room <> RoomCageReward;

end;
procedure Room18;

begin

  WriteLines(TxtRoom18Lines1);
  Session.Room := RoomSalon;

end;
procedure Room20;

begin

  WriteLn(TxtYouAreIn, TxtRoom20_01);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdPatrz + CmdPlakat then
      WriteLn(TxtRoom20_02);
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlacePokojCentralny,
                    TxtExitPolnoc, TxtPlaceUlSklepikowa,
                    TxtExitWschod, TxtPlaceUlCiemna,
                    TxtExitZachod, TxtPlaceUlDluga]);
    if Command = CmdWyjsc0ie then begin Session.ExitRequested := True; Exit; end;
    MoveWhen([Go(CmdPolodnie, RoomSalon),
              Go(CmdPolnoc, RoomShopStreet),
              Go(CmdZachod, RoomLongStreet),
              Go(CmdWschod, RoomDarkStreet)]);
    StreetFights;
  until Session.Room <> RoomCityCentre;

end;
procedure Room76;

begin

  WriteLn(TxtYouAreIn, TxtRoom76_01);
  WriteLines(TxtRoom76Lines1);
  if World.Maciek = 76 then
    WriteLn(TxtRoom76_05);
  if World.Pedal = 76 then
    WriteLn(TxtRoom76_06);
  if World.Couple = 76 then
    WriteLn(TxtRoom76_07);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceUlicaCiemna]);
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomDarkStreet)]) then Exit;
    if Command = CmdLista then begin
      WriteLines(TxtRoom76Lines2);
    end;
    if Command = CmdZabij + CmdPedal then begin
      FightEasy;
      World.Pedal := 0;
      PillGain;
    end;
    if Command = CmdZabij + CmdPara then begin
      FightVeryHard;
      World.Couple := 0;
      FightVeryHard;
    end;
    if Command = CmdZabij + CmdMaciek then begin
      FightEasy;
      World.Maciek := 0;
    end;
    if Command = CmdMam + Cmd18Lat then begin
      WriteLn(TxtRoom76_13);
    end;
  until Session.Room <> RoomBar;

end;
procedure Room77;

begin

  WriteLn(TxtRoom77_01);
  WriteLn(TxtRoom77_02);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolnoc, TxtPlaceUlCiemna,
                    TxtExitWschod, TxtPlaceBluszcz,
                    TxtExitZachod, TxtPlaceBluszcz,
                    TxtExitPolodnie, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdPolnoc, RoomDarkStreet),
              Go(CmdWschod, RoomIvy2),
              Go(CmdZachod, RoomIvy3),
              Go(CmdPolodnie, RoomIvy4)]) then Exit;
  until Session.Room <> RoomIvy1;

end;
procedure Room78;

begin

  WriteLn(TxtRoom78_01);
  WriteLn(TxtRoom78_02);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdZachod, RoomIvy1)]) then Exit;
  until Session.Room <> RoomIvy2;

end;
procedure Room79;

begin

  WriteLn(TxtRoom79_01);
  WriteLn(TxtRoom79_02);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomIvy1)]) then Exit;
  until Session.Room <> RoomIvy3;

end;
procedure Room80;

begin

  WriteLines(TxtRoom80Lines1);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolnoc, TxtPlaceBluszcz,
                    TxtExitWschod, TxtPlaceBluszcz,
                    TxtExitZachod, TxtPlaceBluszcz,
                    TxtExitPolodnie, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdPolnoc, RoomIvy1),
              Go(CmdZachod, RoomIvy5),
              Go(CmdWschod, RoomIvy6),
              Go(CmdPolodnie, RoomClearing)]) then Exit;
    if Command = CmdPatrz + CmdNapis then
      WriteLn(TxtRoom80_04);
    if Command = CmdPatrz + CmdStudnia then begin
      Combat.Roll := Random(3) + 1;
      WriteLn(TxtRoom80_05, Combat.Roll,
          TxtShared_23);
      Player.Money := Player.Money + Combat.Roll;
      Combat.Roll := Random(100);
      if Combat.Roll < 10 then begin
        WriteLn(TxtRoom80_06);
        Player.Energy := Player.Energy - 40;
        WriteLn(TxtRoom80_07);
        Player.Money := Player.Money - 100;
        if Player.Money < 0 then Player.Money := 0;
      end;
    end;
  until Session.Room <> RoomIvy4;

end;
procedure Room81;

begin

  WriteLn(TxtRoom81_01);
  WriteLn(TxtRoom81_02);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomIvy4)]) then Exit;
  until Session.Room <> RoomIvy5;

end;
procedure Room82;

begin

  WriteLn(TxtRoom82_01);
  WriteLn(TxtRoom82_02);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdZachod, RoomIvy4)]) then Exit;
  until Session.Room <> RoomIvy6;

end;
procedure Room84;

begin

  WriteLines(TxtRoom84Lines1);
  DescribePlants;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    PlantFights;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceBluszcz,
                    TxtExitZachod, TxtPlaceBudynek,
                    TxtExitPolodnie, TxtPlaceWejscieDoGroty]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomClearing), Go(CmdZachod, RoomLivingDoor), Go(CmdPolodnie, RoomCaveMouth)]) then Exit;
  until Session.Room <> RoomCavePath;

end;
procedure Room87;

begin

  WriteLn(TxtRoom87_01);
  WriteLn(TxtRoom87_02);
  Combat.Roll := Random(100);
  if Combat.Roll < 40 then begin
    WriteLn(TxtRoom87_03,
       25 - Player.Dexterity, TxtShared_26);
    Player.Energy := Player.Energy - 25 + Player.Dexterity;
  end;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceGrota,
                    TxtExitPolnoc, TxtPlacePodejrzaneKrzaki]);
    if MoveWhenOrQuit([Go(CmdPolnoc, RoomCavePath), Go(CmdPolodnie, RoomNettleThrone)]) then Exit;
  until Session.Room <> RoomCaveMouth;

end;
procedure Room88;

begin

  WriteLines(TxtRoom88Lines1);
  Write(TxtRoom88_05);
  ReadLn(Command);
  WriteLn(TxtRoom88_06);
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
      WriteLn(TxtRoom88_07);
      Session.Room := RoomCaveMouth;
    end;
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceWejscieDoGroty2]);
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomCaveMouth)]) then Exit;
  until Session.Room <> RoomNettleThrone;

end;
procedure Room85;

begin

  WriteLn(TxtRoom85_01);
  WriteLn(TxtRoom85_02);
  if World.Door <> 0 then
    WriteLn(TxtRoom85_03);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    if Command = CmdZabij + CmdDrzwi then begin
      if World.Door <> 0 then begin
        FightNotEasy;
        if Player.Energy > 0 then World.Door := 0;
      end;
    end;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then begin
      WriteExits([TxtShared_03,
                  TxtExitWschod, TxtPlacePodejrzaneKrzaki]);
      if World.Door <> 0 then
        WriteLn(TxtExitZachod, TxtPlaceGdybyNieTeCholerneDrzwi);
      if World.Door = 0 then
        WriteLn(TxtExitZachod, TxtPlaceWejscieDoDomku);
    end;
    if MoveWhenOrQuit([Go(CmdWschod, RoomCavePath)]) then Exit;
    if (Command = CmdZachod) and (World.Door = 0) then Session.Room := RoomHut;
    if (Command = CmdZachod) and (World.Door <> 0) then
      WriteLn(TxtRoom85_07);
  until Session.Room <> RoomLivingDoor;

end;
procedure Room86;

begin

  WriteLn(TxtRoom86_01);
  if World.OldElf <> 0 then
    WriteLn(TxtRoom86_02);
  if World.OldElf = 0 then
    WriteLn(TxtRoom86_03);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ExpandAbbrev;
    if Command = CmdDawaj + CmdKunszt then Player.Experience := Player.Experience + 500;
    if Command = CmdPatrz + CmdGarnki then
      WriteLn(TxtRoom86_04);
    if Command = CmdRozmawiaj + CmdStaruch then begin
      if (Bag.Sausage > -30) and (Player.Money < 200) and (Bag.ReturnScroll = 0) then begin
        WriteLines(TxtRoom86Lines1);
      end;
    end;
    if Command = CmdRozmawiaj + CmdStaruch then begin
      if (Bag.Sausage < -30) and (Player.Money > 199) then begin
        WriteLines(TxtRoom86Lines2);
        Session.Room := RoomCityCentre;
        Bag.Beer := Bag.Beer - 10;
        Bag.Sausage := Bag.Sausage + 40;
        Player.Money := Player.Money - 200;
        Bag.ReturnScroll := Bag.ReturnScroll - 10;
        Player.Experience := Player.Experience + 50;
        Bag.Count := Bag.Count - 2;
      end;
    end;
    if Command = CmdRozmawiaj + CmdStaruch then begin
      if Bag.ReturnScroll < 0 then begin
        WriteLn(TxtRoom86_13);
        Session.Room := RoomCageHuge;
      end;
    end;
    if Command = CmdZabij + CmdStaruch then begin
      if World.OldElf <> 0 then begin
        FightWeak;
        World.OldElf := 0;
        WriteLn(TxtRoom86_14);
        WriteLn(TxtRoom86_15);
        Player.Level := Player.Level - 1;
      end;
    end;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceBudynek]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomLivingDoor)]) then Exit;
  until Session.Room <> RoomHut;

end;
procedure Room21;

begin

  WriteLn(TxtRoom21_01);
  WriteLn(TxtRoom21_02);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceCentrumMiasta,
                    TxtExitPolnoc, TxtPlaceUlSklepikowa,
                    TxtExitWschod, TxtPlacePiekarnia,
                    TxtExitZachod, TxtPlaceZbrojownia]);
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomCityCentre),
              Go(CmdPolnoc, RoomShopStreet2),
              Go(CmdWschod, RoomBakery),
              Go(CmdZachod, RoomArmoury)]) then Exit;
    StreetFights;
  until Session.Room <> RoomShopStreet;

end;
procedure Room22;

begin

  WriteLn(TxtRoom22_01);
  WriteLn(TxtRoom22_02);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceUlSklepikowa,
                    TxtExitPolnoc, TxtPlaceRozjazd,
                    TxtExitWschod, TxtPlaceSklepWielobranzowy,
                    TxtExitZachod, TxtPlaceSklepMagiczny]);
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomShopStreet),
              Go(CmdWschod, RoomGeneralStore),
              Go(CmdZachod, RoomMagicShop),
              Go(CmdPolnoc, RoomQuestMaster)]) then Exit;
    StreetFights;
  until Session.Room <> RoomShopStreet2;

end;
procedure Room101;

begin

  WriteLines(TxtRoom101Lines1);
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceRozjazd,
                    TxtExitZachod, TxtPlaceDroga,
                    TxtExitPolnoc, TxtPlaceLas,
                    TxtExitPolodnie, TxtPlaceLas]);
    if Command = CmdPatrz + CmdDrogowskaz then
      WriteLn(TxtRoom101_05);
    if MoveWhenOrQuit([Go(CmdWschod, RoomQuestMaster), Go(CmdZachod, RoomRoad2), Go(CmdPolnoc, RoomForest)]) then Exit;
  until Session.Room <> RoomRoad1;

end;
procedure Room102;
begin
  BasicRoomQuit(RoomRoad2,
            [TxtRoom102_01, TxtRoom102_02],
            [TxtShared_03,
             TxtExitWschod, TxtPlaceDroga,
             TxtExitZachod, TxtPlaceDroga,
             TxtExitPolnoc, TxtPlaceLas,
             TxtExitPolodnie, TxtPlaceLas],
            [Go(CmdWschod, RoomRoad1), Go(CmdZachod, RoomRoad3)]);
end;
procedure Room103;
begin
  BasicRoomQuit(RoomRoad3,
            TxtRoom103Lines1,
            [TxtShared_03,
             TxtExitWschod, TxtPlaceDroga,
             TxtExitPolnoc, TxtPlaceLas,
             TxtExitPolodnie, TxtPlaceLas],
            [Go(CmdWschod, RoomRoad2)]);
end;
procedure Room23;

begin

  WriteLn(TxtYouAreIn, TxtRoom23_01);
  WriteLn(TxtRoom23_02);
  WriteLn(TxtRoom23_03);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdPatrz + CmdPlakat then begin
      WriteLn(TxtRoom23_04);
      WriteLn(TxtRoom23_05);
    end;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceUlicaSklepikowa]);
    if MoveWhenOrQuit([Go(CmdZachod, RoomShopStreet)]) then Exit;
    BakeryShop;
  until Session.Room <> RoomBakery;

end;
procedure Room24;

begin

  WriteLn(TxtYouAreIn, TxtRoom24_01);
  WriteLn(TxtRoom24_02);
  WriteLn(TxtRoom24_03);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    ArmouryShop;
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceUlicaSklepikowa]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomShopStreet)]) then Exit;
    if Command = CmdPatrz + CmdPlakat then
      WriteLn(TxtRoom24_04);
    StreetFights;
  until Session.Room <> RoomArmoury;

end;
procedure Room25;

begin

  WriteLn(TxtRoom25_01);
  WriteLn(TxtRoom25_02);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceUlicaSklepikowa]);
    if MoveWhenOrQuit([Go(CmdZachod, RoomShopStreet2)]) then Exit;
    if Command = CmdPatrz + CmdWywieszka then
      WriteLn(TxtRoom25_03);
    StreetFights;
    GeneralStoreShop;
  until Session.Room <> RoomGeneralStore;

end;
procedure Room26;

begin

  WriteLn(TxtRoom26_01);
  DescribeStreet;
  repeat
    Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
    ReadLn(Command);
    if Command = CmdMode then EnterTrance;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceUlicaSklepikowa]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomShopStreet2)]) then Exit;
    if Command = CmdPatrz + CmdPlakat then
      WriteLn(TxtRoom26_02);
    MagicShop;
    StreetFights;
  until Session.Room <> RoomMagicShop;

end;
procedure Room31;
begin
  BasicRoomQuit(RoomLongStreet2,
            [TxtRoom31_01, TxtRoom31_02],
            [TxtShared_03,
             TxtExitWschod, TxtPlaceUlicaDluga,
             TxtExitPolnoc, TxtPlaceDolinaRozrywek],
            [Go(CmdWschod, RoomLongStreet), Go(CmdPolnoc, RoomValley)]);
end;
procedure Room32;
begin
  BasicRoomQuitPoster(RoomArenaEntrance,
            [TxtRoom32_01, TxtRoom32_02],
            [TxtShared_03,
             TxtExitPolodnie, TxtPlaceUlicaDluga,
             TxtExitPolnoc, TxtPlaceArena],
            [Go(CmdPolodnie, RoomLongStreet), Go(CmdPolnoc, RoomArena33)],
            [TxtRoom32_03, TxtRoom32_04]);
end;

const

  RoomDispatch: array[1..46] of TRoomEntry = (
    (id: RoomStart; run:Room0),
    (id: RoomSalon; run:Room1),
    (id: RoomTraining; run:Room2),
    (id: RoomMeditation; run:Room3),
    (id: RoomSchoolHall; run:Room4),
    (id: RoomLost; run:Room5),

    (id: RoomAny; run:PlainRooms),
    (id: RoomSchoolLanding; run:Room9),
    (id: RoomCageCorridor; run:Room11),
    (id: RoomCageWeakling; run:Room12),
    (id: RoomCageStrong; run:Room13),
    (id: RoomCageAgile; run:Room14),
    (id: RoomCageTough; run:Room15),
    (id: RoomCageHuge; run:Room16),
    (id: RoomCageReward; run:Room17),
    (id: RoomTeleport; run:Room18),
    (id: RoomCityCentre; run:Room20),
    (id: RoomDarkStreet; run:Room75),
    (id: RoomLongStreet; run:Room30),
    (id: RoomBar; run:Room76),
    (id: RoomIvy1; run:Room77),
    (id: RoomIvy2; run:Room78),
    (id: RoomIvy3; run:Room79),
    (id: RoomIvy4; run:Room80),
    (id: RoomIvy5; run:Room81),
    (id: RoomIvy6; run:Room82),
    (id: RoomClearing; run:Room83),
    (id: RoomCavePath; run:Room84),
    (id: RoomCaveMouth; run:Room87),
    (id: RoomNettleThrone; run:Room88),
    (id: RoomLivingDoor; run:Room85),
    (id: RoomHut; run:Room86),
    (id: RoomShopStreet; run:Room21),
    (id: RoomShopStreet2; run:Room22),
    (id: RoomRoad1; run:Room101),
    (id: RoomRoad2; run:Room102),
    (id: RoomRoad3; run:Room103),
    (id: RoomQuestMaster; run:Room100),
    (id: RoomBakery; run:Room23),
    (id: RoomArmoury; run:Room24),
    (id: RoomGeneralStore; run:Room25),
    (id: RoomMagicShop; run:Room26),
    (id: RoomLongStreet2; run:Room31),
    (id: RoomValley; run:Room60),

    (id: RoomAny; run:ConcertRooms),
    (id: RoomArenaEntrance; run:Room32)
  );

procedure Start;
label
  L1012_TrancePrompt, L1025_Exit;
var
  gi, ri, ti: Integer;
begin

  Randomize;
  ChooseRace;
  ReadKey;
  repeat
    Checkpoints;
    CheckLevelUp;

    if Bag.Count > Bag.Limit then begin
      WriteLn(TxtStart_01, Bag.Count - Bag.Limit, TxtStart_02);
      WriteLn(TxtStart_03, (Bag.Count - Bag.Limit) * 10, TxtStart_04);
      Player.Energy := Player.Energy - ((Bag.Count - Bag.Limit) * 10);
    end;

    if Combat.PoisonRounds > 0 then begin
      Combat.Roll := Random(5);
      WriteLn(TxtStart_05, Combat.Roll, TxtStart_06);
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
      for ti := Low(TranceItems) to High(TranceItems) do
        with TranceItems[ti] do
          TranceItemLine(item^, line);
      L1012_TrancePrompt: Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);

      Session.ExitRequested := False;
      for gi := Low(GroundCommands) to High(GroundCommands) do
        if (GroundCommands[gi].cmd = TxtEmpty) or (Command = GroundCommands[gi].cmd) then begin
          GroundCommands[gi].run;
          if Session.ExitRequested then goto L1025_Exit;
        end;
      if Session.Room = TranceRoom then goto L1012_TrancePrompt;
    end;

    Combat.Fled := 0;

  until Session.Room = RoomQuit;

  L1025_Exit: ;

end;

end.
