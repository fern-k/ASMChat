INCLUDE ./server.inc



.code


IsUserExist PROC, user: PTR BYTE
    mov eax, [user]
    mov eax, COMMON_OK
    ret
IsUserExist ENDP


IsPswdCorrect PROC, pswd: PTR BYTE
    mov eax, [pswd]
    mov eax, COMMON_OK
    ret
IsPswdCorrect ENDP






END
