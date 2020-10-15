;*********** Server Header **********;
IFNDEF SERVER_HEADER
SERVER_HEADER PROTO


INCLUDE Util/util.inc


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




ENDIF ; CLIENT_HEADER
