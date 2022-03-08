
; ---------------------------------------------------------------------------- ;

; https://man7.org/linux/man-pages/man2/brk.2.html

; ---------------------------------------------------------------------------- ;

global my_brk_int
global my_brk_long
global get_brk

; ---------------------------------------------------------------------------- ;

section .text

    ; NOTE: Basically sbrk(0) but for some Reason when called in the C-Code after
    ; allocating in Assembler it will not return the new Program Break.
    get_brk:

            ; Save Base Pointer (C Convention)
            push rbp
            mov rbp, rsp

            ; Get the current BRK-Location
            mov rdi, 0
            CALL_SYS BRK

            ; Restore old call frame (NOTE: See 'leave'-Instruction)
            mov rsp, rbp
            pop rbp

            ret

; ---------------------------------------------------------------------------- ;

    ; void * my_brk_int (int bytes)
    my_brk_int:
        ; Check if a negative Value was supplied
        cmp edi, 0
        jnl my_brk
        mov rax, ERROR
        ret

    ; void * my_brk_long (long bytes)
    my_brk_long:
        ; Check if a negative Value was supplied
        cmp rdi, 0
        jnl my_brk
        mov rax, ERROR
        ret

; ---------------------------------------------------------------------------- ;

    my_brk:
        ; Check if brk(0) was called
        cmp rdi, 0
        je get_brk

        ; Save Base Pointer (C Convention)
        push rbp
        mov rbp, rsp

        ; Save the Size-Argument
        mov r9, rdi

        ; Get the current BRK-Location
        mov rdi, 0
        CALL_SYS BRK

        ; Store current Heap Base Location
        mov r10, rax

        ; Move the Program
        add r9, r10
        mov rdi, r9
        CALL_SYS BRK

        ; Check if the Syscall was successful
        ; => Returns new Break on success
        ;       (cannot be old Break because my_brk(0) diverts to get_brk)
        ; => Returns old Break on failure
        cmp rax, r10
        ; Compare if it less because you cannot allocate negative Bytes
        ; and if the Break is smaller something is seriously wrong
        jl .failure

        ; Set the Return Value to the start of the allocated Memory
        mov rax, r10

    .end:
        ; Restore old call frame (NOTE: See 'leave'-Instruction)
        mov rsp, rbp
        pop rbp

        ret

    .failure:
        ; Return ERROR
        mov rax, ERROR
        jmp .end

; ---------------------------------------------------------------------------- ;

section .data
    STRING formatter, `ASM Heap Base Pointer: %p (%p => %p)\n\0`
    test_success: db "Hello", 10
    test_success_len: equ $-test_success

section .rodata
    CHUNK_SIZE: db 4096
    FIELD_INC:  db 16

; ---------------------------------------------------------------------------- ;

STRUC ALLOC_STATE
    ALLOCATED:  resb 1
    FREE:       resb 1
    END_FIELDS: resb 1
END_STRUC

; ---------------------------------------------------------------------------- ;
