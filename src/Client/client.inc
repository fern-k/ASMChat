;*********** Client Header **********;
IFNDEF CLIENT_HEADER
CLIENT_HEADER PROTO

INCLUDE Util/util.inc
INCLUDE Util/debug.inc

ChatLinklistNode STRUCT
    next DWORD 0
    data DWORD 0
    dlen DWORD 0
    time SYSTEMTIME <>
ChatLinklistNode ENDS

FriendModel STRUCT
    username BYTE 100 DUP(0)
    status DWORD 0
    chatListHeader ChatLinklistNode <>
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
LoginCallback          PROTO, code: DWORD
RegisterCallback       PROTO, code: DWORD
SendTextCallback       PROTO, code: DWORD
AddFriendCallback      PROTO, code: DWORD
NotificationListener   PROTO, code: DWORD

;********* Client Controller Component *********;
DealwithServerMessage  PROTO
DispatchConnect        PROTO, ip: PTR BYTE, port: DWORD
DispatchDisconnect     PROTO
DispatchLogin          PROTO, user: PTR BYTE, pswd: PTR BYTE
DispatchRegister       PROTO, user: PTR BYTE, pswd: PTR BYTE
DispatchSendText       PROTO, targetUser: PTR BYTE, message: PTR BYTE



ENDIF ; CLIENT_HEADER
