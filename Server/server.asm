;*********** Server Entry **********;


include Commons/commons.inc


;------------- Code ----------------;
.data
cmdBuffer         BYTE 0
lengthOfCmdBuffer DWORD 1
.const
defaultServerPort DWORD 9798
bindingErrMsg     BYTE "Binding socket failed!", 0dh, 0ah, 0
acceptErrMsg      BYTE "Accept connection failed!", 0dh, 0ah, 0
serverOnlineMsg   BYTE "[Server online]", 0dh, 0ah, 0
helloMsg          BYTE "[Server said] Hey, I heard your greeting, nice to meet u!", 0dh, 0ah, 0
CMD_LOGIN         BYTE "L"
CMD_REGISTER      BYTE "R"
CMD_MESSAGE       BYTE "M"
MSG_L BYTE "Got Login!", 0dh, 0ah, 0
MSG_R BYTE "Got Register!", 0dh, 0ah, 0
MSG_O BYTE "Got Other!", 0dh, 0ah, 0
FMG_DN BYTE "%d", 0dh, 0ah, 0

.code
Main PROC
    LOCAL sockAddr: sockaddr_in
    LOCAL serverSocket: DWORD
    LOCAL clientSocket: DWORD
    LOCAL buffer[1024]: BYTE
    ; Initiate server to online
    INVOKE CreateSocket
    mov serverSocket, eax
    INVOKE EnsureSocket, serverSocket
    INVOKE htons, defaultServerPort
    mov sockAddr.sin_port, ax
    mov sockAddr.sin_family, AF_INET
    mov sockAddr.sin_addr, INADDR_ANY
    INVOKE bind, serverSocket, ADDR sockAddr, SIZEOF sockAddr
    .IF eax
        INVOKE MessageBox, NULL, ADDR bindingErrMsg, ADDR bindingErrMsg, MB_OK
        INVOKE Exit, 1
    .ENDIF
    INVOKE listen, serverSocket, 5
    INVOKE crt_printf, ADDR serverOnlineMsg
    INVOKE accept, serverSocket, NULL, 0
    .IF eax == INVALID_SOCKET
        INVOKE MessageBox, NULL, ADDR acceptErrMsg, ADDR acceptErrMsg, MB_OK
        INVOKE Exit, 1
    .ENDIF
    ; Communication with client
    mov clientSocket, eax
    INVOKE recv, clientSocket, ADDR buffer, SIZEOF buffer, 0
    INVOKE crt_printf, ADDR buffer
    INVOKE send, clientSocket, ADDR helloMsg, SIZEOF helloMsg, 0

    INVOKE recv, clientSocket, ADDR cmdBuffer, lengthOfCmdBuffer, 0

    mov al, cmdBuffer

    .IF al == CMD_LOGIN
        INVOKE crt_printf, ADDR MSG_L
    .ELSEIF al == CMD_REGISTER
        INVOKE crt_printf, ADDR MSG_R
    .ELSE
        INVOKE crt_printf, ADDR MSG_O
    .ENDIF
    mov eax, 0
    mov al, cmdBuffer
    INVOKE crt_printf, ADDR FMG_DN, eax
    INVOKE closesocket, clientSocket
    INVOKE closesocket, serverSocket
    INVOKE Exit, 0
    ret
Main ENDP


END Main
