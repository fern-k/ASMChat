;*********** Server Entry **********;


INCLUDE ./server.inc


;------------- Code ----------------;

.data
cmdBuffer         BYTE 4 DUP(?)
lengthOfCmdBuffer DWORD SIZEOF cmdBuffer
.const
listenOkMsg       BYTE "[Server online]", 0dh, 0ah, 0
helloMsg          BYTE "[Server said] Hey, I heard your greeting, nice to meet u!", 0dh, 0ah, 0
MSG_L BYTE "Got Login!", 0dh, 0ah, 0
MSG_R BYTE "Got Register!", 0dh, 0ah, 0
MSG_O BYTE "Got Other!", 0dh, 0ah, 0

.code
Main PROC
    LOCAL serverSockfd: DWORD
    LOCAL clientSockfd: DWORD

    INVOKE ServerUp, defaultServerPort
    @EXIT_FAILED_IF_NOT_OK
    mov    serverSockfd, ebx
    INVOKE crt_printf, ADDR listenOkMsg

    ; TODO: Create HandleThread to handle recving msg. All server actions
    ; are only fired by recving cmd,
    ; like broadcasting online info rely on another user's Login

    INVOKE accept, serverSockfd, NULL, 0
    @EXIT_FAILED_IF_INVALID_SOCKET
    mov clientSockfd, eax

    INVOKE HandleRequest, clientSockfd

    INVOKE closesocket, clientSockfd
    INVOKE closesocket, serverSockfd
    INVOKE Util_Exit, 0
    ret

Main ENDP


ServerUp PROC, port: DWORD
    LOCAL sockAddr: sockaddr_in
    LOCAL sockfd: DWORD

    INVOKE Util_CreateSocket
    @RET_FAILED_IF_NOT_OK

    mov    sockfd, ebx
    INVOKE htons, port
    mov sockAddr.sin_port, ax
    mov sockAddr.sin_addr, INADDR_ANY
    mov sockAddr.sin_family, AF_INET
    INVOKE bind, sockfd, ADDR sockAddr, SIZEOF sockAddr
    @RET_FAILED_IF_SOCKET_ERROR

    INVOKE listen, sockfd, 5
    mov ebx, sockfd
    mov eax, COMMON_OK
    ret

ServerUp ENDP


HandleRequest PROC, sockfd: DWORD
    LOCAL  codebuf: DWORD
    LOCAL  sockfdSet:    fd_set
    LOCAL  timeout:      timeval

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
            INVOKE HandleLogin, sockfd
        .ELSEIF eax == REQ_REGISTER
            ;INVOKE HandleRegister
        .ELSE
            .BREAK
        .ENDIF

    .ENDW

    INVOKE closesocket, sockfd
    ret

HandleRequest ENDP


HandleLogin PROC, sockfd: DWORD
    LOCAL userbuf[1024]: BYTE
    LOCAL pswdbuf[1024]: BYTE

    INVOKE crt_memset, ADDR userbuf, 0, SIZEOF userbuf
    INVOKE crt_memset, ADDR pswdbuf, 0, SIZEOF pswdbuf
    INVOKE recv, sockfd, ADDR userbuf, SIZEOF userbuf, 0
    INVOKE recv, sockfd, ADDR pswdbuf, SIZEOF pswdbuf, 0
    INVOKE IsUserExist, ADDR userbuf
    .IF eax != COMMON_OK
        INVOKE Util_SendCode, sockfd, LOGIN_USER_UNKNOWN
        ret
    .ENDIF
    INVOKE IsPswdCorrect, ADDR pswdbuf
    .IF eax != COMMON_OK
        INVOKE Util_SendCode, sockfd, LOGIN_PSWD_WRONG
        ret
    .ENDIF
    INVOKE Util_SendCode, sockfd, LOGIN_OK
    ret

HandleLogin ENDP


END Main
