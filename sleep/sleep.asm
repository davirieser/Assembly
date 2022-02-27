
; ---------------------------------------------------------------------------- ;

global main

section .text

main:
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msg_len
    CALL_SYS WRITE

    mov QWORD [rel time_mem], 1
    mov QWORD [rel time_mem + 8], 300000000

    mov rdi, time_mem
    mov rsi, NULL
    CALL_SYS NANOSLEEP

    mov rdi, STDOUT
    mov rsi, msg2
    mov rdx, msg_len2
    CALL_SYS WRITE

    mov rdi, time_struct
    mov rsi, NULL
    CALL_SYS NANOSLEEP

    mov rdi, STDOUT
    mov rsi, msg3
    mov rdx, msg_len3
    CALL_SYS WRITE

exit:
    mov rdi, OK
    CALL_SYS EXIT

; ---------------------------------------------------------------------------- ;

; struct __kernel_timespec {
; 	__kernel_time64_t       tv_sec;                 /* seconds */
; 	long long               tv_nsec;                /* nanoseconds */
; };

STRUC _kernel_timespec
    sec : resq 1
    nano: resq 1
ENDSTRUC

; ---------------------------------------------------------------------------- ;

section .data
    msg: db 27, "[31mHello World!", 27, "[0m", 10
    msg_len: equ $ - msg
    msg2: db 27, "[34mIntermidiate World!", 27, "[0m", 10
    msg_len2: equ $ - msg2
    msg3: db `\x1B`, "[92mBye World!", 27, "[0m", 10
    msg_len3: equ $ - msg3
    time_struct: ISTRUC _kernel_timespec
            at sec, dq 1
            at nano, dq 100000000
        IEND

; ---------------------------------------------------------------------------- ;

section .bss
    time_mem: resq 2

; ---------------------------------------------------------------------------- ;
