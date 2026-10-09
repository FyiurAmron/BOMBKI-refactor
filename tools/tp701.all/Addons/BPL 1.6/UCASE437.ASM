
; *******************************************************
; *                                                     *
; *     Turbo Pascal Runtime Library Version 7.0        *
; *     Character Handling Routines                     *
; *                                                     *
; *     Copyright (C) 1991-94 Norbert Juffa             *
; *                                                     *
; *******************************************************

             TITLE   UCASE437


CODE         SEGMENT BYTE PUBLIC

             ASSUME  CS:CODE

; Publics

             PUBLIC  UpCase437

;-------------------------------------------------------------------------------
; Enhanced UpCase function: UpCase437 (Ch: CHAR): CHAR
;
; UpCase437 translates all characters which have an upper case equivalent in
; the IBM character set, codepage 437, to upper case.
;
; On entry:  [SP+4]  input character
;
; On exit:   AL      input character converted to upper case
;-------------------------------------------------------------------------------

UpCase437    PROC    FAR
             MOV     BX, SP            ; new frame pointer
             MOV     AL, SS:[BX+4]     ; get character
             CMP     AL, 'a'           ; char smaller than 'a' ?
             JB      $no_trans         ; yes, no translation
             CMP     AL, 'z'           ; char bigger than 'z' ?
             JA      $special          ; yes, maybe one of the special chars
             SUB     AL, 'a'-'A'       ; translate lower case to upper case
$no_trans:   RET     2                 ; pop parameter and return
$special:    CLD                       ; auto increment for string instructions
             MOV     DI, OFFSET Tbl1   ; address of table with special chars
             MOV     CX, Len           ; length of that table
             MOV     BX, CS            ; initialize extra segment
             MOV     ES, BX            ;  (table in code segment)
             REPNE   SCASB             ; character translatable ?
             JNE     $not_found        ; no, not in table
             MOV     AL, ES:[DI+Len-1] ; yes, load upper case char
$not_found:  RET     2                 ; pop parameters and return
Tbl1         DB      'ÑÅîÜëÇ§á'        ; translatable lower case chars
Tbl2         DB      'éöôèíê•Ä'        ; and their upper case versions
Len          EQU     Tbl2-Tbl1         ; compute table length
UpCase437    ENDP

CODE         ENDS

             END
