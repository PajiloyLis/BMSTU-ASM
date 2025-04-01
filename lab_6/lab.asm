; .model tiny

SSeg segment para STACK 'STACK'
    db 100 dup(?)
SSeg ENDS

CSeg segment para PUBLIC 'CODE'
assume cs:CSeg, ds:CSeg, ss:SSeg
; .CODE
    max_speed EQU 1Fh
    org 100h
main:

    jmp init
    prev_1ch_handler dd 0
    time_now db 0
    speed db max_speed

new_1ch_handler proc near
    push ax
    push dx

    mov ah, 02h                             ; 02 - read for 1Ah interuption
    int 1Ah                                 ; BIOS timer interuption CH - hour, CL - minute, DH - second

    cmp dh, time_now                        ; check seconds in variable and now
    je to_end

    mov time_now, dh                        ; else set new seconds to variable
    dec speed                               ; decrease speed variable -> increase speed of printinh

    cmp speed, max_speed                    
    jbe set_speed                           ; if speed less or equal than max_speed go to set_speed label
    mov speed, max_speed                    ; else set speed on max_speed value

set_speed:
    call wait_port_is_writable
    mov al, 0F3h
    out 60h, al

    call wait_port_is_writable
    mov al, speed
    out 60h, al

to_end:
    pop dx
    pop ax
    jmp dword ptr cs: prev_1ch_handler
new_1ch_handler endp

wait_port_is_writable proc near 
    in  al, 64h
    test al, 0010b
    jnz wait_port_is_writable
    ret
wait_port_is_writable endp

init:
    mov ax, 351Ch                           ; AH = 35 - ask interuption hadler address, AL = 1C - number of interuption
    int 21h                                 ; Get address of current interuption handler ES - segment, BX - shift

    mov word ptr prev_1ch_handler, bx       ; set shift in variable
    mov word ptr prev_1ch_handler[2], es     ; and segment

    mov ax, 251Ch                           ; AH = 25 - set new interuption handler, AL = 1C - number of interuption
    mov dx, offset new_1ch_handler;
    int 21h

    ; mov dx, offset init
    ; int 27h

    mov ax, 3100h
    mov dx, offset init
    shr dx, 1
    int 21h

    mov ax, 4c00h
    int 21h
CSeg ENDS
; END main
END init