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

  TFoe = (WeakEnemy, WeakishEnemy, MediumEnemy, HardEnemy, VeryEasyEnemy,
    EasyEnemy, NotEasyEnemy, VeryHardEnemy);

  TStat = (Strength, Dexterity, Wisdom, MaxStrength, MaxDexterity,
    MaxWisdom);
  TPlayer = record
    Stats: array[TStat] of Integer;
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

  TBagItem = (Backpack, OldSword, SmallShield, Heart, Diploma, Pipe,
    Doughnut, Cookie, DryRation, Bread, BreadRoll, Sausage, Bigos,
    ManaBottle, Tracksuit, SpikedSuit, Cassette, CompareScroll,
    TeleportPill, LuckyLeaf, ReturnScroll, Beer);
  TBag = record
    Count: Integer;
    Limit: Integer;
    Permit: Longint;
    Items: array[TBagItem] of Integer;
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

  ItemUnit = 10;

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
  procedure DoFight;
  procedure ArenaMaze;
  procedure DescribeBeasts;
  procedure EnterTrance;
  procedure Fight(foe: TFoe);
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
  procedure ReadCommand;
  procedure CheckMode;
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

const
  SaveLevelBias = $17;
  SaveEnergyBias = $28;
  SaveStrengthBias = 24;
  SaveDexterityBias = 12;
  SaveStatScale = 4;

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
  TryLoot(Bag.Items[OldSword], threshold, TxtShared_10);
  TryLoot(Bag.Items[SmallShield], threshold, TxtShared_11);
  TryLoot(Bag.Items[Heart], 6, TxtShared_12);
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
    (item: @Bag.Items[OldSword]; line: TxtStart_07),
    (item: @Bag.Items[SmallShield]; line: TxtTranceItemLabel + TxtStart_08),
    (item: @Bag.Items[Heart]; line: TxtTranceItemLabel + TxtStart_09),
    (item: @Bag.Items[Diploma]; line: TxtTranceItemLabel + TxtStart_10),
    (item: @Bag.Items[Pipe]; line: TxtStart_11)
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

type
  TBand = record
    lo, hi, base, perUnit: Integer;
  end;

const
  PosExpBands: array[1..12] of TBand = (
    (lo: 1; hi: 2; base: 10; perUnit: 0),
    (lo: 3; hi: 3; base: 19; perUnit: 0),
    (lo: 4; hi: 6; base: 9; perUnit: 0),
    (lo: 7; hi: 9; base: 8; perUnit: 0),
    (lo: 10; hi: 12; base: 7; perUnit: 0),
    (lo: 13; hi: 15; base: 6; perUnit: 0),
    (lo: 16; hi: 18; base: 5; perUnit: 0),
    (lo: 19; hi: 21; base: 4; perUnit: 0),
    (lo: 22; hi: 24; base: 3; perUnit: 0),
    (lo: 25; hi: 27; base: 2; perUnit: 0),
    (lo: 28; hi: 30; base: 1; perUnit: 0),
    (lo: 31; hi: MaxInt; base: 0; perUnit: 0)
  );
  NegExpBands: array[1..10] of TBand = (
    (lo: 2; hi: 2; base: 12; perUnit: 0),
    (lo: 4; hi: 4; base: 13; perUnit: 0),
    (lo: 6; hi: 6; base: 14; perUnit: 0),
    (lo: 8; hi: 8; base: 15; perUnit: 0),
    (lo: 10; hi: 10; base: 16; perUnit: 0),
    (lo: 12; hi: 12; base: 17; perUnit: 0),
    (lo: 14; hi: 14; base: 18; perUnit: 0),
    (lo: 16; hi: 16; base: 19; perUnit: 0),
    (lo: 18; hi: 18; base: 20; perUnit: 0),
    (lo: 21; hi: MaxInt; base: 21; perUnit: 0)
  );

function BandAmount(const bands: array of TBand; v: Integer): Integer;
var
  bi: Integer;
begin
  for bi := Low(bands) to High(bands) do
    with bands[bi] do
      if (v >= lo) and (v <= hi) then begin
        BandAmount := base + perUnit * v;
        Exit;
      end;
  BandAmount := 0;
end;

function FightExpForEnergy(diff: Integer): Integer;

begin
  if diff > 0 then
    FightExpForEnergy := BandAmount(PosExpBands, diff)
  else if diff < 0 then
    FightExpForEnergy := BandAmount(NegExpBands, -diff)
  else
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
  DoFight;
  Combat.Loot := Random(15);
  WriteLn(TxtShared_08, Combat.Loot, TxtFightDog_01);
  Player.Money := Player.Money + Combat.Loot;
  TryLoot(Bag.Items[Heart], 5, TxtFightDog_02);
end;

type
  PInteger = ^Integer;

type
  TSpawnedAt = record
    monster: TMonster;
    room: Integer;
  end;

const
  CageInits: array[1..5] of TSpawnedAt = (
    (monster: CageWeakling; room: RoomCageWeakling),
    (monster: CageStrong; room: RoomCageStrong),
    (monster: CageAgile; room: RoomCageAgile),
    (monster: CageTough; room: RoomCageTough),
    (monster: CageHuge; room: RoomCageHuge)
  );
  PubSpawns: array[1..6] of TSpawnedAt = (
    (monster: Minibarman; room: RoomPub),
    (monster: Fatso; room: RoomPub),
    (monster: DJ; room: RoomBackstage),
    (monster: Pedal; room: RoomBar),
    (monster: Couple; room: RoomBar),
    (monster: Maciek; room: RoomBar)
  );

procedure SpawnAt(const placements: array of TSpawnedAt);
var
  si: Integer;
begin
  for si := Low(placements) to High(placements) do
    with placements[si] do
      World.Monsters[monster] := room;
end;

procedure SpawnGroup(const targets: array of PInteger; spread, base: Integer);
var
  i: Integer;
begin
  for i := Low(targets) to High(targets) do
    targets[i]^ := Random(spread) + base;
end;

function PastLimit(const targets: array of PInteger; limit: Integer): Boolean;
var
  li: Integer;
begin
  for li := Low(targets) to High(targets) do
    if targets[li]^ <= limit then begin
      PastLimit := False;
      Exit;
    end;
  PastLimit := True;
end;

procedure SpawnMonsters;
begin
  repeat
    SpawnGroup([@World.Monsters[Bacterium], @World.Monsters[Snail], @World.Monsters[Beetle], @World.Monsters[Cockroach], @World.Monsters[Ant],
                @World.Monsters[Spider], @World.Monsters[Boar], @World.Monsters[Fox], @World.Monsters[Rat], @World.Monsters[Partridge]], 38, RoomCityCentre);
  until PastLimit([@World.Monsters[Bacterium], @World.Monsters[Snail], @World.Monsters[Beetle], @World.Monsters[Cockroach], @World.Monsters[Ant], @World.Monsters[Spider], @World.Monsters[Boar], @World.Monsters[Fox], @World.Monsters[Rat], @World.Monsters[Partridge]], RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Deer], @World.Monsters[Eagle], @World.Monsters[Hare], @World.Monsters[Mongrel], @World.Monsters[Woodworm], @World.Monsters[Fly]], 38, RoomCityCentre);
  until PastLimit([@World.Monsters[Deer], @World.Monsters[Eagle], @World.Monsters[Hare], @World.Monsters[Mongrel], @World.Monsters[Woodworm], @World.Monsters[Fly]], RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Elephant], @World.Monsters[Lion], @World.Monsters[Giraffe], @World.Monsters[Camel], @World.Monsters[Ostrich],
                @World.Monsters[Boa], @World.Monsters[Wolf], @World.Monsters[Bison], @World.Monsters[Panther]], 38, RoomCityCentre);
  until PastLimit([@World.Monsters[Elephant], @World.Monsters[Lion], @World.Monsters[Giraffe], @World.Monsters[Camel], @World.Monsters[Ostrich], @World.Monsters[Boa], @World.Monsters[Wolf], @World.Monsters[Bison], @World.Monsters[Panther]], RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Gladiator], @World.Monsters[Warrior], @World.Monsters[Tamer]], 38, RoomCityCentre);
  until PastLimit([@World.Monsters[Gladiator], @World.Monsters[Warrior], @World.Monsters[Tamer]], RoomArenaEntrance);
  repeat
    SpawnGroup([@World.Monsters[Dachshund], @World.Monsters[Shepherd], @World.Monsters[Pooch], @World.Monsters[Spaniel], @World.Monsters[Poodle]], 7, RoomCityCentre);
  until PastLimit([@World.Monsters[Dachshund], @World.Monsters[Shepherd], @World.Monsters[Pooch], @World.Monsters[Spaniel], @World.Monsters[Poodle]], 19);
  repeat
    SpawnGroup([@World.Monsters[Cabman], @World.Monsters[Vendor], @World.Monsters[Sweeper], @World.Monsters[Drunkard], @World.Monsters[SickMan]], 7, RoomCityCentre);
  until PastLimit([@World.Monsters[Cabman], @World.Monsters[Vendor], @World.Monsters[Sweeper], @World.Monsters[Drunkard], @World.Monsters[SickMan]], 19);
  repeat
    SpawnGroup([@World.Monsters[Kid]], 7, RoomValley);
    SpawnGroup([@World.Monsters[Lunatic], @World.Monsters[Listener], @World.Monsters[Fan], @World.Monsters[Man]], 8, RoomValley);
  until PastLimit([@World.Monsters[Kid], @World.Monsters[Lunatic], @World.Monsters[Listener], @World.Monsters[Fan], @World.Monsters[Man]], RoomValley);
  repeat
    SpawnGroup([@World.Monsters[Policeman], @World.Monsters[Bouncer], @World.Monsters[Gorilla]], 9, RoomValley);
    SpawnGroup([@World.Monsters[OldMan]], 8, RoomValley);
    SpawnGroup([@World.Monsters[Reporter]], 7, RoomValley);
  until PastLimit([@World.Monsters[Policeman], @World.Monsters[Bouncer], @World.Monsters[Gorilla], @World.Monsters[OldMan], @World.Monsters[Reporter]], RoomValley);
    SpawnGroup([@World.Monsters[Guitarist], @World.Monsters[Drummer], @World.Monsters[Keyboardist], @World.Monsters[Liroy]], 3, RoomStage1);
  SpawnAt(PubSpawns);
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

type
  TTrainable = record
    cmd: string;
    stat, maxStat: TStat;
    minPractice, cost: Integer;
    cmdForm, nounForm: string;
  end;

