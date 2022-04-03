
; ---------------------------------------------------------------------------- ;

%idefine NULL 0
%define OK 0
%define ERROR -1

; ---------------------------------------------------------------------------- ;

%define ASCII_NUMBER_START 48
%define ASCII_UPPER_START 65
%define ASCII_LOWER_START 97

; ---------------------------------------------------------------------------- ;

%define .startup .init_array
%define .cleanup .fini_array

; ---------------------------------------------------------------------------- ;

%macro FUNC_ENTER 0

    push rbp        ; Save old Stack Frame
    mov rbp, rsp    ; Setup local stack Frame

%endmacro

; ---------------------------------------------------------------------------- ;

%macro FUNC_LEAVE 0

    mov rsp, rbp    ; Restore
    pop rbp

    ret

%endmacro

; ---------------------------------------------------------------------------- ;
