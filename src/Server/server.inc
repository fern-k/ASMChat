;*********** Server Header **********;
IFNDEF SERVER_HEADER
SERVER_HEADER PROTO


INCLUDE Util/util.inc
INCLUDE Util/debug.inc


;------------------------------------
; ServerUp:
; Args:
;       port
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;       ebx -> sockfd
;------------------------------------
ServerUp PROTO,
    port: DWORD
;------------------------------------
; HandleRequest:
; Args:
;       sockfd
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;------------------------------------
HandleRequest PROTO,
    sockfd: DWORD
;------------------------------------
; HandleLogin:
; Args:
;       sockfd
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;------------------------------------
HandleLogin PROTO,
    sockfd: DWORD
IsUserExist PROTO,
    user: PTR BYTE
IsPswdCorrect PROTO,
    pswd: PTR BYTE





ENDIF ; CLIENT_HEADER
