; Display List Interrupts
; Used to switch from the GUI font and colors to the game font and colors

; Switch from the gui font to the game font
; Sets the correct tile colours
DLIGame
	pha				; only using A register, so save it to the stack

	lda #>FONT_TILES; page number of new font data
WhichFontToUse = *-1
	sta WSYNC		; first WSYNC gets us to start of scan line we want
	sta CHBASE		; store to hardware register to affect change immediately

	; Set the playfield colours
	lda #$08
storeCol0 = *-1	
	sta COLPF0		; COL0 = $08
	sta ATRACT		; Prevent attract mode from activating

	lda #$0E
storeCol1 = *-1
	sta COLPF1     	; COL1 = $76

	lda #$86
storeCol2 = *-1	
	sta COLPF2     	; COL2 = $0c

	lda #$a4
storeCol3 = *-1	
	sta COLPF3     	; COL3 = $A4

	pla				; restore A register from stack
	rti				; always end DLI with RTI!

start_color .byte 0
;text_color 	.byte $0f

; ---------------------------------------------------------
; Used during the intro
; Interrupt gets hit on the blank line between the 1st and 2nd lines
; - Wait for WSYNC
; - change the color of the UPPERCASE characters (1 scan line at a time = rainbow)
; - after 8 lines jump into the normal/game DLI to switch 
;	- character font
;	- tile colours
DLIIntro
    pha             ; save A & X registers to stack
	txa
	pha
	ldx #8         	; make 8 color changes
	lda start_color ; initial color
?loop
	sta WSYNC		; first WSYNC gets us to start of scan line we want
	sta COLPF0		; change text color for UPPERCASE characters in gr2
	clc
	adc #1			; change color value, making brighter
	dex				; update iteration count
	;sta WSYNC		; sta doesn't affect processor flags
	bne ?loop       ; we are still checking result of dex

	dec start_color	; change starting color for next time
	
	pla				; restore X & A registers from stack
	tax
	pla
	jmp DLIGame

; ---------------------------------------------------------
; DLI that is executed when the 3 2 1 counter is on the screen
; The sprites are placed in the middle and we wait until
DLICount321
	pha
	txa
	pha
	tya
	pha

	lda DingDingDongMode
	beq ?NoTopGui

	; Top 2 lines get the basic font
	lda OriginalFontAddr
	sta CHBASE

	lda #0				; Black background
	sta COLPF2

	; Line 1
	ldx #8				
	ldy #0
?WaitAtLine1
	lda Colors,y		; Shaded font color
	sta WSYNC
	sta COLPF1
	iny
	dex
	bne ?WaitAtLine1

	; Line 2
	dey
	ldx #8
?WaitAtLine2
	lda Colors,y
	sta WSYNC
	sta COLPF1
	dey
	dex
	bne ?WaitAtLine2

?NoTopGui
	; Switch into the tile font
	lda #>FONT_TILES; page number of new font data
	sta WSYNC		; first WSYNC gets us to start of scan line we want
	sta CHBASE		; store to hardware register to affect change immediately

	; Set the playfield colours
	lda #$08
	sta COLPF0		; COL0 = $08
	sta ATRACT		; Prevent attract mode from activating

	lda #$0E
	sta COLPF1     	; COL1 = $76

	lda #$86
storeCol2_DLICount321 = *-1
	sta COLPF2     	; COL2 = $0c

	lda #$a4
storeCol3_DLICount321 = *-1
	sta COLPF3     	; COL3 = $A4

	; Set the position of the 3 2 1 counter
	lda LevelStartY
	cmp #3
	bcc ?aboveMiddleOfScreen

	; First place the 3 2 1
	lda #BALL_START_X
	sta HPOSP0
	sta HPOSP1
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3

	; Wait until after the 3 2 1 counter's vertical position
	ldx #24+24+24+16
?waitSomeLines
	sta WSYNC		; first WSYNC gets us to start of scan line we want
	dex
	bne ?waitSomeLines

	; Set the ball's X-position
	lda BallXPosition
	sta HPOSP0
	sta HPOSP1
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3
	bne ?endOfDLI
	; -------------------------------------------
?aboveMiddleOfScreen
	; Set the ball's X-position
	lda BallXPosition
	sta HPOSP0
	sta HPOSP1
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3

	ldx #20+24+24
?waitSomeLines1
	sta WSYNC		; first WSYNC gets us to start of scan line we want
	dex
	bne ?waitSomeLines1

	lda #BALL_START_X
	sta HPOSP0
	sta HPOSP1
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3

	ldx #24
?waitSomeLines2
	sta WSYNC		; first WSYNC gets us to start of scan line we want
	dex
	bne ?waitSomeLines2

lda BallXPosition
	sta HPOSP0
	sta HPOSP1
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3

?endOfDLI
	pla
	tay
	pla
	tax
	pla
	rti

DingDingDongMode
	.byte 0
Colors .byte 4,6,8,10,12,14,10,8