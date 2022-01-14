
; ---------------------------------------------------------------------------- ;

; https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html

; https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
; https://filippo.io/linux-syscall-table/
; https://linuxhint.com/list_of_linux_syscalls/#read

; ---------------------------------------------------------------------------- ;

%define WRITE 1
%define STDOUT 1
%define EXIT 60
%define OK 0

%define ASCII_NUM_START 48

; ---------------------------------------------------------------------------- ;

global i2a

; ---------------------------------------------------------------------------- ;

section .text

    ; char * i2a(char* s, int num)
    ; Converts Integer to String and stores it in s
    ; A moved Pointer (inside the s-Buffer) will be returned.
    ; Requires 20-Byte long Buffer as Argument s (for signed 64-bit Numbers)
    i2a:
        ; Move Integer Value into Rax
        mov rax, rsi
        ; Create Index Register pointing at Buffer End
        mov r9, rdi
        add r9, buff_len
        ; Null terminate String
        mov byte [r9], 0
        ; Store Constant Divider in R10
        mov r10, 10

        cmp rax, 0
        jge _is_positive
        jmp _is_negative

    _is_positive:
        mov r8, 0
        jmp _i2a_loop
    _is_negative:
        neg rax
        mov r8, 1
        jmp _i2a_loop

    _i2a_loop:
        ; Divide Rax by 10
        mov rdx, 0
        div r10
        ; Decrement Index Register
        dec r9
        ; Create Ascii-Number from Result
        mov bl, dl
        add bl, ASCII_NUM_START
        ; Push Ascii Value into String
        mov byte [r9], bl
        ; Check if Result is zero
        cmp rax, 0
        jne _i2a_loop

    _i2a_sign:
        cmp r8, 0
        je _i2a_finish
        dec r9
        mov byte [r9], 45

    _i2a_finish:
        ; Return moved Pointer
        mov rax, r9
        ret

; ---------------------------------------------------------------------------- ;
;SECTION .BSS
;Non initialized variables
; ---------------------------------------------------------------------------- ;
section .bss
    buff_len equ 20 ; Enough Space for signed 64 Bit Number
    buff: resb buff_len

; ---------------------------------------------------------------------------- ;
