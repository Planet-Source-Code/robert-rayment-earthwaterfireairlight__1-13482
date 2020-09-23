;Earth.asm
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

;pic1 BITMAP STRUCTURE
%define bmW   [ebp-4]	;eg 300
%define bmH   [ebp-8]	;eg 300
%define bmWB  [ebp-12]	;eg 600 or 900 (16 or 24 bit color)
%define bmpt  [ebp-16]	;pointer to pic1 memory

;POINTER TO COLORS(255) PALETTE
%define palpt [ebp-20]	;pointer to Colors(0) palette

;PIXEL POINT & COLOR
%define ix    [ebp-24]
%define iy    [ebp-28]
%define cul   [ebp-32]

;RANDOM NUMBER
%define irand [ebp-36]	
%define a10   [ebp-40]
%define E1    [ebp-44]
%define E2    [ebp-48]
%define E3    [ebp-52]
%define E4    [ebp-56]
%define E5    [ebp-60]
%define E6    [ebp-64]
%define E7    [ebp-68]
%define iy1   [ebp-72]
%define iy2   [ebp-76]
%define irand1 [ebp-80]	
%define irand2 [ebp-84]	


[bits 32]

	push ebp
	mov ebp,esp
	sub esp,84
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
	
	;Earth levels
	mov ebx,[ebp+16]		;Initial values
	movab E1,[ebx]
	movab E2,[ebx+4]
	movab E3,[ebx+8]
	movab E4,[ebx+12]
	movab E5,[ebx+16]
	movab E6,[ebx+20]
	movab E7,[ebx+24]

	mov eax,10
	mov a10,eax
	
	;---------------------------------------
	;in al,040h				;Seed from timer
	mov eax,[ebp+20]
	mov irand1,eax
	ror eax,1
	;in al,040h				;Seed from timer
	mov irand2,eax
	;---------------------------------------

;------------------------------------------------------------
	;Check if 16 or 24 bit color
	mov eax,bmWB
	cmp eax,600
	je near SixteenBit

;############################################################

;24 bit


mov ix,dword 0
mov ebx,0
CALL GetCul
mov ecx,299
mov iy1,ecx
mov ecx,E1
mov iy2,ecx
mov ebx,0				;Indicates top level
CALL Randomize1			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx],ecx			;Save new E1

mov ecx,iy1
Range1:
	mov ebx,0			;Palette segment 1
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	cmp ecx,dword iy2
	ja Range1
;---------------------------
Level2:
mov ecx,iy2
mov iy1,ecx
mov ecx,E2
mov iy2,ecx
mov ebx,25				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+4],ecx			;Save new E2

mov ecx,iy1
Range2:
	mov ebx,32			;Palette segment 2
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	cmp ecx,dword iy2
	ja Range2
;---------------------------
Level3:
mov ecx,iy2
mov iy1,ecx
mov ecx,E3
mov iy2,ecx
mov ebx,30				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+8],ecx			;Save new E3

mov ecx,iy1
Range3:
	mov ebx,64			;Palette segment 3
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	cmp ecx,dword iy2
	ja Range3
;---------------------------
Level4:
mov ecx,iy2
mov iy1,ecx
mov ecx,E4
mov iy2,ecx
mov ebx,35				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+12],ecx		;Save new E4

mov ecx,iy1
Range4:
	mov ebx,96			;Palette segment 4
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	cmp ecx,dword iy2
	ja Range4
;---------------------------
Level5:
mov ecx,iy2
mov iy1,ecx
mov ecx,E5
mov iy2,ecx
mov ebx,40				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+16],ecx		;Save new E5

mov ecx,iy1
Range5:
	mov ebx,128			;Palette segment 5
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	cmp ecx,dword iy2
	ja Range5
;---------------------------
Level6:
mov ecx,iy2
mov iy1,ecx
mov ecx,E6
mov iy2,ecx
mov ebx,80				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+20],ecx		;Save new E6

mov ecx,iy1
Range6:
	mov ebx,160			;Palette segment 6
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	cmp ecx,dword iy2
	ja Range6
;---------------------------
Level7:
mov ecx,iy2
mov iy1,ecx
mov ecx,E7
mov iy2,ecx
mov ebx,100				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+24],ecx		;Save new E7

mov ecx,iy1
Range7:
	mov ebx,192			;Palette segment 7
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	cmp ecx,dword iy2
	ja Range7
;---------------------------

