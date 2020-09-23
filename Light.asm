;Light.asm
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

%define ix    [ebp-28]
%define iy    [ebp-32]
%define cul   [ebp-36]
%define rads  [ebp-40]
%define zang  [ebp-44]
%define a42   [ebp-48]
%define a150  [ebp-52]
%define a10   [ebp-56]

%define radc  [ebp-60]
%define tix   [ebp-64]
%define tiy   [ebp-68]

%define cos   [ebp-72]
%define sin   [ebp-76]

%define angsto [ebp-80]

%define xc   [ebp-84]
%define yc   [ebp-88]
[bits 32]

	push ebp
	mov ebp,esp
	sub esp,88
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

	;Pointer to zang
	mov ebx,[ebp+16]
	movab zang,[ebx]
	
;------------------------------------------------------------
	;in al,040h          ;Seed from timer
	mov eax,[ebp+20]
	mov irand,eax
;------------------------------------------------------------
	;Set up constants
	mov eax,10
	mov a10,eax			;10

	mov eax,4300 ;4200
	mov a42,eax			;430
	
	fild dword a42		;|a42
	fild dword a10
	fdivp ST1			;|a42/10
	fstp dword a42		;43
	
	mov eax,150			;Offset
	mov a150,eax
	
	fild dword a10		;|a10
	fild dword a150		;|150	|10
	fdivp ST1			;|a10/a150 .0666
	fsincos				;|cos(zang) |sin(zang)
	fstp dword cos		;.99777
	fstp dword sin		;.00666
	
	mov eax,70			;track radius
	mov radc,eax

;------------------------------------------------------------

	;Increment zang
	fld dword zang
	fld dword sin
	faddp ST1
	fstp dword zang
	
	mov eax,dword zang
	mov ebx,[ebp+16]		;save incremented zang
	mov [ebx],eax
	
	;Find track centre		;xc,yc
	fld dword zang	
	fsincos					;cos	|sin
	fild dword radc			;rads 
	fmulp ST1				;r*cos	|sin
	fild dword a150			;xc
	faddp ST1				;xc+r*cos(angle)	|sin
	fstp dword xc

	fild dword radc			;rads	|sin
	fmulp ST1				;r*sin
	fild dword a150			;yc
	faddp ST1				;yc+r*sin(angle)
	fstp dword yc

;------------------------------------------------------------

	;Check if 16 or 24 bit color
	mov eax,bmWB
	cmp eax,600
	je near SixteenBit

;------------------------------------------------------------
;24 bit
	;Blackout
	xor eax,eax
	mov ecx,67500		;900*300/4
	mov edi,bmpt
	rep stosd
	
	
	;Draw circle
	mov eax,0FFFFFFh	;white
	mov cul,eax
	mov ecx,radc
nextrad:	

	mov eax,ecx
	mov ebx,12
	mul ebx
	cmp eax,1020
	jg endcul
	mov ebx,palpt
	add ebx,eax
	mov eax,[ebx]
	mov cul,eax
endcul:
	
	mov rads,ecx	
	CALL Circler
	dec ecx
	jnz nextrad 
	;mov eax,1
	;sub ecx,eax
	;cmp ecx,2
	;ja nextrad
	
	jmp GETOUT
;##################################################################
SixteenBit:

	;Blackout
	xor eax,eax
	mov ecx,45000		;600*300/4
	mov edi,bmpt
	rep stosd
	
	mov ecx,radc
nextrad6:

	mov eax,ecx
	mov ebx,12
	mul ebx
	cmp eax,1020
	jg endcul6

	mov ebx,palpt
	add ebx,eax
	mov eax,[ebx]
	mov cul,eax
endcul6:

	mov rads,ecx	
	CALL Circler
	dec ecx
jnz nextrad6
	
	jmp GETOUT

GETOUT:
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp


	;mov   dx,03DAh    ;Status register
	
	;WaitForOFF:      
	;in    al,dx     
	;test  al,8	  ;Is scan OFF
	;jnz   WaitForOFF  ;No, keep waiting
	
	;WaitForON:
	;in    al,dx     
	;test  al,8	  ;Is scan ON
	;jz    WaitForON	  ;No, keep waiting

	ret 16
;====================================================
Circler:
	push ecx

	mov ecx,628
NextCircAng:
	mov angsto,ecx
	fild dword angsto	;|ang
	fsincos				;|cos(ang) |sin(ang)
	
	fild dword rads		;|rads		|cos(ang) |sin(ang)
	fmulp ST1		    ;|rads*Cos(ang)|sin(ang) 
	fld dword xc		;|xc		|rads*Cos(ang)|sin(ang)
	faddp ST1			;|ix		|sin(ang)
	fistp dword ix		;|sin(ang)
	
	fild dword rads
	fmulp ST1		    ;|rads*Sin(ang)
	fld dword yc		;|yc
	faddp ST1
	fistp dword iy

	;Check if 16 or 24 bit color
	mov eax,bmWB
	cmp eax,600
	je circ16

	CALL XYCul24
	jmp necx

circ16:	
	CALL XYCul16
necx:
	dec ecx
	jnz NextCircAng

	pop ecx
ret	
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
XYCul24:	;Plot point In ix,iy,cul
	push edx

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
	
	pop edx
ret
;====================================================
XYCul16:	;Plot point In ix,iy,cul
	push edx
	
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

	pop edx
ret
;====================================================
Get24EDI:
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
ret
Get16EDI:
	mov edi,bmpt	;->pic1
	mov eax,tix
	mov ebx,2
	mul ebx			;2*ix
	add edi,eax		;edi + 3*ix
	mov eax,bmW
	mul ebx
	mov ebx,tiy		 
	mul ebx			;3*bmW*iy
	add edi,eax		;edi->(ix,iy)
ret
ENDS


