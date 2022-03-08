
; ---------------------------------------------------------------------------- ;

global main ; The "main"-Symbol has to be globally declared for the Linker.

; ---------------------------------------------------------------------------- ;

section .text
    main:
        ; ssize_t write(int fd, const void *buf, size_t count)
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, message
        mov rdx, msg_len
        syscall

        ; ssize_t write(int fd, const void *buf, size_t count)
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, message2
        mov rdx, message2_len
        syscall

        ; ssize_t write(int fd, const void *buf, size_t count)
        mov rax, SYS_WRITE
        mov rdi, STDOUT
        mov rsi, message3
        mov rdx, message3_len
        syscall

        ; void _exit(int status)
        mov rax, SYS_EXIT
        mov rdi, 0
        syscall

; ---------------------------------------------------------------------------- ;

section .data:
    message: db "Hello World!", 0xA
    msg_len: equ $ - message
    STRING message2, {"Hello World!", 0xA}
    STRING message3, `Hello World!\n`

; ---------------------------------------------------------------------------- ;
