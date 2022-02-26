
; ---------------------------------------------------------------------------- ;

%idefine WRITE 1
%idefine STDOUT 1
%idefine EXIT 60
%idefine OK 0

; ---------------------------------------------------------------------------- ;

global main ; The "main"-Symbol has to be globally declared for the Linker.

; ---------------------------------------------------------------------------- ;

section .text

global _start
    main:
        ; ssize_t write(int fd, const void *buf, size_t count)
        mov rax, WRITE
        mov rdi, STDOUT
        mov rsi, message
        mov rdx, msg_len
        syscall

        ; void _exit(int status)
        mov rax, EXIT
        mov rdi, 0
        syscall

; ---------------------------------------------------------------------------- ;

section .data:
    message: db "Hello World!", 0xA
    msg_len: equ $ - message

; ---------------------------------------------------------------------------- ;
