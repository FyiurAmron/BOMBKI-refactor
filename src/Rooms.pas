unit Rooms;

interface

uses Game;

  procedure Room0;
  procedure Room1;
  procedure Room2;
  procedure Room3;
  procedure Room4;
  procedure Room5;
  procedure Room9;
  procedure Room11;
  procedure Room12;
  procedure Room13;
  procedure Room14;
  procedure Room15;
  procedure Room16;
  procedure Room17;
  procedure Room18;
  procedure Room20;
  procedure Room21;
  procedure Room22;
  procedure Room23;
  procedure Room24;
  procedure Room25;
  procedure Room26;
  procedure Room30;
  procedure Room31;
  procedure Room32;
  procedure Room60;
  procedure Room75;
  procedure Room76;
  procedure Room77;
  procedure Room78;
  procedure Room79;
  procedure Room80;
  procedure Room81;
  procedure Room82;
  procedure Room83;
  procedure Room84;
  procedure Room85;
  procedure Room86;
  procedure Room87;
  procedure Room88;
  procedure Room100;
  procedure Room101;
  procedure Room102;
  procedure Room103;
  procedure ConcertRooms;
  procedure PlainRooms;
  procedure BasicRoomGeneric(RoomNo: Integer; const intro, exits: array of string;
    const moves: array of TMovement; posterCmd: string;
    const poster: array of string);
  procedure BasicRoomPoster(RoomNo: Integer; const intro, exits: array of string;
    const moves: array of TMovement; const poster: array of string);
  procedure BasicRoomQuit(RoomNo: Integer; const intro, exits: array of string;
    const moves: array of TMovement);
  procedure BasicRoomQuitGeneric(RoomNo: Integer; const intro, exits: array of string;
    const moves: array of TMovement; posterCmd: string;
    const poster: array of string);
  procedure BasicRoomQuitPoster(RoomNo: Integer; const intro, exits: array of string;
    const moves: array of TMovement; const poster: array of string);
  procedure BasicRoomSimple(RoomNo: Integer; const intro, exits: array of string;
    const moves: array of TMovement);
  procedure SimpleRoom(RoomNo, DestRoom: Integer; Direction, ExitDesc: string);
  procedure DispatchRoom;

implementation

type

  TRoomEntry = record
    id: Integer;
    run: TCommandHandler;
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

procedure Room0;
begin
  WriteLn(TxtRoom0_01);
  repeat
    ReadCommand;
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

procedure Room2;

begin
  WriteLines([TxtYouAreIn + TxtRoom2_01, TxtRoom2_02, TxtShared_04]);
  repeat
    ReadCommand;
    CheckMode;
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
  WriteLines(TxtRoom3Lines1);
  repeat
    ReadCommand;
    CheckMode;
    if Command = CmdExit then
      WriteLn(TxtRoom3_04);
    if MoveWhenOrExit([Go(CmdGora, RoomSalon)]) then Exit;
    Training;
  until Session.Room <> RoomMeditation;
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

procedure Room9;
begin
  BasicRoomSimple(RoomSchoolLanding,
            [TxtYouAreIn + TxtRoom9_01, TxtRoom9_02],
            [TxtShared_03,
             TxtExitDol, TxtPlaceMudSzkola2,
             TxtExitGora, TxtPlaceKlatkiPelneGajdy],
            [Go(CmdDol, RoomLost), Go(CmdGora, RoomCageCorridor)]);
end;

procedure Room11;
begin
  WriteLn(TxtYouAreIn, TxtRoom11_01);
  WriteLines(TxtRoom11Lines1);
  repeat
    ReadCommand;
    ExpandAbbrev;
    CheckMode;
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

procedure CageMonsterFight(var monster: Integer; room, energy, dexterity, strength, lootRand, lootThreshold: Integer);
begin
  if (Command = CmdZabij + CmdPotwor) and (monster = room) then begin
    Combat.EnemyEnergy := energy; Combat.EnemyDexterity := dexterity; Combat.EnemyStrength := strength;
    DoFight;
    if Combat.Fled = 0 then begin
      monster := 0;
      Combat.Loot := Random(lootRand);
      WriteLn(TxtShared_08, Combat.Loot, TxtShared_09);
      Player.Money := Player.Money + Combat.Loot;
      TryCageLoot(lootThreshold);
    end else
      Combat.Fled := 0;
  end;
end;

