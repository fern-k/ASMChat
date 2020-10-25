;************ debug Header **********;
IFNDEF DEBUG_HEADER
DEBUG_HEADER PROTO


;--------------- Debug ---------------;
; Example: @DEBUG A0
; (See markers in bellow section)
@DEBUG MACRO marker
    pushad
    INVOKE crt_printf, ADDR marker
    popad
ENDM

; Example: @DBPRINT FMT_DWORD_ENDL, a_dword_value
; (See formatters in bellow section)
@DBPRINT MACRO formatter, d
    pushad
    INVOKE crt_printf, ADDR formatter, d
    popad
ENDM


.const
;------------ Marker -----------;
A0 BYTE "A0", 0dh, 0ah, 0
A1 BYTE "A1", 0dh, 0ah, 0
A2 BYTE "A2", 0dh, 0ah, 0
A3 BYTE "A3", 0dh, 0ah, 0
A4 BYTE "A4", 0dh, 0ah, 0
A5 BYTE "A5", 0dh, 0ah, 0
A6 BYTE "A6", 0dh, 0ah, 0
A7 BYTE "A7", 0dh, 0ah, 0
A8 BYTE "A8", 0dh, 0ah, 0
A9 BYTE "A9", 0dh, 0ah, 0
B0 BYTE "B0", 0dh, 0ah, 0
B1 BYTE "B1", 0dh, 0ah, 0
B2 BYTE "B2", 0dh, 0ah, 0
B3 BYTE "B3", 0dh, 0ah, 0
B4 BYTE "B4", 0dh, 0ah, 0
B5 BYTE "B5", 0dh, 0ah, 0
B6 BYTE "B6", 0dh, 0ah, 0
B7 BYTE "B7", 0dh, 0ah, 0
B8 BYTE "B8", 0dh, 0ah, 0
B9 BYTE "B9", 0dh, 0ah, 0
C0 BYTE "C0", 0dh, 0ah, 0
C1 BYTE "C1", 0dh, 0ah, 0
C2 BYTE "C2", 0dh, 0ah, 0
C3 BYTE "C3", 0dh, 0ah, 0
C4 BYTE "C4", 0dh, 0ah, 0
C5 BYTE "C5", 0dh, 0ah, 0
C6 BYTE "C6", 0dh, 0ah, 0
C7 BYTE "C7", 0dh, 0ah, 0
C8 BYTE "C8", 0dh, 0ah, 0
C9 BYTE "C9", 0dh, 0ah, 0
D0 BYTE "D0", 0dh, 0ah, 0
D1 BYTE "D1", 0dh, 0ah, 0
D2 BYTE "D2", 0dh, 0ah, 0
D3 BYTE "D3", 0dh, 0ah, 0
D4 BYTE "D4", 0dh, 0ah, 0
D5 BYTE "D5", 0dh, 0ah, 0
D6 BYTE "D6", 0dh, 0ah, 0
D7 BYTE "D7", 0dh, 0ah, 0
D8 BYTE "D8", 0dh, 0ah, 0
D9 BYTE "D9", 0dh, 0ah, 0


;------------- Formatter -------------;
FMT_SP             BYTE " ", 0
FMT_ENDL           BYTE 0dh, 0ah, 0
FMT_DWORD          BYTE "%u", 0
FMT_SDWORD         BYTE "%d", 0
FMT_STRING         BYTE "%s", 0
FMT_DWORD_ENDL     BYTE "%u", 0dh, 0ah, 0
FMT_SDWORD_ENDL    BYTE "%d", 0dh, 0ah, 0
FMT_STRING_ENDL    BYTE "%s", 0dh, 0ah, 0
FMT_DWORD_SP       BYTE "%u ", 0
FMT_SDWORD_SP      BYTE "%d ", 0
FMT_STRING_SP      BYTE "%s ", 0
FMT_DWORD_SP_ENDL  BYTE "%u ", 0dh, 0ah, 0
FMT_SDWORD_SP_ENDL BYTE "%d ", 0dh, 0ah, 0
FMT_STRING_SP_ENDL BYTE "%s ", 0dh, 0ah, 0
FMT_DWORD_HEX      BYTE "0x%08x", 0
FMT_SDWORD_HEX     BYTE "0x%08x", 0



ENDIF ; DEBUG_HEADER
