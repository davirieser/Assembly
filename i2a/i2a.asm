
; ---------------------------------------------------------------------------- ;

%define WRITE 1
%define STDOUT 1
%define EXIT 60
%define OK 0

%define ASCII_NUM_START 48

; ---------------------------------------------------------------------------- ;
;SECTION .TEXT
;Code
; ---------------------------------------------------------------------------- ;
global _start ; The "_start"-Symbol has to be globally declared for the Linker.
section .text

    _start:

        ; char* i2a(char* s, int num)
        mov rax, buff
        mov rdi, 235980
        call i2a

        ; ssize_t write(int fd, const void *buf, size_t count)
        mov rax, WRITE
        mov rdi, STDOUT
        mov rsi, buff
        mov rdx, buff_len
        syscall

        ; void _exit(int status)
        mov rax, EXIT
        mov rdi, 0
        syscall

    ; char* i2a(char* s, int num)
    i2a:
        ; Copy Memory Pointer to the String Start
        mov r8, rax
        ; Create Index Register pointing at Buffer End
        mov r9, rax
        add r9, buff_len
        ; Store Constant Divider in R10
        mov r10, 10
        ; Move Integer Value into Rax
        mov rax, rdi

    _i2a_loop:
        ; Divide Rax by 10
        mov rdx, 0
        div r10
        ; Create Ascii-Number from Result
        mov bl, dl
        add bl, ASCII_NUM_START
        ; Decrement Index Register
        sub r9, 1
        ; Push Ascii Value into String
        mov byte [r9], bl
        ; Check if Result is zero
        cmp rax, 0
        jne _i2a_loop

    _i2a_finish:
        ; Fill the Rest of the String with Space
        ; Decrement Index Register
        sub r9, 1
        ; Push Ascii Space into String
        mov byte [r9], 32
        ; Check if all Bytes are filled
        cmp r9, r8
        jg _i2a_finish

        ; Point Return Value on String Start
        mov rax, r8
        ret


; ---------------------------------------------------------------------------- ;
;SECTION .DATA
;Instantiated variables/Constants
; ---------------------------------------------------------------------------- ;
section .data

; ---------------------------------------------------------------------------- ;
;SECTION .BSS
;Non initialized variables
; ---------------------------------------------------------------------------- ;
section .bss
    buff_len equ 19 ; Enough Space for 64 Bit Number
    buff: resb buff_len

; ---------------------------------------------------------------------------- ;
