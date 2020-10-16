INCLUDE ./server.inc



.code


IsUserExist PROC, user: PTR BYTE
    mov eax, COMMON_OK
    ret
IsUserExist ENDP


IsPswdCorrect PROC, pswd: PTR BYTE
    mov eax, COMMON_OK
    ret
IsPswdCorrect ENDP






END
