VERSION 5.00
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00808080&
   ClientHeight    =   5595
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6885
   FillColor       =   &H00808080&
   FillStyle       =   0  'Solid
   Icon            =   "Elements.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   373
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   459
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00808080&
      BorderStyle     =   0  'None
      Height          =   315
      Left            =   180
      ScaleHeight     =   315
      ScaleWidth      =   1470
      TabIndex        =   12
      Top             =   4980
      Width           =   1470
   End
   Begin VB.CommandButton cmdFREEZE 
      Appearance      =   0  'Flat
      BackColor       =   &H00808080&
      Caption         =   "Freeze"
      Height          =   375
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   10
      Top             =   3840
      Width           =   855
   End
   Begin VB.CommandButton cmdCLEAR 
      Appearance      =   0  'Flat
      BackColor       =   &H00808080&
      Height          =   375
      Left            =   5760
      Picture         =   "Elements.frx":0E42
      Style           =   1  'Graphical
      TabIndex        =   9
      Top             =   3360
      Width           =   855
   End
   Begin VB.PictureBox picPAL 
      AutoRedraw      =   -1  'True
      Height          =   4200
      Left            =   195
      ScaleHeight     =   276
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   20
      TabIndex        =   8
      Top             =   405
      Width           =   360
   End
   Begin VB.CommandButton cmdEXIT 
      Appearance      =   0  'Flat
      BackColor       =   &H00808080&
      Caption         =   "EXIT"
      Height          =   375
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   6
      Top             =   4500
      Width           =   855
   End
   Begin VB.CommandButton cmdLIGHT 
      BackColor       =   &H00FFFFFF&
      Caption         =   "LIGHT"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   5
      Top             =   300
      Width           =   855
   End
   Begin VB.CommandButton cmdAIR 
      BackColor       =   &H00FFFF80&
      Caption         =   "AIR"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   900
      Width           =   855
   End
   Begin VB.CommandButton cmdFIRE 
      BackColor       =   &H008080FF&
      Caption         =   "FIRE"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   1500
      Width           =   855
   End
   Begin VB.CommandButton cmdWATER 
      BackColor       =   &H00FF8080&
      Caption         =   "WATER"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   2100
      Width           =   855
   End
   Begin VB.CommandButton cmdEARTH 
      BackColor       =   &H00008000&
      Caption         =   "EARTH"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5760
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   2700
      Width           =   855
   End
   Begin VB.PictureBox pic1 
      BackColor       =   &H00000000&
      Height          =   4560
      Left            =   750
      ScaleHeight     =   4500
      ScaleWidth      =   4500
      TabIndex        =   0
      Top             =   300
      Width           =   4560
   End
   Begin VB.Label Lab2416 
      BackColor       =   &H00808080&
      Height          =   375
      Left            =   5760
      TabIndex        =   11
      Top             =   4980
      Width           =   855
   End
   Begin VB.Label LabNASM 
      BackColor       =   &H00808080&
      Caption         =   "VB && NASM"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   15.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFC0FF&
      Height          =   435
      Left            =   2340
      TabIndex        =   7
      Top             =   4920
      Width           =   1815
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Elements.frm

' ALL asm 'in' instructions replaced

'E L E M E N T A L  by Robert Rayment

'  This uses the NASM freeware assembler.
'  For references see:
'  "Creating & testing DLLs with NASM" &
'  "Machine code Fractals PLUS"

'The mnemonic asm files are in the folder AsmBat &
'the bat files show how to invoke NASM to produce
'the bin files containing the raw code.

Option Base 1
DefInt A-T
DefSng U-Z

'For calling machine code
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" _
(ByVal lpMCode As Long, _
ByVal Long1 As Long, ByVal Long2 As Long, _
ByVal Long3 As Long, ByVal Long4 As Long) As Long

'To fill BITMAP structure
Private Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" _
(ByVal hObject As Long, ByVal Lenbmp As Long, dimbmp As Any) As Long

Private Type BITMAP
   bmType As Long          ' Type of bitmap
   bmWidth As Long         ' Pixel width
   bmHeight As Long        ' Pixel height
   bmWidthBytes As Long    ' Byte width = 2 or 3 x Pixel width
   bmPlanes As Integer     ' Color depth of bitmap
   bmBitsPixel As Integer  ' Bits per pixel, must be 16 or 24
   bmBits As Long          ' Pointer to bitmap data
End Type
Dim bmp As BITMAP

Dim PathSpec$
Dim BackPic$         'App.Path & "Black300.jpg"
Dim Colors() As Long 'To hold palettes
Dim InCode() As Byte 'To hold mcode
Dim Done As Boolean

