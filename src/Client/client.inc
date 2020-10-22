;*********** Client Header **********;
IFNDEF CLIENT_HEADER
CLIENT_HEADER PROTO


INCLUDE Util/util.inc
INCLUDE Util/debug.inc


;********* Client Model Part ********;
DispatchConnect     PROTO, ip: PTR BYTE, port: DWORD
DispatchDisconnect  PROTO
DispatchLogin       PROTO, user: PTR BYTE, pswd: PTR BYTE
DispatchRegister    PROTO
DispatchSendText    PROTO
HandleServerMessage PROTO
GetSockfd           PROTO, sockbuf: PTR DWORD
SetSockfd           PROTO, newsock: DWORD


;********* Client UI Part ********;
ViewEntry              PROTO
UpdateView             PROTO
LoginCallback          PROTO
RegisterCallback       PROTO
SendTextCallback       PROTO
AddFriendCallback      PROTO
NotificationListener   PROTO


ENDIF ; CLIENT_HEADER
