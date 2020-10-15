;************ Util Header **********;
IFNDEF UTIL_HEADER
UTIL_HEADER PROTO


;------------- Include -------------;
;  The MASM32 Runtime Library includes most of needed files
;  Like windows.inc, kernel32.inc, user32.inc, masm32.inc, etc
;  See https://searchcode.com/codesearch/view/13886032/
INCLUDE masm32rt.inc
;  Windows Socket 2 Library
;  See https://docs.microsoft.com/en-us/windows/win32/api/_winsock/
INCLUDE ws2_32.inc


;------------- Declare -------------;
;------------------------------------
; Util_CreateSocket:
; Args: None
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;       ebx -> socket
;------------------------------------
Util_CreateSocket PROTO
;------------------------------------
; Exit: Exit program.
; Args:
;       code
; Rets: None
;------------------------------------
Util_Exit PROTO, code: DWORD


.const
defaultServerIP   BYTE  "127.0.0.1", 0
defaultServerPort DWORD 9798

;-------------- Code ---------------;
CODE_LEN           DWORD 4

; Common code
COMMON_OK          DWORD 00h
COMMON_FAILED      DWORD 01h

; Request code
REQ_LOGIN          DWORD 700h
REQ_LOGOUT         DWORD 701h
REQ_REGISTER       DWORD 702h
REQ_MESSAGE        DWORD 710h
REQ_PICTURE        DWORD 711h

; Login response code
LOGIN_USER_UNKNOWN DWORD 810h
LOGIN_PSWD_WRONG   DWORD 811h


ENDIF ; UTIL_HEADER
