
; ---------------------------------------------------------------------------- ;

; https://man7.org/linux/man-pages/man2/brk.2.html

; ---------------------------------------------------------------------------- ;

; Export Symbols as functions
global malloc:function
global free:function

; %ifdef DEBUG
    global BRK_START:data
    global BRK_END:data
; %endif

; ---------------------------------------------------------------------------- ;

; Setup Function Pointer called before Startup
section .startup
    MALLOC_INIT: dq malloc_init

; Cleanup Function Pointers
section .cleanup
    MALLOC_FINISH: dq malloc_finish

; ---------------------------------------------------------------------------- ;

STRUC MEM_FIELD
    .next:      resq 1  ; Pointer to next Chunk (void *)
    .prev:      resq 1  ; Pointer to previous Chunk (void *)
    .state:     resb 1  ; State of the current Chunk (FIELD_STATE)
    alignb 8            ; Align Struct to a Double Word (32 Bit Boundary)
ENDSTRUC

STRUC FIELD_STATE       ; This is an Enum for the MEM_FIELD.state-Field
    .FREE:      resb 1
    .IN_USE:    resb 1
ENDSTRUC

; ---------------------------------------------------------------------------- ;

section .text

; ---------------------------------------------------------------------------- ;

    malloc_init:

        FUNC_ENTER

        ; Get the current BRK-Location
        mov rdi, NULL
        CALL_SYS BRK

        ; Store initial Program Break (reserving Space for the initial Header)
        mov [BRK_START], rax
        add QWORD [BRK_START], MEM_FIELD_size

        ; Allocate initial Chunk
        add rax, [CHUNK_SIZE]       ; Program Break + CHUNK_SIZE
        mov rdi, rax
        CALL_SYS BRK

        ; Check if initial Allocation worked.
        cmp rax, [BRK_START]
        jle .exit

        ; Store Program Break End
        mov [BRK_END], rax

        ; Create initial Header
        mov rax, [BRK_START]
        mov QWORD [rax - MEM_FIELD_size + MEM_FIELD.next], NULL
        mov QWORD [rax - MEM_FIELD_size + MEM_FIELD.prev], NULL
        mov BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE

        FUNC_LEAVE

    .exit:

        ; Exit Program because I cannot allocate Memory
        mov rdi, ERROR
        CALL_SYS EXIT

; ---------------------------------------------------------------------------- ;

    malloc_finish:

        FUNC_ENTER

        ; Deallocate all Heap Memory
        mov rdi, [BRK_START]
        CALL_SYS BRK

        FUNC_LEAVE

