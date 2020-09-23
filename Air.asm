;Air.asm
;VB
;Private Type BITMAP
;   bmType As Long          ' Type of bitmap, 0
;   bmWidth As Long         ' Pixel width
;   bmHeight As Long        ' Pixel height
;   bmWidthBytes As Long    ' Byte width = 2 or 3 x Pixel width
;   bmPlanes As Integer     ' Color depth of bitmap, 1
;   bmBitsPixel As Integer  ' Bits per pixel, must be 16 or 24
;   bmBits As Long          ' Pointer to bitmap data
;End Type
;Dim bmp As BITMAP

%macro movab 2		;name & num of parameters
  push dword %2		;2nd param
  pop dword %1		;1st param
%endmacro			;use  movab %1,%2
;Allows eg	movab bmW,[ebx+4]

%define bmW   [ebp-4]	;eg 300
%define bmH   [ebp-8]	;eg 300
%define bmWB  [ebp-12]	;eg 600 or 900 (16 or 24 bit color)
%define bmpt  [ebp-16]	;pointer to bitmap data
%define palpt [ebp-20]	;pointer to Colors(0) palette
%define irand [ebp-24]	;random number 0-255

%define ix    [ebp-28]
%define iy    [ebp-32]
%define cul   [ebp-36]
%define rads  [ebp-40]
%define a150  [ebp-44]
%define a10   [ebp-48]

%define rot   [ebp-52]
%define tix   [ebp-56]	;temp ix
%define tiy   [ebp-60]	;temp iy

%define err   [ebp-64]	;digital ellipse err parameter

[bits 32]

	push ebp
	mov ebp,esp
	sub esp,64
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
	mov irand,eax
;------------------------------------------------------------
	mov eax,10
	mov a10,eax			;10

	mov eax,150			;Offset
	mov a150,eax
	
	mov ebx,[ebp+16]
	movab err,[ebx]
;------------------------------------------------------------
	;Starting ellipse point rad
	fild dword a10
	fld1
	fld1
	faddp ST1
	fld1
	faddp ST1
	fstp dword rads		;rads=3
;------------------------------------------------------------
	;Check if 16 or 24 bit color
	mov eax,bmWB
	cmp eax,600
	je near SixteenBit

;############################################################
;24 bit

StartEll:
	mov edx,dword 0		;Start offset into palette
	mov ecx,129;110		;Number of ellipses


nextellrad:
	CALL Random
	mov edx,eax			;Start offset into palette

	fld dword rads		;Starting ellipse point
	fstp dword tix
	fld dword rads
	fstp dword tiy
	
	push ecx
	mov ecx,1700		;large enough to complete ellipse

NextPt:
	fld dword tiy
	fld dword tix
	fld dword tiy
	fld dword err
	fmulp ST1			;|E.y(n)	|x(n)	|y(n)
	faddp ST1			;|x(n+1)=x(n)+E.y(n)
	fst dword tix
	fld dword err
	fmulp ST1			;|E.x(n+1)	|y(n)
	fsubp ST1			;|y(n)-E.x(n+1)
	fstp dword tiy
	
	fld dword tix
	fild dword a150
	faddp ST1
	fistp dword ix

	fld dword tiy
	fild dword a150
	faddp ST1
	fistp dword iy
	
	mov eax,298			;Check out of bounds
	cmp ix,eax
	ja near oob
	cmp iy,eax
	ja near oob
	mov eax,1
	cmp ix,eax
	jb near oob
	cmp iy,eax
	jb near oob

		;Increment color along path
		add edx,dword 4
		cmp edx,1020
		jle validoff
		mov edx,dword 0
validoff:
		mov esi,palpt	;Pointer to palette
		add esi,edx		;Point randomly into Colors()
		mov eax,[esi]	;x B G R
		bswap eax		;R G B x    Need to make Blue low byte
		shr eax,8		;x R G B
		mov cul,eax

	CALL XYCul24
