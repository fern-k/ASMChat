

INCLUDE ./util.inc


.code


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
    invoke crt_printf, ADDR @_exit_exitMsg
	invoke crt_scanf, ADDR @_exit_holdFmt, ADDR @_exit_holdVal
    invoke ExitProcess, code
    ret
Exit ENDP

END
