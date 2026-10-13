unit Game;

interface
uses crt;

{$I Rooms.inc}
{$I Texts.inc}

type
  TCommandHandler = procedure;

  TMovement = record
    cmd: string;
    dest: Integer;
  end;

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

  TSkill = (Parry, Kick, KickMinMana, KickMaxEnergy, Fleeing, FleeEnergy,
    Comparing, Cooking, CookingDisplayBug, Returning);
  TSkills = record
    Values: array[TSkill] of Integer;
  end;

  TGearItem = (Armor, WornCount, ArmorRating, LuckRoll, Wearing,
    WeaponKind, ShieldKind);
  TGear = record
    Values: array[TGearItem] of Integer;
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

  TMonster = (CageStrong, CageWeakling, CageAgile, CageTough, CageHuge, Woodworm, Fly, Bacterium, Snail, Beetle, Cockroach, Ant, Spider, Boar, Rat, Fox, Partridge, Hare, Mongrel, Eagle, Deer, Elephant, Lion, Giraffe, Camel, Ostrich, Boa, Wolf, Bison, Panther, Gladiator, Warrior, Tamer, Dachshund, Shepherd, Spaniel, Poodle, Pooch, Cabman, Vendor, Sweeper, Drunkard, SickMan, Kid, Lunatic, Listener, Fan, Man, Policeman, Bouncer, OldMan, Gorilla, Reporter, Guitarist, Drummer, Keyboardist, Liroy, Minibarman, Fatso, DJ, Pedal, Couple, Maciek, Sorrel, Daisy, Clover, SowThistle, Dandelion, Rose, Blackberry, Thistle, Gooseberry, Raspberry, Grass, Duncan);
  TWorld = record
    Monsters: array[TMonster] of Integer;
    Door, OldElf, Quest, QuestKills: Integer;
    DuncanQuest: Shortint;
  end;

  TSession = record
    Room, OuterRoom, InArena, MoveGuard: Integer;
    CheckpointStage, SavedFlag, SleepHours, Overall: Integer;
    ExitRequested: Boolean;
    SaveFile: Text;
  end;

  TSideRoom = record
    room, dest: Integer;
    direction, exitDesc: string;
  end;

  TQuestOffer = record
    cmd: string;
    line: string;
    quest: Integer;
    kills: Integer;
    price: Integer;
  end;

const

  SideRooms: array[1..4] of TSideRoom = (
    (room: RoomSchoolSide1; dest: RoomLost; direction: CmdWschod; exitDesc: CmdMudSzkola2),
    (room: RoomSchoolSide3; dest: RoomLost; direction: CmdPolnoc; exitDesc: CmdMudSzkola2),
    (room: RoomSchoolSide2; dest: RoomLost; direction: CmdPolodnie; exitDesc: CmdMudSzkola2),
    (room: RoomSchoolSide4; dest: RoomLost; direction: CmdGora; exitDesc: CmdMudSzkola2)
  );

  QuestOffers: array[1..3] of TQuestOffer = (
    (cmd: CmdKup + CmdLatwyQuest; line: TxtRoom100_09; quest: 1; kills: 75; price: 200),
    (cmd: CmdKup + CmdPrzecietnyQuest; line: TxtRoom100_10; quest: 2; kills: 200; price: 100),
    (cmd: CmdKup + CmdTrudnyQuest; line: TxtRoom100_11; quest: 3; kills: 200; price: 50)
  );

var
  Player: TPlayer;
  Skills: TSkills;
  Gear: TGear;
  Bag: TBag;
  Combat: TCombat;
  World: TWorld;
  Session: TSession;
  Command: string;

  DispatchRooms: procedure;
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

  procedure WriteExits(const items: array of string);
  procedure WriteLines(const lines: array of string);
  function Go(cmd: string; dest: Integer): TMovement;
  procedure MoveWhen(const moves: array of TMovement);
  function MoveWhenOrExit(const moves: array of TMovement): Boolean;
  function MoveWhenOrQuit(const moves: array of TMovement): Boolean;
  procedure TryCageLoot(threshold: Integer);
  procedure BuyQuest(cmd, line: string; quest, kills, price: Integer);
  procedure StreetFights;
  procedure ConcertFights;
  procedure Training;
  procedure BakeryShop;
  procedure ArmouryShop;
  procedure GeneralStoreShop;
  procedure MagicShop;

procedure Start;

implementation

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

procedure TryCageLoot(threshold: Integer);
begin
  TryLoot(Bag.OldSword, threshold, TxtShared_10);
  TryLoot(Bag.SmallShield, threshold, TxtShared_11);
  TryLoot(Bag.Heart, 6, TxtShared_12);
end;

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

procedure BuyQuest(cmd, line: string; quest, kills, price: Integer);

begin
  if (Command = cmd) and (Player.Money >= price) then begin
    WriteLn(line);
    World.Quest := quest;
    World.QuestKills := kills;
    Player.Money := Player.Money - price;
  end;
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
    case diff of
      2: FightExpForEnergy := 12;
      4: FightExpForEnergy := 13;
      6: FightExpForEnergy := 14;
      8: FightExpForEnergy := 15;
      10: FightExpForEnergy := 16;
      12: FightExpForEnergy := 17;
      14: FightExpForEnergy := 18;
      16: FightExpForEnergy := 19;
      18: FightExpForEnergy := 20;
      21..MaxInt: FightExpForEnergy := 21;
      else FightExpForEnergy := 0;
    end;
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

type
  TDodgeBound = record
    limit: Integer;
    player: Integer;
    enemy: Integer;
  end;

const
  DodgeBounds: array[1..12] of TDodgeBound = (
    (limit: 30; player: 12; enemy: 60),
    (limit: 27; player: 13; enemy: 58),
    (limit: 24; player: 14; enemy: 56),
    (limit: 20; player: 15; enemy: 54),
    (limit: 18; player: 16; enemy: 52),
    (limit: 16; player: 17; enemy: 51),
    (limit: 12; player: 18; enemy: 48),
    (limit:  9; player: 19; enemy: 46),
    (limit:  6; player: 20; enemy: 42),
    (limit:  4; player: 21; enemy: 40),
    (limit:  2; player: 22; enemy: 38),
    (limit:  0; player: 23; enemy: 35)
  );

function DodgeBoundRow(chance: Integer): TDodgeBound;

var
  i: Integer;
begin
  i := Low(DodgeBounds);
  while (i < High(DodgeBounds)) and (chance <= DodgeBounds[i].limit) do
    Inc(i);
  DodgeBoundRow := DodgeBounds[i];
end;

function DodgeBound(chance: Integer): Integer;

begin
  DodgeBound := DodgeBoundRow(chance).player;
end;

function EnemyDodgeBound(chance: Integer): Integer;

begin
  EnemyDodgeBound := DodgeBoundRow(chance).enemy;
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

procedure SpawnGroup(const targets: array of PInteger; spread, base: Integer);
var
  i: Integer;
begin
  for i := Low(targets) to High(targets) do
    targets[i]^ := Random(spread) + base;
end;

