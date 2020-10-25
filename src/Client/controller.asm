INCLUDE ./client.inc

DealwithLoginResponse PROTO, code: DWORD
DealwithRegisterResponse PROTO, code: DWORD
DealwithSendTextResponse PROTO, code: DWORD
DealwithAddFriendResponse PROTO, code: DWORD
DealwithNotification PROTO, code: DWORD

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
    LOCAL sockfd: DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE closesocket, sockfd
    @RET_FAILED_IF_SOCKET_ERROR

    @RET_OK
DispatchDisconnect ENDP


DispatchLogin PROC, user: PTR BYTE, pswd: PTR BYTE
    LOCAL sockfd: DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE Util_SendCode, sockfd, REQ_LOGIN
    INVOKE Util_SendStream, sockfd, user
    INVOKE Util_SendStream, sockfd, pswd
    @RET_FAILED_IF_SOCKET_ERROR

    @RET_OK
DispatchLogin ENDP


DispatchRegister PROC, user: PTR BYTE, pswd: PTR BYTE
    LOCAL sockfd: DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE Util_SendCode, sockfd, REQ_REGISTER
    INVOKE Util_SendStream, sockfd, user
    INVOKE Util_SendStream, sockfd, pswd
    @RET_FAILED_IF_SOCKET_ERROR

    @RET_OK
DispatchRegister ENDP


DispatchSendText PROC, targetUser: PTR BYTE, message: PTR BYTE
    LOCAL sockfd: DWORD

    INVOKE GetSockfd, ADDR sockfd
    INVOKE Util_SendCode, sockfd, REQ_MESSAGE
    INVOKE Util_SendStream, sockfd, targetUser
    INVOKE Util_SendStream, sockfd, message
    @RET_FAILED_IF_SOCKET_ERROR

    @RET_OK
DispatchSendText ENDP


DealwithServerMessage PROC
    LOCAL sockfd: DWORD
    LOCAL codebuf: DWORD

    INVOKE GetSockfd, ADDR sockfd
    .WHILE TRUE
        INVOKE Util_RecvCode, sockfd, ADDR codebuf
        @BREAK_IF_NOT_OK
        mov eax, codebuf
        .IF eax > LOGIN_CODE_START && eax < LOGIN_CODE_END
            INVOKE DealwithLoginResponse, codebuf
        .ELSEIF eax > REGISTER_CODE_START && eax < REGISTER_CODE_END
            INVOKE DealwithRegisterResponse, codebuf
        .ELSEIF eax > SENDTEXT_CODE_START && eax < SENDTEXT_CODE_END
            INVOKE DealwithSendTextResponse, codebuf
        .ELSEIF eax > ADDFRIEND_CODE_START && eax < ADDFRIEND_CODE_END
            INVOKE DealwithAddFriendResponse, codebuf
        .ELSEIF eax > SERVER_NOTIFY_CODE_START && eax < SERVER_NOTIFY_CODE_END
            INVOKE DealwithNotification, codebuf
        .ENDIF
    .ENDW

    ret
DealwithServerMessage ENDP


.data
__DealwithLoginResponse__BUFFERSIZE DWORD 10 * 1024 * 1024
.code
DealwithLoginResponse PROC, code: DWORD
    LOCAL sockfd:        DWORD
    LOCAL friendlistbuf: PTR BYTE
    LOCAL friendlistlen: DWORD

    mov eax, code
    .IF eax != LOGIN_OK
        INVOKE LoginCallback, code
        @RET_FAILED
    .ENDIF

    INVOKE Util_Malloc, ADDR friendlistbuf, __DealwithLoginResponse__BUFFERSIZE

    INVOKE GetSockfd, ADDR sockfd
    INVOKE Util_RecvStream, sockfd, friendlistbuf
    mov    friendlistlen, ebx
    INVOKE ParseFriendList, friendlistbuf, friendlistlen
    INVOKE LoginCallback, code

    INVOKE Util_Free, friendlistbuf
    @RET_OK
DealwithLoginResponse ENDP


DealwithRegisterResponse PROC, code: DWORD
    INVOKE RegisterCallback, code
    @RET_OK
DealwithRegisterResponse ENDP


DealwithSendTextResponse PROC, code: DWORD
    INVOKE SendTextCallback, code
    @RET_OK
DealwithSendTextResponse ENDP


DealwithAddFriendResponse PROC, code: DWORD
    INVOKE AddFriendCallback, code
    @RET_OK
DealwithAddFriendResponse ENDP


DealwithNotification PROC, code: DWORD
    INVOKE NotificationListener, code
    @RET_OK
DealwithNotification ENDP




END