const
  Trainables: array[1..3] of TTrainable = (
    (cmd: CmdTrenuj2 + CmdSila; stat: Strength; maxStat: MaxStrength; minPractice: 2; cost: 3; cmdForm: CmdSile; nounForm: CmdSily),
    (cmd: CmdTrenuj2 + CmdZrecznosc; stat: Dexterity; maxStat: MaxDexterity; minPractice: 1; cost: 2; cmdForm: CmdZrecznosc; nounForm: CmdZrecznosci),
    (cmd: CmdTrenuj2 + CmdMadrosc; stat: Wisdom; maxStat: MaxWisdom; minPractice: 2; cost: 3; cmdForm: CmdMadrosc; nounForm: CmdMadrosci)
  );

procedure HandleTrain;

var
  ti: Integer;
begin
  if Command = CmdTrenuj then WriteLn(TxtHandleTrain_01);
  for ti := Low(Trainables) to High(Trainables) do
    with Trainables[ti] do
      if Command = cmd then
        TrainAttribute(Player.Stats[stat], Player.Stats[maxStat], minPractice, cost, cmdForm, nounForm);
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
  DoFight;
  if (Combat.Fled = 0) and (not RequireEnergy or (Player.Energy > 0)) then begin
    Combat.Loot := Random(LootRand) + LootBase;
    WriteLn(TxtShared_08, Combat.Loot, TxtCompositeFight_01);
    Player.Money := Player.Money + Combat.Loot;
    if AntDoughnut then begin
      if Command = CmdZabij + CmdMrowka then begin
        Combat.Roll := Random(10);
        if (Combat.Roll < 7) and (Bag.Items[Doughnut] <> -ItemUnit) then begin
          WriteLn(TxtShared_08, TxtCompositeFight_02);
          Bag.Items[Doughnut] := -ItemUnit;
          Bag.Count := Bag.Count + 1;
        end;
      end;
    end else if (HeartChance > 0) and (Bag.Items[Heart] = 0) then begin
      Combat.Roll := Random(20);
      if (Combat.Roll < HeartChance) and (Bag.Items[Heart] <> -ItemUnit) then begin
        WriteLn(TxtShared_08, TxtCompositeFight_03);
        Bag.Items[Heart] := -ItemUnit;
        Bag.Count := Bag.Count + 1;
      end;
    end;
  end;
end;

type
  TFoeStats = record
    energyBase, energyRand, dexterityBase, dexterityRand: Integer;
    strengthBase, strengthRand, lootBase, lootRand, heartChance: Integer;
    requireEnergy, antDoughnut: Boolean;
  end;

const
  Foes: array[TFoe] of TFoeStats = (
    (energyBase: 1; energyRand: 0; dexterityBase: 1; dexterityRand: 0;
     strengthBase: 2; strengthRand: 0; lootBase: 0; lootRand: 3;
     heartChance: 0; requireEnergy: False; antDoughnut: True),
    (energyBase: 34; energyRand: 3; dexterityBase: 8; dexterityRand: 4;
     strengthBase: 10; strengthRand: 0; lootBase: 10; lootRand: 21;
     heartChance: 5; requireEnergy: False; antDoughnut: False),
    (energyBase: 50; energyRand: 5; dexterityBase: 10; dexterityRand: 5;
     strengthBase: 13; strengthRand: 2; lootBase: 30; lootRand: 30;
     heartChance: 7; requireEnergy: False; antDoughnut: False),
    (energyBase: 60; energyRand: 6; dexterityBase: 12; dexterityRand: 3;
     strengthBase: 15; strengthRand: 3; lootBase: 20; lootRand: 40;
     heartChance: 7; requireEnergy: False; antDoughnut: False),
    (energyBase: 90; energyRand: 10; dexterityBase: 14; dexterityRand: 2;
     strengthBase: 17; strengthRand: 2; lootBase: 10; lootRand: 55;
     heartChance: 4; requireEnergy: True; antDoughnut: False),
    (energyBase: 100; energyRand: 20; dexterityBase: 16; dexterityRand: 0;
     strengthBase: 18; strengthRand: 2; lootBase: 30; lootRand: 30;
     heartChance: 4; requireEnergy: True; antDoughnut: False),
    (energyBase: 130; energyRand: 20; dexterityBase: 20; dexterityRand: 0;
     strengthBase: 19; strengthRand: 2; lootBase: 20; lootRand: 45;
     heartChance: 4; requireEnergy: True; antDoughnut: False),
    (energyBase: 72; energyRand: 3; dexterityBase: 13; dexterityRand: 2;
     strengthBase: 16; strengthRand: 2; lootBase: 15; lootRand: 50;
     heartChance: 5; requireEnergy: False; antDoughnut: False)
  );

procedure Fight(foe: TFoe);
begin
  with Foes[foe] do
    CompositeFight(energyBase, energyRand, dexterityBase, dexterityRand,
      strengthBase, strengthRand, lootBase, lootRand, heartChance,
      requireEnergy, antDoughnut);
end;

procedure KillBeast(cmd: string; var beast: Integer; foe: TFoe);
begin
  if (Command = cmd) and (Session.Room = beast) then begin
    Fight(foe);
    beast := 0;
  end;
end;

procedure KillBeastUnlessFled(cmd: string; var beast: Integer; foe: TFoe);
begin
  if (Command = cmd) and (Session.Room = beast) then begin
    Fight(foe);
    if Combat.Fled = 0 then
      beast := 0;
  end;
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
    (stat: @Player.Stats[Strength]; lo: 16; hi: 18; line: TxtEnemy + TxtCompareFoe_03),
    (stat: @Player.Stats[Strength]; lo: 19; hi: MaxInt; line: TxtCompareFoe_04)
  );
  BigBeastCompareRules: array[1..4] of TCompareFoeRule = (
    (stat: @Session.Overall; lo: -MaxInt - 1; hi: 15; line: TxtCompareFoe_05),
    (stat: @Player.Stats[Strength]; lo: 16; hi: 20; line: TxtCompareFoe_06),
    (stat: @Player.Stats[Strength]; lo: 21; hi: 22; line: TxtCompareFoe_07),
    (stat: @Player.Stats[Strength]; lo: 23; hi: MaxInt; line: TxtCompareFoe_08)
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
    Session.Overall := Player.Level + Player.Stats[Strength] + DexterityBonus(Player.Stats[Dexterity]) + ParryBonus(Skills.Values[Parry]) + KickBonus(Skills.Values[Kick]);
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

type
  TGainBonus = (gbNone, gbMana, gbCassette);

procedure GainLoot1000(threshold: Integer; line1, line2: string; item: TBagItem);
begin
  Combat.Roll := Random(1000);
  if Combat.Roll <= threshold then begin
    WriteLn(line1);
    if line2 <> '' then WriteLn(TxtUniqeItem, line2);
    Bag.Items[item] := Bag.Items[item] - ItemUnit;
    Bag.Count := Bag.Count + 1;
  end;
end;

procedure GainLoot100(threshold: Integer; line1, line2: string; item: TBagItem; bonus: TGainBonus);
begin
  Combat.Roll := Random(100);
  if (Combat.Roll < threshold) and (Session.Room <> DeadRoom) then begin
    WriteLn(TxtShared_08, line1);
    if line2 <> '' then WriteLn(TxtBang, TxtUniqeItem, line2);
    Bag.Items[item] := Bag.Items[item] - ItemUnit;
    case bonus of
      gbMana: Player.MaxMana := Player.MaxMana + 40;
      gbCassette: begin
        Player.MaxEnergy := Player.MaxEnergy + 5;
        Gear.Values[Armor] := Gear.Values[Armor] - 8;
        Player.Stats[Dexterity] := Player.Stats[Dexterity] + 1;
      end;
    end;
    Bag.Count := Bag.Count + 1;
  end;
end;

procedure SuitGain;
begin
  GainLoot1000(25, TxtSuitGain_01, TxtSuitGain_02, SpikedSuit);
end;

procedure PillGain;
begin
  GainLoot1000(42, TxtPillGain_01, '', TeleportPill);
end;

procedure CassetteGain;
begin
  GainLoot100(2, TxtCassetteGain_01, TxtCassetteGain_02, Cassette, gbCassette);
end;

procedure LeafGain;
begin
  GainLoot100(6, TxtLeafGain_01, TxtLeafGain_02, LuckyLeaf, gbMana);
end;

procedure ScrollGain;
begin
  GainLoot100(10, TxtScrollGain_01, '', CompareScroll, gbNone);
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
    (playerStat: @Player.Stats[Strength]; enemyStat: @Combat.EnemyStrength; expFor: FightExpForStrength),
    (playerStat: @Player.Stats[Dexterity]; enemyStat: @Combat.EnemyDexterity; expFor: FightExpForDexterity)
  );

procedure DoFight;
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
    if Player.Stats[Dexterity] > Combat.EnemyDexterity then begin
      Combat.DodgeChance := Player.Stats[Dexterity] - Combat.EnemyDexterity;
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
    if Combat.EnemyDexterity > Player.Stats[Dexterity] then begin
      Combat.DodgeChance := Combat.EnemyDexterity - Player.Stats[Dexterity];
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
      Combat.Damage := Random(Player.Stats[Strength]);
      if Combat.Damage * 10 < Gear.Values[LuckRoll] then begin
        repeat
          Combat.Damage := Random(Player.Stats[Strength]);
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
        Bag.Items[Bigos] := Bag.Items[Bigos] - ItemUnit;
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

type
  TTakeEffect = (teNone, teDiploma, tePipe);
  TTakeDrop = record
    cmd: string;
    item: TBagItem;
    verb, line: string;
    effect: TTakeEffect;
  end;

const
  TakeItems: array[1..5] of TTakeDrop = (
    (cmd: CmdBierz + CmdStary; item: OldSword; verb: TxtPickUpVerb; line: TxtTakeDrop_01; effect: teNone),
    (cmd: CmdBierz + CmdMala; item: SmallShield; verb: TxtPickUpVerb; line: TxtTakeDrop_02; effect: teNone),
    (cmd: CmdBierz + CmdSerce; item: Heart; verb: TxtPickUpVerb; line: TxtTakeDrop_03; effect: teNone),
    (cmd: CmdBierz + CmdDyplom; item: Diploma; verb: TxtPickUpVerb; line: TxtTakeDrop_04; effect: teDiploma),
    (cmd: CmdBierz + CmdFajka; item: Pipe; verb: TxtPickUpVerb; line: TxtTakeDrop_05; effect: tePipe)
  );
  DropItems: array[1..5] of TTakeDrop = (
    (cmd: CmdOdrzuc + CmdStary; item: OldSword; verb: TxtDropVerb; line: TxtTakeDrop_06; effect: teNone),
    (cmd: CmdOdrzuc + CmdFajka; item: Pipe; verb: ''; line: TxtTakeDrop_07; effect: tePipe),
    (cmd: CmdOdrzuc + CmdMala; item: SmallShield; verb: TxtDropVerb; line: TxtTakeDrop_08; effect: teNone),
    (cmd: CmdOdrzuc + CmdSerce; item: Heart; verb: TxtDropVerb; line: TxtTakeDrop_09; effect: teNone),
    (cmd: CmdOdrzuc + CmdDyplom; item: Diploma; verb: TxtDropVerb; line: TxtTakeDrop_10; effect: teDiploma)
  );

