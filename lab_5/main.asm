.386
.dosseg

public action
public str_number
public DIGITS
extrn InputStrNumber: near
extrn OutputMenu: near
extrn InputCode: near
extrn OutputErrorMessage: near
extrn to_octal: near

DIGITS equ 16

MainStackSegment segment word stack use16 'STACK'
    db 200h dup (?)
MainStackSegment ends

MainDataSegment segment word public use16 'DATA'
    action db 1 dup(5)
    functions dw 5 dup(?)
    str_number db 18 dup(0)
MainDataSegment ends

CodeSegment segment word public use16 'CODE'
    assume cs:CodeSegment, ds:MainDataSegment, ss:MainStackSegment
main:
    mov ax, MainDataSegment
    mov ds, ax

    mov str_number, DIGITS

    ; lea di, InputStrNumber
    ; mov functions[0], di

main_loop:
    menu_loop:
        call OutputMenu
        call InputCode
        
        cmp action, 5
        jl end_menu_loop
        call OutputErrorMessage
        jmp menu_loop
    end_menu_loop:

    cmp action, 0
    je end_main_loop
    ; xor bx, bx
    ; mov bl, action
    ; imul bx, 2
    ; call word ptr functions[bx]
    cmp action, 1
    jne elif
    call InputStrNumber
    mov ah, 09
    mov dx, offset str_number
    int 21h
    jmp main_loop
elif:
    cmp action, 2
    jne main_loop
    call to_octal
    jmp main_loop
end_main_loop:

    mov ah, 4Ch
    int 21h

CodeSegment ends
end main
