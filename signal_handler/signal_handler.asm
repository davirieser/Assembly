
; ---------------------------------------------------------------------------- ;

global main

section .text

main:
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msg_len
    CALL_SYS WRITE

exit:
    mov rdi, OK
    CALL_SYS EXIT

; ---------------------------------------------------------------------------- ;

section .data
    msg: db 27, "[31mHello World!", 27, "[0m", 10
    msg_len: equ $ - msg

; ---------------------------------------------------------------------------- ;
