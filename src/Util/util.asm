INCLUDE ./util.inc

.code

Util_CreateSocket PROC
    LOCAL implementInfo: WSADATA

    INVOKE WSAStartup, 101h, ADDR implementInfo
    INVOKE socket, AF_INET, SOCK_STREAM, 0
    .IF eax == INVALID_SOCKET
        mov eax, COMMON_FAILED
        ret
    .ENDIF
    mov ebx, eax
    mov eax, COMMON_OK
    ret

Util_CreateSocket ENDP


.data
@_exit_exitMsg BYTE  0ah, 0dh, "Enter any character to exit...", 0ah, 0dh, 0
@_exit_holdFmt BYTE  "%d", 0
@_exit_holdVal DWORD ?
.code
Util_Exit PROC, code: DWORD

    INVOKE crt_printf, ADDR @_exit_exitMsg
	INVOKE crt_scanf, ADDR @_exit_holdFmt, ADDR @_exit_holdVal
    INVOKE ExitProcess, code
    ret

Util_Exit ENDP





END
