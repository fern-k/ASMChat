;*********** Client Entry **********;


INCLUDE ./client.inc


;------------- Code ----------------;

.const
testingUser       BYTE "User0", 0
testingPswd       BYTE "Pswd0", 0
connectOkMsg      BYTE "[Client connect to server ok]", 0dh, 0ah, 0

.code
Main PROC
    LOCAL sockfd: DWORD

    INVOKE DispatchConnect, ADDR defaultServerIP, defaultServerPort
    @EXIT_FAILED_IF_NOT_OK
    mov    sockfd, ebx
    INVOKE crt_printf, ADDR connectOkMsg


    ; INVOKE ViewEntry


    INVOKE DispatchLogin, ADDR testingUser, ADDR testingPswd
    ;INVOKE HandleServerMessage

    INVOKE closesocket, sockfd
    INVOKE Util_Exit, 0
    ret

Main ENDP



END Main
