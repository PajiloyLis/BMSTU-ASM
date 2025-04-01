.MODEL TINY
.DOSSEG
.CODE

.STARTUP
    MOV AH, 40h
    MOV CL, DS:[80h]
    MOV DX, [82h]
    INT 21h
    MOV AH, 4Ch
    INT 21h
END