procedure SpawnMonsters;
begin
  repeat
    SpawnGroup([@World.Monsters[Bacterium], @World.Monsters[Snail], @World.Monsters[Beetle], @World.Monsters[Cockroach], @World.Monsters[Ant],
                @World.Monsters[Spider], @World.Monsters[Boar], @World.Monsters[Fox], @World.Monsters[Rat], @World.Monsters[Partridge]], 38, RoomCityCentre);
  until (World.Monsters[Bacterium] > RoomArenaEntrance) and (World.Monsters[Snail] > RoomArenaEntrance) and (World.Monsters[Beetle] > RoomArenaEntrance) and (World.Monsters[Cockroach] > RoomArenaEntrance)
    and (World.Monsters[Ant] > RoomArenaEntrance) and (World.Monsters[Spider] > RoomArenaEntrance) and (World.Monsters[Boar] > RoomArenaEntrance) and (World.Monsters[Fox] > RoomArenaEntrance)
    and (World.Monsters[Rat] > RoomArenaEntrance) and (World.Monsters[Partridge] > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Deer], @World.Monsters[Eagle], @World.Monsters[Hare], @World.Monsters[Mongrel], @World.Monsters[Woodworm], @World.Monsters[Fly]], 38, RoomCityCentre);
  until (World.Monsters[Deer] > RoomArenaEntrance) and (World.Monsters[Eagle] > RoomArenaEntrance) and (World.Monsters[Hare] > RoomArenaEntrance) and (World.Monsters[Mongrel] > RoomArenaEntrance)
    and (World.Monsters[Woodworm] > RoomArenaEntrance) and (World.Monsters[Fly] > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Elephant], @World.Monsters[Lion], @World.Monsters[Giraffe], @World.Monsters[Camel], @World.Monsters[Ostrich],
                @World.Monsters[Boa], @World.Monsters[Wolf], @World.Monsters[Bison], @World.Monsters[Panther]], 38, RoomCityCentre);
  until (World.Monsters[Elephant] > RoomArenaEntrance) and (World.Monsters[Lion] > RoomArenaEntrance) and (World.Monsters[Giraffe] > RoomArenaEntrance) and (World.Monsters[Camel] > RoomArenaEntrance)
    and (World.Monsters[Ostrich] > RoomArenaEntrance) and (World.Monsters[Boa] > RoomArenaEntrance) and (World.Monsters[Wolf] > RoomArenaEntrance) and (World.Monsters[Bison] > RoomArenaEntrance)
    and (World.Monsters[Panther] > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Gladiator], @World.Monsters[Warrior], @World.Monsters[Tamer]], 38, RoomCityCentre);
  until (World.Monsters[Gladiator] > RoomArenaEntrance) and (World.Monsters[Warrior] > RoomArenaEntrance) and (World.Monsters[Tamer] > RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Dachshund], @World.Monsters[Shepherd], @World.Monsters[Pooch], @World.Monsters[Spaniel], @World.Monsters[Poodle]], 7, RoomCityCentre);
  until (World.Monsters[Dachshund] > 19) and (World.Monsters[Shepherd] > 19) and (World.Monsters[Pooch] > 19)
    and (World.Monsters[Spaniel] > 19) and (World.Monsters[Poodle] > 19);
  repeat
    SpawnGroup([@World.Monsters[Cabman], @World.Monsters[Vendor], @World.Monsters[Sweeper], @World.Monsters[Drunkard], @World.Monsters[SickMan]], 7, RoomCityCentre);
  until (World.Monsters[Cabman] > 19) and (World.Monsters[Vendor] > 19)
    and (World.Monsters[Sweeper] > 19) and (World.Monsters[Drunkard] > 19) and (World.Monsters[SickMan] > 19);
  repeat
    SpawnGroup([@World.Monsters[Kid]], 7, RoomValley);
    SpawnGroup([@World.Monsters[Lunatic], @World.Monsters[Listener], @World.Monsters[Fan], @World.Monsters[Man]], 8, RoomValley);
  until (World.Monsters[Kid] > RoomValley) and (World.Monsters[Lunatic] > RoomValley) and (World.Monsters[Listener] > RoomValley) and (World.Monsters[Fan] > RoomValley)
    and (World.Monsters[Man] > RoomValley);
  repeat
    SpawnGroup([@World.Monsters[Policeman], @World.Monsters[Bouncer], @World.Monsters[Gorilla]], 9, RoomValley);
    SpawnGroup([@World.Monsters[OldMan]], 8, RoomValley);
    SpawnGroup([@World.Monsters[Reporter]], 7, RoomValley);
  until (World.Monsters[Policeman] > RoomValley) and (World.Monsters[Bouncer] > RoomValley) and (World.Monsters[Gorilla] > RoomValley) and (World.Monsters[OldMan] > RoomValley)
    and (World.Monsters[Reporter] > RoomValley);
    SpawnGroup([@World.Monsters[Guitarist], @World.Monsters[Drummer], @World.Monsters[Keyboardist], @World.Monsters[Liroy]], 3, RoomStage1);
  World.Monsters[Minibarman] := RoomPub;
  World.Monsters[Fatso] := RoomPub;
  World.Monsters[DJ] := RoomBackstage;
  World.Monsters[Pedal] := RoomBar;
  World.Monsters[Couple] := RoomBar;
  World.Monsters[Maciek] := RoomBar;
  World.Door := 1;
  World.OldElf := 1;
  repeat
    SpawnGroup([@World.Monsters[Sorrel], @World.Monsters[Clover], @World.Monsters[Daisy], @World.Monsters[SowThistle], @World.Monsters[Dandelion],
                @World.Monsters[Rose], @World.Monsters[Thistle], @World.Monsters[Raspberry], @World.Monsters[Gooseberry], @World.Monsters[Blackberry],
                @World.Monsters[Grass]], 8, RoomIvy1);
    SpawnGroup([@World.Monsters[Duncan]], 8, RoomIvy1);
  until (World.Monsters[Sorrel] < RoomCavePath) and (World.Monsters[Daisy] < RoomCavePath) and (World.Monsters[Clover] < RoomCavePath) and (World.Monsters[SowThistle] < RoomCavePath)
    and (World.Monsters[Dandelion] < RoomCavePath) and (World.Monsters[Rose] < RoomCavePath) and (World.Monsters[Thistle] < RoomCavePath) and (World.Monsters[Raspberry] < RoomCavePath);
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
    where: PInteger;
    text: string;
  end;

const
  PlantSpots: array[1..11] of TSpot = (
    (where: @World.Monsters[Sorrel]; text: TxtDescribePlants_01),
    (where: @World.Monsters[Daisy]; text: TxtDescribePlants_02),
    (where: @World.Monsters[Clover]; text: TxtDescribePlants_03),
    (where: @World.Monsters[SowThistle]; text: TxtDescribePlants_04),
    (where: @World.Monsters[Dandelion]; text: TxtDescribePlants_05),
    (where: @World.Monsters[Rose]; text: TxtDescribePlants_06),
    (where: @World.Monsters[Thistle]; text: TxtDescribePlants_07),
    (where: @World.Monsters[Blackberry]; text: TxtDescribePlants_08),
    (where: @World.Monsters[Gooseberry]; text: TxtDescribePlants_09),
    (where: @World.Monsters[Raspberry]; text: TxtDescribePlants_10),
    (where: @World.Monsters[Grass]; text: TxtDescribePlants_11)
  );
  BeastSpots: array[1..28] of TSpot = (
    (where: @World.Monsters[Woodworm]; text: TxtDescribeBeasts_01),
    (where: @World.Monsters[Fly]; text: TxtDescribeBeasts_02),
    (where: @World.Monsters[Bacterium]; text: TxtDescribeBeasts_03),
    (where: @World.Monsters[Snail]; text: TxtDescribeBeasts_04),
    (where: @World.Monsters[Beetle]; text: TxtDescribeBeasts_05),
    (where: @World.Monsters[Cockroach]; text: TxtDescribeBeasts_06),
    (where: @World.Monsters[Ant]; text: TxtDescribeBeasts_07),
    (where: @World.Monsters[Spider]; text: TxtDescribeBeasts_08),
    (where: @World.Monsters[Boar]; text: TxtDescribeBeasts_09),
    (where: @World.Monsters[Rat]; text: TxtDescribeBeasts_10),
    (where: @World.Monsters[Fox]; text: TxtDescribeBeasts_11),
    (where: @World.Monsters[Partridge]; text: TxtDescribeBeasts_12),
    (where: @World.Monsters[Hare]; text: TxtDescribeBeasts_13),
    (where: @World.Monsters[Mongrel]; text: TxtDescribeBeasts_14),
    (where: @World.Monsters[Eagle]; text: TxtDescribeBeasts_15),
    (where: @World.Monsters[Deer]; text: TxtDescribeBeasts_16),
    (where: @World.Monsters[Elephant]; text: TxtDescribeBeasts_17),
    (where: @World.Monsters[Lion]; text: TxtDescribeBeasts_18),
    (where: @World.Monsters[Giraffe]; text: TxtDescribeBeasts_19),
    (where: @World.Monsters[Camel]; text: TxtDescribeBeasts_20),
    (where: @World.Monsters[Ostrich]; text: TxtDescribeBeasts_21),
    (where: @World.Monsters[Boa]; text: TxtDescribeBeasts_22),
    (where: @World.Monsters[Wolf]; text: TxtDescribeBeasts_23),
    (where: @World.Monsters[Bison]; text: TxtDescribeBeasts_24),
    (where: @World.Monsters[Panther]; text: TxtDescribeBeasts_25),
    (where: @World.Monsters[Gladiator]; text: TxtDescribeBeasts_26),
    (where: @World.Monsters[Warrior]; text: TxtDescribeBeasts_27),
    (where: @World.Monsters[Tamer]; text: TxtDescribeBeasts_28)
  );
  StreetSpots: array[1..10] of TSpot = (
    (where: @World.Monsters[Dachshund]; text: TxtDescribeStreet_01),
    (where: @World.Monsters[Shepherd]; text: TxtDescribeStreet_02),
    (where: @World.Monsters[Pooch]; text: TxtDescribeStreet_03),
    (where: @World.Monsters[Spaniel]; text: TxtDescribeStreet_04),
    (where: @World.Monsters[Poodle]; text: TxtDescribeStreet_05),
    (where: @World.Monsters[Cabman]; text: TxtDescribeStreet_06),
    (where: @World.Monsters[Vendor]; text: TxtDescribeStreet_07),
    (where: @World.Monsters[Sweeper]; text: TxtDescribeStreet_08),
    (where: @World.Monsters[Drunkard]; text: TxtDescribeStreet_09),
    (where: @World.Monsters[SickMan]; text: TxtDescribeStreet_10)
  );
  StageSpots: array[1..4] of TSpot = (
    (where: @World.Monsters[Guitarist]; text: TxtDescribeStage_01),
    (where: @World.Monsters[Drummer]; text: TxtDescribeStage_02),
    (where: @World.Monsters[Keyboardist]; text: TxtDescribeStage_03),
    (where: @World.Monsters[Liroy]; text: TxtDescribeStage_04)
  );
  CrowdSpots: array[1..10] of TCrowdSpot = (
    (where: @World.Monsters[Kid]; text: TxtDescribeCrowd_01),
    (where: @World.Monsters[Lunatic]; text: TxtDescribeCrowd_02),
    (where: @World.Monsters[Listener]; text: TxtDescribeCrowd_03),
    (where: @World.Monsters[Fan]; text: TxtDescribeCrowd_04),
    (where: @World.Monsters[Man]; text: TxtDescribeCrowd_05),
    (where: @World.Monsters[Policeman]; text: TxtDescribeCrowd_06),
    (where: @World.Monsters[Bouncer]; text: TxtDescribeCrowd_07),
    (where: @World.Monsters[Gorilla]; text: TxtDescribeCrowd_08),
    (where: @World.Monsters[OldMan]; text: TxtDescribeCrowd_09),
    (where: @World.Monsters[Reporter]; text: TxtDescribeCrowd_10)
  );