oob:
	dec ecx
	jnz near NextPt

	fld dword rads		;Increment ellipse start rad
	fld1
	fld1
	faddp ST1
	faddp ST1
	fstp dword rads
	
	mov edx,dword 0

	pop ecx
	dec ecx
	jnz near nextellrad
	
;--------------------------------------------------------------
	jmp GETOUT

;##################################################################
SixteenBit:

StartEll6:	
	mov edx,dword 0		;Start offset into palette
	mov ecx,129;110		;Number of ellipses

nextellrad6:
	CALL Random
	mov edx,eax			;Start offset into palette

	fld dword rads		;Starting ellipse point
	fstp dword tix
	fld dword rads
	fstp dword tiy
	
	push ecx
	mov ecx,1700		;large enough to complete ellipse

NextPt6:
	fld dword tiy
	fld dword tix
	fld dword tiy
	fld dword err
	fmulp ST1			;|Ey(n)	|x(n)	|y(n)
	faddp ST1			;|x(n+1)=x(n)+Ey(n)
	fst dword tix
	fld dword err
	fmulp ST1			;|Ex(n+1)	|y(n)
	fsubp ST1			;|y(n)-Ex(n+1)
	fstp dword tiy
	
	fld dword tix
	fild dword a150
	faddp ST1
	fistp dword ix

	fld dword tiy
	fild dword a150
	faddp ST1
	fistp dword iy

	mov eax,298			;Check out of bounds
	cmp ix,eax
	ja near oob6
	cmp iy,eax
	ja near oob6
	mov eax,1
	cmp ix,eax
	jb near oob6
	cmp iy,eax
	jb near oob6

		;Increment color along path
		add edx,dword 4
		cmp edx,1020
		jle validoff6
		mov edx,dword 0
validoff6:
		mov esi,palpt	;Pointer to palette
		add esi,edx		;Point randomly into Colors()
		mov eax,[esi]	;x B G R
		bswap eax		;R G B x    Need to make Blue low byte
		shr eax,8		;x R G B
		mov cul,eax

	CALL XYCul16

oob6:
	dec ecx
	jnz near NextPt6

	fld dword rads		;Increment ellipse start rad
	fld1
	fld1
	faddp ST1
	faddp ST1
	fstp dword rads

	pop ecx
	dec ecx
	jnz near nextellrad6
	
;--------------------------------------
	jmp GETOUT
;--------------------------------------
GETOUT:
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 16

;***************************************************************
;====================================================
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
XYCul24:
	push edx
	
	mov edi,bmpt	;->bitmap array
	mov eax,ix
	mov ebx,3
	mul ebx			;3*ix
	add edi,eax		;edi + 3*ix
	mov eax,bmW
	mul ebx
	mov ebx,iy		 
	mul ebx			;3*bmW*iy
	add edi,eax		;edi->(ix,iy)

	mov edx,cul		;- B G R   -- xx dh dl, Red low in Colors() palette
	
	bswap edx		;R G B -   -- xx dh dl
	mov [edi],dh	;B
	inc edi
	bswap edx		;- B G R   -- xx dh dl
	mov [edi],dh	;G
	inc edi
	mov [edi],dl	;R
	
	pop edx
ret
;====================================================
XYCul16:
	push edx
	
	mov edi,bmpt	;->bitmap array
	mov eax,ix
	mov ebx,2
	mul ebx			;2*ix
	add edi,eax		;edi + 2*ix
	mov eax,bmW
	mul ebx
	mov ebx,iy		 
	mul ebx			;2*bmW*iy
	add edi,eax		;edi->(ix,iy)


	mov eax,cul		;- B G R   -- xx dh dl, Red low in Colors() palette
		;Convert pal to 16bit color
		;              R       G       B
		;00000000|11111111|11111111|11111111	
		;                     ah       al
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

	mov [edi],ax	;BGR 16-bit

	pop edx
ret
;====================================================

ENDS


