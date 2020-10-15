
;------------- Include -------------;
;  The MASM32 Runtime Library includes most of needed files
;  Like windows.inc, kernel32.inc, user32.inc, masm32.inc, etc
;  See https://searchcode.com/codesearch/view/13886032/
INCLUDE masm32rt.inc
INCLUDE ws2_32.inc
;------------- Declare -------------;
CreateSocket PROTO
EnsureSocket PROTO, s: DWORD
Exit         PROTO, code: DWORD

