;*********** Client Entry **********;
INCLUDE ./client.inc


.code
Main PROC
    .data
    sockfd       DWORD 0
    connectokMsg BYTE "[Client connect to server ok]", 0dh, 0ah, 0
    .code

    INVOKE DispatchConnect, ADDR defaultServerIP, defaultServerPort
    @EXIT_FAILED_IF_NOT_OK
    mov    sockfd, ebx
    INVOKE crt_printf, ADDR connectokMsg

    INVOKE ViewEntry

    INVOKE CreateThread, NULL, 0, OFFSET DealwithServerMessage, NULL, 0, NULL
    @EXIT_FAILED_IF_ZERO

    ;---Test your function here.---
    INVOKE DispatchRegister, ADDR user0, ADDR pswd0
    INVOKE DispatchRegister, ADDR user404, ADDR pswd404
    INVOKE DispatchLogin, ADDR user404, ADDR pswd404
    INVOKE DispatchLogin, ADDR user0, ADDR pswd0
    ;INVOKE DispatchLogin, ADDR user0, ADDR pswd1
    .IF eax == COMMON_OK
        @DEBUG A1
    .ELSE
        @DEBUG A2
    .ENDIF

    ;INVOKE DispatchDisconnect
    INVOKE Util_Exit, 0
    ret
Main ENDP



END Main