procedure DescribeCage(monster: TMonster; room: Integer; aliveLine, deadLine: string);
begin
  WriteLn(TxtShared_06);
  if World.Monsters[monster] = room then WriteLn(aliveLine)
  else if World.Monsters[monster] = 0 then WriteLn(deadLine);
end;

procedure Room12;

begin
  DescribeCage(CageWeakling, RoomCageWeakling, TxtRoom12_01, TxtShared_07);
  repeat
    ReadCommand;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceKlatkiPelneGajdy]);
    CheckMode;
    if MoveWhenOrExit([Go(CmdZachod, RoomCageCorridor)]) then Exit;
    CageMonsterFight(World.Monsters[CageWeakling], RoomCageWeakling, 20, 3, 3, 10, 4);
  until Session.Room <> RoomCageWeakling;
end;

procedure Room13;
begin
  DescribeCage(CageStrong, RoomCageStrong, TxtRoom13_01, TxtShared_07);
  repeat
    ReadCommand;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceKlatkiPelneGajdy]);
    CheckMode;
    if MoveWhenOrExit([Go(CmdWschod, RoomCageCorridor)]) then Exit;
    CageMonsterFight(World.Monsters[CageStrong], RoomCageStrong, 20, 3, 10, 15, 7);
  until Session.Room <> RoomCageStrong;

end;

procedure Room14;

begin

  DescribeCage(CageAgile, RoomCageAgile, TxtRoom14_01, TxtRoom14_02);
  repeat
    ReadCommand;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceKlatkiPelneGajdy]);
    CheckMode;
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomCageCorridor)]) then Exit;
    CageMonsterFight(World.Monsters[CageAgile], RoomCageAgile, 20, 30, 3, 15, 7);
  until Session.Room <> RoomCageAgile;

end;

procedure Room15;

begin

  DescribeCage(CageTough, RoomCageTough, TxtRoom15_01, TxtShared_07);
  repeat
    ReadCommand;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolnoc, TxtPlaceKlatkiPelneGajdy]);
    CheckMode;
    if MoveWhenOrQuit([Go(CmdPolnoc, RoomCageCorridor)]) then Exit;
    CageMonsterFight(World.Monsters[CageTough], RoomCageTough, 40, 3, 3, 15, 7);
  until Session.Room <> RoomCageTough;

end;

procedure Room16;

begin

  DescribeCage(CageHuge, RoomCageHuge, TxtRoom16_01, TxtShared_07);
  repeat
    if World.Monsters[CageHuge] = RoomCageHuge then begin
      Combat.EnemyEnergy := 40; Combat.EnemyDexterity := 11; Combat.EnemyStrength := 10;
      DoFight;
      if Combat.Fled <> 0 then begin
        Combat.Fled := 0;
        Session.Room := RoomCageCorridor;
      end else begin
        World.Monsters[CageHuge] := 0;
        Combat.Loot := Random(30);
        WriteLn(TxtShared_08, Combat.Loot, TxtShared_09);
        Player.Money := Player.Money + Combat.Loot;
        TryCageLoot(10);
      end;
    end;
    ReadCommand;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitDol, TxtPlaceKlatkiPelneGajdy]);
    CheckMode;
    if MoveWhenOrQuit([Go(CmdDol, RoomCageCorridor)]) then Exit;
  until Session.Room <> RoomCageHuge;

end;

procedure Room17;

begin

  WriteLn(TxtYouAreIn, TxtRoom17_01);
  repeat
    ReadCommand;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitGora, TxtPlaceKlatkiPelneGajdy,
                    TxtExitDol, TxtPlaceTeleport]);
    if Command = CmdPatrz + CmdPlakat then begin
      WriteLines(TxtRoom17Lines1);
      if (World.Monsters[CageWeakling] = 0) and (World.Monsters[CageAgile] = 0) and
      (World.Monsters[CageStrong] = 0) and (World.Monsters[CageTough] = 0) and
      (World.Monsters[CageHuge] = 0) and (Bag.Items[Diploma] = 0) then
        Bag.Items[Diploma] := RoomCageReward;
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
    ReadCommand;
    CheckMode;
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

procedure Room21;

begin

  WriteLn(TxtRoom21_01);
  WriteLn(TxtRoom21_02);
  DescribeStreet;
  repeat
    ReadCommand;
    CheckMode;
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
    ReadCommand;
    CheckMode;
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

procedure Room23;

