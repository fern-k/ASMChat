;************ Util Header **********;
IFNDEF UTIL_HEADER
UTIL_HEADER PROTO


;------------- Include -------------;
;  The MASM32 Runtime Library includes most of needed files
;  Like windows.inc, kernel32.inc, user32.inc, masm32.inc, etc,
;  and the most important header, **msvcrt.inc** is included too.
;  Every function you need from C like printf, scanf, fopen
;      was introduce in msvcrt.inc with "crt_" prefix.
;  Open msvcrt.inc to see all of them (like crt_printf).
;  See https://searchcode.com/codesearch/view/13886032/
INCLUDE masm32rt.inc
;  Windows Socket 2 Library
;  See https://docs.microsoft.com/en-us/windows/win32/api/_winsock/
INCLUDE ws2_32.inc


;------------- Declare -------------;
;------------------------------------
; Util_CreateSocket:
; Args: None
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;       ebx -> socket
;------------------------------------
Util_CreateSocket PROTO
;------------------------------------
; Util_SendCode:
; Args:
;       sockfd -> target socket to send code
;       code -> the code to send
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;------------------------------------
Util_SendCode PROTO,
    sockfd: DWORD,
    code: DWORD
;------------------------------------
; Util_SendStream:
; Args:
;       sockfd -> target socket to send stream
;       stream -> the byte stream to send
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED, Other special error code  }
;------------------------------------
Util_SendStream PROTO,
    sockfd: DWORD,
    stream: PTR BYTE
;------------------------------------
; Util_RecvCode:
; Args:
;       sockfd -> target socket to recv code
;       codebuf -> the code buffer
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;------------------------------------
Util_RecvCode PROTO,
    sockfd: DWORD,
    codebuf: PTR DWORD
;------------------------------------
; Util_RecvStream:
; Args:
;       sockfd -> target socket to recv stream
;       streambuf -> the stream buffer
;       streambuflen -> the stream buffer length
; Rets:
;       eax -> {  COMMON_OK, COMMON_FAILED  }
;       ebx -> stream length
;------------------------------------
Util_RecvStream PROTO,
    sockfd: DWORD,
    streambuf: PTR BYTE,
    streambuflen: DWORD
;------------------------------------
; Util_Malloc: Malloc a memory filled with 0.
; Args:
;       bufpp
;       requestlen
; Rets:
;       eax -> { COMMON_OK }
;------------------------------------
Util_Malloc PROTO,
    bufpp: DWORD,
    requestlen: DWORD
;------------------------------------
; Util_Free: Free a memory.
; Args:
;       bufp
; Rets:
;       eax -> { COMMON_OK }
;------------------------------------
Util_Free PROTO,
    bufp: PTR BYTE
;------------------------------------
; Util_Div: Divide. To replace harmful x86 div instruction.
; Args:
;       dividend
;       divisor
; Rets:
;       eax -> { COMMON_OK }
;       ebx -> quotient
;------------------------------------
Util_Div PROTO,
    dividend: DWORD,
    divisor:  DWORD
;------------------------------------
; Util_Exit: Exit program.
; Args:
;       exitcode -> exit code
; Rets: None
;------------------------------------
Util_Exit PROTO, exitcode: DWORD


;------------- Macro -------------;
;;; Normal ret
@RET_OK MACRO
    mov eax, COMMON_OK
    ret
ENDM
@RET_FAILED MACRO
    mov eax, COMMON_FAILED
    ret
ENDM

;;; Ret if socket_error or if not ok
@RET_FAILED_IF_SOCKET_ERROR MACRO
    .IF eax == SOCKET_ERROR
        mov eax, COMMON_FAILED
        ret
    .ENDIF
ENDM
@RET_FAILED_IF_NOT_OK MACRO
    .IF eax != COMMON_OK
        mov eax, COMMON_FAILED
        ret
    .ENDIF
ENDM

;;; Break if socket error or if not ok 
@BREAK_IF_SOCKET_ERROR MACRO
    .IF eax == SOCKET_ERROR
        .BREAK
    .ENDIF
ENDM
@BREAK_IF_NOT_OK MACRO
    .IF eax != COMMON_OK
        .BREAK
    .ENDIF
ENDM


;;; Exit, Exit if not ok and Exit if invalid socket
@EXIT_FAILED_IF_NOT_OK MACRO
    .IF eax != COMMON_OK
        INVOKE Util_Exit, 1
    .ENDIF
ENDM
@EXIT_FAILED_IF_INVALID_SOCKET MACRO
    .IF eax == INVALID_SOCKET
        INVOKE Util_Exit, 1
    .ENDIF
ENDM


;-------------- Const ---------------;
.const
defaultServerIP   BYTE  "127.0.0.1", 0
defaultServerPort DWORD 9798

CODE_LEN                   DWORD 4
; Common code
COMMON_CODE_START          DWORD 600h
COMMON_OK                  DWORD 610h
COMMON_FAILED              DWORD 611h
COMMON_CODE_END            DWORD 6FFh
;;; Request code
; - Events triggered by user inteface(UI).
REQ_CODE_START             DWORD 700h
REQ_LOGIN                  DWORD 711h
REQ_LOGOUT                 DWORD 712h
REQ_REGISTER               DWORD 713h
REQ_MESSAGE                DWORD 720h
REQ_PICTURE                DWORD 721h
REQ_ADDFRIEND              DWORD 730h
REQ_PERMIT_ADDFRIEND       DWORD 731h
REQ_CODE_END               DWORD 7FFh
;;; Response code
; - Results of user request.
RES_CODE_START             DWORD 800h
;   Login response code
LOGIN_CODE_START           DWORD 810h
LOGIN_OK                   DWORD 811h
LOGIN_USER_UNKNOWN         DWORD 812h
LOGIN_PSWD_WRONG           DWORD 813h
LOGIN_CODE_END             DWORD 81Fh
;   Register response code
REGISTER_CODE_START        DWORD 820h
REGISTER_OK                DWORD 821h
REGISTER_USER_EXIST        DWORD 822h
REGISTER_CODE_END          DWORD 82Fh
;   SendText response code
SENDTEXT_CODE_START        DWORD 830h
SENDTEXT_OK                DWORD 831h
SENDTEXT_TARGET_OFFLINE    DWORD 832h
SENDTEXT_TARGET_UNFAMILIAR DWORD 833h
SENDTEXT_TARGET_NOTFOUND   DWORD 834h
SENDTEXT_CODE_END          DWORD 83Fh
;   AddFriend response code
ADDFRIEND_CODE_START       DWORD 840h
ADDFRIEND_SUBMITTED        DWORD 841h
ADDFRIEND_REJECTED         DWORD 842h
ADDFRIEND_CODE_END         DWORD 84Fh
;   Response code end
RES_CODE_END               DWORD 8FFh
;;; Server one-way notify code
; - Events that triggered by other users instead of us.
SERVER_NOTIFY_CODE_START   DWORD 900h
GOT_ADDFRIEND              DWORD 911h
GOT_TEXT                   DWORD 912h
FRIEND_ONLINE              DWORD 921h
FRIEND_OFFLINE             DWORD 922h
SERVER_NOTIFY_CODE_END     DWORD 9FFh



ENDIF ; UTIL_HEADER
