INCLUDE ./client.inc


.code


ViewEntry PROC
    ret
ViewEntry ENDP


LoginCallback PROC, code: DWORD
    mov eax, code
    ret
LoginCallback ENDP


RegisterCallback PROC, code: DWORD
    mov eax, code
    ret
RegisterCallback ENDP


SendTextCallback PROC, code: DWORD
    mov eax, code
    ret
SendTextCallback ENDP


AddFriendCallback PROC, code: DWORD
    mov eax, code
    ret
AddFriendCallback ENDP


NotificationListener PROC, code: DWORD
    mov eax, code
    ret
NotificationListener ENDP



END

