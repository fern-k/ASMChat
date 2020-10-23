INCLUDE ./client.inc


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