procedure DescribePlants;
var
  i: Integer;
begin
  for i := Low(PlantSpots) to High(PlantSpots) do
    if PlantSpots[i].where^ = Session.Room then
      WriteLn(PlantSpots[i].text);
  if Session.Room = World.Monsters[Duncan] then
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

procedure KillBeast(cmd: string; var beast: Integer; fight: TFight);
begin
  if (Command = cmd) and (Session.Room = beast) then begin
    fight;
    beast := 0;
  end;
end;

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

type
  TCompareFoeRule = record
    stat: ^Integer;
    lo: Integer;
    hi: Integer;
    line: string;
  end;

procedure CompareFoeRules(const rules: array of TCompareFoeRule);

var
  i: Integer;
begin
  for i := Low(rules) to High(rules) do
    with rules[i] do
      if (stat^ >= lo) and (stat^ <= hi) then
        WriteLn(line);
end;

const
  BeastCompareRules: array[1..3] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 15; line: TxtCompareFoe_02),
    (stat: @Player.Strength; lo: 16; hi: 18; line: TxtEnemy + TxtCompareFoe_03),
    (stat: @Player.Strength; lo: 19; hi: MaxInt; line: TxtCompareFoe_04)
  );
  BigBeastCompareRules: array[1..4] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 15; line: TxtCompareFoe_05),
    (stat: @Player.Strength; lo: 16; hi: 20; line: TxtCompareFoe_06),
    (stat: @Player.Strength; lo: 21; hi: 22; line: TxtCompareFoe_07),
    (stat: @Player.Strength; lo: 23; hi: MaxInt; line: TxtCompareFoe_08)
  );
  FighterCompareRules: array[1..5] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 14; line: TxtCompareFoe_09),
    (stat: @Session.Overall; lo: 15; hi: 17; line: TxtCompareFoe_10),
    (stat: @Session.Overall; lo: 18; hi: 22; line: TxtCompareFoe_11),
    (stat: @Session.Overall; lo: 23; hi: 25; line: TxtCompareFoe_12),
    (stat: @Session.Overall; lo: 26; hi: MaxInt; line: TxtCompareFoe_13)
  );
  DrunkCompareRules: array[1..5] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 23; line: TxtCompareFoe_14),
    (stat: @Session.Overall; lo: 24; hi: 25; line: TxtCompareFoe_15),
    (stat: @Session.Overall; lo: 26; hi: 28; line: TxtCompareFoe_16),
    (stat: @Session.Overall; lo: 29; hi: MaxInt; line: TxtCompareFoe_17),
    (stat: @Session.Overall; lo: 35; hi: MaxInt; line: TxtCompareFoe_18)
  );
  MusicianCompareRules: array[1..3] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 20; line: TxtCompareFoe_19),
    (stat: @Session.Overall; lo: 23; hi: 27; line: TxtCompareFoe_20),
    (stat: @Session.Overall; lo: 28; hi: MaxInt; line: TxtCompareFoe_21)
  );
  IvyCompareRules: array[1..5] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 19; line: TxtCompareFoe_22),
    (stat: @Session.Overall; lo: 20; hi: 25; line: TxtCompareFoe_23),
    (stat: @Session.Overall; lo: 26; hi: 29; line: TxtCompareFoe_24),
    (stat: @Session.Overall; lo: 30; hi: MaxInt; line: TxtCompareFoe_25),
    (stat: @Session.Overall; lo: 36; hi: MaxInt; line: TxtCompareFoe_26)
  );
  LiroyCompareRules: array[1..5] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 27; line: TxtCompareFoe_27),
    (stat: @Session.Overall; lo: 28; hi: 32; line: TxtCompareFoe_28),
    (stat: @Session.Overall; lo: 33; hi: 43; line: TxtCompareFoe_29),
    (stat: @Session.Overall; lo: 44; hi: 47; line: TxtCompareFoe_30),
    (stat: @Session.Overall; lo: 48; hi: MaxInt; line: TxtCompareFoe_31)
  );
  PokrzywaCompareRules: array[1..2] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 39; line: TxtCompareFoe_32),
    (stat: @Session.Overall; lo: 40; hi: MaxInt; line: TxtCompareFoe_33)
  );

procedure CompareFoe;
begin
  if Player.Mana > 9 then begin
    Combat.Roll := Random(100);
    WriteLn(TxtCompareFoe_01);
    ReadLn(Command);
    Session.Overall := Player.Level + Player.Strength + DexterityBonus(Player.Dexterity) + ParryBonus(Skills.Values[Parry]) + KickBonus(Skills.Values[Kick]);
    if (Command = CmdDzik) or (Command = CmdSzczur) or (Command = CmdLis) or
       (Command = CmdKuropatwa) or (Command = CmdZajac) or (Command = CmdWilczur) or
       (Command = CmdOrzel) or (Command = CmdSarna) or (Command = CmdDziecko) or (Command = CmdDziadek) then
      CompareFoeRules(BeastCompareRules);
    if (Command = CmdSlon) or (Command = CmdLew) or (Command = CmdZyrafa) or (Command = CmdWielblad) or
       (Command = CmdStrus) or (Command = CmdBoa) or (Command = CmdWilk) or (Command = CmdBizon) or
       (Command = CmdPantera) or (Command = CmdWariat) or (Command = CmdSluchacz) or (Command = CmdFan) or
       (Command = CmdCzlowiek) or (Command = CmdReporter) then
      CompareFoeRules(BigBeastCompareRules);
    if (Command = CmdGladiator) or (Command = CmdWojownik) or (Command = CmdTrener) or
       (Command = CmdPolicjant) or (Command = CmdGoryl) or (Command = CmdOchroniarz) then
      CompareFoeRules(FighterCompareRules);
    if (Command = CmdMiniBarman) or (Command = CmdGrubas) or (Command = CmdDJ) then
      CompareFoeRules(DrunkCompareRules);
    if (Command = CmdTaksowkarz) or (Command = CmdSprzedawca) or (Command = CmdGitarzysta) or (Command = CmdPerkusista) or
       (Command = CmdOrganista) or (Command = CmdZebrak) or (Command = CmdPijak) or (Command = CmdZamiatacz) or (Command = CmdSzczaw) or
       (Command = CmdStokrotka) or (Command = CmdKoniczynka) or (Command = CmdMlecz) or (Command = CmdDmuchawiec) then
      CompareFoeRules(MusicianCompareRules);
    if (Command=CmdPedal) or (Command=CmdPara) or (Command=CmdMaciek) or (Command=CmdRoza) or
       (Command=CmdMalina) or (Command=CmdTrawa) or (Command = CmdAgrest) or (Command = CmdJezyna) then
      CompareFoeRules(IvyCompareRules);
    if Command = CmdLiroy then
      CompareFoeRules(LiroyCompareRules);
    if Command = CmdPokrzywa then
      CompareFoeRules(PokrzywaCompareRules);
    if (Command = CmdSpaniel) or (Command = CmdOwczarek) or (Command = CmdPiesek) or (Command=CmdJamnik) or (Command=CmdPudel) then
      WriteLn(TxtCompareFoe_34);
    if (Combat.Roll < 3) and (Skills.Values[Comparing] < 100) then begin
      WriteLn(TxtFightStars17, TxtLearnVerb, TxtCompareFoe_35);
      Skills.Values[Comparing] := Skills.Values[Comparing] + 1;
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
    Gear.Values[Armor] := Gear.Values[Armor] - 8;
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
  if Combat.Roll <= Gear.Values[Armor] then begin
    Combat.Damage := Combat.Damage - Gear.Values[WornCount];
    if Combat.Damage < 0 then Combat.Damage := 0;
    WriteLn(TxtShieldBlock_01, Combat.Damage, TxtShared_20);
  end;