procedure TakeItem(cmd: string; item: TBagItem; verb, line: string; effect: TTakeEffect);
begin
  if (Command = cmd) and (Bag.Items[item] = Session.OuterRoom) then begin
    WriteLn(verb, line);
    Bag.Items[item] := -ItemUnit;
    Bag.Count := Bag.Count + 1;
    case effect of
      teDiploma: Player.MaxEnergy := Player.MaxEnergy + 5;
      tePipe: if Player.Stats[Wisdom] < Player.Stats[MaxWisdom] then Player.Stats[Wisdom] := Player.Stats[Wisdom] + 1;
    end;
  end;
end;

procedure DropItem(cmd: string; item: TBagItem; verb, line: string; effect: TTakeEffect);
begin
  if (Command = cmd) and (Bag.Items[item] = -ItemUnit) then begin
    WriteLn(verb, line);
    Bag.Items[item] := Session.OuterRoom;
    Bag.Count := Bag.Count - 1;
    case effect of
      teDiploma: Player.MaxEnergy := Player.MaxEnergy - 5;
      tePipe: Player.Stats[Wisdom] := Player.Stats[Wisdom] - 1;
    end;
  end;
end;

procedure TakeDrop;

var
  ti: Integer;
begin
  for ti := Low(TakeItems) to High(TakeItems) do
    with TakeItems[ti] do
      TakeItem(cmd, item, verb, line, effect);
  for ti := Low(DropItems) to High(DropItems) do
    with DropItems[ti] do
      DropItem(cmd, item, verb, line, effect);
end;

type
  TFoodItem = record
    cmd: string;
    item: TBagItem;
    verb, line: string;
    gain: Integer;
    stat, cap: PInteger;
  end;

const
  FoodItems: array[1..8] of TFoodItem = (
    (cmd: CmdUzyj + CmdPaczek; item: Doughnut; verb: TxtEatVerb; line: TxtUseItems_12; gain: 8; stat: @Player.Energy; cap: @Player.MaxEnergy),
    (cmd: CmdUzyj + CmdCiastko; item: Cookie; verb: TxtEatVerb; line: TxtUseItems_13; gain: 12; stat: @Player.Energy; cap: @Player.MaxEnergy),
    (cmd: CmdUzyj + CmdSuchaRacja; item: DryRation; verb: TxtEatVerb; line: TxtUseItems_14; gain: 16; stat: @Player.Energy; cap: @Player.MaxEnergy),
    (cmd: CmdUzyj + CmdBulka; item: BreadRoll; verb: TxtEatVerb; line: TxtUseItems_15; gain: 20; stat: @Player.Energy; cap: @Player.MaxEnergy),
    (cmd: CmdUzyj + CmdChleb; item: Bread; verb: TxtEatVerb; line: TxtUseItems_23; gain: 26; stat: @Player.Energy; cap: @Player.MaxEnergy),
    (cmd: CmdUzyj + CmdWeka; item: Sausage; verb: TxtEatVerb; line: TxtUseItems_25; gain: 34; stat: @Player.Energy; cap: @Player.MaxEnergy),
    (cmd: CmdUzyj + CmdMalaButelkaMany; item: ManaBottle; verb: ''; line: TxtUseItems_26; gain: 30; stat: @Player.Mana; cap: @Player.MaxMana),
    (cmd: CmdUzyj + CmdBigos; item: Bigos; verb: TxtEatVerb; line: TxtUseItems_27; gain: 20; stat: @Player.Energy; cap: @Player.MaxEnergy)
  );

procedure ClampStat(var stat: Integer; cap: Integer);
begin
  if stat > cap then stat := cap;
end;

procedure EatFood(cmd: string; item: TBagItem; verb, line: string;
  gain: Integer; stat, cap: PInteger);
begin
  if (Command = cmd) and (Bag.Items[item] <= -ItemUnit) then begin
    Bag.Count := Bag.Count - 1;
    Bag.Items[item] := Bag.Items[item] + ItemUnit;
    WriteLn(verb, line);
    stat^ := stat^ + gain;
    ClampStat(stat^, cap^);
  end;
end;

procedure UseItems;

var
  fi: Integer;
begin
  if (Command = CmdUzyj + CmdFajka) and (Bag.Items[Pipe] = -ItemUnit) then WriteLn(TxtUseItems_01);
  if (Command = CmdUzyj + CmdSerce) and (Bag.Items[Heart] = -ItemUnit) then begin
    Bag.Items[Heart] := 0;
    WriteLn(TxtEatVerb, TxtUseItems_02);
    Player.Energy := Player.Energy + 5;
    ClampStat(Player.Energy, Player.MaxEnergy);
    Bag.Count := Bag.Count - 1;
  end;
  if (Command = CmdUzyj + CmdDyplom) and (Bag.Items[Diploma] = -ItemUnit) then begin
    WriteLines(TxtUseItemsLines1);
  end;
  for fi := Low(FoodItems) to High(FoodItems) do
    with FoodItems[fi] do
      EatFood(cmd, item, verb, line, gain, stat, cap);
  if (Command = CmdZniszcz + CmdPrzepustka) and (Bag.Permit <= -ItemUnit) then begin
    WriteLn(TxtUseItems_16);
    Bag.Permit := Bag.Permit + ItemUnit;
    Bag.Count := Bag.Count + 1;
  end;
  if (Command = CmdPatrz + CmdPrzepustka) and (Bag.Permit <= -ItemUnit) then begin
    WriteLines(TxtUseItemsLines2);
  end;
  if Command = CmdUzyj + CmdKaseta then WriteLn(TxtUseItems_24);
  if (Command = CmdUzyj + CmdKomplet) and (Bag.Items[Tracksuit] <= -ItemUnit) and (Gear.WornGarment = TxtEmpty) then begin
    WriteLn(TxtUseItems_28);
    Gear.Values[Armor] := Gear.Values[Armor] + 7;
    Gear.Values[Wearing] := 1;
    Gear.WornGarment := TxtWornSyf;
  end;
  if (Command = CmdOdlorz + CmdKomplet) and (Bag.Items[Tracksuit] <= -ItemUnit) and (Gear.WornGarment = TxtWornSyf) then begin
    WriteLn(TxtUseItems_29);
    Gear.Values[Wearing] := 0;
    Gear.Values[Armor] := Gear.Values[Armor] - 7;
    Gear.WornGarment := TxtEmpty;
  end;
  if (Command = CmdUzyj + CmdListek) and (Bag.Items[LuckyLeaf] <= -ItemUnit) then WriteLn(TxtUseItems_30);
  if (Command = CmdUzyj + TxtWornGarnitur) and (Bag.Items[SpikedSuit] <= -ItemUnit) and (Gear.WornGarment = TxtEmpty) then begin
    WriteLn(TxtUseItems_31);
    Gear.Values[Wearing] := 1;
    Gear.Values[WornCount] := Gear.Values[WornCount] + 1;
    Gear.Values[Armor] := Gear.Values[Armor] + 10;
    Gear.Values[LuckRoll] := Gear.Values[LuckRoll] + 15;
    Gear.WornGarment := TxtWornGarnitur;
  end;
  if (Command = CmdUzyj + CmdPigulka) and (Bag.Items[TeleportPill] <= -ItemUnit) then begin
    WriteLn(TxtUseItems_32);
    Bag.Items[TeleportPill] := Bag.Items[TeleportPill] + ItemUnit;
    SpawnMonsters;
    if Player.Stats[Wisdom] < 10 then begin
      WriteLn(TxtUseItems_33);
      WriteLn(TxtUseItems_34);
      Player.MaxEnergy := Player.MaxEnergy - 1;
      Player.Energy := 1;
      Player.Experience := Player.Experience - 50;
    end else if Player.Stats[Wisdom] < 16 then begin
      WriteLn(TxtUseItems_35);
      WriteLn(TxtUseItems_36);
      Player.Energy := Player.Energy - 40;
      if Player.Energy < 1 then Player.Energy := 1;
      Player.Experience := Player.Experience - 30;
    end else
      WriteLn(TxtUseItems_37);
  end;
  if (Command = CmdOdlorz + TxtWornGarnitur) and (Bag.Items[SpikedSuit] <= -ItemUnit) and (Gear.WornGarment = TxtWornGarnitur) then begin
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
    foe: TFoe;
    unlessFled: Boolean;
  end;

const
  BeastKills: array[1..23] of TBeastKill = (
    (cmd: CmdZabij + CmdSlimak; beast: @World.Monsters[Snail]; foe: WeakEnemy; unlessFled: True),
    (cmd: CmdZabij + CmdKornik; beast: @World.Monsters[Woodworm]; foe: WeakEnemy; unlessFled: True),
    (cmd: CmdZabij + CmdMucha; beast: @World.Monsters[Fly]; foe: WeakEnemy; unlessFled: True),
    (cmd: CmdZabij + CmdZuk; beast: @World.Monsters[Beetle]; foe: WeakEnemy; unlessFled: True),
    (cmd: CmdZabij + CmdKaraluch; beast: @World.Monsters[Cockroach]; foe: WeakEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdMrowka; beast: @World.Monsters[Ant]; foe: WeakEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdPajak; beast: @World.Monsters[Spider]; foe: WeakEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdDzik; beast: @World.Monsters[Boar]; foe: WeakishEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdSzczur; beast: @World.Monsters[Rat]; foe: WeakishEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdLis; beast: @World.Monsters[Fox]; foe: WeakishEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdKuropatwa; beast: @World.Monsters[Partridge]; foe: WeakishEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdZajac; beast: @World.Monsters[Hare]; foe: WeakishEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdOrzel; beast: @World.Monsters[Eagle]; foe: WeakishEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdSarna; beast: @World.Monsters[Deer]; foe: WeakishEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdSlon; beast: @World.Monsters[Elephant]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdLew; beast: @World.Monsters[Lion]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdZyrafa; beast: @World.Monsters[Giraffe]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdWilk; beast: @World.Monsters[Wolf]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdWielblad; beast: @World.Monsters[Camel]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdStrus; beast: @World.Monsters[Ostrich]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdBoa; beast: @World.Monsters[Boa]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdBizon; beast: @World.Monsters[Bison]; foe: MediumEnemy; unlessFled: False),
    (cmd: CmdZabij + CmdPantera; beast: @World.Monsters[Panther]; foe: MediumEnemy; unlessFled: False)
  );

