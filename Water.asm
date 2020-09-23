;Water.asm
;VB
;Private Type BITMAP
;   bmType As Long          ' Type of bitmap
;   bmWidth As Long         ' Pixel width
;   bmHeight As Long        ' Pixel height
;   bmWidthBytes As Long    ' Byte width = 2 or 3 x Pixel width
;   bmPlanes As Integer     ' Color depth of bitmap
;   bmBitsPixel As Integer  ' Bits per pixel, must be 16 or 24
;   bmBits As Long          ' Pointer to bitmap data
;End Type
;Dim bmp As BITMAP

%macro movab 2		;name & num of parameters
  push dword %2		;2nd param
  pop dword %1		;1st param
%endmacro			;use  movab %1,%2

%define bmW   [ebp-4]	;eg 300
%define bmH   [ebp-8]	;eg 300
%define bmWB  [ebp-12]	;eg 600 or 900 (16 or 24 bit color)
%define bmpt  [ebp-16]	;pointer to pic1 memory
%define palpt [ebp-20]	;pointer to Colors(0) palette
%define irand [ebp-24]	;random number 0-255

[bits 32]

	push ebp
	mov ebp,esp
	sub esp,24
	push edi
	push esi
	push ebx

	;Fill bmp structure
	mov ebx,[ebp+8]
	movab bmW,[ebx+4]
	movab bmH,[ebx+8]
	movab bmWB,[ebx+12]
	movab bmpt,[ebx+20]
	
	;Pointer to palette
	mov ebx,[ebp+12]
	movab palpt,ebx

;------------------------------------------------------------
	;in al,040h          ;Seed from timer
	mov eax,[ebp+20]
	mov irand,eax
;------------------------------------------------------------
	;Check if 16 or 24 bit color
	mov eax,bmWB
	cmp eax,600
	je near SixteenBit

;------------------------------------------------------------
;24 bit
	mov edi,bmpt		;Fill top
	add edi,275*900		
	mov ecx,25
	xor edx,edx
	mov edx,002B5D9h	;Top color
sky:
	push ecx
	mov ecx,300
sky2:
	mov [edi],dx
	bswap edx
	mov [edi+2],dh
	bswap edx
	add edi,3
	dec ecx
	jnz sky2
	
	pop ecx
	dec ecx
	jnz sky
;------------------------------------------------------------
	mov edi,bmpt		;Start water
	add edi,272*900		

	mov ecx,6		;Pre-start 6 lines 
	cmp al,128
	jb SROW
	mov ecx,3		;or Pre-start 3 lines 
SROW:
	push ecx
	mov ecx,300
SROW2:
	mov esi,palpt	;Pointer to palette
	CALL Random		;Get random number to eax

	add esi,eax		;Point randomly into Colors()
	mov eax,[esi]	;x B G R
	bswap eax		;R G B x    Need to make Blue low byte
	shr eax,8		;x R G B

	mov [edi],ax	;Set start colors in
	bswap eax
	mov [edi+2],ah
	bswap eax
	add edi,3
	dec ecx
	jnz SROW2

	pop ecx
	dec ecx
	jnz near SROW
;--------------------------------------------------------------
	mov edi,bmpt
	add edi,900		;1 line up
	mov esi,edi
	add esi,900		;Point to line above
	mov ecx,271 	;271 lines, has to get to lines @ 20-23
WATER:
	push ecx
	mov ecx,300
WaterLine:
	CALL Random			;Get random number to bl
	mov ebx,irand

	;Obstruction

	cmp ecx,300
	jg obstruc2
	cmp ecx,250
	jl obstruc2
	pop edx
	push edx
	cmp edx,171
	jl obstruc2
	cmp bl,254
	jg near nextpix
	
obstruc2:


	cmp ecx,175
	jg obstruc3
	cmp ecx,125
	jl obstruc3
	pop edx
	push edx
	cmp edx,71
	jl obstruc3
	cmp bl,254
	jg near nextpix
	jmp nx


