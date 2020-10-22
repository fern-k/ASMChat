INCLUDE ./client.inc


HandleLoginResponse PROTO
ParseFriendList     PROTO, flistBuffer: PTR BYTE, flistBufLen: DWORD


FriendModel STRUCT
    username BYTE 100 DUP(0)
    status DWORD 0
FriendModel ENDS

ClientModel STRUCT
    sockfd DWORD 0
    friendList FriendModel 100 DUP(<>)
    friendNumb DWORD 0
ClientModel ENDS


.data
clientModelInstance ClientModel <>


.code
GetSockfd PROC, sockbuf: PTR DWORD
    INVOKE crt_memcpy, sockbuf, OFFSET clientModelInstance.sockfd, TYPE DWORD
    @RET_OK
GetSockfd ENDP

SetSockfd PROC, newsock: DWORD
    mov eax, newsock
    mov clientModelInstance.sockfd, eax
    @RET_OK
SetSockfd ENDP

GetFriendList PROC, flistbuf: PTR DWORD
    LOCAL  frinedListAddr: DWORD
    mov    frinedListAddr, OFFSET clientModelInstance.friendList
    INVOKE crt_memcpy, flistbuf, ADDR frinedListAddr, TYPE DWORD
    @RET_OK
GetFriendList ENDP

AppendFriend PROC, newFriend: PTR FriendModel
    mov eax, clientModelInstance.friendNumb
    INVOKE crt_memcpy, clientModelInstance.friendList[eax], newFriend, SIZEOF FriendModel
    inc clientModelInstance.friendNumb
    @RET_OK
AppendFriend ENDP

ChangeFriendStatus PROC USES ebx ecx edx, friendName: PTR BYTE, newStatus: DWORD
    LOCAL currFriend: PTR FriendModel

    mov ecx, 0
    mov ebx, clientModelInstance.friendNumb
    .WHILE ecx < ebx
        mov eax, SIZEOF FriendModel
        mul ecx
        add eax, OFFSET clientModelInstance.friendList
        mov currFriend, eax
        INVOKE crt_strcmp, (FriendModel PTR currFriend).username, friendName
        .IF eax != 0
            inc ecx
            .CONTINUE
        .ENDIF
        INVOKE crt_memcpy, (FriendModel PTR currFriend).status, ADDR newStatus, TYPE DWORD
        @RET_OK
    .ENDW
    @RET_FAILED
ChangeFriendStatus ENDP

DispatchConnect PROC, ip: PTR BYTE, port: DWORD
    LOCAL sockfd: DWORD
    LOCAL sockAddr: sockaddr_in

    INVOKE Util_CreateSocket
    @RET_FAILED_IF_NOT_OK
    mov    sockfd, ebx
    INVOKE SetSockfd, sockfd

    INVOKE htons, port
    mov    sockAddr.sin_port, ax
    INVOKE inet_addr, ip
    mov    sockAddr.sin_addr, eax
    mov    sockAddr.sin_family, AF_INET
	INVOKE connect, sockfd, ADDR sockAddr, SIZEOF sockAddr
    @RET_FAILED_IF_SOCKET_ERROR

    mov ebx, sockfd
    @RET_OK

DispatchConnect ENDP


DispatchDisconnect PROC
    LOCAL sockfd:  DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE closesocket, sockfd
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

DispatchDisconnect ENDP


DispatchLogin PROC, user: PTR BYTE, pswd: PTR BYTE
    LOCAL sockfd:  DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE Util_SendCode, sockfd, REQ_LOGIN
    INVOKE Util_SendStream, sockfd, user
    INVOKE Util_SendStream, sockfd, pswd
    ret

DispatchLogin ENDP


HandleServerMessage PROC
    LOCAL sockfd: DWORD
    LOCAL codebuf: DWORD

    INVOKE GetSockfd, ADDR sockfd
    .WHILE TRUE
        INVOKE Util_RecvCode, sockfd, ADDR codebuf
        @BREAK_IF_NOT_OK
        mov eax, codebuf
        .IF eax > LOGIN_CODE_START && eax < LOGIN_CODE_END
            INVOKE HandleLoginResponse
        .ELSEIF eax > REGISTER_CODE_START && eax < REGISTER_CODE_END
            ;INVOKE RegisterCallback
        .ELSEIF eax > SENDTEXT_CODE_START && eax < SENDTEXT_CODE_END
            ;INVOKE SendTextCallback
        .ELSEIF eax > ADDFRIEND_CODE_START && eax < ADDFRIEND_CODE_END
            ;INVOKE AddFriendCallback
        .ELSEIF eax > SERVER_NOTIFY_CODE_START && eax < SERVER_NOTIFY_CODE_END
            ;INVOKE NotificationListener
        .ENDIF
    .ENDW
    ret

HandleServerMessage ENDP


.data
__HandleLoginResponse__BUFFERSIZE DWORD 10 * 1024 * 1024
.code
HandleLoginResponse PROC
    LOCAL sockfd: DWORD
    LOCAL flistBuffer: PTR BYTE
    LOCAL flistBufLen:    DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE crt_malloc, __HandleLoginResponse__BUFFERSIZE
    mov    flistBuffer, eax
    INVOKE crt_memset, flistBuffer, 0, __HandleLoginResponse__BUFFERSIZE
    INVOKE Util_RecvStream, sockfd, flistBuffer, __HandleLoginResponse__BUFFERSIZE
    mov    flistBufLen, ebx
    INVOKE ParseFriendList, flistBuffer, flistBufLen
    INVOKE crt_free, flistBuffer
    @RET_OK

HandleLoginResponse ENDP



ParseFriendList PROC USES ebx ecx edx, flistBuffer: PTR BYTE, flistBufLen: DWORD
    LOCAL flistLength:    DWORD
    LOCAL currFriend:     PTR FriendModel

    INVOKE Util_Div, flistBufLen, TYPE FriendModel
    mov    flistLength, ebx

    mov ecx, 0
    .WHILE ecx < ebx
        mov eax, TYPE FriendModel
        mul ecx
        add eax, flistBuffer
        mov currFriend, eax
        INVOKE AppendFriend, currFriend
        inc ecx
    .ENDW

    @RET_OK

ParseFriendList ENDP


END