type
  TArenaKill = record
    cmd: string;
    monster: TMonster;
    pills: Boolean;
  end;

const
  ArenaKills: array[1..3] of TArenaKill = (
    (cmd: CmdZabij + CmdGladiator; monster: Gladiator; pills: True),
    (cmd: CmdZabij + CmdWojownik; monster: Warrior; pills: True),
    (cmd: CmdZabij + CmdTrener; monster: Tamer; pills: False)
  );

procedure ArenaKill(cmd: string; monster: TMonster; pills: Boolean);
begin
  if (Command = cmd) and (Session.Room = World.Monsters[monster]) then begin
    Fight(HardEnemy);
    World.Monsters[monster] := 0;
    if pills then PillGain else SuitGain;
  end;
end;

type
  TMazeDir = (mdPolodnie, mdPolnoc, mdWschod, mdZachod);
  TMazeMove = record
    room: Integer;
    dest: array[TMazeDir] of Integer;
  end;

const
  MazeMoves: array[1..25] of TMazeMove = (
    (room: RoomArena33; dest: (RoomArenaEntrance, RoomArena34, RoomArena35, RoomArena36)),
    (room: RoomArena34; dest: (RoomArena33, RoomArena37, RoomArena38, RoomArena39)),
    (room: RoomArena35; dest: (RoomArena35, RoomArena38, RoomArena40, RoomArena33)),
    (room: RoomArena36; dest: (RoomArena36, RoomArena39, RoomArena33, RoomArena41)),
    (room: RoomArena37; dest: (RoomArena34, RoomArena42, RoomArena43, RoomArena44)),
    (room: RoomArena38; dest: (RoomArena35, RoomArena43, RoomArena45, RoomArena34)),
    (room: RoomArena39; dest: (RoomArena36, RoomArena44, RoomArena34, RoomArena46)),
    (room: RoomArena40; dest: (RoomArena40, RoomArena45, RoomArena40, RoomArena35)),
    (room: RoomArena41; dest: (RoomArena41, RoomArena46, RoomArena36, RoomArena41)),
    (room: RoomArena42; dest: (RoomArena37, RoomArena47, RoomArena48, RoomArena49)),
    (room: RoomArena43; dest: (RoomArena38, RoomArena48, RoomArena50, RoomArena37)),
    (room: RoomArena44; dest: (RoomArena39, RoomArena49, RoomArena37, RoomArena51)),
    (room: RoomArena45; dest: (RoomArena40, RoomArena50, RoomArena45, RoomArena38)),
    (room: RoomArena46; dest: (RoomArena41, RoomArena51, RoomArena39, RoomArena46)),
    (room: RoomArena47; dest: (RoomArena42, RoomArena47, RoomArena52, RoomArena53)),
    (room: RoomArena48; dest: (RoomArena43, RoomArena52, RoomArena54, RoomArena42)),
    (room: RoomArena49; dest: (RoomArena44, RoomArena53, RoomArena42, RoomArena55)),
    (room: RoomArena50; dest: (RoomArena45, RoomArena54, RoomArena50, RoomArena43)),
    (room: RoomArena51; dest: (RoomArena46, RoomArena55, RoomArena44, RoomArena51)),
    (room: RoomArena52; dest: (RoomArena48, RoomArena52, RoomArena56, RoomArena47)),
    (room: RoomArena53; dest: (RoomArena49, RoomArena53, RoomArena47, RoomArena57)),
    (room: RoomArena54; dest: (RoomArena50, RoomArena56, RoomArena54, RoomArena48)),
    (room: RoomArena55; dest: (RoomArena51, RoomArena57, RoomArena49, RoomArena55)),
    (room: RoomArena56; dest: (RoomArena54, RoomArena56, RoomArena56, RoomArena52)),
    (room: RoomArena57; dest: (RoomArena55, RoomArena57, RoomArena53, RoomArena57))
  );

procedure MazeMove(dir: TMazeDir);
var
  mi: Integer;
begin
  Session.InArena := 0;
  for mi := Low(MazeMoves) to High(MazeMoves) do
    with MazeMoves[mi] do
      if Session.Room = room then begin
        if dest[dir] = room then Session.InArena := 1
        else Session.Room := dest[dir];
        Break;
      end;
end;

procedure ArenaMaze;
var
  bi, ai: Integer;
begin
  if (Session.Room >= RoomArena33) and (Session.Room <= RoomArena57) then
  begin
    Session.InArena := 1;
    WriteLn(TxtArenaMaze_01);
    DescribeBeasts;
    repeat
      write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
      ReadLn(Command);
      ExpandAbbrev;
      CheckMode;
      if (Command = CmdZabij + CmdBakteria) and (Session.Room = World.Monsters[Bacterium]) then
      begin Fight(WeakEnemy);
        World.Monsters[Bacterium] := 0;
        WriteLn(TxtArenaMaze_02);
      end;
      for bi := Low(BeastKills) to High(BeastKills) do
        with BeastKills[bi] do
          if unlessFled then
            KillBeastUnlessFled(cmd, beast^, foe)
          else
            KillBeast(cmd, beast^, foe);
      if (Command = CmdZabij + CmdWilczur) and (Session.Room = World.Monsters[Mongrel]) then
      begin WriteLn(TxtArenaMaze_03);
        Fight(WeakishEnemy);
        World.Monsters[Mongrel] := 0;
      end;

      for ai := Low(ArenaKills) to High(ArenaKills) do
        with ArenaKills[ai] do
          ArenaKill(cmd, monster, pills);
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
      if Command = CmdPolodnie then
        MazeMove(mdPolodnie);
      if Command = CmdPolnoc then begin
        MazeMove(mdPolnoc);
        Session.MoveGuard := 1;
      end;
      if Command = CmdWschod then begin
        MazeMove(mdWschod);
        Session.MoveGuard := 1;
      end;
      if Command = CmdZachod then begin
        MazeMove(mdZachod);
        Session.MoveGuard := 1;
      end;
      Session.MoveGuard := 0;
      until (Session.InArena = 0) or (Session.Room = TranceRoom);
  end;
end;

procedure StageFights;
begin
  if (Command = CmdZabij + CmdPerkusista) and (World.Monsters[Drummer] = Session.Room) then begin
    Fight(VeryEasyEnemy);
    World.Monsters[Drummer] := 0;
    CassetteGain;
  end;
  if (Command = CmdZabij + CmdGitarzysta) and (World.Monsters[Guitarist] = Session.Room) then begin
    Fight(VeryEasyEnemy);
    World.Monsters[Guitarist] := 0;
    CassetteGain;
  end;
  if (Command = CmdZabij + CmdLiroy) and (World.Monsters[Liroy] = Session.Room) then begin
    Fight(NotEasyEnemy);
    if (Session.Room <> DeadRoom) and (Player.Energy > 0) and (Combat.Fled = 0) then begin
      WriteLn(TxtStageFights_01);
      Player.Money := Player.Money + 30;
      CassetteGain;
      if World.Quest > 1 then World.QuestKills := World.QuestKills - 150;
      World.Monsters[Liroy] := 0;
    end;
  end;
  if (Command = CmdZabij + CmdOrganista) and (World.Monsters[Keyboardist] = Session.Room) then begin
    Fight(VeryEasyEnemy);
    World.Monsters[Keyboardist] := 0;
    CassetteGain;
  end;
end;

procedure KillPlant(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Session.Room) then begin
    Fight(VeryEasyEnemy);
    Plant := 0;
  end;
end;

procedure KillPlantIfAlive(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Session.Room) then begin
    Fight(VeryEasyEnemy);
    if Player.Energy > 0 then Plant := 0;
  end;
end;

procedure KillPlantEasyIfAlive(cmd: string; var Plant: Integer);

begin
  if (Command = cmd) and (Plant = Session.Room) then begin
    Fight(EasyEnemy);
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
    Fight(EasyEnemy);
    if Combat.EnemyEnergy < 1 then World.Monsters[Duncan] := 0;
  end;
  if (Command = CmdSecret + CmdLista) and (World.Monsters[Duncan] = Session.Room) then begin
    WriteLines(TxtPlantFightsLines1);
  end;
  if Command = CmdKup + CmdDokument then begin if Player.Money > 399 then begin
      WriteLn(TxtPlantFights_05);
      Bag.Permit := Bag.Permit - ItemUnit;
      Player.Money := Player.Money - 400;
      Bag.Count := Bag.Count + 1; end;
  end;
  if (Command = CmdKup + CmdPlecak) and (World.Monsters[Duncan] = Session.Room) then begin if Player.Money > 4799 then begin
      WriteLn(TxtPlantFights_06);
      Player.Money := Player.Money - 4800;
      Bag.Items[Backpack] := Bag.Items[Backpack] - ItemUnit;
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
    Fight(HardEnemy);
    for i := 2 to 4 do
      if Player.Energy > 0 then Fight(HardEnemy);
    if (Player.Energy > 0) and (Combat.Fled = 0) then
      WriteLn(TxtPlantFights_18);
  end;
end;

procedure ReadCommand;
begin
  Write(Player.Energy, TxtShared_01, Player.Experience, TxtShared_02);
  ReadLn(Command);
end;

