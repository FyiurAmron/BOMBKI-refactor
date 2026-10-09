unit pastest;
{Minimal unit-test framework for the BOMBKI reconstruction.

Plain TP-compatible Pascal so the same test sources compile
with FPC -Mtp (host-native) and, later, with genuine TP7
under DOS: procedural types for the test registry, Str()
for number formatting, writeln diagnostics, and Halt(code)
as the pass/fail signal for the Python runner.

Each test registers itself with RegisterTest. RunTests runs
every test (or only the one named by the first command-line
argument, which gives each test a fresh process and keeps
the units' global state from leaking between tests) and
halts with code 1 when any check failed.}
interface
type
  TTestProc = procedure;

procedure RegisterTest(const name: string; proc: TTestProc);
procedure CheckTrue(condition: Boolean; const what: string);
procedure CheckEqual(expected, actual: Longint; const what: string);
procedure CheckStrEqual(const expected, actual: string; const what: string);
procedure CheckRange(const what: string; value, low, high: Longint);
procedure RunTests;

implementation

const
  {Static arrays keep the unit TP7-compatible; the cap is
   only a guard against runaway registration.}
  MaxTests = 200;

var
  TestNames: array[1..MaxTests] of string;
  TestProcs: array[1..MaxTests] of TTestProc;
  TestCount: Integer;
  Failures: Integer;
  CurrentTest: string;

procedure Fail(const what: string);
begin
  Failures := Failures + 1;
  WriteLn('FAIL [', CurrentTest, '] ', what);
end;

procedure RegisterTest(const name: string; proc: TTestProc);
begin
  if TestCount >= MaxTests then begin
    WriteLn('pastest: too many tests (maximum ', MaxTests, ')');
    Halt(1);
  end;
  TestCount := TestCount + 1;
  TestNames[TestCount] := name;
  TestProcs[TestCount] := proc;
end;

procedure CheckTrue(condition: Boolean; const what: string);
begin
  if not condition then
    Fail(what);
end;

procedure CheckEqual(expected, actual: Longint; const what: string);
var
  s1, s2: string;
begin
  if expected <> actual then begin
    Str(expected, s1);
    Str(actual, s2);
    Fail(what + ' (expected ' + s1 + ', got ' + s2 + ')');
  end;
end;

procedure CheckStrEqual(const expected, actual: string; const what: string);
begin
  if expected <> actual then
    Fail(what + ' (expected "' + expected + '", got "' + actual + '")');
end;

procedure CheckRange(const what: string; value, low, high: Longint);
var
  s1, s2, s3: string;
begin
  if (value < low) or (value > high) then begin
    Str(value, s1);
    Str(low, s2);
    Str(high, s3);
    Fail(what + ' in ' + s2 + '..' + s3 + ' (got ' + s1 + ')');
  end;
end;

procedure RunTests;
var
  i, ran: Integer;
  filter: string;
begin
  filter := '';
  if ParamCount > 0 then
    filter := ParamStr(1);
  ran := 0;
  for i := 1 to TestCount do
    if (filter = '') or (TestNames[i] = filter) then begin
      CurrentTest := TestNames[i];
      WriteLn('RUN ', TestNames[i]);
      TestProcs[i];
      ran := ran + 1;
    end;
  if (filter <> '') and (ran = 0) then begin
    WriteLn('no test named "', filter, '"');
    Halt(1);
  end;
  WriteLn('tests: ', ran, ', failures: ', Failures);
  if Failures > 0 then
    Halt(1);
end;

begin
  TestCount := 0;
  Failures := 0;
  CurrentTest := '';
end.