obstruc3:

	cmp ecx,100
	jg nx
	cmp ecx,75
	jl nx
	pop edx
	push edx
	cmp edx,131
	jl nx
	cmp bl,254
	jg near nextpix


nx:
	;Average above & below to blurr
	mov eax,[esi+900]	;x R G B

	;jmp Wobble
	
	mov edx,ecx
	and edx,07h
	jnz Wobble
	
	mov edx,[esi-900]	;x R G B
	shr al,1			;B/2
	shr dl,1			;B/2
	add al,dl			;Av B
	shr ah,1			;G/2
	shr dh,1			;G/2
	add ah,dh			;Av G
	bswap eax
	bswap edx
	shr ah,1			;R/2
	shr dh,1			;R/2
	add ah,dh			;Av R
	bswap eax

Wobble:
	cmp bl,70			;Wobble Left Center Right as bl
	jb leftpix
	cmp bl,185
	ja rightpix

	mov [edi],ax		;Set pixels BG
	bswap eax
	mov [edi+2],ah		;Set pixel R

	jmp nextpix
rightpix:
	mov [edi+3],ax		;Set pixels to right BG
	bswap eax
	mov [edi+5],ah		;;Set pixel to right R

	jmp nextpix
leftpix:
	mov [edi-3],ax		;Set pixel to left BG
	bswap eax
	mov [edi-1],ah		;Set pixel to left R

nextpix:
	add edi,3			;next pixel
	add esi,3
	dec ecx				;decr line count
	jnz near WaterLine

nextline:
	pop ecx
	dec ecx
	jnz near WATER
	
	jmp GETOUT
;##################################################################
SixteenBit:

	mov edi,bmpt		;Fill top
	add edi,278*600		
	mov ecx,22
	mov dx, 03DEFh	;Top color
sky6:
	push ecx
	mov ecx,300
sky26:
	mov [edi],dx
	inc edi
	inc edi
	dec ecx
	jnz sky26
	
	pop ecx
	dec ecx
	jnz sky6

;------------------------------------------------------------
	mov edi,bmpt		;Start water
	add edi,272*600		

	mov ecx,6		;Pre-start 6 lines 
	cmp al,128
	jb SROW6
	mov ecx,3		;or Pre-start 3 lines 
SROW6:
	push ecx
	mov ecx,300
SROW26:
	mov esi,palpt	;Pointer to palette
	CALL Random		;Get random number to eax

	add esi,eax		;Point randomly into Colors()
	mov eax,[esi]	;x B G R
	bswap eax		;R G B x    Need to make Blue low byte
	shr eax,8		;x R G B

	CALL Conv16		;In eax 24bit Out ax 16bit
	
	mov [edi],ax	;Set start colors in
	add edi,2
	dec ecx
	jnz SROW26

	pop ecx
	dec ecx
	jnz near SROW6
	
;--------------------------------------------------------------
	mov edi,bmpt
	add edi,600		;1 line up
	mov esi,edi
	add esi,600		;Point to line above
	mov ecx,271 	;271 lines, has to get to lines @ 20-23
WATER6:
	push ecx
	mov ecx,300
WaterLine6:
	CALL Random			;Get random number to bl
	mov ebx,irand

	;Obstruction
	cmp ecx,175
	jg obstruc26
	cmp ecx,125
	jl obstruc26
	pop edx
	push edx
	cmp edx,71
	jl obstruc26
	cmp bl,254
	jg near nextpix6
	jmp nx6
	
obstruc26:

	cmp ecx,250
	jg obstruc36
	cmp ecx,225
	jl obstruc36
	pop edx
	push edx
	cmp edx,171
	jl obstruc36
	cmp bl,254
	jg near nextpix6


obstruc36:

	cmp ecx,100
	jg nx6
	cmp ecx,75
	jl nx6
	pop edx
	push edx
	cmp edx,131
	jl nx6
	cmp bl,254
	jg near nextpix6


