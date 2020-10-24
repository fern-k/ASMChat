;*********** Client Entry **********;
INCLUDE ./client.inc

.const
user404           BYTE "User404", 0
pswd404           BYTE "Pswd404", 0
connectokMsg      BYTE "[Client connect to server ok]", 0dh, 0ah, 0

.code
Main PROC
    LOCAL sockfd: DWORD
    LOCAL localTime: SYSTEMTIME
    invoke GetLocalTime, ADDR localTime

    INVOKE DispatchConnect, ADDR defaultServerIP, defaultServerPort
    @EXIT_FAILED_IF_NOT_OK
    mov    sockfd, ebx
    INVOKE crt_printf, ADDR connectokMsg

    ; INVOKE ViewEntry
    INVOKE CreateThread, NULL, 0, OFFSET DealwithServerMessage, NULL, 0, NULL
    .IF eax == 0
        INVOKE Util_Exit, 1
    .ENDIF

    ;INVOKE DispatchLogin, ADDR user404, ADDR pswd404
    ;INVOKE DispatchRegister, ADDR user0, ADDR pswd0
    INVOKE DispatchLogin, ADDR user0, ADDR pswd0
    ;INVOKE DispatchDisconnect

    INVOKE Util_Exit, 0
    ret

Main ENDP



END Main
