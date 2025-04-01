extrn str_number: byte
extrn DIGITS: abs
public InputStrNumber

CodeSegment segment word public use16 'CODE'
InputStrNumber proc near
    push cx

    xor cx, cx
    mov cx, DIGITS

loop_start:
    mov ah, 01
    int 21h
    mov bx, DIGITS
    sub bx, cx
    mov str_number[bx], al
    loop loop_start

    mov ah, 02

    mov dl, 10
    int 21h

    mov dl, 13
    int 21h

    pop dx
    ret
InputStrNumber endp
CodeSegment ends
end