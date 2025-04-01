.model small
.stack 100h
.code
.186

start:
        push    FAR_BSS
        pop     ds

        xor     ax, ax
        int     1Ah
        mov     di, 320*200+1
fill_buffer:
        imul    dx, 4E35h
        inc     dx
        mov     ax, dx
        shr     ax, 15
        mov     byte ptr [di], al

        dec     di
        jnz     fill_buffer

        mov     ax, 0013h
        int     10h

main_loop:
        mov     di, 320*200+1
step_1:
        mov     al, byte ptr [di+1]
        add     al, byte ptr [di-1]
        add     al, byte ptr [di+319]
        add     al, byte ptr [di-319]
        add     al, byte ptr [di+320]
        add     al, byte ptr [di-320]
        add     al, byte ptr [di+321]
        add     al, byte ptr [di-321]
        shl     al, 4

        or      byte ptr [di],al

        dec     di
        jnz     step_1

        mov     di, 320*200+1
flip_cycle:
        mov     al, byte ptr [di]
        shr     al, 4
        cmp     al, 3
        je      birth
        cmp     al, 2
        je      f_c_continue
        mov     byte ptr [di], 0
        jmp short f_c_continue

birth:
        mov     byte ptr [di], 1
f_c_continue:
        and     byte ptr [di], 0Fh

        dec     di
        jnz     flip_cycle

        mov     si, 230*200+1
        mov     cx, 319
        mov     dx, 199

zdisplay:
        mov     al, byte ptr [si]
        mov     ah, 0Ch
        int     10h
        dec     si
        dec     cx
        jns     zdisplay
        mov     cx, 319
        dec     dx
        jns     zdisplay

        mov     ah, 1
        int     16h
        jz      main_loop

        mov     ax, 0003h
        int     10h
        mov     ax, 4C00h
        int     21h

.fardata?
        db 320*20+1 dup(?)
end start
