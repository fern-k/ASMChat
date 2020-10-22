;*********** Client Header **********;
IFNDEF CLIENT_HEADER
CLIENT_HEADER PROTO


INCLUDE Util/util.inc
INCLUDE Util/debug.inc


;***** Client communication Part *****;
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
;------------------------------------
; Register:
; Args:
;       sockfd
;       user
;       pswd
; Rets:
;       eax -> {
;                 COMMON_OK, COMMON_FAILED,
;                 REGISTER_USER_EXIST
;              }
;------------------------------------
Register PROTO,
    sockfd: DWORD,
    user: PTR BYTE,
    pswd: PTR BYTE
;------------------------------------
; SendText:
; Args:
;       sockfd
;       target_user
;       message
; Rets:
;       eax -> {
;                 COMMON_OK, COMMON_FAILED,
;                 SENDTEXT_TARGET_OFFLINE, SENDTEXT_TARGET_UNFAMILIAR,
;                 SENDTEXT_TARGET_NOTFOUND
;              }
;------------------------------------
SendText PROTO,
    sockfd: DWORD,
    target_user: PTR BYTE,
    message: PTR BYTE
HandleServerMessage PROTO
HandleLoginResponse PROTO
ParseFriendList     PROTO,
    flistBuffer: PTR BYTE,
    flistBufLen: DWORD


;********* Client Model Part ********;
; private
GetSockfd        PROTO, sockbuf: PTR DWORD
SetSockfd        PROTO, newsock: DWORD
; public
DispatchConnect PROTO, ip: PTR BYTE, port: DWORD
DispatchLogin    PROTO, user: PTR BYTE, pswd: PTR BYTE
DispatchRegister PROTO
DispatchSendText PROTO



;********* Client UI Part ********;
ViewEntry              PROTO
UpdateView             PROTO
LoginCallback          PROTO
RegisterCallback       PROTO
SendTextCallback       PROTO
AddFriendCallback      PROTO
NotificationListener   PROTO



ENDIF ; CLIENT_HEADER
