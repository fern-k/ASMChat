;*********** Server Entry **********;
INCLUDE ./server.inc

.const
listenokMsg       BYTE "[Server online]", 0dh, 0ah, 0

.code
Main PROC
    LOCAL serverSockfd: DWORD

    INVOKE ServerUp, defaultServerPort
    @EXIT_FAILED_IF_NOT_OK
    mov    serverSockfd, ebx
    INVOKE crt_printf, ADDR listenokMsg

    INVOKE ServerListenWorker, serverSockfd

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



END Main
