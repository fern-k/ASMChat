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


AppendFriend PROC, friendName: PTR BYTE
    LOCAL target:  PTR FriendModel
    LOCAL namelen: DWORD
    .data
    __AppendFriend__tempfriend FriendModel <>
    .code


    mov    __AppendFriend__tempfriend.isOnline, 0
    INVOKE crt_strlen, friendName
    mov    namelen, eax
    INVOKE crt_memcpy, OFFSET __AppendFriend__tempfriend.username, friendName, namelen

    mov    target, OFFSET clientModelInstance.friendList
    mov    eax, SIZEOF FriendModel
    mul    clientModelInstance.friendNumb
    add    target, eax
    INVOKE crt_memcpy, target, ADDR __AppendFriend__tempfriend, SIZEOF FriendModel

    inc    clientModelInstance.friendNumb
    @RET_OK
AppendFriend ENDP


ChangeFriendIsOnline PROC USES ebx ecx edx, friendName: PTR BYTE, newIsOnline: DWORD
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
        INVOKE crt_memcpy, (FriendModel PTR currFriend).isOnline, ADDR newIsOnline, TYPE DWORD
        @RET_OK
    .ENDW

    @RET_FAILED
ChangeFriendIsOnline ENDP


END
