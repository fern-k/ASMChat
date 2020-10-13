.386
.model flat, stdcall
option casemap: none

;------------- Include -------------;
;---- Normal
include kernel32.inc
include windows.inc
include user32.inc
include msvcrt.inc
include masm32rt.inc
;---- Socket
include wsock32.inc
include ws2_32.inc
;------------- Declare -------------;
CreateSocket PROTO
EnsureSocket PROTO, s: DWORD
Exit         PROTO, code: DWORD


;------------- Code ----------------;
.data
connectErrMsg     BYTE "Connect server failed!", 0
greetingMsg       BYTE "Good morning Ser!", 0dh, 0ah, 0
.const
defaultServerIP   BYTE  "127.0.0.1", 0
defaultServerPort DWORD 9798
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
    ; Greeting to server
    INVOKE send, commsSocket, ADDR greetingMsg, SIZEOF greetingMsg, 0
    INVOKE recv, commsSocket, ADDR buffer, SIZEOF buffer, 0
    INVOKE StdOut, ADDR buffer
    INVOKE closesocket, commsSocket
    INVOKE Exit, 0
    ret
Main ENDP


;------------------------------------
; CreateSocket:
;       Create an IPV4/TCP socket.
; Args: None
; Rets: eax -> The created socket
;------------------------------------
CreateSocket PROC
    LOCAL implementInfo: WSADATA
    INVOKE WSAStartup, 101h, ADDR implementInfo
    INVOKE socket, AF_INET, SOCK_STREAM, 0
    ret
CreateSocket ENDP


;------------------------------------
; EnsureSocket:
;       Ensure an IPV4/TCP socket is valid.
; Args:
;       s DWORD -> The socket to check
; Rets: None
;------------------------------------
.data
createErrMsg BYTE "Create socket failed!", 0
.code
EnsureSocket PROC USES eax, s: DWORD
    mov eax, s
    .IF eax == INVALID_SOCKET
        invoke MessageBox, NULL, ADDR createErrMsg, ADDR createErrMsg, MB_OK
        invoke Exit, 1
    .ENDIF
    ret
EnsureSocket ENDP


;------------------------------------
; Exit: Exit program.
; Args:
;       code [DWORD] exit code of program.
; Rets: None
;------------------------------------
.data
@_exit_exitMsg BYTE  0ah, 0dh, "Enter any character to exit...", 0ah, 0dh, 0
@_exit_holdFmt BYTE  "%d", 0
@_exit_holdVal DWORD ?
.code
Exit PROC, code: DWORD
    invoke StdOut, ADDR @_exit_exitMsg
	invoke crt_scanf, ADDR @_exit_holdFmt, ADDR @_exit_holdVal
    invoke ExitProcess, code
    ret
Exit ENDP


END Main
