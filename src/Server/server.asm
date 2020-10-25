;*********** Server Entry **********;
INCLUDE ./server.inc

.code
Main PROC
    .data
    __Main__listenokMsg  BYTE "[Server online]", 0dh, 0ah, 0
    __Main__serverSockfd DWORD 0
    .code

    INVOKE ServerUp, defaultServerPort
    @EXIT_FAILED_IF_NOT_OK
    mov    __Main__serverSockfd, ebx
    INVOKE crt_printf, ADDR __Main__listenokMsg

    INVOKE ServerListenWorker, __Main__serverSockfd

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
