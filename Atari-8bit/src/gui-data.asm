	;*=(*+255)&$FF00

; GUI for the game
; 1st line with 16 characters
; 0123456789ABCDEF
; DSCHUMP   LVL:..
; 2nd line with 32 characters
; 0123456789ABCDEF0123456789ABCDEF
; BOOST:========|    Lifes[][][][]
GuiGame
	.sbyte "RETRO:DSCHUMP"
	.byte 32,11,0,31		; " Lvl:"
LevelIndicatorTens .byte	32		; space		
LevelIndicatorOnes .byte	32		; space
	.byte 32,7,8,9,10,30	; Score:
ScoreIndicator:
	.byte 16,16,16,16,16,16,16	; 7x 0		 +0 1 2 3 4 5 6

	;.sbyte "DSCHUMP"
	;.byte 32,32,32
	;.sbyte +64, "LVL:"	; +64 = white

; Line 2
; Boost:[========]  Lifes:()()()()
	.byte 1,2,2,3,4,5					; BOOST:			6 chars
BoostBar		
	.byte 59,59,59,59,59,59,59,59		; Boost bar 8*4  	8 chars
	.byte 6								; Boost bar end		1 char
	.byte 32,32,32,32,11,12,13,14,15,	; Lifes:
LifesIndicator
	.byte 0,0,0,0,0,0,0,0

; GUI for the intro
; 1st line with 16 characters
; 0123456789ABCDEF
; DSCHUMP
; 2nd line with 16 characters
; 0123456789ABCDEF

GuiIntro
	.byte 0,10,4,12,10,8,27,28		; " RETRO--" in yellow
	.byte 3,11,2,5,13,7,9,0			; "DSCHUMP "
	.byte +64,11,12,1,10,12			; "START" +64 for white
	.byte 0,15+64,0					; " @ "
	.byte +128, 6,4,14,4,6,26		; "LEVEL:" +128 for blue
GuiIntroLevelIndicator
	.sbyte "01"

GuiLevel:
	.ds 64