procedure CheckMode;
begin
  if Command = CmdMode then EnterTrance;
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
    baseStats: array[TStat] of Integer;
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
    (name:CmdCzlowiek; baseStats: (10, 10, 10, 15, 15, 15);
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdOlbrzym; baseStats: (13, 13, 5, 20, 20, 7);
     MaxManaBonus:-30; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdNimfa; baseStats: (10, 13, 7, 15, 20, 11);
     MaxManaBonus:0; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdPolElf; baseStats: (6, 16, 8, 10, 24, 12);
     MaxManaBonus:-20; MoneyBonus:30; MaxEnergyBonus:-5; EnergyBonus:-5),
    (name:CmdUfok; baseStats: (9, 9, 13, 13, 14, 20);
     MaxManaBonus:50; MoneyBonus:0; MaxEnergyBonus:0; EnergyBonus:0),
    (name:CmdCzaromil; baseStats: (6, 7, 16, 9, 11, 25);
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

const
  LvlThresholds: array[1..5] of TBand = (
    (lo: 1; hi: 1; base: Lvl1_Threshold; perUnit: 0),
    (lo: 2; hi: 2; base: Lvl2_Threshold; perUnit: 0),
    (lo: 3; hi: 3; base: Lvl3_Threshold; perUnit: 0),
    (lo: 4; hi: 8; base: Lvl4_Base; perUnit: 1),
    (lo: 9; hi: MaxInt; base: Lvl9_Base; perUnit: 2)
  );

function LevelThreshold(lvl: Integer): Integer;

begin
  LevelThreshold := BandAmount(LvlThresholds, lvl);
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
    (item: @Bag.Items[OldSword]; desc: CmdStaryZardzewialyMiecz; width: 0; kind: ikShown),
    (item: @Bag.Items[SmallShield]; desc: CmdOkraglaMalaTarcza; width: 0; kind: ikShown),
    (item: @Bag.Items[Heart]; desc: CmdZakrwawioneSerce; width: 0; kind: ikShown),
    (item: @Bag.Items[Diploma]; desc: CmdDyplomMudSzkoly; width: 0; kind: ikShown),
    (item: @Bag.Items[Doughnut]; desc: CmdSmacznyPolanyLikieremPaczek; width: 10; kind: ikShown),
    (item: @Bag.Items[Cookie]; desc: CmdSmaczneCiastko; width: 10; kind: ikShown),
    (item: @Bag.Items[DryRation]; desc: CmdTwardaSuchaRacje; width: 10; kind: ikShown),
    (item: @Bag.Items[BreadRoll]; desc: CmdOkraglaPachnacaBulka; width: 10; kind: ikShown),
    (item: @Bag.Items[Bread]; desc: CmdDuzyCieplyChleb; width: 10; kind: ikShown),
    (item: @Bag.Items[Sausage]; desc: CmdDlugaISmacznaWeke; width: 10; kind: ikShown),
    (item: @Bag.Items[Bigos]; desc: CmdPysznyBigosZKapustaZWroga; width: 10; kind: ikShown),
    (item: @Bag.Items[Beer]; desc: CmdOzewiajacePiwskoZKonkretnymKlimatem; width: 0; kind: ikDiv10),
    (item: @Bag.Items[Pipe]; desc: CmdCiezkaFajkaOdDziadaMroza; width: 0; kind: ikPlain),
    (item: @Bag.Items[Tracksuit]; desc: CmdKompletUbranFirmySyf; width: 0; kind: ikPlain),
    (item: @Bag.Items[SpikedSuit]; desc: CmdGarniturZKolcami; width: 0; kind: ikPlain),
    (item: @Bag.Items[ManaBottle]; desc: CmdMalaButelkeMany; width: 0; kind: ikPlain),
    (item: @Bag.Items[LuckyLeaf]; desc: CmdDelikatnyChocSzorstkiListek; width: 0; kind: ikPlain),
    (item: @Bag.Items[Cassette]; desc: CmdKasetaLiroyaLJakLiroy; width: 0; kind: ikPlain),
    (item: @Bag.Items[TeleportPill]; desc: CmdPigulkaTransportujacaMG; width: 0; kind: ikPlain),
    (item: @Bag.Permit; desc: CmdPrzepustkaWlasnoreczniePodpisanaPrzezQuestMastera; width: 0; kind: ikPlain),
    (item: @Bag.Items[CompareScroll]; desc: CmdScrollZCzaremPorownywanie; width: 0; kind: ikPlain),
    (item: @Bag.Items[ReturnScroll]; desc: CmdScrollZCzaremPowrot; width: 0; kind: ikPlain)
  );

procedure ShowSheetItem(kind: TSheetKind; val: Integer; const desc: string; width: Integer);
begin
  if val <= -ItemUnit then
    case kind of
      ikShown: if width = 0 then WriteLn(desc)
               else WriteLn(desc, val:width);
      ikDiv10: WriteLn(desc, val div 10);
      ikPlain: WriteLn(desc, val);
    end;
end;

procedure ShowCharacter;

var
  i, gap, si: Integer;
begin

  for i := High(DexterityItemLimits) downto Low(DexterityItemLimits) do
    if Player.Stats[Dexterity] >= DexterityItemLimits[i].gate then begin
      Bag.Limit := DexterityItemLimits[i].limit;
      Break;
    end;
  if Bag.Items[Backpack] < 0 then Bag.Limit := Bag.Limit + 4;
  WriteLn(TxtShowCharacter_01);
  for si := Low(SheetItems) to High(SheetItems) do
    with SheetItems[si] do
      ShowSheetItem(kind, item^, desc, width);
  WriteLn(TxtShowCharacter_02, Bag.Count, TxtShowCharacter_03, Bag.Limit, TxtShowCharacter_04);
  if Gear.Values[WeaponKind] = 0 then WriteLn(TxtShowCharacter_05);
  if Gear.Values[ShieldKind] = 0 then WriteLn(TxtShowCharacter_06);
  if Gear.WornGarment = TxtEmpty then WriteLn(TxtShowCharacter_07);
  if Gear.WornGarment = TxtWornSyf then WriteLn(TxtWearingLabel, TxtShowCharacter_08);
  if Gear.WornGarment = TxtWornGarnitur then WriteLn(TxtWearingLabel, TxtShowCharacter_09);
  if (Gear.Values[ShieldKind] = 1) and (Bag.Items[SmallShield] = -100) then
    WriteLn(TxtShowCharacter_10);
  if (Gear.Values[WeaponKind] = 1) and (Bag.Items[OldSword] = -100) then
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

  WriteLn(TxtShowCharacter_21, Player.Stats[Strength], TxtShowCharacter_03, Player.Stats[MaxStrength],
         TxtShowCharacter_22, Player.Stats[Dexterity], TxtShowCharacter_03, Player.Stats[MaxDexterity],
         TxtShowCharacter_23, Player.Stats[Wisdom], TxtShowCharacter_03, Player.Stats[MaxWisdom]);
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
  si: TStat;
begin
  ShowIntro;
  repeat
    WriteLn(TxtChooseRace_01);
    ReadLn(Command);
    chosen := FindRace(Command);
    if chosen > 0 then begin
      for si := Low(TStat) to High(TStat) do
        Player.Stats[si] := Races[chosen].baseStats[si];
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
  SpawnAt(CageInits);

  Player.Level := 1;
  Player.MaxMana := Player.MaxMana + 100;
  Player.Mana := Player.MaxMana;
  SpawnMonsters;
  WriteLines(TxtChooseRaceLines1);
end;

type
  TStreetKind = (skDog, skFolk);

procedure KillStreetFoe(cmd: string; var target: Integer; extra: Boolean; kind: TStreetKind);
begin
  if (Command = cmd) and (target = Session.Room) then begin
    case kind of
      skDog: FightDog;
      skFolk: Fight(VeryEasyEnemy);
    end;
    target := 0;
    if extra then
      case kind of
        skDog: WriteLines(TxtKillDogLines1);
        skFolk: SuitGain;
      end;
  end;
end;

procedure KillSweeper;

begin
  if (Command = CmdZabij + CmdZamiatacz) and (World.Monsters[Sweeper] = Session.Room) then begin
    Fight(VeryEasyEnemy);
    World.Monsters[Sweeper] := 0;
    Combat.Roll := Random(100);
    if (Combat.Roll < 35) and (Bag.Items[Tracksuit] = 0) then begin
      WriteLn(TxtKillSweeper_01);
      Bag.Items[Tracksuit] := Bag.Items[Tracksuit] - ItemUnit;
    end;
  end;
end;

procedure KillSickMan;

begin
  if (Command = CmdZabij + CmdZebrak) and (World.Monsters[SickMan] = Session.Room) then begin
    Fight(VeryEasyEnemy);
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
    kind: TStreetKind;
  end;

const
  StreetKills: array[1..8] of TStreetKill = (
    (cmd: CmdZabij + CmdOwczarek; target: @World.Monsters[Shepherd]; extra: False; kind: skDog),
    (cmd: CmdZabij + CmdPiesek; target: @World.Monsters[Pooch]; extra: False; kind: skDog),
    (cmd: CmdZabij + CmdJamnik; target: @World.Monsters[Dachshund]; extra: False; kind: skDog),
    (cmd: CmdZabij + CmdSpaniel; target: @World.Monsters[Spaniel]; extra: True; kind: skDog),
    (cmd: CmdZabij + CmdPudel; target: @World.Monsters[Poodle]; extra: False; kind: skDog),
    (cmd: CmdZabij + CmdTaksowkarz; target: @World.Monsters[Cabman]; extra: True; kind: skFolk),
    (cmd: CmdZabij + CmdSprzedawca; target: @World.Monsters[Vendor]; extra: True; kind: skFolk),
    (cmd: CmdZabij + CmdPijak; target: @World.Monsters[Drunkard]; extra: False; kind: skFolk)
  );

procedure StreetFights;
var
  ki: Integer;
begin

  for ki := Low(StreetKills) to High(StreetKills) do
    with StreetKills[ki] do
      KillStreetFoe(cmd, target^, extra, kind);
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

function GatesMet(reqWisdom, reqStrength, reqDexterity: Integer): Boolean;
begin
  GatesMet :=
    ((reqWisdom = -1) or (Player.Stats[Wisdom] > reqWisdom)) and
    ((reqStrength = -1) or (Player.Stats[Strength] > reqStrength)) and
    ((reqDexterity = -1) or (Player.Stats[Dexterity] > reqDexterity));
end;

procedure WriteTrainingGain(skillName: string; value: Integer);
begin
  WriteLn(TxtTrainingVerb, skillName, TxtTrainingThreshold, value,
          TxtTraining_29, Player.Practice, TxtShared_19);
end;

procedure Training;
var
  i: Integer;