end;

type
  TFightExpFunc = function(diff: Integer): Integer;
  TFightExpStat = record
    playerStat: ^Integer;
    enemyStat: ^Integer;
    expFor: TFightExpFunc;
  end;

const
  FightExpStats: array[1..3] of TFightExpStat = (
    (playerStat: @Player.MaxEnergy; enemyStat: @Combat.EnemyEnergy; expFor: FightExpForEnergy),
    (playerStat: @Player.Strength; enemyStat: @Combat.EnemyStrength; expFor: FightExpForStrength),
    (playerStat: @Player.Dexterity; enemyStat: @Combat.EnemyDexterity; expFor: FightExpForDexterity)
  );

procedure Fight;
var
  i: Integer;
begin
  for i := Low(FightExpStats) to High(FightExpStats) do
    with FightExpStats[i] do
      Combat.FightExperience := Combat.FightExperience + expFor(playerStat^ - enemyStat^);

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
      if (Skills.Values[Parry] > 0) and (Combat.Damage > 0) then begin
        Combat.Roll := Random(140);
        if Combat.Roll <= Skills.Values[Parry] then begin
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
          if (Combat.Roll < 1) and (Skills.Values[Parry] < 100) then begin
            WriteLn(TxtFightStars15, TxtLearnVerb, TxtFightParryLearn);
            Skills.Values[Parry] := Skills.Values[Parry] + 1;
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
      if Combat.Damage * 10 < Gear.Values[LuckRoll] then begin
        repeat
          Combat.Damage := Random(Player.Strength);
          WriteLn(TxtFightLuckRoll);
        until (Combat.Damage * 10) > Gear.Values[LuckRoll];
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
    if (Skills.Values[Kick] > 0) and (Player.Mana > Skills.Values[KickMinMana]) and (Player.Energy < Skills.Values[KickMaxEnergy]) then begin
      Combat.Roll := Random(100);
      if Combat.Roll <= Skills.Values[Kick] - 10 then begin
        Combat.Roll := Random(10) + Random(Player.Level);
        TextColor(14);
        WriteLn(TxtFightKickVerb, TxtFightSuperKickLabel, Combat.Roll, TxtFightTailEnergi);
        TextColor(15);
        Player.Mana := Player.Mana - Random(3) - 3;
        Combat.EnemyEnergy := Combat.EnemyEnergy - Combat.Roll;
      end else WriteLn(TxtFightKickVerb, TxtFightSuperKickMiss);
      Player.Mana := Player.Mana - Random(2) - 2;
    end;
    if (Skills.Values[Fleeing] > 0) and (Player.Energy < Skills.Values[FleeEnergy]) and (Player.Mana > 14) then begin
      Player.Mana := Player.Mana - 15;
      Combat.Roll := Random(100);
      if Combat.Roll <= Skills.Values[Fleeing] then begin
        Combat.Fled := 1;
        WriteLn(TxtFightFled);
        Player.Experience := Player.Experience - 20;
      end else WriteLn(TxtFightFleeFailed);
    end;
  until (Player.Energy < 1) or (Combat.EnemyEnergy < 1) or (Combat.Fled = 1);
  if (Combat.EnemyEnergy < 1) and (Player.Energy > 0) then begin
    if Player.MaxEnergy > 75 then Combat.FightExperience := Combat.FightExperience - 2;
    if Player.MaxEnergy > 115 then Combat.FightExperience := Combat.FightExperience - 3;
    if Skills.Values[Parry] > 50 then Combat.FightExperience := Combat.FightExperience - 2;
    if Skills.Values[Parry] > 75 then Combat.FightExperience := Combat.FightExperience - 2;
    if Skills.Values[Parry] > 95 then Combat.FightExperience := Combat.FightExperience - 1;
    if Skills.Values[Kick] > 50 then Combat.FightExperience := Combat.FightExperience - 5;
    if Skills.Values[Kick] > 95 then Combat.FightExperience := Combat.FightExperience - 2;
    if Combat.FightExperience < 0 then Combat.FightExperience := 0;
    WriteLn(TxtFightVictoryLabel, Combat.FightExperience, TxtFightVictoryTail);
    Player.Experience := Combat.FightExperience + Player.Experience;
    Combat.FireballCharges := 0;
    Combat.PoisonCharges := 0;

    if World.Quest > 0 then World.QuestKills := World.QuestKills - 1;
    if Skills.Values[Cooking] > 0 then begin
      Combat.Roll := Random(100);
      if Skills.Values[Cooking] > Combat.Roll then begin
        WriteLn(TxtFightMadeBigos);
        Bag.Bigos := Bag.Bigos - 10;
        Bag.Count := Bag.Count + 1;
        if (Combat.Roll < 1) and (Skills.Values[Cooking] < 100) then begin
          WriteLn(TxtFightCookingLearn);
          Skills.Values[Cooking] := Skills.Values[Cooking] + 1;
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
    Gear.Values[Armor] := Gear.Values[Armor] + 7;
    Gear.Values[Wearing] := 1;
    Gear.WornGarment := TxtWornSyf;
  end;
  if (Command = CmdOdlorz + CmdKomplet) and (Bag.Tracksuit <= -10) and (Gear.WornGarment = TxtWornSyf) then begin
    WriteLn(TxtUseItems_29);
    Gear.Values[Wearing] := 0;
    Gear.Values[Armor] := Gear.Values[Armor] - 7;
    Gear.WornGarment := TxtEmpty;
  end;
  if (Command = CmdUzyj + CmdListek) and (Bag.LuckyLeaf <= -10) then WriteLn(TxtUseItems_30);
  if (Command = CmdUzyj + TxtWornGarnitur) and (Bag.SpikedSuit <= -10) and (Gear.WornGarment = TxtEmpty) then begin
    WriteLn(TxtUseItems_31);
    Gear.Values[Wearing] := 1;
    Gear.Values[WornCount] := Gear.Values[WornCount] + 1;
    Gear.Values[Armor] := Gear.Values[Armor] + 10;
    Gear.Values[LuckRoll] := Gear.Values[LuckRoll] + 15;
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
    Gear.Values[Wearing] := 0;
    Gear.Values[WornCount] := Gear.Values[WornCount] - 1;
    Gear.Values[Armor] := Gear.Values[Armor] - 10;
    Gear.Values[LuckRoll] := Gear.Values[LuckRoll] - 15;
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
  BeastKills: array[1..23] of TBeastKill = (
    (cmd: CmdZabij + CmdSlimak; beast: @World.Monsters[Snail]; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdKornik; beast: @World.Monsters[Woodworm]; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdMucha; beast: @World.Monsters[Fly]; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdZuk; beast: @World.Monsters[Beetle]; fight: FightWeak; unlessFled: True),
    (cmd: CmdZabij + CmdKaraluch; beast: @World.Monsters[Cockroach]; fight: FightWeak; unlessFled: False),
    (cmd: CmdZabij + CmdMrowka; beast: @World.Monsters[Ant]; fight: FightWeak; unlessFled: False),
    (cmd: CmdZabij + CmdPajak; beast: @World.Monsters[Spider]; fight: FightWeak; unlessFled: False),
    (cmd: CmdZabij + CmdDzik; beast: @World.Monsters[Boar]; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdSzczur; beast: @World.Monsters[Rat]; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdLis; beast: @World.Monsters[Fox]; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdKuropatwa; beast: @World.Monsters[Partridge]; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdZajac; beast: @World.Monsters[Hare]; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdOrzel; beast: @World.Monsters[Eagle]; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdSarna; beast: @World.Monsters[Deer]; fight: FightWeakish; unlessFled: False),
    (cmd: CmdZabij + CmdSlon; beast: @World.Monsters[Elephant]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdLew; beast: @World.Monsters[Lion]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdZyrafa; beast: @World.Monsters[Giraffe]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdWilk; beast: @World.Monsters[Wolf]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdWielblad; beast: @World.Monsters[Camel]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdStrus; beast: @World.Monsters[Ostrich]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdBoa; beast: @World.Monsters[Boa]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdBizon; beast: @World.Monsters[Bison]; fight: FightMedium; unlessFled: False),
    (cmd: CmdZabij + CmdPantera; beast: @World.Monsters[Panther]; fight: FightMedium; unlessFled: False)
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
      if (Command = CmdZabij + CmdBakteria) and (Session.Room = World.Monsters[Bacterium]) then
      begin FightWeak;
        World.Monsters[Bacterium] := 0;
        WriteLn(TxtArenaMaze_02);
      end;
      for bi := Low(BeastKills) to High(BeastKills) do
        with BeastKills[bi] do
          if unlessFled then
            KillBeastUnlessFled(cmd, beast^, fight)
          else
            KillBeast(cmd, beast^, fight);
      if (Command = CmdZabij + CmdWilczur) and (Session.Room = World.Monsters[Mongrel]) then
      begin WriteLn(TxtArenaMaze_03);
        FightWeakish;
        World.Monsters[Mongrel] := 0;
      end;

      if (Command = CmdZabij + CmdGladiator) and (Session.Room = World.Monsters[Gladiator]) then
      begin FightHard;
        World.Monsters[Gladiator] := 0;
        PillGain;
      end;
      if (Command = CmdZabij + CmdWojownik) and (Session.Room = World.Monsters[Warrior]) then
      begin FightHard;
        World.Monsters[Warrior] := 0;
        PillGain;
      end;
      if (Command = CmdZabij + CmdTrener) and (Session.Room = World.Monsters[Tamer]) then
      begin FightHard;
        World.Monsters[Tamer] := 0;
        SuitGain;
      end;
      if Command = CmdExit then
        case Session.Room of
          RoomArena33:
            WriteExits([TxtShared_03,
                        TxtExitPolodnie, TxtPlaceWejscieNaArene,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
          RoomArena34, RoomArena37, RoomArena38, RoomArena39,
          RoomArena42, RoomArena43, RoomArena44, RoomArena48,
          RoomArena49:
            WriteExits([TxtShared_03,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
          RoomArena35, RoomArena36:
            WriteExits([TxtShared_03,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
          RoomArena40:
            WriteExits([TxtShared_03,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
          RoomArena41:
            WriteExits([TxtShared_03,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena]);
          RoomArena45, RoomArena50, RoomArena54:
            WriteExits([TxtArenaMaze_08,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
          RoomArena46, RoomArena51, RoomArena55:
            WriteExits([TxtArenaMaze_08,
                        TxtExitPolnoc, TxtPlaceArena,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena]);
          RoomArena47, RoomArena52, RoomArena53:
            WriteExits([TxtArenaMaze_09,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitWschod, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
          RoomArena56:
            WriteExits([TxtArenaMaze_10,
                        TxtExitPolodnie, TxtPlaceArena,
                        TxtExitZachod, TxtPlaceArena]);
          RoomArena57:
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
  if (Command = CmdZabij + CmdPerkusista) and (World.Monsters[Drummer] = Session.Room) then begin
    FightVeryEasy;
    World.Monsters[Drummer] := 0;
    CassetteGain;
  end;
  if (Command = CmdZabij + CmdGitarzysta) and (World.Monsters[Guitarist] = Session.Room) then begin
    FightVeryEasy;
    World.Monsters[Guitarist] := 0;
    CassetteGain;
  end;
  if (Command = CmdZabij + CmdLiroy) and (World.Monsters[Liroy] = Session.Room) then begin
    FightNotEasy;
    if (Session.Room <> DeadRoom) and (Player.Energy > 0) and (Combat.Fled = 0) then begin
      WriteLn(TxtStageFights_01);
      Player.Money := Player.Money + 30;
      CassetteGain;
      if World.Quest > 1 then World.QuestKills := World.QuestKills - 150;
      World.Monsters[Liroy] := 0;
    end;
  end;
  if (Command = CmdZabij + CmdOrganista) and (World.Monsters[Keyboardist] = Session.Room) then begin
    FightVeryEasy;
    World.Monsters[Keyboardist] := 0;
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

type
  TPlantKill = record
    cmd: string;
    plant: ^Integer;
  end;

const
  PlantKills: array[1..4] of TPlantKill = (
    (cmd: CmdZabij + CmdSzczaw; plant: @World.Monsters[Sorrel]),
    (cmd: CmdZabij + CmdKoniczynka; plant: @World.Monsters[Clover]),
    (cmd: CmdZabij + CmdMlecz; plant: @World.Monsters[SowThistle]),
    (cmd: CmdZabij + CmdDmuchawiec; plant: @World.Monsters[Dandelion])
  );

  EasyPlantKills: array[1..5] of TPlantKill = (
    (cmd: CmdZabij + CmdRoza; plant: @World.Monsters[Rose]),
    (cmd: CmdZabij + CmdOset; plant: @World.Monsters[Thistle]),
    (cmd: CmdZabij + CmdMalina; plant: @World.Monsters[Raspberry]),
    (cmd: CmdZabij + CmdAgrest; plant: @World.Monsters[Gooseberry]),
    (cmd: CmdZabij + CmdJezyna; plant: @World.Monsters[Blackberry])
  );

procedure PlantFights;
var
  i: Integer;
begin
  if (Command = CmdZabij + CmdDuncan) and (World.Monsters[Duncan] = Session.Room) then begin
    FightEasy;
    if Combat.EnemyEnergy < 1 then World.Monsters[Duncan] := 0;
  end;
  if (Command = CmdSecret + CmdLista) and (World.Monsters[Duncan] = Session.Room) then begin
    WriteLines(TxtPlantFightsLines1);
  end;
  if Command = CmdKup + CmdDokument then begin if Player.Money > 399 then begin
      WriteLn(TxtPlantFights_05);
      Bag.Permit := Bag.Permit - 10;
      Player.Money := Player.Money - 400;
      Bag.Count := Bag.Count + 1; end;
  end;
  if (Command = CmdKup + CmdPlecak) and (World.Monsters[Duncan] = Session.Room) then begin if Player.Money > 4799 then begin
      WriteLn(TxtPlantFights_06);
      Player.Money := Player.Money - 4800;
      Bag.Backpack := Bag.Backpack - 10;
      Bag.Count := Bag.Count + 1; end;
  end;
  if (Command = CmdRozmawiaj + CmdDuncan) and (World.Monsters[Duncan] = Session.Room) then begin
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

  for i := Low(PlantKills) to High(PlantKills) do
    with PlantKills[i] do
      KillPlant(cmd, plant^);

  KillPlantIfAlive(CmdZabij + CmdStokrotka, World.Monsters[Daisy]);

  for i := Low(EasyPlantKills) to High(EasyPlantKills) do
    with EasyPlantKills[i] do
      KillPlantEasyIfAlive(cmd, plant^);

  if (Command = CmdZabij + CmdTrawa) and (World.Monsters[Grass] = Session.Room) then begin
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

  TCommandEntry = record
    cmd: string;
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

procedure ChooseRace; forward;
procedure Checkpoints; forward;
procedure CheckLevelUp; forward;
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

type
  TSheetKind = (ikShown, ikDiv10, ikPlain);
  TSheetItem = record
    item: ^Integer;
    desc: string;
    width: Integer;
    kind: TSheetKind;
  end;

const
  SheetItems: array[1..22] of TSheetItem = (
    (item: @Bag.OldSword; desc: CmdStaryZardzewialyMiecz; width: 0; kind: ikShown),
    (item: @Bag.SmallShield; desc: CmdOkraglaMalaTarcza; width: 0; kind: ikShown),
    (item: @Bag.Heart; desc: CmdZakrwawioneSerce; width: 0; kind: ikShown),
    (item: @Bag.Diploma; desc: CmdDyplomMudSzkoly; width: 0; kind: ikShown),
    (item: @Bag.Doughnut; desc: CmdSmacznyPolanyLikieremPaczek; width: 10; kind: ikShown),
    (item: @Bag.Cookie; desc: CmdSmaczneCiastko; width: 10; kind: ikShown),
    (item: @Bag.DryRation; desc: CmdTwardaSuchaRacje; width: 10; kind: ikShown),
    (item: @Bag.BreadRoll; desc: CmdOkraglaPachnacaBulka; width: 10; kind: ikShown),
    (item: @Bag.Bread; desc: CmdDuzyCieplyChleb; width: 10; kind: ikShown),
    (item: @Bag.Sausage; desc: CmdDlugaISmacznaWeke; width: 10; kind: ikShown),
    (item: @Bag.Bigos; desc: CmdPysznyBigosZKapustaZWroga; width: 10; kind: ikShown),
    (item: @Bag.Beer; desc: CmdOzewiajacePiwskoZKonkretnymKlimatem; width: 0; kind: ikDiv10),
    (item: @Bag.Pipe; desc: CmdCiezkaFajkaOdDziadaMroza; width: 0; kind: ikPlain),
    (item: @Bag.Tracksuit; desc: CmdKompletUbranFirmySyf; width: 0; kind: ikPlain),
    (item: @Bag.SpikedSuit; desc: CmdGarniturZKolcami; width: 0; kind: ikPlain),
    (item: @Bag.ManaBottle; desc: CmdMalaButelkeMany; width: 0; kind: ikPlain),
    (item: @Bag.LuckyLeaf; desc: CmdDelikatnyChocSzorstkiListek; width: 0; kind: ikPlain),
    (item: @Bag.Cassette; desc: CmdKasetaLiroyaLJakLiroy; width: 0; kind: ikPlain),
    (item: @Bag.TeleportPill; desc: CmdPigulkaTransportujacaMG; width: 0; kind: ikPlain),
    (item: @Bag.Permit; desc: CmdPrzepustkaWlasnoreczniePodpisanaPrzezQuestMastera; width: 0; kind: ikPlain),
    (item: @Bag.CompareScroll; desc: CmdScrollZCzaremPorownywanie; width: 0; kind: ikPlain),
    (item: @Bag.ReturnScroll; desc: CmdScrollZCzaremPowrot; width: 0; kind: ikPlain)
  );

procedure ShowCharacter;

var
  i, gap, si: Integer;
begin

  for i := High(DexterityItemLimits) downto Low(DexterityItemLimits) do
    if Player.Dexterity >= DexterityItemLimits[i].gate then begin
      Bag.Limit := DexterityItemLimits[i].limit;
      Break;
    end;
  if Bag.Backpack < 0 then Bag.Limit := Bag.Limit + 4;
  WriteLn(TxtShowCharacter_01);
  for si := Low(SheetItems) to High(SheetItems) do
    with SheetItems[si] do
      case kind of
        ikShown: ShowItem(item^, desc, width);
        ikDiv10: ShowItemDiv10(item^, desc);
        ikPlain: ShowItemPlain(item^, desc);
      end;
  WriteLn(TxtShowCharacter_02, Bag.Count, TxtShowCharacter_03, Bag.Limit, TxtShowCharacter_04);
  if Gear.Values[WeaponKind] = 0 then WriteLn(TxtShowCharacter_05);
  if Gear.Values[ShieldKind] = 0 then WriteLn(TxtShowCharacter_06);
  if Gear.WornGarment = TxtEmpty then WriteLn(TxtShowCharacter_07);
  if Gear.WornGarment = TxtWornSyf then WriteLn(TxtWearingLabel, TxtShowCharacter_08);
  if Gear.WornGarment = TxtWornGarnitur then WriteLn(TxtWearingLabel, TxtShowCharacter_09);
  if (Gear.Values[ShieldKind] = 1) and (Bag.SmallShield = -100) then
    WriteLn(TxtShowCharacter_10);
  if (Gear.Values[WeaponKind] = 1) and (Bag.OldSword = -100) then
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
  Gear.Values[ArmorRating] := 10 * Gear.Values[WornCount] + Gear.Values[Armor];
  WriteLn(TxtShowCharacter_24, Gear.Values[ArmorRating],
         TxtShowCharacter_25, Gear.Values[LuckRoll]);
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
  World.Monsters[CageWeakling] := RoomCageWeakling;

  World.Monsters[CageStrong] := RoomCageStrong;
  World.Monsters[CageAgile] := RoomCageAgile;
  World.Monsters[CageTough] := RoomCageTough;
  World.Monsters[CageHuge] := RoomCageHuge;

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
  if (Command = CmdZabij + CmdZamiatacz) and (World.Monsters[Sweeper] = Session.Room) then begin
    FightVeryEasy;
    World.Monsters[Sweeper] := 0;
    Combat.Roll := Random(100);
    if (Combat.Roll < 35) and (Bag.Tracksuit = 0) then begin
      WriteLn(TxtKillSweeper_01);
      Bag.Tracksuit := Bag.Tracksuit - 10;
    end;
  end;
end;

procedure KillSickMan;

begin
  if (Command = CmdZabij + CmdZebrak) and (World.Monsters[SickMan] = Session.Room) then begin
    FightVeryEasy;
    if Player.Energy > 0 then begin
      Combat.Roll := Random(10);
      WriteLn(TxtKillSickMan_01,
              Combat.Roll, TxtShared_23);
      Player.Money := Player.Money + Combat.Roll;
      World.Monsters[SickMan] := 0;
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
  StreetDogs: array[1..5] of TStreetKill = (
    (cmd: CmdZabij + CmdOwczarek; target: @World.Monsters[Shepherd]; extra: False),
    (cmd: CmdZabij + CmdPiesek; target: @World.Monsters[Pooch]; extra: False),
    (cmd: CmdZabij + CmdJamnik; target: @World.Monsters[Dachshund]; extra: False),
    (cmd: CmdZabij + CmdSpaniel; target: @World.Monsters[Spaniel]; extra: True),
    (cmd: CmdZabij + CmdPudel; target: @World.Monsters[Poodle]; extra: False)
  );
  StreetFolk: array[1..3] of TStreetKill = (
    (cmd: CmdZabij + CmdTaksowkarz; target: @World.Monsters[Cabman]; extra: True),
    (cmd: CmdZabij + CmdSprzedawca; target: @World.Monsters[Vendor]; extra: True),
    (cmd: CmdZabij + CmdPijak; target: @World.Monsters[Drunkard]; extra: False)
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

type
  TTrainingLine = record
    wisdom, strength, dexterity: Integer;
    text1: string;
  end;

const
  TrainingLines: array[1..24] of TTrainingLine = (
    (wisdom: 10; strength: 11; dexterity: -1; text1: TxtTraining_03),
    (wisdom: 10; strength: -1; dexterity: 10; text1: TxtTraining_04),
    (wisdom: 15; strength: -1; dexterity: 11; text1: TxtTraining_05),
    (wisdom: 11; strength: -1; dexterity: -1; text1: TxtTraining_06),
    (wisdom: 18; strength: -1; dexterity: -1; text1: TxtTraining_07),
    (wisdom: 17; strength: -1; dexterity: -1; text1: TxtTraining_08),
    (wisdom: -1; strength: -1; dexterity: 20; text1: TxtTraining_09),
    (wisdom: -1; strength: 20; dexterity: 10; text1: TxtTraining_10),
    (wisdom: 19; strength: 10; dexterity: 10; text1: TxtTraining_11),
    (wisdom: 12; strength: 25; dexterity: -1; text1: TxtTraining_12),
    (wisdom: 14; strength: 29; dexterity: -1; text1: TxtTraining_13),
    (wisdom: -1; strength: -1; dexterity: 22; text1: TxtTraining_14),
    (wisdom: -1; strength: -1; dexterity: 28; text1: TxtTraining_15),
    (wisdom: 22; strength: -1; dexterity: -1; text1: TxtTraining_16),
    (wisdom: 23; strength: -1; dexterity: -1; text1: TxtTraining_17),
    (wisdom: 14; strength: 14; dexterity: 24; text1: TxtTraining_18),
    (wisdom: 24; strength: -1; dexterity: -1; text1: TxtTraining_19),
    (wisdom: 26; strength: -1; dexterity: -1; text1: TxtTraining_20),
    (wisdom: 19; strength: 12; dexterity: 12; text1: TxtTraining_21),
    (wisdom: 16; strength: -1; dexterity: 22; text1: TxtTraining_22),
    (wisdom: -1; strength: -1; dexterity: 30; text1: TxtTraining_23),
    (wisdom: 29; strength: -1; dexterity: -1; text1: TxtTraining_24),
    (wisdom: 19; strength: -1; dexterity: -1; text1: TxtTraining_25),
    (wisdom: 23; strength: -1; dexterity: 12; text1: TxtTraining_26)
  );

function GatesMet(wisdom, strength, dexterity: Integer): Boolean;
begin
  GatesMet :=
    ((wisdom = -1) or (Player.Wisdom > wisdom)) and
    ((strength = -1) or (Player.Strength > strength)) and
    ((dexterity = -1) or (Player.Dexterity > dexterity));
end;

procedure Training;
var
  i: Integer;
begin
  if Command = CmdPatrz + CmdPlakat then begin
    WriteLn(TxtShared_13);
    WriteLn(TxtTraining_01);
    if Player.Wisdom < 11 then WriteLn(TxtTraining_02);
    for i := Low(TrainingLines) to High(TrainingLines) do
      if GatesMet(TrainingLines[i].wisdom, TrainingLines[i].strength,
                  TrainingLines[i].dexterity) then
        WriteLn(TrainingLines[i].text1);
    WriteLn(TxtTraining_27);
  end;

  if Command = CmdCwicz + CmdKopac then
    if (Player.Wisdom > 10) and (Player.Strength > 11) and (Player.Practice > 0) then begin
      Skills.Values[Kick] := Skills.Values[Kick] + Player.Wisdom;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingDigging, TxtTrainingThreshold, Skills.Values[Kick],
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + CmdUciekac then begin
    if Player.Wisdom > 10 then
      if Player.Dexterity > 10 then
        if (Player.Practice > 0) and (Skills.Values[Fleeing] < 85) then begin
          Skills.Values[Fleeing] := Skills.Values[Fleeing] + Player.Wisdom + Player.Dexterity - 5;
          Player.Practice := Player.Practice - 1;
          WriteLn(TxtTrainingVerb, TxtTrainingFleeing, TxtTrainingThreshold, Skills.Values[Fleeing],
                  TxtTraining_29, Player.Practice, TxtShared_19);
        end else
          WriteLn(TxtTraining_31);
  end;

  if Command = CmdCwicz + CmdPowrot then
    if (Player.Wisdom > 17) and (Skills.Values[Returning] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Returning] := Skills.Values[Returning] + 2 * Player.Wisdom - 3;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingReturning, TxtTrainingThreshold, Skills.Values[Returning],
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + TxtTrainingParrying then
    if (Player.Wisdom > 15) and (Player.Dexterity > 11) and (Skills.Values[Parry] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Parry] := Skills.Values[Parry] + Player.Wisdom + Player.Dexterity - 14;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingParrying, TxtTrainingThreshold, Skills.Values[Parry],
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + CmdPorownanie then
    if (Player.Wisdom > 11) and (Skills.Values[Comparing] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Comparing] := Skills.Values[Comparing] + 3 * Player.Wisdom - 9;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingComparing, TxtTrainingThreshold, Skills.Values[Comparing],
              TxtTraining_29, Player.Practice, TxtShared_19);
    end;

  if Command = CmdCwicz + TxtTrainingCooking then
    if (Player.Wisdom > 18) and (Skills.Values[Cooking] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Cooking] := Skills.Values[Cooking] + Player.Wisdom + 1;
      Player.Practice := Player.Practice - 1;
      WriteLn(TxtTrainingVerb, TxtTrainingCooking, TxtTrainingThreshold, Skills.Values[Cooking],
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
  SaveSlot(Skills.Values[Comparing]);
  SaveSlot(Player.MaxMana);
  SaveSlot(Player.MaxStrength);
  SaveSlot(Player.MaxDexterity);
  SaveSlot(Player.MaxWisdom);
  SaveSlot(Bag.Count);
  SaveSlot(Gear.Values[Armor]);
  SaveSlot(Gear.Values[LuckRoll]);
  SaveSlot(Gear.Values[WeaponKind]);
  SaveSlot(Gear.Values[Wearing]);
  SaveSlot(Session.Overall);
  SaveSlot(Session.SavedFlag);
  SaveSlot(World.Monsters[CageWeakling]);
  SaveSlot(World.Monsters[CageStrong]);
  SaveSlot(World.Monsters[CageAgile]);
  SaveSlot(World.Monsters[CageTough]);
  SaveSlot(World.Monsters[CageHuge]);
  SaveSlot(Gear.Values[ShieldKind]);
  SaveSlot(Gear.Values[ArmorRating]);
  SaveSlot(Skills.Values[Cooking]);
  SaveSlot(Skills.Values[CookingDisplayBug]);
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
  SaveSlot(Gear.Values[WornCount]);
  SaveSlot(Skills.Values[Parry]);
  SaveSlot(Skills.Values[Kick]);
  SaveSlot(Skills.Values[KickMinMana]);
  SaveSlot(Skills.Values[KickMaxEnergy]);
  SaveSlot(Skills.Values[Fleeing]);
  SaveSlot(Skills.Values[FleeEnergy]);
  SaveSlot(Combat.Fled);
  SaveSlot(Session.InArena);
  SaveSlot(Bag.Tracksuit);
  SaveSlot(Bag.Cassette);
  SaveSlot(Bag.TeleportPill);
  SaveSlot(World.Monsters[Woodworm]);
  SaveSlot(World.Monsters[Fly]);
  SaveSlot(World.Monsters[Bacterium]);
  SaveSlot(World.Quest);
  SaveSlot(World.QuestKills);
  SaveSlot(World.Monsters[Snail]);
  SaveSlot(Bag.LuckyLeaf);
  SaveSlot(Skills.Values[Returning]);
  SaveSlot(Bag.Bigos);
  SaveSlot(Bag.Beer);
  SaveSlot(Bag.CompareScroll);
  SaveSlot(Bag.ReturnScroll);
  SaveSlot(World.OldElf);
  SaveSlot(World.DuncanQuest);
  SaveSlot(Bag.Backpack);
  SaveSlot(World.Monsters[Duncan]);
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

type
  TBakeryItem = record
    cmd: string;
    item: ^Integer;
    price: Integer;
    desc: string;
  end;

const
  BakeryItems: array[1..6] of TBakeryItem = (
    (cmd: CmdKup + CmdPaczek; item: @Bag.Doughnut; price: 8; desc: TxtItemPaczek),
    (cmd: CmdKup + CmdCiastko; item: @Bag.Cookie; price: 12; desc: TxtItemCiastko),
    (cmd: CmdKup + CmdSuchaRacja; item: @Bag.DryRation; price: 15; desc: TxtItemSuchaRacje),
    (cmd: CmdKup + CmdBulka; item: @Bag.BreadRoll; price: 19; desc: TxtItemBulke),
    (cmd: CmdKup + CmdChleb; item: @Bag.Bread; price: 24; desc: TxtItemChleb),
    (cmd: CmdKup + CmdWeka; item: @Bag.Sausage; price: 29; desc: TxtItemWeke)
  );

procedure BakeryShop;

var
  bi2: Integer;
begin
  if Command = CmdLista then begin
    WriteLines(TxtBakeryShopLines1);
  end;
  StreetFights;
  for bi2 := Low(BakeryItems) to High(BakeryItems) do
    with BakeryItems[bi2] do
      BuyItem(cmd, item^, price, desc, True);
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
  Gear.Values[Armor] := Gear.Values[Armor] - 8;
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
  Gear.Values[Armor] := Gear.Values[Armor] + 8;
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
  if (Command = CmdZabij + CmdDziecko) and (World.Monsters[Kid] = Session.Room) then begin
    FightWeakish;
    if Combat.EnemyEnergy < 1 then World.Monsters[Kid] := 0;
  end;
  if (Command = CmdZabij + CmdDziadek) and (World.Monsters[OldMan] = Session.Room) then begin
    FightWeakish;
    if Combat.EnemyEnergy < 1 then begin
      World.Monsters[OldMan] := 0;
      Combat.Roll := Random(100);
      if (Combat.Roll < 5) and (Bag.Pipe = 0) then begin
        WriteLn(TxtShared_08, TxtConcertFights_01);
        WriteLn(TxtConcertFights_02);
        Bag.Pipe := Bag.Pipe - 10;
        Player.Wisdom := Player.Wisdom + 1;
      end;
    end;
  end;
  if (Command = CmdZabij + CmdWariat) and (World.Monsters[Lunatic] = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Monsters[Lunatic] := 0;
  end;
  if (Command = CmdZabij + CmdSluchacz) and (World.Monsters[Listener] = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Monsters[Listener] := 0;
  end;
  if (Command = CmdZabij + CmdCzlowiek) and (World.Monsters[Man] = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Monsters[Man] := 0;
  end;
  if (Command = CmdZabij + CmdFan) and (World.Monsters[Fan] = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Monsters[Fan] := 0;
  end;
  if (Command = CmdZabij + CmdReporter) and (World.Monsters[Reporter] = Session.Room) then begin
    FightMedium;
    if Combat.EnemyEnergy < 1 then World.Monsters[Reporter] := 0;
  end;
  if (Command = CmdZabij + CmdPolicjant) and (World.Monsters[Policeman] = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Monsters[Policeman] := 0;
  end;
  if (Command = CmdZabij + CmdGoryl) and (World.Monsters[Gorilla] = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Monsters[Gorilla] := 0;
    SuitGain;
  end;
  if (Command = CmdZabij + CmdOchroniarz) and
     (World.Monsters[Bouncer] = Session.Room) then begin
    FightHard;
    if Combat.EnemyEnergy < 1 then World.Monsters[Bouncer] := 0;
    SuitGain;
  end;
end;

type
  TCheckpoint = record
    exp, stage, next, loStr, hiStr: Integer;
  end;

const
  CheckpointRules: array[1..6] of TCheckpoint = (
    (exp: 400; stage: 0; next: 1; loStr: -MaxInt - 1; hiStr: 19),
    (exp: 180; stage: 0; next: 1; loStr: -MaxInt - 1; hiStr: 7),
    (exp: 360; stage: 1; next: 2; loStr: -MaxInt - 1; hiStr: 7),
    (exp: 540; stage: 2; next: 3; loStr: -MaxInt - 1; hiStr: 7),
    (exp: 300; stage: 0; next: 1; loStr: 8; hiStr: 12),
    (exp: 500; stage: 1; next: 2; loStr: 8; hiStr: 12)
  );

procedure ReachCheckpoint(exp, stage, next, loStr, hiStr: Integer);
begin
  if (Player.Experience >= exp) and (Session.CheckpointStage = stage)
    and (Player.Strength >= loStr) and (Player.Strength <= hiStr) then begin
    WriteLn(TxtCheckpoints_01);
    Session.CheckpointStage := next;
    SpawnMonsters;
  end;
end;

procedure Checkpoints;

var
  ci: Integer;
begin
  for ci := Low(CheckpointRules) to High(CheckpointRules) do
    with CheckpointRules[ci] do
      ReachCheckpoint(exp, stage, next, loStr, hiStr);
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
  LoadSlot(Skills.Values[Comparing]);
  LoadSlot(Player.MaxMana);
  LoadSlot(Player.MaxStrength);
  LoadSlot(Player.MaxDexterity);
  LoadSlot(Player.MaxWisdom);
  LoadSlot(Bag.Count);
  LoadSlot(Gear.Values[Armor]);
  LoadSlot(Gear.Values[LuckRoll]);
  LoadSlot(Gear.Values[WeaponKind]);
  LoadSlot(Gear.Values[Wearing]);
  LoadSlot(Session.Overall);
  LoadSlot(Session.SavedFlag);
  LoadSlot(World.Monsters[CageWeakling]);
  LoadSlot(World.Monsters[CageStrong]);
  LoadSlot(World.Monsters[CageAgile]);
  LoadSlot(World.Monsters[CageTough]);
  LoadSlot(World.Monsters[CageHuge]);
  LoadSlot(Gear.Values[ShieldKind]);
  LoadSlot(Gear.Values[ArmorRating]);
  LoadSlot(Skills.Values[Cooking]);
  LoadSlot(Skills.Values[CookingDisplayBug]);
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
  LoadSlot(Gear.Values[WornCount]);
  LoadSlot(Skills.Values[Parry]);
  LoadSlot(Skills.Values[Kick]);
  LoadSlot(Skills.Values[KickMinMana]);
  LoadSlot(Skills.Values[KickMaxEnergy]);
  LoadSlot(Skills.Values[Fleeing]);
  LoadSlot(Skills.Values[FleeEnergy]);
  LoadSlot(Combat.Fled);
  LoadSlot(Session.InArena);
  LoadSlot(Bag.Tracksuit);
  LoadSlot(Bag.Cassette);
  LoadSlotShort(Bag.TeleportPill);
  LoadSlot(World.Monsters[Woodworm]);
  LoadSlot(World.Monsters[Fly]);
  LoadSlot(World.Monsters[Bacterium]);
  LoadSlot(World.Quest);
  LoadSlot(World.QuestKills);
  LoadSlot(World.Monsters[Snail]);
  LoadSlotShort(Bag.LuckyLeaf);
  LoadSlot(Skills.Values[Returning]);
  LoadSlotShort(Bag.Bigos);
  LoadSlot(Bag.Beer);
  LoadSlot(Bag.CompareScroll);
  LoadSlot(Bag.ReturnScroll);
  LoadSlot(World.OldElf);
  LoadSlotShort(World.DuncanQuest);
  LoadSlotShort(Bag.Backpack);
  LoadSlot(World.Monsters[Duncan]);
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
  Gear.Values[WornCount] := 0;
  Gear.Values[Armor] := 0;
  Gear.Values[LuckRoll] := 0;
end;

procedure CmdStrip;
begin
  Gear.Values[Wearing] := 0;
  Gear.Values[WeaponKind] := 0;
  Gear.Values[ShieldKind] := 0;
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
  if (Bag.OldSword = -10) and (Gear.Values[WeaponKind] = 0) then begin
    Bag.OldSword := -100;
    Gear.Values[WeaponKind] := 1;
    WriteLn(TxtCmdWieldOldSword_01);
    Player.Strength := Player.Strength + 1;
    Gear.Values[LuckRoll] := Gear.Values[LuckRoll] + 3;
  end;
end;

procedure CmdUnwieldOldSword;
begin
  if (Bag.OldSword = -100) and (Gear.Values[WeaponKind] = 1) then begin
    Bag.OldSword := -10;
    Gear.Values[WeaponKind] := 0;
    WriteLn(TxtCmdUnwieldOldSword_01);
    Player.Strength := Player.Strength - 1;
    Gear.Values[LuckRoll] := Gear.Values[LuckRoll] - 3;
  end;
end;

procedure CmdWieldSmallShield;
begin
  if (Gear.Values[ShieldKind] = 0) and (Bag.SmallShield = -10) then begin
    Gear.Values[ShieldKind] := 1;
    Gear.Values[Armor] := Gear.Values[Armor] + 15;
    Gear.Values[WornCount] := Gear.Values[WornCount] + 1;
    Bag.SmallShield := -100;
    WriteLn(TxtCmdWieldSmallShield_01);
  end;
end;

procedure CmdUnwieldSmallShield;
begin
  if (Gear.Values[ShieldKind] = 1) and (Bag.SmallShield = -100) then begin
    Gear.Values[ShieldKind] := 0;
    Gear.Values[Armor] := Gear.Values[Armor] - 15;
    Gear.Values[WornCount] := Gear.Values[WornCount] - 1;
    Bag.SmallShield := -10;
    WriteLn(TxtCmdUnwieldSmallShield_01);
  end;
end;

procedure CmdSetFleeEnergy;
begin
  if Skills.Values[Fleeing] > 0 then begin
    WriteLn(TxtCmdSetFleeEnergy_01);
    ReadLn(Skills.Values[FleeEnergy]);
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
  if Skills.Values[Comparing] > 0 then begin
    Combat.Roll := Random(100);
    if Skills.Values[Comparing] > Combat.Roll then begin
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

const
  RefusedFood: array[1..8] of string = (
    CmdOdrzuc + CmdPaczek, CmdOdrzuc + CmdCiastko,
    CmdOdrzuc + CmdSuchaRacja, CmdOdrzuc + CmdBulka,
    CmdOdrzuc + CmdChleb, CmdOdrzuc + CmdWeka,
    CmdOdrzuc + CmdSerce, CmdOdrzuc + CmdBigos);

procedure CmdRefuseFoodDrop;
var
  i: Integer;
begin
  for i := Low(RefusedFood) to High(RefusedFood) do
    if Command = RefusedFood[i] then begin
      WriteLn(TxtCmdRefuseFoodDrop_01);
      Break;
    end;
end;

procedure CmdOpenPortal;
begin
  if ((Command = CmdPowrot) and (Skills.Values[Returning] > 0)) or
   ((Command = CmdUzyj + CmdScrollPowrot) and (Bag.ReturnScroll < 0)) then begin
    Combat.Roll := Random(100);
    if Command = CmdUzyj + CmdScrollPowrot then begin
      Combat.Roll := Random(1);
      Bag.ReturnScroll := Bag.ReturnScroll + 10;
      Bag.Count := Bag.Count - 1;
    end;
    if Combat.Roll <= Skills.Values[Returning] then begin
      WriteLn(TxtCmdOpenPortal_01);
      Player.Mana := Player.Mana - 15;
      Session.OuterRoom := RoomCityCentre;
    end;
    if (Combat.Roll > Skills.Values[Returning]) and (Skills.Values[Returning] + 30 > Combat.Roll) then begin
      WriteLn(TxtCmdOpenPortal_02);
      Player.Mana := Player.Mana - 5;
    end;
    if Skills.Values[Returning] + 29 < Combat.Roll then begin
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
  if Skills.Values[Kick] > 0 then begin
    WriteLn(TxtCmdSetKickThresholds_01);
    WriteLn(TxtCmdSetKickThresholds_02);
    ReadLn(Skills.Values[KickMaxEnergy]);
    WriteLn(TxtCmdSetKickThresholds_03);
    ReadLn(Skills.Values[KickMinMana]);
  end;
end;

procedure CmdSpeede;
begin
  Bag.Permit := Bag.Permit - 10;
end;

type
  TSkillLine = record
    wisdom, strength, dexterity: Integer;
    text1: string;
    skill: ^Integer;
    text2: string;
  end;

const
  SkillLines: array[1..6] of TSkillLine = (
    (wisdom: 10; strength: 11; dexterity: -1; text1: TxtCmdShowSkills_01; skill: @Skills.Values[Kick]; text2: TxtShared_26),
    (wisdom: 10; strength: -1; dexterity: 10; text1: TxtCmdShowSkills_02; skill: @Skills.Values[Fleeing]; text2: TxtShared_26),
    (wisdom: 15; strength: -1; dexterity: 11; text1: TxtCmdShowSkills_03; skill: @Skills.Values[Parry]; text2: TxtShared_26),
    (wisdom: 11; strength: -1; dexterity: -1; text1: TxtCmdShowSkills_04; skill: @Skills.Values[Comparing]; text2: TxtShared_26),
    (wisdom: 18; strength: -1; dexterity: -1; text1: TxtCmdShowSkills_05; skill: @Skills.Values[CookingDisplayBug]; text2: TxtShared_26),
    (wisdom: 19; strength: -1; dexterity: -1; text1: TxtCmdShowSkills_06; skill: @Skills.Values[Returning]; text2: TxtShared_26)
  );

procedure CmdShowSkills;
var
  i: Integer;
begin
  for i := Low(SkillLines) to High(SkillLines) do
    if GatesMet(SkillLines[i].wisdom, SkillLines[i].strength,
                SkillLines[i].dexterity) then
      with SkillLines[i] do
        WriteLn(text1, skill^, text2);
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

procedure Start;
label
  L1012_TrancePrompt, L1025_Exit;
var
  gi, ti: Integer;
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
    DispatchRooms;
    if Session.ExitRequested then goto L1025_Exit;

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
