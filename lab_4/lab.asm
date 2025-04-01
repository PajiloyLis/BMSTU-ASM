.MODEL SMALL

.DOSSEG

.STACK 100

	ROWS = 9
	COLS EQU 9

.DATA

	matrix 	db ROWS*COLS dup(?)
	n	dw 0
	m 	dw 0

.CODE
.STARTUP
	mov 	ah, 01h
	int 	21h
	xor 	dx, dx
	mov 	dl, al
	mov 	n, dx
	sub		n, '0'
	
	int 21h

	int 	21h
	mov 	dl, al
	mov 	m, dx
	sub		m, '0'

	int 21h

	mov 	cx, n
	xor 	bx, bx
outer_in:
	xor 	si, si
inner_in:
	int 	21h
	mov 	matrix[bx][si], al
	sub		matrix[bx][si], '0'
	int 21h
	inc 	si
	cmp 	si, m
	jne 	inner_in
	
	add 	bx, COLS
	loop	outer_in
	
	
	xor 	bx, bx
cycle:
	xor 	si, si
	mov 	di, m
	dec 	di
swap_cycle:
	xchg 	dl, matrix[bx][si]
	xchg 	dl, matrix[bx][di]
	xchg 	dl, matrix[bx][si]
	
	inc 	si
	dec 	di
	cmp 	si, di
	jl 	swap_cycle
	
	add 	bx, 2*COLS
	cmp 	bx, ROWS*COLS
	jl 	cycle
	
	mov 	ah, 02 

	mov 	dl, 10
	int 	21h

	mov 	dl, 13
	int 	21h
	
	mov 	cx, n
	xor 	bx, bx
outer_out:
	xor 	si, si
inner_out:
	mov 	dl, matrix[bx][si]
	add		dl, '0'
	int 	21h

	mov		dl, ' '
	int 21h

	inc 	si
	cmp 	si, m
	jne 	inner_out
	
	mov 	dl, 10
	int 	21h

	mov 	dl, 13
	int 	21h

	add 	bx, COLS
	loop	outer_out	
	
	mov 	ax, 4C00h
	int 	21h
END
