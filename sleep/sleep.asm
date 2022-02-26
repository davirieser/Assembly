
; ---------------------------------------------------------------------------- ;

%idefine WRITE 1
%idefine STDOUT 1
%idefine EXIT 60
%idefine OK 0

%idefine SLEEP 35
%idefine NULL 0

; ---------------------------------------------------------------------------- ;

global main

section .text

main:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov QWORD [rel time_mem], 0
    mov QWORD [rel time_mem + 8], 300000000

    mov rax, SLEEP
    mov rdi, time_mem
    mov rsi, NULL
    syscall

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, msg2
    mov rdx, msg_len2
    syscall

    mov rax, SLEEP
    mov rdi, time_struct
    mov rsi, NULL
    syscall

    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, msg3
    mov rdx, msg_len3
    syscall

exit:
    mov rax, EXIT
    mov rdi, OK
    syscall

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
            at sec, dq 0
            at nano, dq 100000000
        IEND

; ---------------------------------------------------------------------------- ;

section .bss
    time_mem: resq 2

; ---------------------------------------------------------------------------- ;
