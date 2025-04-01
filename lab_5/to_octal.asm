.386

extrn str_number: byte
extrn DIGITS: abs
public to_octal

OCTAL_DIGITS equ 6

OctalDataSegment segment word public use16 'DATA'
    value dw 1 dup (0)
    octal_number db 6 dup (0)
OctalDataSegment ends

CodeSegment segment word public use16 'CODE'
    assume ds:OctalDataSegment

str_to_uint proc near
    ; mov ah, 09h
    ; mov dx, offset kek
    ; int 21h

    lea si, str_number
    add si, 2

    push ds
    push cx

    ; mov ax, OctalDataSegment
    ; mov ds, ax

    xor cx, cx
    xor ax, ax
    mov cx, DIGITS

label_loop:
    lodsb
    sub al, '0'
    shl value, 1
    add value, ax
    loop label_loop

    pop cx
    pop ds
    ret
str_to_uint endp

to_octal proc near
    mov value, 0
    call str_to_uint
    push ds
    mov ax, OctalDataSegment
    mov ds, ax
    mov es, ax
    mov di, offset octal_number

    xor cx, cx
    xor ax, ax
    mov cl, OCTAL_DIGITS
    std
label_loop:
    mov al, 111b
    and ax, value
    ; cmp al, 10
    ; jge elif
    add al, '0'
    stosb
    shr value, 3
    jmp end_if
elif:
    add al, 'A'
    stosb
end_if:
    loop label_loop
    cld

    mov ah, 09
    mov dx, offset octal_number
    int 21h

    mov ah, 02

    mov dl, 10
    int 21h

    mov dl, 13
    int 21h
    pop ds
    ret
to_octal endp
CodeSegment ends
end