begin
  if Command = CmdPatrz + CmdPlakat then begin
    WriteLn(TxtShared_13);
    WriteLn(TxtTraining_01);
    if Player.Stats[Wisdom] < 11 then WriteLn(TxtTraining_02);
    for i := Low(TrainingLines) to High(TrainingLines) do
      if GatesMet(TrainingLines[i].wisdom, TrainingLines[i].strength,
                  TrainingLines[i].dexterity) then
        WriteLn(TrainingLines[i].text1);
    WriteLn(TxtTraining_27);
  end;

  if Command = CmdCwicz + CmdKopac then
    if (Player.Stats[Wisdom] > 10) and (Player.Stats[Strength] > 11) and (Player.Practice > 0) then begin
      Skills.Values[Kick] := Skills.Values[Kick] + Player.Stats[Wisdom];
      Player.Practice := Player.Practice - 1;
      WriteTrainingGain(TxtTrainingDigging, Skills.Values[Kick]);
    end;

  if Command = CmdCwicz + CmdUciekac then begin
    if Player.Stats[Wisdom] > 10 then
      if Player.Stats[Dexterity] > 10 then
        if (Player.Practice > 0) and (Skills.Values[Fleeing] < 85) then begin
          Skills.Values[Fleeing] := Skills.Values[Fleeing] + Player.Stats[Wisdom] + Player.Stats[Dexterity] - 5;
          Player.Practice := Player.Practice - 1;
          WriteTrainingGain(TxtTrainingFleeing, Skills.Values[Fleeing]);
        end else
          WriteLn(TxtTraining_31);
  end;

  if Command = CmdCwicz + CmdPowrot then
    if (Player.Stats[Wisdom] > 17) and (Skills.Values[Returning] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Returning] := Skills.Values[Returning] + 2 * Player.Stats[Wisdom] - 3;
      Player.Practice := Player.Practice - 1;
      WriteTrainingGain(TxtTrainingReturning, Skills.Values[Returning]);
    end;

  if Command = CmdCwicz + TxtTrainingParrying then
    if (Player.Stats[Wisdom] > 15) and (Player.Stats[Dexterity] > 11) and (Skills.Values[Parry] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Parry] := Skills.Values[Parry] + Player.Stats[Wisdom] + Player.Stats[Dexterity] - 14;
      Player.Practice := Player.Practice - 1;
      WriteTrainingGain(TxtTrainingParrying, Skills.Values[Parry]);
    end;

  if Command = CmdCwicz + CmdPorownanie then
    if (Player.Stats[Wisdom] > 11) and (Skills.Values[Comparing] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Comparing] := Skills.Values[Comparing] + 3 * Player.Stats[Wisdom] - 9;
      Player.Practice := Player.Practice - 1;
      WriteTrainingGain(TxtTrainingComparing, Skills.Values[Comparing]);
    end;

  if Command = CmdCwicz + TxtTrainingCooking then
    if (Player.Stats[Wisdom] > 18) and (Skills.Values[Cooking] < 90) and (Player.Practice > 0) then begin
      Skills.Values[Cooking] := Skills.Values[Cooking] + Player.Stats[Wisdom] + 1;
      Player.Practice := Player.Practice - 1;
      WriteTrainingGain(TxtTrainingCooking, Skills.Values[Cooking]);
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
  SaveSlot(Player.Mana * SaveStatScale);
  SaveSlot(Player.Level + SaveLevelBias);
  SaveSlot(Bag.Items[OldSword]);
  SaveSlot(Bag.Items[Pipe]);
  SaveSlot(Bag.Items[Diploma]);
  SaveSlot(Bag.Items[SmallShield]);
  SaveSlot(Bag.Items[SpikedSuit]);
  SaveSlot(Player.Experience);
  SaveSlot((Player.Energy + SaveEnergyBias) * SaveStatScale);
  SaveSlot(Session.OuterRoom);
  SaveSlot(Player.Stats[Dexterity] + SaveDexterityBias);
  SaveSlot(Player.Stats[Strength] - SaveStrengthBias);
  SaveSlot(Player.Stats[Wisdom]);
  SaveSlot(Player.Practice);
  SaveSlot(Session.CheckpointStage);
  SaveSlot(0);
  SaveSlot(0);
  SaveSlot(Player.Money * Player.Stats[Wisdom]);
  SaveSlot(Combat.Loot);
  SaveSlot(Player.MaxEnergy);
  SaveSlot(Bag.Limit);
  SaveSlot(Skills.Values[Comparing]);
  SaveSlot(Player.MaxMana);
  SaveSlot(Player.Stats[MaxStrength]);
  SaveSlot(Player.Stats[MaxDexterity]);
  SaveSlot(Player.Stats[MaxWisdom]);
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
  SaveSlot(Bag.Items[Heart]);
  SaveSlot(Bag.Items[ManaBottle]);
  SaveSlot(Bag.Items[Cookie]);
  SaveSlot(Bag.Items[DryRation]);
  SaveSlot(Bag.Items[Bread]);
  SaveSlot(Bag.Items[BreadRoll]);
  SaveSlot(Bag.Items[Sausage]);
  SaveSlot(Bag.Items[Bread]);
  SaveSlot(Bag.Items[BreadRoll]);
  SaveSlot(Gear.Values[WornCount]);
  SaveSlot(Skills.Values[Parry]);
  SaveSlot(Skills.Values[Kick]);
  SaveSlot(Skills.Values[KickMinMana]);
  SaveSlot(Skills.Values[KickMaxEnergy]);
  SaveSlot(Skills.Values[Fleeing]);
  SaveSlot(Skills.Values[FleeEnergy]);
  SaveSlot(Combat.Fled);
  SaveSlot(Session.InArena);
  SaveSlot(Bag.Items[Tracksuit]);
  SaveSlot(Bag.Items[Cassette]);
  SaveSlot(Bag.Items[TeleportPill]);
  SaveSlot(World.Monsters[Woodworm]);
  SaveSlot(World.Monsters[Fly]);
  SaveSlot(World.Monsters[Bacterium]);
  SaveSlot(World.Quest);
  SaveSlot(World.QuestKills);
  SaveSlot(World.Monsters[Snail]);
  SaveSlot(Bag.Items[LuckyLeaf]);
  SaveSlot(Skills.Values[Returning]);
  SaveSlot(Bag.Items[Bigos]);
  SaveSlot(Bag.Items[Beer]);
  SaveSlot(Bag.Items[CompareScroll]);
  SaveSlot(Bag.Items[ReturnScroll]);
  SaveSlot(World.OldElf);
  SaveSlot(World.DuncanQuest);
  SaveSlot(Bag.Items[Backpack]);
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
    Item := Item - ItemUnit;
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
    (cmd: CmdKup + CmdPaczek; item: @Bag.Items[Doughnut]; price: 8; desc: TxtItemPaczek),
    (cmd: CmdKup + CmdCiastko; item: @Bag.Items[Cookie]; price: 12; desc: TxtItemCiastko),
    (cmd: CmdKup + CmdSuchaRacja; item: @Bag.Items[DryRation]; price: 15; desc: TxtItemSuchaRacje),
    (cmd: CmdKup + CmdBulka; item: @Bag.Items[BreadRoll]; price: 19; desc: TxtItemBulke),
    (cmd: CmdKup + CmdChleb; item: @Bag.Items[Bread]; price: 24; desc: TxtItemChleb),
    (cmd: CmdKup + CmdWeka; item: @Bag.Items[Sausage]; price: 29; desc: TxtItemWeke)
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
  CanBuyOldSword := (Bag.Items[OldSword] = 0) and (Player.Money >= 70);
end;

procedure SellItem(var Item: Integer; price: Integer; itemName: string);
begin
  WriteLn(TxtSellVerb, itemName);
  Player.Money := Player.Money + price;
  Item := Item + ItemUnit;
  Bag.Count := Bag.Count - 1;
end;

procedure BuyOldSword;
begin
  BuyItem(CmdKup + CmdStary, Bag.Items[OldSword], 70, TxtBuyOldSword_01, True);
end;

function CanSellOldSword: Boolean;
begin
  CanSellOldSword := Bag.Items[OldSword] = -ItemUnit;
end;

procedure SellOldSword;
begin
  WriteLn(TxtSellOldSword_01);
  WriteLn(TxtSellOldSword_02);
  Player.Money := Player.Money + 30;
  Bag.Items[OldSword] := 0;
  Bag.Count := Bag.Count - 1;
end;

function CanBuySmallShield: Boolean;
begin
  CanBuySmallShield := (Bag.Items[SmallShield] = 0) and (Player.Money >= 15);
end;

procedure BuySmallShield;
begin
  BuyItem(CmdKup + CmdMala, Bag.Items[SmallShield], 15, TxtBuySmallShield_01, True);
end;

procedure SellSmallShield;

begin
  WriteLn(TxtSellSmallShield_01);
  Player.Money := Player.Money + 8;
  Bag.Items[SmallShield] := 0;
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
  CanBuyPipe := (Bag.Items[Pipe] = 0) and (Player.Money >= 480);
end;

procedure BuyPipe;
begin
  WriteLn(TxtShopVerb, TxtBuyPipe_01, TxtSpaceZa, 480, TxtSpaceMonet);
  Player.Money := Player.Money - 480;
  Bag.Items[Pipe] := Bag.Items[Pipe] - ItemUnit;
  Bag.Count := Bag.Count + 1;
  Player.Stats[Wisdom] := Player.Stats[Wisdom] + 1;
end;

function CanBuyTracksuit: Boolean;
begin
  CanBuyTracksuit := (Bag.Items[Tracksuit] = 0) and (Player.Money >= 35);
end;

procedure BuyTracksuit;
begin
  BuyItem(CmdKup + CmdKomplet, Bag.Items[Tracksuit], 35, TxtBuyTracksuit_01, True);
end;

function CanSellTracksuit: Boolean;
begin
  CanSellTracksuit := (Bag.Items[Tracksuit] <= -ItemUnit) and (Gear.WornGarment <> TxtWornSyf);
end;

procedure SellTracksuit;
begin
  SellItem(Bag.Items[Tracksuit], 15, TxtSellTracksuit_01);
end;

function CanSellPipe: Boolean;
begin
  CanSellPipe := Bag.Items[Pipe] = -ItemUnit;
end;

procedure SellPipe;
begin
  WriteLn(TxtSellVerb, TxtSellPipe_01);
  Player.Money := Player.Money + 120;
  Bag.Items[Pipe] := Bag.Items[Pipe] + ItemUnit;
  Bag.Count := Bag.Count - 1;
  Player.Stats[Wisdom] := Player.Stats[Wisdom] - 1;
end;

function CanBuyCassette: Boolean;
begin
  CanBuyCassette := Player.Money >= 1999;
end;

procedure BuyCassette;
begin
  WriteLn(TxtShopVerb, TxtBuyCassette_01, TxtSpaceZa, 1999, TxtSpaceMonet);
  Player.Money := Player.Money - 1999;
  Bag.Items[Cassette] := Bag.Items[Cassette] - ItemUnit;
  Gear.Values[Armor] := Gear.Values[Armor] - 8;
  Player.MaxEnergy := Player.MaxEnergy + 5;
  Player.Stats[Dexterity] := Player.Stats[Dexterity] + 1;
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
  Bag.Items[SpikedSuit] := Bag.Items[SpikedSuit] - ItemUnit;
  Bag.Count := Bag.Count + 1;
