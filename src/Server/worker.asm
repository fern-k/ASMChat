INCLUDE ./server.inc

.data
serverModelInstance ServerModel <>

.code
ServerListenWorker PROC, sockfd: DWORD
    LOCAL clientSockfd: DWORD

    .WHILE TRUE
        INVOKE accept, sockfd, NULL, 0
        @EXIT_FAILED_IF_INVALID_SOCKET
        mov clientSockfd, eax
        INVOKE CreateThread, NULL, 0, OFFSET ClientCommunicateWorker, clientSockfd, 0, NULL
    .ENDW

    INVOKE closesocket, sockfd
    ret
ServerListenWorker ENDP


ClientCommunicateWorker PROC, sockfd: DWORD
    LOCAL  codebuf:   DWORD
    LOCAL  sockfdSet: fd_set
    LOCAL  timeout:   timeval

    .WHILE TRUE
        INVOKE crt_memcpy, ADDR sockfdSet.fd_array, ADDR sockfd, TYPE DWORD
        mov    sockfdSet.fd_count, 1
        mov    timeout.tv_sec, 0
        mov    timeout.tv_usec, 200*1000
        INVOKE select, 0, ADDR sockfdSet, NULL, NULL, ADDR timeout
        .IF eax == 0
            .CONTINUE
        .ENDIF

        INVOKE crt_memset, ADDR codebuf, 0, SIZEOF codebuf
        INVOKE Util_RecvCode, sockfd, ADDR codebuf
        @BREAK_IF_NOT_OK

        mov eax, codebuf
        .IF eax == REQ_LOGIN
            INVOKE HandleLoginRequest, sockfd
        .ELSEIF eax == REQ_REGISTER
            INVOKE HandleRegisterRequest, sockfd
        .ELSEIF eax == REQ_MESSAGE
            INVOKE HandleMessageRequest, sockfd
        .ELSE
            .BREAK
        .ENDIF
    .ENDW

    INVOKE closesocket, sockfd
    ret
ClientCommunicateWorker ENDP


HandleLoginRequest PROC, sockfd: DWORD
    LOCAL userbuf[1024]: BYTE
    LOCAL pswdbuf[1024]: BYTE

    INVOKE crt_memset, ADDR userbuf, 0, 1024
    INVOKE crt_memset, ADDR pswdbuf, 0, 1024
    INVOKE Util_RecvStream, sockfd, ADDR userbuf
    INVOKE Util_RecvStream, sockfd, ADDR pswdbuf
    INVOKE IsUserExist, ADDR userbuf
    .IF eax != COMMON_OK
        @DEBUG B1
        INVOKE Util_SendCode, sockfd, LOGIN_USER_UNKNOWN
        ret
    .ENDIF
    INVOKE IsPswdCorrect, ADDR userbuf, ADDR pswdbuf
    .IF eax != COMMON_OK
        @DEBUG B2
        INVOKE Util_SendCode, sockfd, LOGIN_PSWD_WRONG
        ret
    .ENDIF

    @DEBUG B3
    INVOKE Util_SendCode, sockfd, LOGIN_OK
    ret
HandleLoginRequest ENDP


HandleRegisterRequest PROC, sockfd: DWORD
    LOCAL userbuf[1024]: BYTE
    LOCAL pswdbuf[1024]: BYTE

    INVOKE crt_memset, ADDR userbuf, 0, SIZEOF userbuf
    INVOKE crt_memset, ADDR pswdbuf, 0, SIZEOF pswdbuf
    INVOKE Util_RecvStream, sockfd, ADDR userbuf
    INVOKE Util_RecvStream, sockfd, ADDR pswdbuf
    INVOKE IsUserExist, ADDR userbuf
    .IF eax == COMMON_OK
        @DEBUG C1
        INVOKE Util_SendCode, sockfd, REGISTER_USER_EXIST
        ret
    .ENDIF

    @DEBUG C2
    INVOKE StoreNewUser, ADDR userbuf, ADDR pswdbuf
    INVOKE Util_SendCode, sockfd, REGISTER_OK
    ret
HandleRegisterRequest ENDP


HandleMessageRequest PROC, sockfd: DWORD
    LOCAL targetbuf:  PTR BYTE
    LOCAL messagebuf: PTR BYTE
    .data
    __HandleMessageRequest__BUFFERSIZE DWORD 20 * 1024 * 1024
    .code

    INVOKE Util_Malloc, ADDR targetbuf, __HandleMessageRequest__BUFFERSIZE
    INVOKE Util_Malloc, ADDR messagebuf, __HandleMessageRequest__BUFFERSIZE

    INVOKE Util_RecvStream, sockfd, targetbuf
    INVOKE Util_RecvStream, sockfd, messagebuf
    ; TODO: Handle send message

    INVOKE Util_Free, targetbuf
    INVOKE Util_Free, messagebuf
    ret
HandleMessageRequest ENDP



END
