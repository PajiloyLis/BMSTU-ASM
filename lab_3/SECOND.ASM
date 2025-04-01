PUBLIC read_str
PUBLIC wrd

SD2 SEGMENT para public 'DATA'
        wrd db 33 dup (?)
SD2 ENDS

SC SEGMENT para public 'CODE'
        assume CS:SC, DS:SD2
read_str proc NEAR
        mov     ax, SD2
        mov     ds, ax
	
	mov bx, offset wrd
	mov al, 30
	mov [bx], al
	
        mov     ah, 0Ah
        mov     dx, offset wrd
        int     21h
        ret
read_str endp
SC ENDS
END
