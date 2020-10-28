INCLUDE ./server.inc

.data
serverModelInstance ServerModel <>

.code
ServerListenWorker PROC, sockfd: DWORD
    LOCAL clientSockfd: DWORD

    .WHILE TRUE
        INVOKE accept, sockfd, NULL, 0
        @EXIT_FAILED_IF_INVALID_SOCKET
        mov    clientSockfd, eax
        INVOKE AppendNewClient, clientSockfd
        INVOKE CreateThread, NULL, 0, OFFSET ClientCommunicateWorker, clientSockfd, 0, NULL
        @EXIT_FAILED_IF_ZERO
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
    LOCAL userbuf[1024]:   BYTE
    LOCAL pswdbuf[1024]:   BYTE
    LOCAL friendbuf[1024]: BYTE
    LOCAL friendNumb:      DWORD

    INVOKE crt_memset, ADDR userbuf, 0, SIZEOF userbuf
    INVOKE crt_memset, ADDR pswdbuf, 0, SIZEOF userbuf
    INVOKE Util_RecvString, sockfd, ADDR userbuf
    INVOKE Util_RecvString, sockfd, ADDR pswdbuf

    INVOKE IsUserExist, ADDR userbuf
    @DEBUG B0
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
    INVOKE GetFriendNumb, ADDR userbuf, ADDR friendNumb
    INVOKE Util_SendDWord, sockfd, friendNumb
    mov    ecx, 0
    .WHILE ecx < friendNumb
        INVOKE crt_memset, ADDR friendbuf, 0, SIZEOF friendbuf
        INVOKE GetFriend, ADDR userbuf, ecx, ADDR friendbuf
        INVOKE Util_SendString, sockfd, ADDR friendbuf
        inc    ecx
    .ENDW
    ;TODO: notify friend online

    ret
HandleLoginRequest ENDP


HandleRegisterRequest PROC, sockfd: DWORD
    LOCAL userbuf[1024]: BYTE
    LOCAL pswdbuf[1024]: BYTE

    INVOKE crt_memset, ADDR userbuf, 0, SIZEOF userbuf
    INVOKE crt_memset, ADDR pswdbuf, 0, SIZEOF pswdbuf
    INVOKE Util_RecvString, sockfd, ADDR userbuf
    INVOKE Util_RecvString, sockfd, ADDR pswdbuf
    INVOKE IsUserExist, ADDR userbuf
    @DEBUG C0
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

    INVOKE Util_RecvString, sockfd, targetbuf
    INVOKE Util_RecvString, sockfd, messagebuf
    ; TODO: Handle send message

    INVOKE Util_Free, targetbuf
    INVOKE Util_Free, messagebuf
    ret
HandleMessageRequest ENDP


AppendNewClient PROC, sockfd: DWORD
    LOCAL target: PTR ClientData

    mov    target, OFFSET serverModelInstance.clients
    mov    eax, SIZEOF ClientData
    mul    serverModelInstance.clientNumb
    add    target, eax
    INVOKE crt_memset, target, 0, SIZEOF ClientData
    INVOKE crt_memcpy, (ClientData PTR target).sockfd, ADDR sockfd, TYPE DWORD
    mov    (ClientData PTR target).isOnline, 0
    inc    serverModelInstance.clientNumb

    INVOKE PrintClientList
    ret
AppendNewClient ENDP


PrintClientList PROC USES ecx
    LOCAL curr: PTR ClientData
    LOCAL stat: PTR BYTE
    .data
    temp_client ClientData <>
    fmt_header  BYTE "----------PRINT CLIENT LIST----------", 0dh, 0ah, 0
    fmt_footer  BYTE "-------------------------------------", 0dh, 0ah, 0
    fmt_row     BYTE "%d %d %s %s", 0dh, 0ah, 0
    online_str  BYTE "online", 0
    offline_str BYTE "offline", 0
    .code

    INVOKE crt_printf, ADDR fmt_header
    mov    ecx, 0
    mov    curr, OFFSET serverModelInstance.clients
    .WHILE ecx < serverModelInstance.clientNumb
        INVOKE crt_memcpy, ADDR temp_client, curr, SIZEOF ClientData
        .IF temp_client.isOnline == 0
            mov stat, OFFSET offline_str
        .ELSE
            mov stat, OFFSET online_str
        .ENDIF
        INVOKE crt_printf, ADDR fmt_row, ecx, temp_client.sockfd, OFFSET temp_client.username, stat

        add curr, SIZEOF ClientData
        inc ecx
    .ENDW

    INVOKE crt_printf, ADDR fmt_footer
    ret
PrintClientList ENDP


END