nx6:
	;Average above & below to blurr
	mov ax,[esi+600]	;0RGB

	mov edx,ecx
	and edx,07h
	jnz Wobble6
	
	mov dx,[esi-600]	;0RGB
	CALL Aver16	;In ax, dx Out ax average of 16bit colors in ax & dx

Wobble6:
	cmp bl,70			;Wobble Left Center Right as bl
	jb leftpix6
	cmp bl,185
	ja rightpix6

	mov [edi],ax		;Set pixels BG

	jmp nextpix6
rightpix6:
	mov [edi+2],ax		;Set pixels to right BG

	jmp nextpix6
leftpix6:
	mov [edi-2],ax		;Set pixel to left BG

nextpix6:
	add edi,2			;next pixel
	add esi,2
	dec ecx				;decr line count
	jnz near WaterLine6

nextline6:
	pop ecx
	dec ecx
	jnz near WATER6

GETOUT:
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 16

;------------------
Random: ;Random number 0-255 LoB irand
		;& 4*LoB irand in eax -> offset into palette
	push edx
	mov eax,irand

	mov edx,08405h
	mul edx
	inc eax
	mov irand,eax
	and eax,0FFh
	mov edx,4
	mul edx
	pop edx
ret
;====================================================
Aver16:	;In ax, dx Out ax average of 16bit colors in ax & dx
	push ebx
				;                      R      G      B
				;00000000|00000000|0(11111)(11|111)(11111)
	shl eax,3	;00000000|000000(11|111)(11111)|(11111)000
	shr al,4	;00000000|000000(11|111)(11111)|00001111
	shl eax,3	;00000000|000(11111)|(11111)000|01111000
	shr ah,4	;00000000|000(11111)|00001111|01111000
	shr al,3	;00000000|000(11111)|00001111|00001111
	bswap eax	;00001111|00001111|000(11111)|00000000
	shr ah,1	;00001111|00001111|00001111|00000000
				;   B1       G1       R1
	shl edx,3	;00000000|000000(11|111)(11111)|(11111)000
	shr dl,4	;00000000|000000(11|111)(11111)|00001111
	shl edx,3	;00000000|000(11111)|(11111)000|01111000
	shr dh,4	;00000000|000(11111)|00001111|01111000
	shr dl,3	;00000000|000(11111)|00001111|00001111
	bswap edx	;00001111|00001111|000(11111)|00000000
	shr dh,1	;00001111|00001111|00001111|00000000
				;   B2       G2       R2
	;add ah,dh
	;bswap eax
	;bswap edx
	;add ah,dh
	;add al,dl	;00000000| Av Red | Av Green | Av Blue

	bswap eax
	bswap edx
	add eax,edx ;00000000| Av Red | Av Green | Av Blue

	mov bl,al	;00001111
	mov bh,ah	;00001111
	shl bl,3	;01111000 bx=00001111|01111000
	shr bx,3	;bx = 000000(01|111)(01111)
	bswap eax	;Av Blue | Av Green |000(01111)|00000000
	mov al,ah
	shl al,2	;0(01111)00
	add bh,al
	mov ax,bx
	
	pop ebx
ret
;====================================================
Conv16:	;In eax 24bit Out ax 16bit
		;              R       G       B
		;00000000|11111111|11111111|11111111	
		;                     ah       al
	push ebx
	shr al,3	;00000000|11111111|11111111|00011111
	shr ah,3	;00000000|11111111|00011111|00011111
	bswap eax	;00011111|00011111|11111111|00000000
	shr ah,3	;00011111|00011111|00011111|00000000
	bswap eax	;00000000|00011111|00011111|00011111
	shl al,3	;00000000|00011111|00011111|11111000
	shr ax,3	;00000000|00011111|00000011|11111111
	mov bl,ah	;00000011
	bswap eax	;11111111|00000011|00011111|00000000
	mov bh,ah	;00011111                     al
	bswap eax	;00000000|00011111|00000011|11111111
	shl bl,6	;11000000
	shr bx,6	;00000000|01111111
	mov ah,bl	;ax is now 16bit
	pop ebx
ret

ENDS


