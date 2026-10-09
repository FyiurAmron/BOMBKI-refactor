{ Instr is similar to Pos, but allows to specify a start position at which the
  search in the Target string for the Objct string is to start.

  Copyright (c) 1989-1994 Norbert Juffa
}



FUNCTION  Instr  (Objct, Target: STRING; StartPos: BYTE): BYTE; ASSEMBLER;
ASM
{$IFOPT G+}
           PUSH    BP            { save frame pointer }
{$ENDIF}
           CLD                   { auto increment for string instructions }
           PUSH    DS            { save Turbo Pascal's data segment }
           LES     DI, [Target]  { pointer to target string }
           LDS     SI, [Objct]   { pointer to object string }
           XOR     BX, BX        { initialize }
           OR      BL, [StartPos]{  start position }
           JZ      @NoChange     { don't change when zero }
           DEC     BX            { dekrement start position }
@NoChange: LODSW                 { AL = length Object, AH = 1. char in Object }
           SUB     AL, 1         { length Object - 1 }
           JB      @NotFound1    { exit, if length-1 < 0 }
           MOV     CL, ES: [DI]  { length target String }
           MOV     CH, CL        { length traget String }
           SUB     CL, AL        { length target - length Object + 1 }
           JBE     @NotFound1    { if <= 0, exit }
           SUB     CL, BL        { remaining length Target }
           JBE     @NotFound1    { if <= 0, exit }
           INC     DI            { 1. char in Target }
           ADD     DI, BX        { start position in Target }
           XCHG    CH, BH        { BH = length target string, CH = 0 }
           XCHG    AL, AH        { AL = 1. char Object, AH = length Object }
           MOV     BP, SI        { save pointer }
@Search1:  REPNZ   SCASB         { scan target for 1st char of Object }
           JNZ     @NotFound2    { if not found, exit }
           MOV     BL, CL        { save remaining length target }
           MOV     CL, AH        { char still to compare in Object }
           MOV     DX, DI        { get offset into Target }
           REPZ    CMPSB         { compare CX chars of Target and Object }
           MOV     SI, BP        { offset into Object }
           MOV     DI, DX        { offset into Target }
           MOV     CL, BL        { remaining length Target }
           JNZ     @Search1      { continue search if no complete match }
           SUB     BH, BL        { pos = length Target - remaining len target}
           SUB     BH, AH        { pos = l. Target - rem. l. target - l. Object}
@NotFound1:MOV     CH, BH        { pos }
@NotFound2:MOV     AL, CH        { pos }
           XOR     AH, AH        { clear MSB }
           POP     DS            { restore TURBO Pascal's data segment }
{$IFOPT G+}
           POP     BP            { restore frame pointer }
{$ENDIF}
END; { Instr }