begin

  WriteLines([TxtYouAreIn + TxtRoom23_01, TxtRoom23_02, TxtRoom23_03]);
  DescribeStreet;
  repeat
    ReadCommand;
    CheckMode;
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

  WriteLines([TxtYouAreIn + TxtRoom24_01, TxtRoom24_02, TxtRoom24_03]);
  DescribeStreet;
  repeat
    ReadCommand;
    ArmouryShop;
    CheckMode;
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

  WriteLines([TxtRoom25_01, TxtRoom25_02]);
  DescribeStreet;
  repeat
    ReadCommand;
    CheckMode;
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
    ReadCommand;
    CheckMode;
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

procedure Room76;

begin

  WriteLn(TxtYouAreIn, TxtRoom76_01);
  WriteLines(TxtRoom76Lines1);
  if World.Monsters[Maciek] = 76 then
    WriteLn(TxtRoom76_05);
  if World.Monsters[Pedal] = 76 then
    WriteLn(TxtRoom76_06);
  if World.Monsters[Couple] = 76 then
    WriteLn(TxtRoom76_07);
  repeat
    ReadCommand;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceUlicaCiemna]);
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomDarkStreet)]) then Exit;
    if Command = CmdLista then begin
      WriteLines(TxtRoom76Lines2);
    end;
    if Command = CmdZabij + CmdPedal then begin
      Fight(EasyEnemy);
      World.Monsters[Pedal] := 0;
      PillGain;
    end;
    if Command = CmdZabij + CmdPara then begin
      Fight(VeryHardEnemy);
      World.Monsters[Couple] := 0;
      Fight(VeryHardEnemy);
    end;
    if Command = CmdZabij + CmdMaciek then begin
      Fight(EasyEnemy);
      World.Monsters[Maciek] := 0;
    end;
    if Command = CmdMam + Cmd18Lat then begin
      WriteLn(TxtRoom76_13);
    end;
  until Session.Room <> RoomBar;

end;

procedure Room77;

begin

  WriteLines([TxtRoom77_01, TxtRoom77_02]);
  DescribePlants;
  repeat
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
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

  WriteLines([TxtRoom78_01, TxtRoom78_02]);
  DescribePlants;
  repeat
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdZachod, RoomIvy1)]) then Exit;
  until Session.Room <> RoomIvy2;

end;

procedure Room79;

begin

  WriteLines([TxtRoom79_01, TxtRoom79_02]);
  DescribePlants;
  repeat
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
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
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
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

  WriteLines([TxtRoom81_01, TxtRoom81_02]);
  DescribePlants;
  repeat
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomIvy4)]) then Exit;
  until Session.Room <> RoomIvy5;

end;

procedure Room82;

begin

  WriteLines([TxtRoom82_01, TxtRoom82_02]);
  DescribePlants;
  repeat
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitZachod, TxtPlaceBluszcz]);
    if MoveWhenOrQuit([Go(CmdZachod, RoomIvy4)]) then Exit;
  until Session.Room <> RoomIvy6;

end;

procedure Room83;
begin
  WriteLines(TxtRoom83Lines1);
  DescribePlants;
  repeat
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolnoc, TxtPlaceBluszcz,
                    TxtExitZachod, TxtPlacePodejrzaneKrzaki]);
    if MoveWhenOrExit([Go(CmdPolnoc, RoomIvy4), Go(CmdZachod, RoomCavePath)]) then Exit;
  until Session.Room <> RoomClearing;

end;

procedure Room84;

begin

  WriteLines(TxtRoom84Lines1);
  DescribePlants;
  repeat
    ReadCommand;
    ExpandAbbrev;
    PlantFights;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceBluszcz,
                    TxtExitZachod, TxtPlaceBudynek,
                    TxtExitPolodnie, TxtPlaceWejscieDoGroty]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomClearing), Go(CmdZachod, RoomLivingDoor), Go(CmdPolodnie, RoomCaveMouth)]) then Exit;
  until Session.Room <> RoomCavePath;

end;

procedure Room85;

