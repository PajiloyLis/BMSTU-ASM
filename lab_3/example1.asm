.model small 
.stack 100h 
 
.data 
    video_mode equ 13h  
 
.code 
main proc 
    mov ax, @data 
    mov ds, ax 
 
    mov ax, video_mode 
    int 10h 
 
    mov ax, 0A000h    
    mov es, ax 
 
    mov cx, 320 * 200    
    xor di, di               
 
fill_screen: 
    mov word ptr es:[di], 66h    
    add di, 1                    
    loop fill_screen             
 
    mov ah, 0 
    int 16h             
 
    mov ax, 3h           
    int 10h 
 
    mov ax, 4C00h        
    int 21h 
main endp 
 
end main
