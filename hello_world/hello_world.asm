
; ---------------------------------------------------------------------------- ;

%define WRITE 1
%define STDOUT 1
%define EXIT 60
%define OK 0

; ---------------------------------------------------------------------------- ;

global _start ; The "_start"-Symbol has to be globally declared for the Linker.

; ---------------------------------------------------------------------------- ;

section .text

global _start
    _start:
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