LevelBase:
mov ecx,iy2
mov iy1,ecx
cmp iy1,dword 1
jb Scroll
RangeBase:
	mov ebx,224			;Palette segment 8
	CALL GetCul
	mov iy,ecx
	CALL XYCul24
	dec ecx
	jnz RangeBase

Scroll:

mov esi,bmpt
mov eax,900
add esi,eax
mov ecx,298
AvLines:
	CALL Average24
	dec ecx
	jnz AvLines


CALL ScrollRight

jmp GETOUT

;##################################################################

SixteenBit:
mov ix,dword 0
mov ecx,299
mov iy1,ecx
mov ecx,dword E1
mov iy2,ecx
mov ebx,0				;Indicates top level
CALL Randomize1			;IN iy1 - iy2 OUT ~iy2~
mov ecx,dword iy2
mov ebx,[ebp+16]
mov [ebx],ecx			;Save new E1

mov ecx,dword iy1
Range16:
	mov ebx,0			;Palette segment 1
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	cmp ecx,dword iy2
	ja Range16
;---------------------------
Level26:
mov ecx,iy2
mov iy1,ecx
mov ecx,dword E2
mov iy2,ecx
mov ebx,25				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~
mov ecx,dword iy2
mov ebx,[ebp+16]
mov [ebx+4],ecx			;Save new E2

mov ecx,iy1
Range26:
	mov ebx,32			;Palette segment 2
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	cmp ecx,dword iy2
	ja Range26
;---------------------------
Level36:
mov ecx,iy2
mov iy1,ecx
mov ecx,E3
mov iy2,ecx
mov ebx,30				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+8],ecx			;Save new E3

mov ecx,iy1
Range36:
	mov ebx,64			;Palette segment 3
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	cmp ecx,dword iy2
	ja Range36
;---------------------------
Level46:
mov ecx,iy2
mov iy1,ecx
mov ecx,E4
mov iy2,ecx
mov ebx,35				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+12],ecx		;Save new E4

mov ecx,iy1
Range46:
	mov ebx,96			;Palette segment 4
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	cmp ecx,dword iy2
	ja Range46
;---------------------------
Level56:
mov ecx,iy2
mov iy1,ecx
mov ecx,E5
mov iy2,ecx
mov ebx,40				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+16],ecx		;Save new E5

mov ecx,iy1
Range56:
	mov ebx,128			;Palette segment 5
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	cmp ecx,dword iy2
	ja Range56
;---------------------------
Level66:
mov ecx,iy2
mov iy1,ecx
mov ecx,E6
mov iy2,ecx
mov ebx,50				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+20],ecx		;Save new E6

mov ecx,iy1
Range66:
	mov ebx,160			;Palette segment 6
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	cmp ecx,dword iy2
	ja Range66
;---------------------------
Level76:
mov ecx,iy2
mov iy1,ecx
mov ecx,E7
mov iy2,ecx
mov ebx,100				;Max spacing iy1-iy2
CALL Randomize2			;IN iy1 - iy2 OUT ~iy2~

mov ecx,iy2
mov ebx,[ebp+16]
mov [ebx+24],ecx		;Save new E7

mov ecx,iy1
Range76:
	mov ebx,192			;Palette segment 7
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	cmp ecx,dword iy2
	ja Range76
;---------------------------

LevelBase6:
mov ecx,iy2
mov iy1,ecx
cmp iy1,dword 1
jl Scroll6
RangeBase6:
	mov ebx,224			;Palette segment 8
	CALL GetCul
	mov iy,ecx
	CALL XYCul16
	dec ecx
	jnz RangeBase6


Scroll6:

mov esi,bmpt
mov eax,600
add esi,eax
mov ecx,298
AvLines6:
	CALL Average16
	dec ecx
	jnz AvLines6

CALL ScrollRight6

jmp GETOUT

;---------------------------------------
GETOUT:
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 16

;##################################################################
Randomize1:
CALL Random1	;Out eax
jmp Rander
;ret
Randomize2:
CALL Random2	;Out eax
jmp Rander
;ret
;====================================================
Rander:
	;IN iy1 - iy2, ebx=0 top
	;OUT ~iy2~
	mov ecx,iy2
	and eax,0Fh	;07h
	cmp eax,dword 8	;4
	jb adder
		sub ecx,dword 2
		jmp CheckHi
adder:
		add ecx,dword 2
CheckHi:
	cmp ecx,iy1
	jbe CheckDiff
		mov ecx,iy1
		jmp Filliy2