Dim xx As Single
Dim zang As Single
Dim zr() As Single
Dim Earth() As Long

Private Sub cmdAIR_Click()
Done = True

'Load black300.jpg to pic1
'pic1.Picture = LoadPicture(BackPic$)
'GetObjectAPI pic1.Picture, Len(bmp), bmp

PalSpec$ = PathSpec$ & "Air.PAL"
ReadPAL PalSpec$
If PalSpec$ = "" Then MsgBox ("No Air.PAL"): Exit Sub

InFile$ = "Air.bin"
Loadmcode (InFile$)
ptmc& = VarPtr(InCode(1))
ptbuff& = VarPtr(bmp.bmType)
ptPal& = VarPtr(Colors(0))
'xx = -0.0039063  'circle
xx = 0.71   'Ellipses err
ptxx& = VarPtr(xx)
zcount = 0
Done = False
   
   res& = CallWindowProc(ptmc&, ptbuff&, ptPal&, ptxx&, 4&)
   pic1.Refresh

InFile$ = "AirCycle.bin"
Loadmcode (InFile$)
ptmc& = VarPtr(InCode(1))
ptbuff& = VarPtr(bmp.bmType)
ptPal& = VarPtr(Colors(0))
zcount = 0
Done = False
Do
   res& = CallWindowProc(ptmc&, ptbuff&, ptPal&, 3&, 4&)
   pic1.Refresh
   zcount = zcount + 1
   Picture1.Cls
   Picture1.Print zcount;
   DoEvents
Loop While Done = False

End Sub

Private Sub cmdCLEAR_Click()
Done = True
'Load black300.jpg to pic1
pic1.Picture = LoadPicture(BackPic$)
GetObjectAPI pic1.Picture, Len(bmp), bmp

End Sub

Private Sub cmdEARTH_Click()
Done = True

PalSpec$ = PathSpec$ & "Earth.PAL"
ReadPAL PalSpec$
If PalSpec$ = "" Then MsgBox ("No Earth.PAL"): Exit Sub

InFile$ = "Earth.bin"
Loadmcode (InFile$)
ptmc& = VarPtr(InCode(1))
ptbuff& = VarPtr(bmp.bmType)
ptPal& = VarPtr(Colors(0))
ReDim Earth(7)
Earth(1) = 250
Earth(2) = 240
Earth(3) = 220
Earth(4) = 200
Earth(5) = 160
Earth(6) = 100
Earth(7) = 80
ptEarth& = VarPtr(Earth(1))
zcount = 0
Done = False
irand& = 255 * Rnd
Do
   irand& = 255 * Rnd
   res& = CallWindowProc(ptmc&, ptbuff&, ptPal&, ptEarth&, irand&)
   pic1.Refresh
   DoEvents
   zcount = zcount + 1
   Picture1.Cls
   Picture1.Print zcount;
Loop While Done = False

End Sub

Private Sub cmdFIRE_Click()
Done = True
PalSpec$ = PathSpec$ & "Fire.PAL"
ReadPAL PalSpec$
If PalSpec$ = "" Then MsgBox ("No Fire.PAL"): Exit Sub

InFile$ = "Fire.bin"
Loadmcode (InFile$)
ptmc& = VarPtr(InCode(1))
ptbuff& = VarPtr(bmp.bmType)
ptPal& = VarPtr(Colors(0))
zcount = 0
Done = False
Do
   irand& = 255 * Rnd
   res& = CallWindowProc(ptmc&, ptbuff&, ptPal&, 3&, irand&)
   pic1.Refresh
   zcount = zcount + 1
   Picture1.Cls
   Picture1.Print zcount;
   DoEvents
Loop While Done = False

End Sub

Private Sub cmdFREEZE_Click()
Done = True
End Sub

Private Sub cmdLIGHT_Click()
Done = True

PalSpec$ = PathSpec$ & "Light.PAL"
ReadPAL PalSpec$
If PalSpec$ = "" Then MsgBox ("No Light.PAL"): Exit Sub

InFile$ = "Light.bin"
Loadmcode (InFile$)
ptmc& = VarPtr(InCode(1))
ptbuff& = VarPtr(bmp.bmType)
ptPal& = VarPtr(Colors(0))
zang = 0#
ptzang& = VarPtr(zang)
zcount = 0#
Done = False
Do
   irand& = 255 * Rnd
   res& = CallWindowProc(ptmc&, ptbuff&, ptPal&, ptzang&, irand&)
   pic1.Refresh
   zcount = zcount + 1
   Picture1.Cls
   Picture1.Print zcount;
   DoEvents
Loop While Done = False

