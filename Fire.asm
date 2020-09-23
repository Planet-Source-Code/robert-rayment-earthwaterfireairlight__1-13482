;Fire.asm
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
;-----------------------------------------------
	
	;Pointer to palette
	mov ebx,[ebp+12]
	movab palpt,ebx

;-----------------------------------------------
	;in al,040h          ;Seed from timer
	mov eax,[ebp+20]
	mov irand,eax

;-----------------------------------------------
	;Check if 16 or 24 bit color
	mov eax,bmWB
	cmp eax,600
	je near SixteenBit

;-----------------------------------------------
;24 bit
	mov edi,bmpt		;Fill ground
	mov ecx,20*300
	mov edx, 00770000h	;ground color
ground:
	mov [edi],edx
	add edi,3
	dec ecx
	jnz ground
;-----------------------------------------------
	
	mov edi,bmpt	;Start fire
	mov eax,18000	;20*900
	add edi,eax		;Start at row 20
	
	mov ecx,900		;Pre-start 6 lines (depends on edi,esi+3)
	cmp al,128
	jb SROWS
	shr ecx,1		;or Pre-start 3 lines (depends on edi,esi+3)

SROWS:
	mov esi,palpt	;Pointer to palette
	
	CALL Random		;Get random number to eax
	
	cmp eax,400
	jb fillA
	cmp eax,600
	ja fillA
	mov eax,0		;Put occasional black
	jmp fillB

fillA:
	add esi,eax		;Point randomly into Colors()
	mov eax,[esi]	;x B G R
	bswap eax		;R G B x    Need to make Blue low byte
	shr eax,8		;x R G B

fillB:	
	mov [edi],eax	;Put same color in twice to give larger color blocks
	add edi,3
	mov [edi],eax
	add edi,3
	mov [edi+900],eax
	
	dec ecx
	jnz SROWS
	
;-----------------------------------------------
	mov edi,bmpt
	mov eax,269997	;270000-3 ie last 3B pixel
	add edi,eax
	mov esi,edi
	sub esi,900		;Point to line below
	
	mov eax,300
	mov ecx,277
	mul ecx
	mov ecx,eax		;277 lines, has to get to lines @ 20-23

flamer:
	CALL Random			;Get random number to bl
	mov ebx,irand

	;Average above & below to blurr
	mov eax,[esi+900]	;x R G B
	shr ah,1
	bswap eax			;B G R x
	shr ah,1
	bswap eax			;x R G B
	
	mov edx,[esi-900]	;x R G B
	shr dh,1
	bswap edx			;B G R x
	shr dh,1
	bswap edx			;x R G B
	add eax,edx
						;Drift to right
	cmp bl,40			;Shift right as bl
	jb right2pix
	cmp bl,200
	ja right4pix
	mov [edi+3],eax		;Set pixel
	jmp nextpix
right4pix:
	mov [edi+12],eax	;Set pixel
	jmp nextpix
right2pix:
	mov [edi+6],eax		;Set pixel
nextpix:
	sub edi,3			;next pixel
	sub esi,3
	dec ecx				;decr line count
	jnz flamer
	
	jmp GETOUT

;###############################################################
SixteenBit:

	mov edi,bmpt		;Fill ground
	mov ecx,20*300
	mov dx, 03C00h		;ground color
ground6:
	mov [edi],dx
	add edi,2
	dec ecx
	jnz ground6
;-----------------------------------------------
	mov edi,bmpt	;Start fire
	mov eax,12000	;20*600
	add edi,eax		;Start at row 20
	
	mov ecx,600		;Pre-start 6 lines (depends on edi,esi+3)
	cmp al,128
	jb SROWS6
	shr ecx,1		;or Pre-start 3 lines (depends on edi,esi+3)

SROWS6:
	mov esi,palpt	;Pointer to palette
	
	CALL Random		;Get random number to eax
	
	cmp eax,400
	jb fillA6
	cmp eax,600
	ja fillA6
	mov eax,0		;Put occasional black
	jmp fillB6

fillA6:
	add esi,eax		;Point randomly into Colors()
	mov eax,[esi]	;x B G R
	bswap eax		;R G B x    Need to make Blue low byte
	shr eax,8		;x R G B
	
	CALL Conv16		;eax 24bit -> ax 16bit

fillB6:	

	mov [edi],ax	;Put same color in twice to give larger color blocks
	add edi,2
	mov [edi],ax
	add edi,2
	mov [edi+600],ax
	
	dec ecx
	jnz SROWS6
;-----------------------------------------------
	mov edi,bmpt
	mov eax,179998	;180000-2 ie last 2B pixel
	add edi,eax
	mov esi,edi
	sub esi,600		;Point to line below
	mov ecx,277
	
Flamer6:
	push ecx
	mov ecx,300
DoRow6:
	CALL Random			;Get random number to bl
	mov ebx,irand

	;Average above & below to blurr
	xor eax,eax
	xor edx,edx
	mov ax,[esi+600]	;0RGB
	mov dx,[esi-600]	;0RGB

	cmp bl,250			;vary averaging for 16bit
	jl skipav
	CALL Aver16			;In ax, dx Out ax average of 16bit colors in ax & dx
	jmp oskip
skipav:					;Drift to right
	mov ax,dx
oskip:

	cmp bl,40			;Shift right as bl
	jb right2pix6
	cmp bl,200
	ja right4pix6
	mov [edi+2],ax		;Set pixel
	jmp nextpix6
right4pix6:
	mov [edi+8],ax	;Set pixel
	jmp nextpix6
right2pix6:
	mov [edi+4],ax		;Set pixel
nextpix6:
	
	sub edi,2			;next pixel
	sub esi,2
	dec ecx
	jnz DoRow6
	
	pop ecx
	dec ecx				;decr line count
	jnz near Flamer6
	
;-----------------------------------------------
GETOUT:
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 16

;====================================================
Random: ;Random number 0-255 loB irand
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


