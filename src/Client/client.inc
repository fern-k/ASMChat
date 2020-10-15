;*********** Client Header **********;
IFNDEF CLIENT_HEADER
CLIENT_HEADER PROTO


INCLUDE Util/util.inc


;------------------------------------
; Connect:
; Args:
;       ip
;       port
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;       ebx -> sockfd
;------------------------------------
Connect PROTO,
    ip: PTR BYTE,
    port: DWORD
;------------------------------------
; Login:
; Args:
;       sockfd
;       user
;       pswd
; Rets:
;       eax -> {
;                 COMMON_OK, COMMON_FAILED,
;                 LOGIN_USER_UNKNOWN, LOGIN_PSWD_WRONG
;              }
;------------------------------------
Login PROTO,
    sockfd: DWORD,
    user: PTR BYTE,
    pswd: PTR BYTE
Register PROTO,
    sockfd: DWORD,
    user: PTR BYTE,
    pswd: PTR BYTE
SendTextMessage PROTO,
    sockfd: DWORD,
    target_user: PTR BYTE,
    message: PTR BYTE


ENDIF ; CLIENT_HEADER