End Sub

Private Sub cmdWATER_Click()
Done = True

PalSpec$ = PathSpec$ & "Water.PAL"
ReadPAL PalSpec$
If PalSpec$ = "" Then MsgBox ("No Water.PAL"): Exit Sub

InFile$ = "Water.bin"
Loadmcode (InFile$)
ptmc& = VarPtr(InCode(1))
ptbuff& = VarPtr(bmp.bmType)
ptPal& = VarPtr(Colors(0))
zcount = 0
Done = False
Do
   irand& = 255 * Rnd
   res& = CallWindowProc(ptmc&, ptbuff&, ptPal&, 3&, irand&)
   pic1.Refresh
   zcount = zcount + 1
   Picture1.Cls
   Picture1.Print zcount;
   DoEvents
Loop While Done = False

End Sub

Private Sub Form_Load()
'Palette holder
ReDim Colors(0 To 255)
'Get path
PathSpec$ = App.Path
If Right$(PathSpec$, 1) <> "\" Then PathSpec$ = PathSpec$ & "\"

'Load black300.jpg to pic1
BackPic$ = PathSpec$ & "Black300.jpg"
On Error GoTo noblack
pic1.Picture = LoadPicture(BackPic$)
'Fill bmp structure
GetObjectAPI pic1.Picture, Len(bmp), bmp

If bmp.bmBitsPixel = 24 Then
   Lab2416.Caption = "24 bit color"
ElseIf bmp.bmBitsPixel = 16 Then
   Lab2416.Caption = "16 bit color"
Else
   MsgBox ("Sorry,  not 24 or 16 bit color")
   End
End If

Exit Sub
'============
noblack:
MsgBox ("NO  black300.jpg ")
End
End Sub

Private Sub Loadmcode(InFile$)
Open InFile$ For Binary As #1
MCSize& = LOF(1)
If MCSize& = 0 Then
   MsgBox (InFile$ & " missing")
   End
End If
ReDim InCode(MCSize&)
Get #1, , InCode
Close #1
End Sub

Private Sub Form_Resize()
ScaleMode = vbPixels
WindowState = vbNormal
Width = 7000
Height = 5800
Left = 1000
Top = 1000
Caption = "E L E M E N T S  by  Robert Rayment"
With pic1
   .ScaleMode = vbPixels
   .Left = 50
   .Top = 20
   .Height = 304
   .Width = 304
   .BackColor = 0
End With
picPAL.Height = 256
End Sub
Private Sub cmdEXIT_Click()
Form_Unload 1
End Sub
Private Sub Form_Unload(Cancel As Integer)
Done = True
Unload Me
End
End Sub

Private Sub ReadPAL(PalSpec$)
Dim red As Byte, grn As Byte, blu As Byte
On Error GoTo filenotfound
Open PalSpec$ For Input As #1
Line Input #1, A$
p = InStr(1, A$, "JASC")
If p = 0 Then PalSpec$ = "": Exit Sub
   
   'JASC-PAL
   '0100
   '256
   Line Input #1, A$
   Line Input #1, A$

   For n = 0 To 255
      If EOF(1) Then Exit For
      Line Input #1, A$
      ParsePAL A$, red, grn, blu
      Colors(n) = RGB(red, grn, blu)
      'Colors(n) = RGB(blu, grn, red)
   Next n
   Close #1
'   PalName$ = LCase$(ExtractFileName$(PalSpec$))
'   Form1.Label4.Caption = PalName$

For i = 0 To 255
   Form1.picPAL.Line (0, i)-(Form1.pic1.ScaleWidth, i), Colors(i)
Next i
Exit Sub
'===========
filenotfound:
PalSpec$ = ""
Exit Sub
End Sub

Private Sub ParsePAL(ain$, red As Byte, grn As Byte, blu As Byte)
'Input string ain$, with 3 numbers(R G B) with
'space separators and then any text
ain$ = LTrim(ain$)
lena = Len(ain$)
r$ = ""
g$ = ""
B$ = ""
'num = 1 'R
num = 0 'R
nt = 0
For i = 1 To lena
   c$ = Mid$(ain$, i, 1)
   
   If c$ <> " " Then
      If nt = 0 Then num = num + 1
      nt = 1
      If num = 4 Then Exit For
      If Asc(c$) < 48 Or Asc(c$) > 57 Then Exit For
      If num = 1 Then r$ = r$ + c$
      If num = 2 Then g$ = g$ + c$
      If num = 3 Then B$ = B$ + c$
   Else
      nt = 0
   End If
Next i
red = Val(r$): grn = Val(g$): blu = Val(B$)
End Sub


