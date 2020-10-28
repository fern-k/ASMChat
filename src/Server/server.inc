;*********** Server Header **********;
IFNDEF SERVER_HEADER
SERVER_HEADER PROTO


INCLUDE Util/util.inc
INCLUDE Util/debug.inc


ClientData STRUCT
    sockfd   DWORD 0
    username BYTE  100 DUP(0)
    isOnline DWORD 0
ClientData ENDS

ServerModel STRUCT
    clients    ClientData 100 DUP(<>)
    clientNumb DWORD      0
ServerModel ENDS

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
; ServerListenWorker:
; Args:
;       sockfd
; Rets: None
;------------------------------------
ServerListenWorker PROTO,
    sockfd: DWORD
;------------------------------------
; ClientCommunicateWorker:
; Args:
;       sockfd
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;------------------------------------
ClientCommunicateWorker PROTO,
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
HandleMessageRequest PROTO,
    sockfd: DWORD

AppendNewClient PROTO,
    sockfd: DWORD
PrintClientList PROTO
GetClientName PROTO,
    sockfd: DWORD
GetClientSockfd PROTO,
    username: PTR BYTE


IsUserExist PROTO,
    user: PTR BYTE
IsPswdCorrect PROTO,
    user: PTR BYTE,
    pswd: PTR BYTE
StoreNewUser PROTO,
    user: PTR BYTE,
    pswd: PTR BYTE
GetFriendNumb PROTO,
    user: PTR BYTE,
    result: PTR DWORD
GetFriend PROTO,
    user: PTR BYTE,
    index: DWORD,
    result: PTR BYTE



ENDIF ; CLIENT_HEADER
