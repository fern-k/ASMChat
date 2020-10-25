INCLUDE ./util.inc
INCLUDE ./debug.inc

.code

Util_CreateSocket PROC
    LOCAL implementInfo: WSADATA

    INVOKE WSAStartup, 101h, ADDR implementInfo
    INVOKE socket, AF_INET, SOCK_STREAM, 0
    @RET_FAILED_IF_SOCKET_ERROR
    mov ebx, eax
    @RET_OK

Util_CreateSocket ENDP


Util_SendCode PROC, sockfd: DWORD, code: DWORD

    INVOKE send, sockfd, ADDR code, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_SendCode ENDP


Util_SendStream PROC, sockfd: DWORD, stream: PTR BYTE
    LOCAL streamLength: DWORD

    INVOKE crt_strlen, stream
    mov    streamLength, eax
    INVOKE send, sockfd, ADDR streamLength, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    INVOKE send, sockfd, stream, streamLength, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_SendStream ENDP


Util_RecvCode PROC, sockfd: DWORD, codebuf: PTR DWORD

    INVOKE recv, sockfd, codebuf, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_RecvCode ENDP


Util_RecvStream PROC, sockfd: DWORD, streambuf: PTR BYTE
    LOCAL reallen: DWORD

    INVOKE recv, sockfd, ADDR reallen, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    INVOKE recv, sockfd, streambuf, reallen, 0
    @RET_FAILED_IF_SOCKET_ERROR
    mov    ebx, reallen
    @RET_OK

Util_RecvStream ENDP


Util_Malloc PROC, bufpp: DWORD, requestlen: DWORD
    LOCAL  bufptr: DWORD

    INVOKE crt_malloc, requestlen
    mov    bufptr, eax
    INVOKE crt_memset, bufptr, 0, requestlen
    INVOKE crt_memcpy, bufpp, ADDR bufptr, SIZEOF DWORD
    @RET_OK

Util_Malloc ENDP


Util_Free PROC, bufp: PTR BYTE

    INVOKE crt_free, bufp
    @RET_OK

Util_Free ENDP


Util_Div PROC USES ecx edx, dividend: DWORD, divisor: DWORD

    mov eax, dividend
    mov ebx, divisor
    div ebx
    mov ebx, eax
    @RET_OK

Util_Div ENDP


.data
@_exit_exitMsg BYTE  0ah, 0dh, "Enter any character to exit...", 0ah, 0dh, 0
@_exit_holdFmt BYTE  "%d", 0
@_exit_holdVal DWORD ?
.code
Util_Exit PROC, exitcode: DWORD

    INVOKE crt_printf, ADDR @_exit_exitMsg
	INVOKE crt_scanf, ADDR @_exit_holdFmt, ADDR @_exit_holdVal
    INVOKE ExitProcess, exitcode
    ret

Util_Exit ENDP





END
