;*********** Client Entry **********;


include Commons/commons.inc


;------------- Code ----------------;
.data
.const
defaultServerPort DWORD 9798
defaultServerIP   BYTE  "127.0.0.1", 0
connectErrMsg     BYTE "Connect server failed!", 0
clientOnlineMsg   BYTE "[Client online]", 0dh, 0ah, 0
greetingMsg       BYTE "[Client said] Good morning Ser!", 0dh, 0ah, 0
LENGTHOF_CMD      DWORD 1
CMD_LOGIN         BYTE "L"
CMD_REGISTER      BYTE "R"
CMD_MESSAGE       BYTE "M"

.code
Main PROC
    LOCAL sockAddr: sockaddr_in
    LOCAL commsSocket: DWORD
    LOCAL buffer[1024]: BYTE
    ; Initiate connection
    INVOKE CreateSocket
    mov commsSocket, eax
    INVOKE EnsureSocket, commsSocket
    INVOKE htons, defaultServerPort
    mov sockAddr.sin_port, ax
    mov sockAddr.sin_family, AF_INET
    INVOKE inet_addr, ADDR defaultServerIP
    mov sockAddr.sin_addr, eax
	INVOKE connect, commsSocket, ADDR sockAddr, SIZEOF sockAddr
    .IF eax == SOCKET_ERROR
        INVOKE MessageBox, NULL, ADDR connectErrMsg, ADDR connectErrMsg, MB_OK
        INVOKE Exit, 1
    .ENDIF
    INVOKE crt_printf, ADDR clientOnlineMsg
    ; Greeting to server
    INVOKE send, commsSocket, ADDR greetingMsg, SIZEOF greetingMsg, 0
    INVOKE recv, commsSocket, ADDR buffer, SIZEOF buffer, 0
    INVOKE crt_printf, ADDR buffer

    INVOKE send, commsSocket, ADDR CMD_REGISTER, LENGTHOF_CMD, 0

    INVOKE closesocket, commsSocket
    INVOKE Exit, 0
    ret
Main ENDP


END Main