CheckDiff:
	cmp ebx,0
	je CheckLo
		mov eax,iy1
		sub eax,ecx		;iy1-iy2
		cmp eax,ebx
		jbe CheckLo
			mov ecx,iy1
			sub ecx,ebx
CheckLo:	
	cmp ecx,dword 1
	ja Filliy2
		mov ecx,dword 1
Filliy2:
	mov iy2,ecx
ret
;====================================================
Random1:
	mov eax,irand1
	mov edx,08405h
	mul edx
	inc eax
	mov irand1,eax
ret
;====================================================
Random2:
	mov eax,irand2
	mov edx,08405h
	mul edx
	inc eax
	mov irand2,eax
ret
;====================================================
GetCul:
CALL Random2	;ebx 1		ebx 2		ebx 3		..ebx 7
and eax,01Fh	;0 -  31	
add eax,ebx		;0 -  31	 32 -  63	 64 -  95	..224 -  255
shl eax,2		;0 - 124	128 - 252	256 - 380	..896 - 1020
mov ebx,palpt
add ebx,eax
mov eax,[ebx]
mov cul,eax
ret
;====================================================

ScrollRight:

	mov edi,bmpt
	mov eax,899
	add edi,eax
	mov esi,edi
	sub esi,3
	
	mov ecx,bmH		;num of lines
	dec ecx
	std			;decr edi, esi
byteshiftR:
	push ecx
	push edi
	push esi
	
	mov ecx,897
	rep movsb		;[esi]->[edi] esi-1,edi-1,ecx-1
	
	pop esi
	pop edi
	mov eax,900
	add esi,eax
	add edi,eax
	
	pop ecx
	dec ecx
	jnz byteshiftR

	cld
ret
;====================================================
ScrollRight6:
	
	mov edi,bmpt
	mov eax,599
	add edi,eax
	mov esi,edi
	sub esi,2
	
	mov ecx,bmH		;num of lines
	dec ecx
	std			;decr edi, esi
byteshiftR6:
	push ecx
	push edi
	push esi
	
	mov ecx,598
	rep movsb		;[esi]->[edi] esi-1,edi-1,ecx-1
	
	pop esi
	pop edi
	mov eax,600
	add esi,eax
	add edi,eax
	
	pop ecx
	dec ecx
	jnz byteshiftR6

	cld

ret
;====================================================
XYCul24:
	push edx
	push ebx
	
	;Get 24bit address from ix,iy
	
	mov edi,bmpt	;->pic1
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
	
	pop ebx
	pop edx
ret
;====================================================
XYCul16:
	push edx
	push ebx
	
	;Get 16bit address from ix,iy
	mov edi,bmpt	;->pic1
	mov eax,ix
	mov ebx,2
	mul ebx			;2*ix
	add edi,eax		;edi + 2*ix
	mov eax,bmW
	mul ebx
	mov ebx,iy		 
	mul ebx			;2*bmW*iy
	add edi,eax		;edi->(ix,iy)
	
		;In eax 24bit from palette  Out ax 16bit
	
		mov edx,cul		;- B G R   -- xx dh dl, Red low in Colors() palette
		mov ax,0	
					;    16-bit memcolor
					;    R       G       B
					;0(11111)(11 | 111)(11111)
		mov bx,0
		mov bh,dl		;RED 0-255
		shr bh,3		;RED\8 
		shl bx,2		;01111100 00000000
		or ax,bx
		
		mov bx,0
		mov bh,dh		;GREEN 0-255
		shr bh,3		;GREEN\8
		shr bx,3		;00000011 11100000
		or ax,bx	
	
		mov bx,0
		bswap edx		;R G B -   -- xx dh dl
		mov bl,dh		;BLUE 0-255
		shr bl,3		;BLUE\8   00000000 00011111
		or ax,bx		;   R        G       B
					;0(11111)(11 | 111)(11111)
		mov [edi],ax	;RGB 16-bit

	pop ebx
	pop edx
ret
;====================================================
Average24: ;In: esi lines 1 to 298  Out:Color in eax
	;Average above & below to blurr
	;Uses eax & edx
	mov eax,[esi+900]	;x R G B
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
ret
;====================================================
Average16:	;In esi Out ax average of 16bit colors in ax & dx
	;Average above & below to blurr
	;Uses eax,ebx,edx
	push ebx
	mov ax,[esi+600]	;0RGB
	mov dx,[esi-600]	;0RGB
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

ENDS