begin

  WriteLines([TxtRoom85_01, TxtRoom85_02]);
  if World.Door <> 0 then
    WriteLn(TxtRoom85_03);
  repeat
    ReadCommand;
    ExpandAbbrev;
    if Command = CmdZabij + CmdDrzwi then begin
      if World.Door <> 0 then begin
        Fight(NotEasyEnemy);
        if Player.Energy > 0 then World.Door := 0;
      end;
    end;
    CheckMode;
    if Command = CmdExit then begin
      WriteExits([TxtShared_03,
                  TxtExitWschod, TxtPlacePodejrzaneKrzaki]);
      if World.Door <> 0 then
        WriteLn(TxtExitZachod, TxtPlaceGdybyNieTeCholerneDrzwi)
      else
        WriteLn(TxtExitZachod, TxtPlaceWejscieDoDomku);
    end;
    if MoveWhenOrQuit([Go(CmdWschod, RoomCavePath)]) then Exit;
    if Command = CmdZachod then
      if World.Door = 0 then Session.Room := RoomHut
      else WriteLn(TxtRoom85_07);
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
    ReadCommand;
    ExpandAbbrev;
    if Command = CmdDawaj + CmdKunszt then Player.Experience := Player.Experience + 500;
    if Command = CmdPatrz + CmdGarnki then
      WriteLn(TxtRoom86_04);
    if Command = CmdRozmawiaj + CmdStaruch then begin
      if (Bag.Items[Sausage] > -30) and (Player.Money < 200) and (Bag.Items[ReturnScroll] = 0) then begin
        WriteLines(TxtRoom86Lines1);
      end;
      if (Bag.Items[Sausage] < -30) and (Player.Money > 199) then begin
        WriteLines(TxtRoom86Lines2);
        Session.Room := RoomCityCentre;
        Bag.Items[Beer] := Bag.Items[Beer] - ItemUnit;
        Bag.Items[Sausage] := Bag.Items[Sausage] + 40;
        Player.Money := Player.Money - 200;
        Bag.Items[ReturnScroll] := Bag.Items[ReturnScroll] - ItemUnit;
        Player.Experience := Player.Experience + 50;
        Bag.Count := Bag.Count - 2;
      end;
      if Bag.Items[ReturnScroll] < 0 then begin
        WriteLn(TxtRoom86_13);
        Session.Room := RoomCageHuge;
      end;
    end;
    if Command = CmdZabij + CmdStaruch then begin
      if World.OldElf <> 0 then begin
        Fight(WeakEnemy);
        World.OldElf := 0;
        WriteLn(TxtRoom86_14);
        WriteLn(TxtRoom86_15);
        Player.Level := Player.Level - 1;
      end;
    end;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitWschod, TxtPlaceBudynek]);
    if MoveWhenOrQuit([Go(CmdWschod, RoomLivingDoor)]) then Exit;
  until Session.Room <> RoomHut;

end;

procedure Room87;

begin

  WriteLn(TxtRoom87_01);
  WriteLn(TxtRoom87_02);
  Combat.Roll := Random(100);
  if Combat.Roll < 40 then begin
    WriteLn(TxtRoom87_03,
       25 - Player.Stats[Dexterity], TxtShared_26);
    Player.Energy := Player.Energy - 25 + Player.Stats[Dexterity];
  end;
  repeat
    ReadCommand;
    ExpandAbbrev;
    CheckMode;
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
    DoFight;
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
    ReadCommand;
    ExpandAbbrev;
    CheckMode;
    if Command = CmdExit then
        WriteExits([TxtShared_03,
                    TxtExitPolodnie, TxtPlaceWejscieDoGroty2]);
    if MoveWhenOrQuit([Go(CmdPolodnie, RoomCaveMouth)]) then Exit;
  until Session.Room <> RoomNettleThrone;

end;

procedure GrantQuestReward(quest, exp: Integer);
begin
  WriteLn(TxtRoom100_12);
  WriteLn(TxtQuestReward, exp, TxtSpaceKunsztDashes);
  Player.Experience := Player.Experience + exp;
  World.Quest := 0;
  World.QuestKills := 0;
  Bag.Permit := Bag.Permit - ItemUnit;
  case quest of
    1: Bag.Count := Bag.Count + 1;
    2: begin
      Bag.Items[Diploma] := 0;
      Player.MaxEnergy := Player.MaxEnergy - 5;
    end;
    3: begin
      Bag.Count := Bag.Count - 1;
      Player.Stats[Wisdom] := Player.Stats[Wisdom] - 1;
      Bag.Items[Pipe] := Bag.Items[Pipe] + ItemUnit;
      Player.Practice := Player.Practice - 1;
    end;
  end;
end;

procedure Room100;
var
  i: Integer;
