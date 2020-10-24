INCLUDE ./server.inc

.code

IsUserExist PROC, user: PTR BYTE

    INVOKE crt_strcmp, user, ADDR user0
    .IF eax == 0
        @RET_OK
    .ENDIF
    INVOKE crt_strcmp, user, ADDR user1
    .IF eax == 0
        @RET_OK
    .ENDIF
    @RET_FAILED

IsUserExist ENDP

IsPswdCorrect PROC, user: PTR BYTE, pswd: PTR BYTE

    INVOKE crt_strcmp, user, ADDR user0
    .IF eax == 0
        INVOKE crt_strcmp, pswd, ADDR pswd0
        .IF eax == 0
            @RET_OK
        .ENDIF
        @RET_FAILED
    .ENDIF
    INVOKE crt_strcmp, user, ADDR user1
    .IF eax == 0
        INVOKE crt_strcmp, pswd, ADDR pswd1
        .IF eax == 0
            @RET_OK
        .ENDIF
        @RET_FAILED
    .ENDIF
    @RET_FAILED

IsPswdCorrect ENDP

StoreNewUser PROC, user: PTR BYTE, pswd: PTR BYTE
    mov eax, [user]
    mov eax, [pswd]
    mov eax, COMMON_OK
    ret
StoreNewUser ENDP



END