; ---------------------------------------------------------------------------- ;

    ; void * malloc(long size)
    malloc:
        ; rax always points to the current Block Start
        ; rdi is the specified Size, r10 is used for Calculation

        FUNC_ENTER

        ; Check if Size-Argument is negative
        cmp rdi, 0
        jl .failure

        ; Make sure that the Size is a multiple of a QWORD
        or rdi, 0x7
        inc rdi

        ; Get first Block
        mov rax, [BRK_START]


    .find_free_block:
        ; Check if this is the last Block
        cmp QWORD [rax - MEM_FIELD_size + MEM_FIELD.next], NULL
        je .check_last_block

        ; Check if Block is free
        cmp BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE
        jne .next_block

        ; Calculate current Block Size (Next Block Pointer - Current Block Pointer - MEM_FIELD_size)
        mov r10, [rax - MEM_FIELD_size + MEM_FIELD.next]
        sub r10, rax
        sub r10, MEM_FIELD_size

        ; Check if Block is big enough
        cmp rdi, r10
        jg .next_block

        ; Calculate how much Space will be left after the Block
        sub r10, rdi
        ; Check if enough Space is available after it for another Block
        cmp r10, MEM_FIELD_size
        jle .found_block

        ; Create new Block if there is enough Space for it.
        .split_block:
            ; Calculate Block Header Position
            mov r10, rax
            add r10, rdi
            add r10, MEM_FIELD_size
            ; Get next Block
            mov r9, [rax - MEM_FIELD_size + MEM_FIELD.next]
            ; Create new Header
            mov [r10 - MEM_FIELD_size + MEM_FIELD.prev], rax
            mov [r10 - MEM_FIELD_size + MEM_FIELD.next], r9
            mov BYTE [r10 - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE
            ; Relink previous and next Block
            mov [rax - MEM_FIELD_size + MEM_FIELD.next], r10
            mov [r9 - MEM_FIELD_size + MEM_FIELD.prev], r10

        .found_block:
            ; If Block is big enough, allocate it
            mov BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.IN_USE
            ; Return RAX (contains Block Start Address)
            jmp .end

        .next_block:
            mov rax, [rax - MEM_FIELD_size + MEM_FIELD.next]
            jmp .find_free_block

    .check_last_block:

        ; Check if Block is free
        cmp BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE
        jne .new_block

        ; Calculate current Block Size (Next Block Pointer - Current Block Pointer - MEM_FIELD_size)
        mov r10, [rax - MEM_FIELD_size + MEM_FIELD.next]
        sub r10, rax
        sub r10, MEM_FIELD_size

        ; Check if Block is big enough
        cmp rdi, r10
        jg .new_block

        ; Create new Block if there is enough Space for it.
        .split_last_block:
            ; Calculate Block Header Position
            mov r10, rax
            add r10, rdi
            add r10, MEM_FIELD_size
            ; Create new Header
            mov [r10 - MEM_FIELD_size + MEM_FIELD.prev], rax
            mov QWORD [r10 - MEM_FIELD_size + MEM_FIELD.next], NULL
            mov BYTE [r10 - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE
            ; Relink previous Block
            mov [rax - MEM_FIELD_size + MEM_FIELD.next], r10

        ; If Block is big enough, allocate it
        mov BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.IN_USE
        ; Return RAX (contains Block Start Address)
        jmp .end

    .new_block:

        ; Create Pointer to where the next Block will be (reserving space for Header)
        add rdi, rax
        add rdi, MEM_FIELD_size

    .allocation_worked:

        ; Check if enough Space is available
        ; .allocate_more_space jumps back to .allocation_worked on success
        ; This will enable it to keep trying to allocate Memory until
        ; either your Computer runs out or there is enough Memory allocated.
        cmp rdi, [BRK_END]
        jg .allocate_more_space

        ; Set previous Block's next-Field to Start of this Block
        mov [rax - MEM_FIELD_size + MEM_FIELD.next], rdi
        ; Indicate that this Block is now in Use
        mov BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.IN_USE

        ; Create new Ending Block
        mov QWORD [rdi - MEM_FIELD_size + MEM_FIELD.next], NULL
        mov QWORD [rdi - MEM_FIELD_size + MEM_FIELD.prev], rax
        mov QWORD [rdi - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE
        ; Return Block Starting Address (already contained in rax)
        jmp .end

    .allocate_more_space:

        ; Save rax and rdi
        push rax
        push rdi

        ; Allocate another Chunk
        mov rax, [BRK_END]
        add rax, [CHUNK_SIZE]       ; Program Break + CHUNK_SIZE
        mov rdi, rax
        CALL_SYS BRK

        ; Check if Allocation worked.
        cmp rax, [BRK_END]
        jle .failure

        ; Store new Break End
        mov [BRK_END], rax

        ; Restore rax and rdi
        pop rdi
        pop rax

        ; Jump back
        jmp .allocation_worked

    .failure:
        mov rax, NULL

    .end:
        FUNC_LEAVE

; ---------------------------------------------------------------------------- ;

    free:

        FUNC_ENTER

        ; Check for null Pointer
        cmp rdi, 0
        je .failure

        ; Set Memory Field State to free
        mov BYTE [rdi - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE

    .try_merge_next:

        ; Get the next Block
        mov rax, [rdi - MEM_FIELD_size + MEM_FIELD.next]
        ; Check if this is the last Block
        cmp rax, 0
        je .last_block
        ; Check if next Memory Block is free
        cmp BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE
        jne .try_merge_previous

                ; Get Pointer to the next Block
                mov r10, [rax - MEM_FIELD_size + MEM_FIELD.next]
                ; Change current Blocks next-Pointer to after the free Block
                mov [rdi - MEM_FIELD_size + MEM_FIELD.next], r10
                ; Check if the next Block exists
                cmp r10, NULL
                je .try_merge_previous
                    ; Change the Blocks prev-Pointer to the current Block
                    mov [r10 - MEM_FIELD_size + MEM_FIELD.prev], rdi

    .try_merge_previous:

        ; Get the previous Block
        mov rax, [rdi - MEM_FIELD_size + MEM_FIELD.prev]
        ; Check if this is the first Block
        cmp rax, 0
        je .first_block
        ; Check if previous Memory Block is free
        cmp BYTE [rax - MEM_FIELD_size + MEM_FIELD.state], FIELD_STATE.FREE
        jne .end

            ; Get next Block
            mov r10, [rdi - MEM_FIELD_size + MEM_FIELD.next]
            ; Set this Field's next Pointer to the next Block
            mov [rax - MEM_FIELD_size + MEM_FIELD.next], r10
            ; Check if the previous Block exists
            cmp r10, NULL
            je .end
                ; Set next Blocks prev Field to the current Block
                mov [r10 - MEM_FIELD_size + MEM_FIELD.prev], rax
            jmp .end

    .last_block:
        mov QWORD [rdi - MEM_FIELD_size + MEM_FIELD.next], NULL
        jmp .try_merge_previous

    .first_block:
        mov QWORD [rdi - MEM_FIELD_size + MEM_FIELD.prev], NULL

    .failure:
    .end:

        ; Always return NULL
        xor rax, rax

        FUNC_LEAVE

; ---------------------------------------------------------------------------- ;

; Initialized Variables
section .data

; ---------------------------------------------------------------------------- ;

; Global Variables
section .bss
    BRK_START: resq 1 ; void *
    BRK_END: resq 1 ; void *

; ---------------------------------------------------------------------------- ;

; Constants
section .rodata
    CHUNK_SIZE: dq 4096

; ---------------------------------------------------------------------------- ;
