
; ---------------------------------------------------------------------------- ;

%define STDIN 0
%define STDOUT 1
%define STDERR 2

; ---------------------------------------------------------------------------- ;

; Examples:
; --------------------------------------
; STRING message, {"Hello World!", 0xA}
; - and --------------------------------
; STRING message, `Hello World!\n`
; --------------------------------------
; expand into:
; --------------------------------------
; message: db "Hello World!", 0xA
; msg_len: equ $ - message
; --------------------------------------

%macro STRING 2
    %1: db %2
    %1_len: equ $ - %1
%endmacro

%macro DEBUG 1
section .rodata
    %%dbg_str: db %1
    %%dbg_str_len: equ $ - %%dbg_str
section .text
    mov rdi, STDOUT
    mov rsi, %%dbg_str
    mov rdx, %%dbg_str_len
    CALL_SYS WRITE
%endmacro

; ---------------------------------------------------------------------------- ;
