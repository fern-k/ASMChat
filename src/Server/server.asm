;*********** Server Entry **********;


INCLUDE ./server.inc


;------------- Code ----------------;

.data
cmdBuffer         BYTE 4 DUP(?)
lengthOfCmdBuffer DWORD SIZEOF cmdBuffer
.const
serverOnlineMsg   BYTE "[Server online]", 0dh, 0ah, 0
helloMsg          BYTE "[Server said] Hey, I heard your greeting, nice to meet u!", 0dh, 0ah, 0
MSG_L BYTE "Got Login!", 0dh, 0ah, 0
MSG_R BYTE "Got Register!", 0dh, 0ah, 0
MSG_O BYTE "Got Other!", 0dh, 0ah, 0

.code
Main PROC
    LOCAL serverSockfd: DWORD
    LOCAL clientSockfd: DWORD
    LOCAL buffer[1024]: BYTE

    INVOKE ServerUp, defaultServerPort
    .IF eax != COMMON_OK
        INVOKE Util_Exit, 1
        ret
    .ENDIF
    mov    serverSockfd, ebx
    INVOKE crt_printf, ADDR serverOnlineMsg
    INVOKE accept, serverSockfd, NULL, 0
    .IF eax == INVALID_SOCKET
        INVOKE Util_Exit, 1
        ret
    .ENDIF
    mov clientSockfd, eax
    INVOKE recv, clientSockfd, ADDR buffer, SIZEOF buffer, 0
    INVOKE crt_printf, ADDR buffer
    INVOKE send, clientSockfd, ADDR helloMsg, SIZEOF helloMsg, 0

    INVOKE recv, clientSockfd, ADDR cmdBuffer, lengthOfCmdBuffer, 0

    mov eax, DWORD PTR cmdBuffer

    .IF eax == REQ_LOGIN
        INVOKE crt_printf, ADDR MSG_L
    .ELSEIF eax == REQ_REGISTER
        INVOKE crt_printf, ADDR MSG_R
    .ELSE
        INVOKE crt_printf, ADDR MSG_O
    .ENDIF
    INVOKE closesocket, clientSockfd
    INVOKE closesocket, serverSockfd
    INVOKE Util_Exit, 0
    ret

Main ENDP


ServerUp PROC, port: DWORD
    LOCAL sockAddr: sockaddr_in
    LOCAL sockfd: DWORD

    INVOKE Util_CreateSocket
    .IF eax != COMMON_OK
        mov eax, COMMON_FAILED
        ret
    .ENDIF
    mov    sockfd, ebx
    INVOKE htons, port
    mov sockAddr.sin_port, ax
    mov sockAddr.sin_addr, INADDR_ANY
    mov sockAddr.sin_family, AF_INET
    INVOKE bind, sockfd, ADDR sockAddr, SIZEOF sockAddr
    .IF eax == SOCKET_ERROR
        mov eax, COMMON_FAILED
        ret
    .ENDIF
    INVOKE listen, sockfd, 5
    mov ebx, sockfd
    mov eax, COMMON_OK
    ret

ServerUp ENDP





END Main
