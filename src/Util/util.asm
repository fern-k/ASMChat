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
    LOCAL codebuf: DWORD
    LOCAL totalsent: DWORD

    INVOKE crt_memset, ADDR codebuf, 0, SIZEOF codebuf
    mov    eax, code
    mov    codebuf, eax
    INVOKE send, sockfd, ADDR codebuf, TYPE DWORD, 0
    mov    totalsent, 0
    mov    totalsent, eax
    mov    eax, totalsent
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_SendCode ENDP


Util_SendStream PROC, sockfd: DWORD, stream: PTR BYTE
    LOCAL streamLength: DWORD

    INVOKE crt_strlen, stream
    mov    streamLength, eax
    INVOKE send, sockfd, stream, streamLength, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_SendStream ENDP


Util_RecvCode PROC, sockfd: DWORD, codebuf: PTR DWORD

    INVOKE recv, sockfd, codebuf, CODE_LEN, 0
    @RET_FAILED_IF_SOCKET_ERROR
    @RET_OK

Util_RecvCode ENDP


Util_RecvStream PROC, sockfd: DWORD, streambuf: PTR BYTE, streambuflen: DWORD

    INVOKE recv, sockfd, streambuf, streambuflen, 0
    @RET_FAILED_IF_SOCKET_ERROR
    mov ebx, eax
    @RET_OK

Util_RecvStream ENDP


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
