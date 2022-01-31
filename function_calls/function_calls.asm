
; ---------------------------------------------------------------------------- ;

global asm_test

extern c_test

; ---------------------------------------------------------------------------- ;

section .text
    asm_test:

        ; Save Base Pointer (C Convention)
        push rbp
        mov rbp, rsp

        ; ARG1 in RDI
        cmp rdi, 420
        jne fail
        ; ARG2 in RSI
        cmp rsi, 69
        jne fail
        ; ARG3 in RDX
        cmp rdx, 42069
        jne fail
        ; ARG4 in RCX
        cmp rcx, 69420
        jne fail
        ; ARG5 in R8
        cmp r8, 6969
        jne fail
        ; ARG6 in R9
        cmp r9, 420420
        jne fail
        ; All other Arguments are pushed on top of the Stack
        ;
        ; The Base Pointer of the Stack (rbp) has to be offset because
        ; the previous Base Pointer is saved on the Stack as well as
        ; the Return Address. Only after those two Values the Arguments
        ; are pushed:
        ;
        ; |-----------------------| 0xFF20
        ; | Argument 2            |
        ; |-----------------------| 0xFF18
        ; | Argument 1            |
        ; |-----------------------| 0xFF10
        ; | Return Address        |
        ; |-----------------------| 0xFF08
        ; | Saved Base Pointer    |
        ; |-----------------------| 0xFF00 (variable size)  <-- Base Pointer
        ; |                       |
        ; | Your Stack Area       |
        ; |                       |
        ; |-----------------------| 0x0                     <-- Stack Pointer
        ;
        cmp qword [rbp + 16], 42
        jne fail
        cmp qword [rbp + 24], 4269
        jne fail

; ---------------------------------------------------------------------------- ;

    pass:
        ; Call C-Function from Assembly
        ; Arguments are setup the same way
        ; I don't know if you have to save the Base Pointer RBP or not lul
        mov rax, 0
        mov rdi, 4269
        mov rsi, 42
        mov rdx, 420420
        mov rcx, 6969
        mov r8, 69420
        mov r9, 42069
        push 420
        push 69
        call c_test

        ; Return the RAX returned by the c_test-Function
        jmp return

; ---------------------------------------------------------------------------- ;

    fail:
        mov rax, 42069

    return:
        mov rsp, rbp
        pop rbp
        ret

; ---------------------------------------------------------------------------- ;