end;

function CanSellSpikedSuit: Boolean;
begin
  CanSellSpikedSuit := Gear.WornGarment <> TxtWornGarnitur;
end;

procedure SellSpikedSuit;
begin
  SellItem(Bag.Items[SpikedSuit], 500, TxtSellSpikedSuit_01);
end;

function CanSellCassette: Boolean;
begin
  CanSellCassette := Bag.Items[Cassette] < 0;
end;

procedure SellCassette;
begin
  WriteLn(TxtSellVerb, TxtSellCassette_01);
  Player.Money := Player.Money + 1000;
  Bag.Items[Cassette] := Bag.Items[Cassette] + ItemUnit;
  Gear.Values[Armor] := Gear.Values[Armor] + 8;
  Player.MaxEnergy := Player.MaxEnergy - 5;
  Player.Stats[Dexterity] := Player.Stats[Dexterity] - 1;
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
  Bag.Items[ManaBottle] := Bag.Items[ManaBottle] - ItemUnit;
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
  Bag.Items[LuckyLeaf] := Bag.Items[LuckyLeaf] - ItemUnit;
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
  Bag.Items[LuckyLeaf] := Bag.Items[LuckyLeaf] + ItemUnit;
  Bag.Count := Bag.Count - 1;
  Player.MaxMana := Player.MaxMana - 40;
end;

function CanBuyTeleportPill: Boolean;
begin
  CanBuyTeleportPill := Player.Money >= 235;
end;

procedure BuyTeleportPill;
begin
  BuyItem(CmdKup + CmdPigulkaTransportujaca, Bag.Items[TeleportPill], 235, TxtBuyTeleportPill_01, True);
end;

function CanSellTeleportPill: Boolean;
begin
  CanSellTeleportPill := Bag.Items[TeleportPill] <= 10;
end;

procedure SellTeleportPill;
begin
  WriteLn(TxtSellTeleportPill_01);
  Player.Money := Player.Money + 170;
  Bag.Items[TeleportPill] := Bag.Items[TeleportPill] + ItemUnit;
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
  Bag.Items[CompareScroll] := Bag.Items[CompareScroll] - ItemUnit;
  Bag.Count := Bag.Count + 1;
end;

function CanSellCompareScroll: Boolean;
begin
  CanSellCompareScroll := Bag.Items[CompareScroll] < 0;
end;

procedure SellCompareScroll;
begin
  WriteLn(TxtSellCompareScroll_01);
  Player.Money := Player.Money + 18;
  Bag.Items[CompareScroll] := Bag.Items[CompareScroll] + ItemUnit;
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

type
  TShopStock = record
    item: TBagItem;
    lines: array[1..3] of string;
  end;

const
  ArmouryStock: array[1..2] of TShopStock = (
    (item: OldSword; lines: (TxtArmouryShop_01, '', '')),
    (item: SmallShield; lines: (TxtArmouryShop_02, '', ''))
  );
  GeneralStoreStock: array[1..2] of TShopStock = (
    (item: Pipe; lines: (TxtGeneralStoreShop_02, '', '')),
    (item: Tracksuit; lines: (TxtGeneralStoreShop_03, TxtGeneralStoreShop_04, TxtGeneralStoreShop_05))
  );

procedure ShowStock(item: TBagItem; const lines: array of string);
var
  si: Integer;
begin
  if Bag.Items[item] = 0 then
    for si := Low(lines) to High(lines) do
      if lines[si] <> '' then WriteLn(lines[si]);
end;

procedure ArmouryShop;

var
  si2: Integer;
begin
  if Command = CmdLista then begin
    WriteLn(TxtShared_24);
    for si2 := Low(ArmouryStock) to High(ArmouryStock) do
      with ArmouryStock[si2] do
        ShowStock(item, lines);
    WriteLn(TxtArmouryShop_03);
  end;
  StreetFights;
  RunShopRules(ArmouryRules);
end;

procedure GeneralStoreShop;

var
  si2: Integer;
begin
  if Command = CmdLista then begin
    WriteLn(TxtGeneralStoreShop_01);
    for si2 := Low(GeneralStoreStock) to High(GeneralStoreStock) do
      with GeneralStoreStock[si2] do
        ShowStock(item, lines);
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

type
  TConcertBonus = (cbNone, cbPipe, cbSuit);
  TConcertKill = record
    cmd: string;
    monster: TMonster;
    foe: TFoe;
    bonus: TConcertBonus;
  end;

const
  ConcertKills: array[1..10] of TConcertKill = (
    (cmd: CmdZabij + CmdDziecko; monster: Kid; foe: WeakishEnemy; bonus: cbNone),
    (cmd: CmdZabij + CmdDziadek; monster: OldMan; foe: WeakishEnemy; bonus: cbPipe),
    (cmd: CmdZabij + CmdWariat; monster: Lunatic; foe: MediumEnemy; bonus: cbNone),
    (cmd: CmdZabij + CmdSluchacz; monster: Listener; foe: MediumEnemy; bonus: cbNone),
    (cmd: CmdZabij + CmdCzlowiek; monster: Man; foe: MediumEnemy; bonus: cbNone),
    (cmd: CmdZabij + CmdFan; monster: Fan; foe: MediumEnemy; bonus: cbNone),
    (cmd: CmdZabij + CmdReporter; monster: Reporter; foe: MediumEnemy; bonus: cbNone),
    (cmd: CmdZabij + CmdPolicjant; monster: Policeman; foe: HardEnemy; bonus: cbNone),
    (cmd: CmdZabij + CmdGoryl; monster: Gorilla; foe: HardEnemy; bonus: cbSuit),
    (cmd: CmdZabij + CmdOchroniarz; monster: Bouncer; foe: HardEnemy; bonus: cbSuit)
  );

procedure ConcertKill(cmd: string; monster: TMonster; foe: TFoe; bonus: TConcertBonus);
begin
  if (Command = cmd) and (Session.Room = World.Monsters[monster]) then begin
    Fight(foe);
    if Combat.EnemyEnergy < 1 then begin
      World.Monsters[monster] := 0;
      if bonus = cbPipe then begin
        Combat.Roll := Random(100);
        if (Combat.Roll < 5) and (Bag.Items[Pipe] = 0) then begin
          WriteLn(TxtShared_08, TxtConcertFights_01);
          WriteLn(TxtConcertFights_02);
          Bag.Items[Pipe] := Bag.Items[Pipe] - ItemUnit;
          Player.Stats[Wisdom] := Player.Stats[Wisdom] + 1;
        end;
      end;
    end;
    if bonus = cbSuit then SuitGain;
  end;
end;

procedure ConcertFights;

var
  ci: Integer;
begin
  for ci := Low(ConcertKills) to High(ConcertKills) do
    with ConcertKills[ci] do
      ConcertKill(cmd, monster, foe, bonus);
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
    and (Player.Stats[Strength] >= loStr) and (Player.Stats[Strength] <= hiStr) then begin
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
  Player.Mana := Player.Mana div SaveStatScale;
  LoadSlotShort(Player.Level);
  Player.Level := Player.Level - SaveLevelBias;
  LoadSlot(Bag.Items[OldSword]);
  LoadSlot(Bag.Items[Pipe]);
  LoadSlot(Bag.Items[Diploma]);
  LoadSlot(Bag.Items[SmallShield]);
  LoadSlot(Bag.Items[SpikedSuit]);
  LoadSlot(Player.Experience);
  LoadSlot(Player.Energy);
  Player.Energy := Player.Energy div SaveStatScale;
  Player.Energy := Player.Energy - SaveEnergyBias;
  LoadSlot(Session.OuterRoom);
  LoadSlot(Player.Stats[Dexterity]);
  Player.Stats[Dexterity] := Player.Stats[Dexterity] - SaveDexterityBias;
  LoadSlot(Player.Stats[Strength]);
  Player.Stats[Strength] := Player.Stats[Strength] + SaveStrengthBias;
  LoadSlot(Player.Stats[Wisdom]);
  LoadSlot(Player.Practice);
  LoadSlot(Session.CheckpointStage);
  LoadSlot(dummy);
  LoadSlot(dummy);
  LoadSlotLong(Player.Money);
  Player.Money := Player.Money div Player.Stats[Wisdom];
  LoadSlot(Combat.Loot);
  LoadSlot(Player.MaxEnergy);
  LoadSlot(Bag.Limit);
  LoadSlot(Skills.Values[Comparing]);
  LoadSlot(Player.MaxMana);
  LoadSlot(Player.Stats[MaxStrength]);
  LoadSlot(Player.Stats[MaxDexterity]);
  LoadSlot(Player.Stats[MaxWisdom]);
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
  LoadSlot(Bag.Items[Heart]);
  LoadSlot(Bag.Items[ManaBottle]);
  LoadSlot(Bag.Items[Cookie]);
  LoadSlot(Bag.Items[DryRation]);
  LoadSlot(Bag.Items[Bread]);
  LoadSlot(Bag.Items[BreadRoll]);
  LoadSlot(Bag.Items[Sausage]);
  LoadSlot(Bag.Items[Bread]);
  LoadSlot(Bag.Items[BreadRoll]);
  LoadSlot(Gear.Values[WornCount]);
  LoadSlot(Skills.Values[Parry]);
  LoadSlot(Skills.Values[Kick]);
  LoadSlot(Skills.Values[KickMinMana]);
  LoadSlot(Skills.Values[KickMaxEnergy]);
  LoadSlot(Skills.Values[Fleeing]);
  LoadSlot(Skills.Values[FleeEnergy]);
  LoadSlot(Combat.Fled);
  LoadSlot(Session.InArena);
  LoadSlot(Bag.Items[Tracksuit]);
  LoadSlot(Bag.Items[Cassette]);
  LoadSlot(Bag.Items[TeleportPill]);
  LoadSlot(World.Monsters[Woodworm]);
  LoadSlot(World.Monsters[Fly]);
  LoadSlot(World.Monsters[Bacterium]);
  LoadSlot(World.Quest);
  LoadSlot(World.QuestKills);
  LoadSlot(World.Monsters[Snail]);
  LoadSlot(Bag.Items[LuckyLeaf]);
  LoadSlot(Skills.Values[Returning]);
  LoadSlot(Bag.Items[Bigos]);
  LoadSlot(Bag.Items[Beer]);
  LoadSlot(Bag.Items[CompareScroll]);
  LoadSlot(Bag.Items[ReturnScroll]);
  LoadSlot(World.OldElf);
  LoadSlotShort(World.DuncanQuest);
  LoadSlot(Bag.Items[Backpack]);
  LoadSlot(World.Monsters[Duncan]);
  ReadLn(Session.SaveFile);
  LoadSlotText(Gear.WornGarment);
  Close(Session.SaveFile);
  WriteLn(TxtLoadCharacter_01, Gear.WornGarment);
