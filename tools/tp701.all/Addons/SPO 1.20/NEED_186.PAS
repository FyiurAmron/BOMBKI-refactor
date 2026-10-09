Unit      Need_186; Interface
{ ------------------------------------------------------------------------- }
{ Support module for units optimized by Sally Peephole Optimizer.           }
{ Copyright 1994 by Sally I/S.                                              }
{                                                                           }
{ Private individuals may distribute compiled versions of this unit as part }
{ of their own software provided that the copyright messages are left       }
{ intact.                                                                   }
{                                                                           }
{ Aborts program if processor is not 186 or better.                         }
{ ------------------------------------------------------------------------- }
{$R-,S-,I-,Q-,O-,F-,G-,A+}

Implementation
{ ------------------------------------------------------------------------- }
{$IFDEF MSDOS}
Begin
  If 1 Shl (Test8086+32)=0 Then Begin
    Writeln('This program requires a 186 cpu or better.');
    Halt($FC);
    Writeln('Portions copyright 1993 by Sally I/S'#13#10);
  End;
{$ENDIF}
End.
