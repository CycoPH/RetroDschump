; Display list for the game
;
; Align on page boundary
; 192 scan lines are available after the initial 8 blank lines
;  19 = GUI 
;		8 scan lines with 16 mode 6 chars
;		1 scan line blank
;		8 scan lines with 32 mode 4 chars
;		1 scan line blank + DLI
;		1 scan line blank
; 168 = LEVEL
;   5 = Info
;		1 scan line blank
;		4 scan lines with 64 pixels in 16 bytes (3 colors + background)
;
; 8+1 + 8+1+1 = 19 header display lines
; 21*8 = 168 lines of scrolling
; 1 blank

	;*=(*+255)&$FF00
; We have 256 bytes for the Display list and GUI data
	* = $7AE8
	
DisplayList
	.byte $70,$70,$70       	; 24 blank lines
GameOrIntroOverride:
	.byte DL_LMS|DL_TEXT_4, <GuiGame, >GuiGame ; 1x mode 6 line + LMS + address
	.byte DL_BLANK_1
	.byte DL_TEXT_4
	.byte DL_BLANK_1+$80		; DLI
	;
	.byte DL_BLANK_1
	.byte $64					; Mode 4 + VSCROLL + LMS
DisplayListVscrollAddress
	.byte <SCREEN,>SCREEN  		; Mode 4 + LMS + address
	.byte $24,$24,$24,$24,$24,$24,$24,$24   ; 20 more Mode 4 + VSCROLL lines
	.byte $24,$24,$24,$24,$24,$24,
DLIXPos:	
	.byte $24
	.byte $24,$24,$24,$24
	.byte $4					; and the final Mode 4 without VSCROLL
	.byte DL_BLANK_1
	;.byte DL_LMS|DL_MAP_A, <LevelProgress, >LevelProgress ; 1x mode 10 line + LMS + address
	.byte $41,<DisplayList,>DisplayList ; JVB ends display list

DLGame:
	.byte DL_LMS|DL_TEXT_4, <GuiGame, >GuiGame ; 1x mode 6 line + LMS + address
	.byte DL_BLANK_1
	.byte DL_TEXT_4
	.byte DL_BLANK_1+$80		; DLI

DLIntro:
	.byte DL_LMS|DL_TEXT_6, <GuiIntro, >GuiIntro ; 1x mode 6 line + LMS + address
	.byte DL_BLANK_1+$80		; DLI
	.byte DL_TEXT_6
	.byte DL_BLANK_1

DL321:
	.byte DL_BLANK_1+$80
	.byte DL_LMS|DL_TEXT_2, <GuiLevel, >GuiLevel ; 1x mode 2 line + LMS + address
	.byte DL_TEXT_2
	.byte DL_BLANK_1		; DLI
END_OF_DISPLAY_LISTS
	