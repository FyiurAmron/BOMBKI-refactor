program BOMBKI;

uses
  Game, Rooms;

begin
  { The Rooms unit owns the per-turn room dispatch; the game core
    calls it through this hook, which keeps the two units free of
    a circular reference. }
  Game.DispatchRooms := Rooms.DispatchRoom;
  Game.Start;
end.