end;

type
  TEnergyBonus = record
    dexLo, strLo, bonus: Integer;
  end;

const
  LevelCosts: array[1..5] of TBand = (
    (lo: 1; hi: 1; base: 725; perUnit: 0),
    (lo: 2; hi: 2; base: 730; perUnit: 0),
    (lo: 3; hi: 3; base: 735; perUnit: 0),
    (lo: 4; hi: 8; base: Lvl4_Base; perUnit: 1),
    (lo: 9; hi: MaxInt; base: Lvl9_Base; perUnit: 2)
  );
  PracticeGains: array[1..4] of TBand = (
    (lo: -128; hi: 10; base: 3; perUnit: 0),
    (lo: 11; hi: 15; base: 4; perUnit: 0),
    (lo: 16; hi: 22; base: 5; perUnit: 0),
    (lo: -MaxInt - 1; hi: MaxInt; base: 6; perUnit: 0)
  );
  MaxEnergyGains: array[1..4] of TEnergyBonus = (
    (dexLo: 12; strLo: -MaxInt - 1; bonus: 1),
    (dexLo: 16; strLo: -MaxInt - 1; bonus: 1),
    (dexLo: 21; strLo: -MaxInt - 1; bonus: 1),
    (dexLo: 26; strLo: 20; bonus: 1)
  );

procedure CheckLevelUp;

var
  threshold, ei: Integer;
begin
  if Player.Level < 1 then Exit;
  threshold := LevelThreshold(Player.Level);
  if Player.Experience < threshold then Exit;

  WriteLines(TxtCheckLevelUpLines1);

  Player.Experience := Player.Experience - BandAmount(LevelCosts, Player.Level);
  Player.Practice := Player.Practice + BandAmount(PracticeGains, Player.Stats[Wisdom]);
  WriteLn(TxtCheckLevelUp_02, Player.Practice, TxtCheckLevelUp_03);
  Player.MaxEnergy := Player.MaxEnergy + 10;
  for ei := Low(MaxEnergyGains) to High(MaxEnergyGains) do
    with MaxEnergyGains[ei] do
      if (Player.Stats[Dexterity] > dexLo) and (Player.Stats[Strength] > strLo) then
        Player.MaxEnergy := Player.MaxEnergy + bonus;
  WriteLn(TxtCheckLevelUp_02, Player.MaxEnergy, TxtCheckLevelUp_04);
  Player.MaxMana := Player.MaxMana + Player.Stats[Wisdom] + 2;
   WriteLn(TxtCheckLevelUp_05, Player.Stats[Wisdom] + 2, TxtCheckLevelUp_06);
  Player.Level := Player.Level + 1;
  Session.CheckpointStage := 0;
  if Player.Level = 12 then begin
    WriteLn(TxtCheckLevelUp_07);
    if Player.Stats[Strength] >= Player.Stats[MaxStrength] then Player.Stats[MaxStrength] := Player.Stats[MaxStrength] + 3;
    if Player.Stats[Dexterity] >= Player.Stats[MaxDexterity] then Player.Stats[MaxDexterity] := Player.Stats[MaxDexterity] + 3;
    if Player.Stats[Wisdom] >= Player.Stats[MaxWisdom] then Player.Stats[MaxWisdom] := Player.Stats[MaxWisdom] + 3;
    if Player.Stats[Strength] < Player.Stats[MaxStrength] then Player.Stats[MaxStrength] := Player.Stats[MaxStrength] + 2;
    if Player.Stats[Dexterity] < Player.Stats[MaxDexterity] then Player.Stats[MaxDexterity] := Player.Stats[MaxDexterity] + 2;
    if Player.Stats[Wisdom] < Player.Stats[MaxWisdom] then Player.Stats[MaxWisdom] := Player.Stats[MaxWisdom] + 2;
    if (Player.Stats[MaxWisdom] > Player.Stats[MaxStrength]) and (Player.Stats[MaxWisdom] > Player.Stats[MaxDexterity]) then
      Player.Stats[MaxWisdom] := Player.Stats[MaxWisdom] + 3;
    if (Player.Stats[MaxStrength] > Player.Stats[MaxWisdom]) and (Player.Stats[MaxStrength] > Player.Stats[MaxDexterity]) then
      Player.Stats[MaxStrength] := Player.Stats[MaxStrength] + 3;
    if (Player.Stats[MaxDexterity] > Player.Stats[MaxStrength]) and (Player.Stats[MaxDexterity] > Player.Stats[MaxWisdom]) then
      Player.Stats[MaxDexterity] := Player.Stats[MaxDexterity] + 3;
    if (Player.Stats[MaxDexterity] = Player.Stats[MaxStrength]) and (Player.Stats[MaxStrength] = Player.Stats[MaxWisdom]) then begin
      Player.Stats[MaxDexterity] := Player.Stats[MaxDexterity] + 1;
      Player.Stats[MaxWisdom] := Player.Stats[MaxWisdom] + 1;
      Player.Stats[MaxStrength] := Player.Stats[MaxStrength] + 1;
    end;
    if (Player.Stats[MaxDexterity] > Player.Stats[MaxWisdom]) and (Player.Stats[MaxDexterity] = Player.Stats[MaxStrength]) then begin
      Player.Stats[MaxStrength] := Player.Stats[MaxStrength] + 2;
      Player.Stats[MaxDexterity] := Player.Stats[MaxDexterity] + 1;
    end;
    WriteLn(TxtCheckLevelUp_08, Player.Stats[MaxStrength],
          TxtMaxymalnie, TxtCheckLevelUp_09);
    WriteLn(TxtCheckLevelUp_08, Player.Stats[MaxDexterity],
          TxtMaxymalnie, TxtCheckLevelUp_10);
    WriteLn(TxtCheckLevelUp_08, Player.Stats[MaxWisdom],
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
  Bag.Items[OldSword] := -ItemUnit;
  Bag.Items[SmallShield] := -ItemUnit;
  Player.Stats[Strength] := Player.Stats[Strength] - 1;
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
  if Bag.Items[Beer] <= -ItemUnit then begin
    Bag.Items[Beer] := Bag.Items[Beer] + ItemUnit;
    WriteLn(TxtCmdDrinkBeer_01);
    Bag.Count := Bag.Count - 1;
    Player.Energy := Player.Energy + 10;
    Player.Mana := Player.Mana + 10;
  end;
end;

procedure CmdWieldOldSword;
begin
  if (Bag.Items[OldSword] = -ItemUnit) and (Gear.Values[WeaponKind] = 0) then begin
    Bag.Items[OldSword] := -100;
    Gear.Values[WeaponKind] := 1;
    WriteLn(TxtCmdWieldOldSword_01);
    Player.Stats[Strength] := Player.Stats[Strength] + 1;
    Gear.Values[LuckRoll] := Gear.Values[LuckRoll] + 3;
  end;
end;

procedure CmdUnwieldOldSword;
begin
  if (Bag.Items[OldSword] = -100) and (Gear.Values[WeaponKind] = 1) then begin
    Bag.Items[OldSword] := -ItemUnit;
    Gear.Values[WeaponKind] := 0;
    WriteLn(TxtCmdUnwieldOldSword_01);
    Player.Stats[Strength] := Player.Stats[Strength] - 1;
    Gear.Values[LuckRoll] := Gear.Values[LuckRoll] - 3;
  end;
end;

procedure CmdWieldSmallShield;
begin
  if (Gear.Values[ShieldKind] = 0) and (Bag.Items[SmallShield] = -ItemUnit) then begin
    Gear.Values[ShieldKind] := 1;
    Gear.Values[Armor] := Gear.Values[Armor] + 15;
    Gear.Values[WornCount] := Gear.Values[WornCount] + 1;
    Bag.Items[SmallShield] := -100;
    WriteLn(TxtCmdWieldSmallShield_01);
  end;
end;

procedure CmdUnwieldSmallShield;
begin
  if (Gear.Values[ShieldKind] = 1) and (Bag.Items[SmallShield] = -100) then begin
    Gear.Values[ShieldKind] := 0;
    Gear.Values[Armor] := Gear.Values[Armor] - 15;
    Gear.Values[WornCount] := Gear.Values[WornCount] - 1;
    Bag.Items[SmallShield] := -ItemUnit;
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
    WriteLn(TxtCmdSleep_05, Player.Stats[Wisdom], TxtCmdSleep_06);
    Player.Energy := Player.Energy + Player.Stats[Wisdom];
  end;
  if Session.SleepHours > 8 then begin
    WriteLn(TxtCmdSleep_07, Player.Stats[Wisdom] * 2, TxtCmdSleep_06);
    Player.Energy := Player.Energy + (Player.Stats[Wisdom] * 2);
  end;
  ClampStat(Player.Energy, Player.MaxEnergy);
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
   ((Command = CmdUzyj + CmdScrollPowrot) and (Bag.Items[ReturnScroll] < 0)) then begin
    Combat.Roll := Random(100);
    if Command = CmdUzyj + CmdScrollPowrot then begin
      Combat.Roll := Random(1);
      Bag.Items[ReturnScroll] := Bag.Items[ReturnScroll] + ItemUnit;
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
  if Bag.Items[CompareScroll] < 0 then begin
    CompareFoe;
    Player.Mana := Player.Mana - 10;
    Bag.Items[CompareScroll] := Bag.Items[CompareScroll] + ItemUnit;
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
  Bag.Permit := Bag.Permit - ItemUnit;
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
    if Session.ExitRequested then Exit;

    ArenaMaze;
    if Session.Room = DeadRoom then Death;
    ClampStat(Player.Energy, Player.MaxEnergy);
    if Session.Room = TranceRoom then begin
      for ti := Low(TranceItems) to High(TranceItems) do
        with TranceItems[ti] do
          TranceItemLine(item^, line);
      repeat
        ReadCommand;

        Session.ExitRequested := False;
        for gi := Low(GroundCommands) to High(GroundCommands) do
          if (GroundCommands[gi].cmd = TxtEmpty) or (Command = GroundCommands[gi].cmd) then begin
            GroundCommands[gi].run;
            if Session.ExitRequested then Exit;
          end;
      until Session.Room <> TranceRoom;
    end;

    Combat.Fled := 0;

  until Session.Room = RoomQuit;

end;

end.
