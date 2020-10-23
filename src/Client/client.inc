;*********** Client Header **********;
IFNDEF CLIENT_HEADER
CLIENT_HEADER PROTO

INCLUDE Util/util.inc
INCLUDE Util/debug.inc

FriendModel STRUCT
    username BYTE 100 DUP(0)
    status DWORD 0
FriendModel ENDS

ClientModel STRUCT
    sockfd DWORD 0
    friendList FriendModel 100 DUP(<>)
    friendNumb DWORD 0
ClientModel ENDS


;*****
; The Client project was divided into three components:
; Model, View and Controller.
; (A simple rule to simulate MVC framework)
;*****


;********* Client Model Component *********;
GetSockfd              PROTO, sockbuf: PTR DWORD
SetSockfd              PROTO, newsock: DWORD
GetFriendList          PROTO, flistbuf: PTR DWORD
AppendFriend           PROTO, newFriend: PTR FriendModel
ChangeFriendStatus     PROTO, friendName: PTR BYTE, newStatus: DWORD
ParseFriendList        PROTO, flistBuffer: PTR BYTE, flistBufLen: DWORD

;********* Client View Component *********;
ViewEntry              PROTO
LoginCallback          PROTO
RegisterCallback       PROTO
SendTextCallback       PROTO
AddFriendCallback      PROTO
NotificationListener   PROTO

;********* Client Controller Component *********;
DealwithServerMessage  PROTO
DispatchConnect        PROTO, ip: PTR BYTE, port: DWORD
DispatchDisconnect     PROTO
DispatchLogin          PROTO, user: PTR BYTE, pswd: PTR BYTE
DispatchRegister       PROTO
DispatchSendText       PROTO



ENDIF ; CLIENT_HEADER
