;AirCycle.asm
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

[bits 32]

	push ebp
	mov ebp,esp
	sub esp,20
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
	;Check if 16 or 24 bit color
	mov eax,bmWB
	cmp eax,600
	je near SixteenBit

;############################################################
;24 bit

	CALL ROTCULS

	jmp GETOUT

;##################################################################
SixteenBit:

	CALL ROTCULS6
;---------------------------------------
GETOUT:
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 16

;***************************************************************
;---------------------------------------
ROTCULS:
	mov esi,bmpt	
	mov ecx,298
culy:
	push ecx
	mov ecx,298
Cul24:
	mov edx,[esi]		;- R G B  -- xx dh dl	
	and edx,0FFFFFFh	;leave 3 byte number rgb
	cmp edx,0
	jne NextColor
	add esi,3			;skip black
	jmp ncx
NextColor:
	cmp dl,255
	jb IncrColor
	mov edx,0010101h	;Black+1
	jmp PutBGR
IncrColor:
	add edx,0010101h	;R+1, G+1, B+1
PutBGR:
	mov [esi],dl		;B
	inc esi
	mov [esi],dh		;G
	inc esi
	bswap edx			;B G R -  -- xx dh dl 
	mov [esi],dh		;R+1
	inc esi
ncx:
	dec ecx
	jnz Cul24

	pop ecx
	dec ecx
	jnz culy
ret	
;---------------------------------------

ROTCULS6:
	mov esi,bmpt	
	mov ecx,298
culy6:
	push ecx

	mov ecx,298

Nxt16Cul:
	mov dx,[esi]	;0(11111)(11 | 111)(11111)	
	cmp dx,0	;Black?
	jne ExtrRed16
	jmp n16cx	;Skip black
ExtrRed16:
	mov al,dh
	shr al,2	;00011111 Red
	cmp al,31
	jb Inc16Cul
	;mov bx,0|0000 0100|0010 0001b	;Black+1
	mov bx,00421h
	jmp Put16BGR
Inc16Cul:
	mov bx,dx
	;add bx,0|0000 0100|0010 0001b  ;RGB+1
	add bx,00421h
Put16BGR:
	mov[esi],bx
n16cx:
	inc esi
	inc esi
	dec ecx
	jnz Nxt16Cul
	
	pop ecx
	dec ecx
	jnz culy6

ret
;====================================================

ENDS


