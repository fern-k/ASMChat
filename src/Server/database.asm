INCLUDE ./server.inc

.code

IsUserExist PROC, user: PTR BYTE
    mov eax, [user]
    mov eax, COMMON_OK
    ret
IsUserExist ENDP

IsPswdCorrect PROC, user: PTR BYTE, pswd: PTR BYTE
    mov eax, [user]
    mov eax, [pswd]
    mov eax, COMMON_OK
    ret
IsPswdCorrect ENDP

StoreNewUser PROC, user: PTR BYTE, pswd: PTR BYTE
    mov eax, [user]
    mov eax, [pswd]
    mov eax, COMMON_OK
    ret
StoreNewUser ENDP



END
