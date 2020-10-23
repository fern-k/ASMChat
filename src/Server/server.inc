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
; HandleRequestEntry:
; Args:
;       sockfd
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;------------------------------------
HandleRequestEntry PROTO,
    sockfd: DWORD
;------------------------------------
; HandleLoginRequest:
; Args:
;       sockfd
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;------------------------------------
HandleLoginRequest PROTO,
    sockfd: DWORD
HandleRegisterRequest PROTO,
    sockfd: DWORD
IsUserExist PROTO,
    user: PTR BYTE
IsPswdCorrect PROTO,
    user: PTR BYTE,
    pswd: PTR BYTE
StoreNewUser PROTO,
    user: PTR BYTE,
    pswd: PTR BYTE




ENDIF ; CLIENT_HEADER
