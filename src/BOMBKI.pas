program BOMBKI;

uses
  Game, Rooms;

begin
  Game.DispatchRooms := Rooms.DispatchRoom;
  Game.Start;
end.
