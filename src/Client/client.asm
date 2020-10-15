;*********** Client Entry **********;


INCLUDE ./client.inc


;------------- Code ----------------;

.const
connectErrMsg     BYTE "Connect server failed!", 0
clientOnlineMsg   BYTE "[Client online]", 0dh, 0ah, 0
greetingMsg       BYTE "[Client said] Good morning Ser!", 0dh, 0ah, 0

.code
Main PROC
    LOCAL sockfd: DWORD
    LOCAL buffer[1024]: BYTE

    INVOKE Connect, ADDR defaultServerIP, defaultServerPort
    .IF eax != COMMON_OK
        INVOKE Util_Exit, 1
    .ENDIF
    mov    sockfd, ebx
    INVOKE crt_printf, ADDR clientOnlineMsg
    ; Greeting to server
    INVOKE send, sockfd, ADDR greetingMsg, SIZEOF greetingMsg, 0
    INVOKE recv, sockfd, ADDR buffer, SIZEOF buffer, 0
    INVOKE crt_printf, ADDR buffer

    INVOKE send, sockfd, ADDR REQ_REGISTER, CODE_LEN, 0

    INVOKE closesocket, sockfd
    INVOKE Util_Exit, 0
    ret

Main ENDP


Connect PROC, ip: PTR BYTE, port: DWORD
    LOCAL sockAddr: sockaddr_in
    LOCAL sockfd: DWORD

    INVOKE Util_CreateSocket
    .IF eax != COMMON_OK
        mov eax, COMMON_FAILED
        ret
    .ENDIF
    mov    sockfd, ebx
    INVOKE htons, port
    mov    sockAddr.sin_port, ax
    INVOKE inet_addr, ip
    mov    sockAddr.sin_addr, eax
    mov    sockAddr.sin_family, AF_INET
	INVOKE connect, sockfd, ADDR sockAddr, SIZEOF sockAddr
    .IF eax == SOCKET_ERROR
        mov eax, COMMON_FAILED
        ret
    .ENDIF
    mov ebx, sockfd
    mov eax, COMMON_OK
    ret

Connect ENDP


Login PROC, sockfd: DWORD, user: PTR BYTE, pswd: PTR BYTE
    LOCAL  user_len: DWORD
    LOCAL  pswd_len: DWORD
    LOCAL  buffer[1024]: BYTE

    INVOKE send, sockfd, ADDR REQ_LOGIN, CODE_LEN, 0
    INVOKE recv, sockfd, ADDR buffer, SIZEOF buffer, 0
    mov    eax, DWORD PTR buffer
    .IF eax != COMMON_OK
        mov eax, COMMON_FAILED
        ret
    .ENDIF
    INVOKE crt_strlen, user
    mov    user_len, eax
    INVOKE crt_strlen, pswd
    mov    pswd_len, eax
    INVOKE send, sockfd, user, user_len, 0
    INVOKE send, sockfd, pswd, pswd_len, 0
    INVOKE recv, sockfd, ADDR buffer, SIZEOF buffer, 0
    mov    eax, DWORD PTR buffer
    .IF eax != LOGIN_USER_UNKNOWN && eax != LOGIN_PSWD_WRONG
        mov eax, COMMON_FAILED
        ret
    .ENDIF
    ret

Login ENDP





END Main
