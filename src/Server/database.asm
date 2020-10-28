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
    mov eax, [user] ; Nothing here; Just disable unused variable warning.
    mov eax, [pswd] ; Nothing here; Just disable unused variable warning.
    @RET_OK
StoreNewUser ENDP


GetFriendNumb PROC, user: PTR BYTE, result: PTR DWORD
    .IF user == NULL
        @RET_FAILED
    .ENDIF

    INVOKE crt_strcmp, user, ADDR user0
    .IF eax == 0
        mov eax, result
        mov DWORD PTR [eax], 1
        @RET_OK
    .ENDIF

    INVOKE crt_strcmp, user, ADDR user1
    .IF eax == 0
        mov eax, result
        mov DWORD PTR [eax], 1
        @RET_OK
    .ENDIF

    @RET_FAILED
GetFriendNumb ENDP


GetFriend PROC, user: PTR BYTE, index: DWORD, result: PTR BYTE
    .IF user == NULL
        @RET_FAILED
    .ENDIF

    mov eax, index ; Nothing here; Just disable unused variable warning.

    INVOKE crt_strcmp, user, ADDR user0
    .IF eax == 0
        INVOKE crt_strlen, ADDR user1
        INVOKE crt_memcpy, result, ADDR user1, eax
        @RET_OK
    .ENDIF

    INVOKE crt_strcmp, user, ADDR user1
    .IF eax == 0
        INVOKE crt_strlen, ADDR user0
        INVOKE crt_memcpy, result, ADDR user0, eax
        @RET_OK
    .ENDIF

    @RET_FAILED
GetFriend ENDP



END
