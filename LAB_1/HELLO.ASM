.MODEL TINY
.DOSSEG
MSG EQU "Hello, World!$"
.CODE
.STARTUP
    MOV AH, 09h
    MOV DX, OFFSET MSG
    INT 21h
    MOV AH, 4Ch
    INT 21h
END
