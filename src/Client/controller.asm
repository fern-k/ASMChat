INCLUDE ./client.inc

DealwithLoginResponse PROTO

.code

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
            INVOKE DealwithLoginResponse
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
__DealwithLoginResponse__BUFFERSIZE DWORD 10 * 1024 * 1024
.code
DealwithLoginResponse PROC
    LOCAL sockfd: DWORD
    LOCAL flistBuffer: PTR BYTE
    LOCAL flistBufLen:    DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE crt_malloc, __DealwithLoginResponse__BUFFERSIZE
    mov    flistBuffer, eax
    INVOKE crt_memset, flistBuffer, 0, __DealwithLoginResponse__BUFFERSIZE
    INVOKE Util_RecvStream, sockfd, flistBuffer, __DealwithLoginResponse__BUFFERSIZE
    mov    flistBufLen, ebx
    INVOKE ParseFriendList, flistBuffer, flistBufLen
    INVOKE crt_free, flistBuffer
    @RET_OK

DealwithLoginResponse ENDP



END
