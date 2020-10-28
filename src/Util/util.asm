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

    INVOKE Util_SendDWord, sockfd, code
    ret

Util_SendCode ENDP


Util_SendDWord PROC, sockfd: DWORD, value: DWORD

    INVOKE send, sockfd, ADDR value, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_SendDWord ENDP


Util_SendString PROC, sockfd: DWORD, strbuf: PTR BYTE
    LOCAL stringLength: DWORD

    INVOKE crt_strlen, strbuf
    mov    stringLength, eax
    INVOKE send, sockfd, ADDR stringLength, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    INVOKE send, sockfd, strbuf, stringLength, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_SendString ENDP


Util_RecvCode PROC, sockfd: DWORD, codebuf: PTR DWORD

    INVOKE Util_RecvDWord, sockfd, codebuf
    ret

Util_RecvCode ENDP


Util_RecvDWord PROC, sockfd: DWORD, valuebuf: PTR DWORD

    INVOKE recv, sockfd, valuebuf, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_RecvDWord ENDP


Util_RecvString PROC, sockfd: DWORD, strbuf: PTR BYTE
    LOCAL reallen: DWORD

    INVOKE recv, sockfd, ADDR reallen, TYPE DWORD, 0
    @RET_FAILED_IF_SOCKET_ERROR
    INVOKE recv, sockfd, strbuf, reallen, 0
    @RET_FAILED_IF_SOCKET_ERROR
    mov    ebx, reallen
    @RET_OK

Util_RecvString ENDP


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


Util_Exit PROC, exitcode: DWORD
    .data
    __exit__exitMsg BYTE  0ah, 0dh, "Enter any character to exit...", 0ah, 0dh, 0
    __exit__holdFmt BYTE  "%d", 0
    __exit__holdVal DWORD ?
    .code

    INVOKE crt_printf, ADDR __exit__exitMsg
	INVOKE crt_scanf, ADDR __exit__holdFmt, ADDR __exit__holdVal
    INVOKE ExitProcess, exitcode
    ret

Util_Exit ENDP





END
