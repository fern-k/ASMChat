;*********** Client Header **********;
IFNDEF CLIENT_HEADER
CLIENT_HEADER PROTO


INCLUDE Util/util.inc
INCLUDE Util/debug.inc

;*****
; The Client project was divided into three components:
; Model, View and Controller.
; (A simple rule to simulate MVC framework)
;*****


;********* Client Model Part *********;
GetSockfd              PROTO, sockbuf: PTR DWORD
SetSockfd              PROTO, newsock: DWORD
GetFriendList          PROTO, flistbuf: PTR DWORD
AppendFriend           PROTO, newFriend: PTR FriendModel
ChangeFriendStatus     PROTO, friendName: PTR BYTE, newStatus: DWORD
ParseFriendList        PROTO, flistBuffer: PTR BYTE, flistBufLen: DWORD

;********* Client View Part *********;
ViewEntry              PROTO
LoginCallback          PROTO
RegisterCallback       PROTO
SendTextCallback       PROTO
AddFriendCallback      PROTO
NotificationListener   PROTO

;********* Client Controller Part *********;
DealwithServerMessage  PROTO
DispatchConnect        PROTO, ip: PTR BYTE, port: DWORD
DispatchDisconnect     PROTO
DispatchLogin          PROTO, user: PTR BYTE, pswd: PTR BYTE
DispatchRegister       PROTO
DispatchSendText       PROTO



ENDIF ; CLIENT_HEADER