begin
  WriteLines([TxtRoom100_01, TxtRoom100_02]);
  DescribeStreet;
  repeat
    ReadCommand;
    CheckMode;
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
    for i := Low(QuestOffers) to High(QuestOffers) do
      with QuestOffers[i] do
        BuyQuest(cmd, line, quest, kills, price);
    if (Command = CmdSprzedaj + CmdQuest) and (World.Quest > 0) then begin
      case World.Quest of
        1: if World.QuestKills < 1 then GrantQuestReward(1, 100);
        2: if (World.QuestKills < 1) and (Bag.Items[Diploma] <= -ItemUnit) then GrantQuestReward(2, 250);
        3: if (World.QuestKills < 1) and (Bag.Items[Pipe] <= -ItemUnit) and (Player.Practice > 0) then GrantQuestReward(3, 425);
      end;

    end;
    if MoveWhenOrExit([Go(CmdPolodnie, RoomShopStreet2)]) then Exit;
    if (Command = CmdZachod) and (Bag.Permit <= -ItemUnit) then Session.Room := RoomRoad1;
if (Command = CmdZachod) and (Bag.Permit = 0) then WriteLn(TxtRoom100_16);
    if Command = CmdZabij + CmdQuestMaster then begin
      Combat.PoisonCharges := 10;
      Combat.FireballCharges := 20;
      Combat.EnemyStrength := 10;
      Combat.EnemyDexterity := 26;
      Combat.EnemyEnergy := 188;
      DoFight;
      if Combat.EnemyEnergy < 1 then Bag.Permit := Bag.Permit - ItemUnit;
    end;
  until Session.Room <> RoomQuestMaster;

end;

procedure Room101;

begin
  BasicRoomQuitGeneric(RoomRoad1,
            TxtRoom101Lines1,
            [TxtShared_03,
             TxtExitWschod, TxtPlaceRozjazd,
             TxtExitZachod, TxtPlaceDroga,
             TxtExitPolnoc, TxtPlaceLas,
             TxtExitPolodnie, TxtPlaceLas],
            [Go(CmdWschod, RoomQuestMaster), Go(CmdZachod, RoomRoad2),
             Go(CmdPolnoc, RoomForest)],
            CmdPatrz + CmdDrogowskaz,
            [TxtRoom101_05]);
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

procedure ConcertRooms;

begin
  if Session.Room = RoomCrowd1 then begin

    WriteLines(TxtConcertRoomsLines1);
    DescribeCrowd;
    repeat
      ReadCommand;
      CheckMode;
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
      ReadCommand;
      ExpandAbbrev;
      CheckMode;
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
      ReadCommand;
      ExpandAbbrev;
      CheckMode;
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
      ReadCommand;
      ExpandAbbrev;
      CheckMode;
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
      ReadCommand;
      ExpandAbbrev;
      CheckMode;
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
      ReadCommand;
      ExpandAbbrev;
      CheckMode;
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
    if World.Monsters[Minibarman] = 67 then
      WriteLn(TxtConcertRooms_20);
    if World.Monsters[Fatso] = 67 then
      WriteLn(TxtConcertRooms_21);
    DescribeCrowd;
    repeat
      ReadCommand;
      ExpandAbbrev;
      CheckMode;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitWschod, TxtPlaceWejscieNaEstrade,
                      TxtExitPolodnie, TxtPlaceTlum]);
      ConcertFights;
      if (Command = CmdZabij + CmdMiniBarman) and (World.Monsters[Minibarman] = 67) then begin
        WriteLn(TxtConcertRooms_23);
        WriteLn(TxtConcertRooms_24);
        Fight(VeryHardEnemy);
        if Player.Energy > 0 then begin
          World.Monsters[Minibarman] := 0;
          Combat.Roll := Random(100);
          if Combat.Roll < 15 then begin
            WriteLn(TxtConcertRooms_25, TxtShared_08, TxtPiwoTail);
            Bag.Items[Beer] := Bag.Items[Beer] - ItemUnit;
            Bag.Count := Bag.Count + 1;
          end;
        end;
      end;
      if (Command = CmdZabij + CmdGrubas) and (World.Monsters[Fatso] = 67) then begin
        Fight(VeryHardEnemy);
        if Player.Energy > 0 then begin
          World.Monsters[Fatso] := 0;
          if Combat.Roll < 15 then begin
            WriteLn(TxtConcertRooms_26, TxtShared_08, TxtPiwoTail);
            Bag.Items[Beer] := Bag.Items[Beer] - ItemUnit;
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
      ReadCommand;
      ExpandAbbrev;
      CheckMode;
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
    if World.Monsters[DJ] = 69 then
      WriteLn(TxtConcertRooms_35);
    repeat
      ReadCommand;
      CheckMode;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitZachod, TxtPlaceWejscieNaScene,
                      TxtExitPolodnie, TxtPlaceScena]);
      if Command = CmdZabij + CmdDJ then begin
        if World.Monsters[DJ] = 69 then begin
          Fight(VeryHardEnemy);
          if Combat.EnemyEnergy < 0 then begin
            World.Monsters[DJ] := 0;
            Combat.Roll := Random(100);
            if Combat.Roll < 25 then begin
              WriteLn(TxtShared_08, TxtConcertRooms_38);
              Bag.Items[DryRation] := Bag.Items[DryRation] - ItemUnit;
              Bag.Count := Bag.Count + 1;
            end;
            if Combat.Roll < 3 then begin
              WriteLn(TxtShared_08, TxtConcertRooms_39);
              WriteLn(TxtBang, TxtUniqeItem, TxtConcertRooms_40);
              Bag.Items[Cassette] := Bag.Items[Cassette] - ItemUnit;
              Player.MaxEnergy := Player.MaxEnergy + 5;
              Gear.Values[Armor] := Gear.Values[Armor] - 8;
              Bag.Count := Bag.Count + 1;
              Player.Stats[Dexterity] := Player.Stats[Dexterity] + 1;
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
      ReadCommand;
      CheckMode;
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
      ReadCommand;
      CheckMode;
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
      ReadCommand;
      CheckMode;
      if Command = CmdExit then
          WriteExits([TxtShared_03,
                      TxtExitPolnoc, TxtPlaceSrodekSceny]);
      if MoveWhenOrExit([Go(CmdPolnoc, RoomStage2)]) then Exit;
      StageFights;
    until Session.Room <> RoomStage3;
  end;
