EXTRN read_str:	near
EXTRN wrd: byte

SSTK SEGMENT para STACK 'STACK'
        db 100 dup (?)
SSTK ENDS

SD1 SEGMENT para public 'DATA'
        RES     db 0
SD1 ENDS

SC SEGMENT para public 'CODE'
        assume  CS:SC, SS:SSTK, ES:SD1
main:
	mov ax, SD1
	mov es, ax

        call read_str
        
        mov ah, 02
        mov dl, 10
        int 21h
        
        mov ah, 02
        mov dl, 13
        int 21h
      
        mov bx, offset wrd
        mov al, [bx+3]
       	add RES, al
       	;xor dl, dl
       	;add dl, ds:[bx+3]
        sub RES, '0'
        ;sub dl, '0'
        mov al, [bx+6]
        add RES, al
        ;add dl, ds:[bx+6]
        mov ah, 02
        mov dl, RES
        int 21h
        
        mov ax, 4c00h
	int 21h
SC ENDS
END main
