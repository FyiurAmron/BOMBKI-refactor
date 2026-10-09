Unit      Need_386; Interface
{ ------------------------------------------------------------------------- }
{ Support module for units optimized by Sally Peephole Optimizer.           }
{ Copyright 1994 by Sally I/S.                                              }
{                                                                           }
{ Private individuals may distribute compiled versions of this unit as part }
{ of their own software provided that the copyright messages are left       }
{ intact.                                                                   }
{                                                                           }
{ Aborts program if processor is not 386 or better.                         }
{ ------------------------------------------------------------------------- }
{$R-,S-,I-,Q-,O-,F-,G-,A+}

Implementation
{ ------------------------------------------------------------------------- }
{$IFNDEF OS2}
Begin
  If Test8086<2 Then Begin
    Writeln('This program requires a 386 cpu or better.');
    Halt($FC);
    Writeln('Portions copyright 1993 by Sally I/S'#13#10);
  End;
{$ENDIF}
End.