end;

procedure PlainRooms;
var
  i: Integer;
begin
  for i := Low(SideRooms) to High(SideRooms) do
    with SideRooms[i] do
      SimpleRoom(room, dest, direction, exitDesc);
end;

procedure BasicRoomGeneric(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; posterCmd: string;
  const poster: array of string);
begin
  if Session.Room <> RoomNo then Exit;
  WriteLines(intro);
  repeat
    ReadCommand;
    CheckMode;
    if Command = CmdExit then
        WriteExits(exits);
    if MoveWhenOrExit(moves) then Exit;
    if (Low(poster) <= High(poster)) and (Command = posterCmd) then
        WriteLines(poster);
  until Session.Room <> RoomNo;
end;

procedure BasicRoomPoster(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; const poster: array of string);
begin
  BasicRoomGeneric(RoomNo, intro, exits, moves, CmdPatrz + CmdPlakat, poster);
end;

procedure BasicRoomQuit(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement);
begin
  BasicRoomQuitGeneric(RoomNo, intro, exits, moves, '', []);
end;

procedure BasicRoomQuitGeneric(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; posterCmd: string;
  const poster: array of string);
begin
  if Session.Room <> RoomNo then Exit;
  WriteLines(intro);
  repeat
    ReadCommand;
    CheckMode;
    if Command = CmdExit then
        WriteExits(exits);
    if MoveWhenOrQuit(moves) then Exit;
    if (Low(poster) <= High(poster)) and (Command = posterCmd) then
        WriteLines(poster);
  until Session.Room <> RoomNo;
end;

procedure BasicRoomQuitPoster(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement; const poster: array of string);
begin
  BasicRoomQuitGeneric(RoomNo, intro, exits, moves, CmdPatrz + CmdPlakat,
    poster);
end;

procedure BasicRoomSimple(RoomNo: Integer; const intro, exits: array of string;
  const moves: array of TMovement);
begin
  BasicRoomGeneric(RoomNo, intro, exits, moves, '', []);
end;

procedure SimpleRoom(RoomNo, DestRoom: Integer; Direction, ExitDesc: string);

begin
  if Session.Room = RoomNo then begin
    WriteLn(TxtYouAreIn, TxtSimpleRoom_01);
    repeat
      ReadCommand;
      CheckMode;
      if Command = CmdExit then begin
        WriteLn(TxtShared_03);
        WriteLn(Direction + TxtSimpleRoom_02 + ExitDesc);
      end;
      if MoveWhenOrExit([Go(Direction, DestRoom)]) then Exit;
    until Session.Room <> RoomNo;
  end;
end;

procedure DispatchRoom;

var
  ri: Integer;
begin
  for ri := Low(RoomDispatch) to High(RoomDispatch) do
    if (RoomDispatch[ri].id = -1) or (Session.Room = RoomDispatch[ri].id) then begin
      RoomDispatch[ri].run;
      if Session.ExitRequested then Exit;
    end;
end;

end.
