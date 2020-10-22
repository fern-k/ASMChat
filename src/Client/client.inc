;*********** Client Header **********;
IFNDEF CLIENT_HEADER
CLIENT_HEADER PROTO


INCLUDE Util/util.inc
INCLUDE Util/debug.inc


;********* Client Model Part ********;
GetSockfd           PROTO, sockbuf: PTR DWORD
SetSockfd           PROTO, newsock: DWORD
ParseFriendList     PROTO, flistBuffer: PTR BYTE, flistBufLen: DWORD

;********* Client View Part ********;
ViewEntry              PROTO
UpdateView             PROTO
LoginCallback          PROTO
RegisterCallback       PROTO
SendTextCallback       PROTO
AddFriendCallback      PROTO
NotificationListener   PROTO

;********* Client Controller Part ********;
HandleServerMessage PROTO
DispatchConnect     PROTO, ip: PTR BYTE, port: DWORD
DispatchDisconnect  PROTO
DispatchLogin       PROTO, user: PTR BYTE, pswd: PTR BYTE
DispatchRegister    PROTO
DispatchSendText    PROTO



ENDIF ; CLIENT_HEADER
