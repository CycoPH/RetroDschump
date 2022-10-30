; Fake parallax scrolling by shifting the contents of the characters
; Char 0 - background
; Char 1-6 (3x2) grid to make a tile

; Copy the original values of the first 7 chars
; When the level starts we can restore the original (non parallax scrolled)
; chars back to have a consistent start;
	.local
InitParallax
	; Speed adjustments
	lda #PARALLAX_SPEED_BACKGROUND
	sta zpParallaxCounter0

	lda #PARALLAX_SPEED_LEVEL1
	sta zpParallaxCounter1_6

	rts

; Called from the main event loop
; Update the characters to fake parallax scrolling
DoParallaxScrolling
	jsr ?parallaxChar0
	jmp ?parallaxChar1to6	; this routine will rts to the caller!

; ---------------------------------------------------------
; Fake parallax scroll the background character (char 0)
?parallaxChar0
	; is it time to update the background char
	lda zpParallaxCounter0
	dec zpParallaxCounter0
	bne ?parallax0Done

	lda #PARALLAX_SPEED_BACKGROUND
	sta zpParallaxCounter0

	lda zpScrollDirection
	beq ?parallax0Done
	bpl ?parallaxChar0Down
	; move up
	ldx FONT_TILES
	lda FONT_TILES+1
	sta FONT_TILES
	lda FONT_TILES+2
	sta FONT_TILES+1
	lda FONT_TILES+3
	sta FONT_TILES+2
	lda FONT_TILES+4
	sta FONT_TILES+3
	lda FONT_TILES+5
	sta FONT_TILES+4
	lda FONT_TILES+6
	sta FONT_TILES+5
	lda FONT_TILES+7
	sta FONT_TILES+6
	stx FONT_TILES+7
?parallax0Done
	rts

?parallaxChar0Down
	ldx FONT_TILES+7
	;
	lda FONT_TILES+6
	sta FONT_TILES+7
	lda FONT_TILES+5
	sta FONT_TILES+6
	lda FONT_TILES+4
	sta FONT_TILES+5
	lda FONT_TILES+3
	sta FONT_TILES+4
	lda FONT_TILES+2
	sta FONT_TILES+3
	lda FONT_TILES+1
	sta FONT_TILES+2
	lda FONT_TILES+0
	sta FONT_TILES+1
	stx FONT_TILES
	rts	

; ---------------------------------------------------------
?parallaxChar1to6
	dec zpParallaxCounter1_6
	bne ?parallax1_6Done
	; Reset level 1 parallax counter
	lda #PARALLAX_SPEED_LEVEL1
	sta zpParallaxCounter1_6

	lda zpScrollDirection
	beq ?parallax1_6Done		; zero movement then we are done
	bpl ?parallaxChar1_6Down
	; -------------------------------
	; move up
	; char 1 + 2 [font bytes 8-23] byte 9->8 ... 8->23
	; Setup the from and to pointers
	lda #<(FONT_TILES+9)
	sta zpFromL
	lda #>(FONT_TILES+9)
	sta zpFromH

	lda #<(FONT_TILES+8)
	sta zpToL
	lda #>(FONT_TILES+8)
	sta zpToH

	; column 1 (8-23)
	ldx FONT_TILES+8	; save for wrap around to the bottom
	ldy #0
?copyCol1
	lda (zpFrom),y
	sta (zpTo),y
	iny
	cpy #15
	bne ?copyCol1
	txa
	sta (zpTo),y
	iny
	; column 2 (24-39)
	lda (zpTo),y	; Save the top of the column to store at the end
	tax
?copyCol2
	lda (zpFrom),y
	sta (zpTo),y
	iny
	cpy #15+16
	bne ?copyCol2
	txa
	sta (zpTo),y
	iny
	; column 3 (40-55)
	lda (zpTo),y	; Save the top of the column to store at the end
	tax
?copyCol3
	lda (zpFrom),y
	sta (zpTo),y
	iny
	cpy #15+16+16
	bne ?copyCol3
	txa
	sta (zpTo),y
	iny	
?parallax1_6Done
	rts

?parallaxChar1_6Down
	; move down
	; Setup the from and to pointers
	; Column 3
	lda #<(FONT_TILES+8)	; The 2nd last byte
	sta zpFromL
	lda #>(FONT_TILES+8)
	sta zpFromH

	lda #<(FONT_TILES+9)		; the last byte in col3
	sta zpToL
	lda #>(FONT_TILES+9)
	sta zpToH

	; starting at the end of column 3
	ldy #46
	lda (zpTo),y	; save the bottom byte of the column
	tax
?copyDownCol3
	lda (zpFrom),y
	sta (zpTo),y
	dey
	cpy #31
	bne ?copyDownCol3
	txa
	sta (zpTo),y
	dey
	; Now at the end of column 2
	lda (zpTo),y	; save the bottom byte of the column
	tax
?copyDownCol2
	lda (zpFrom),y
	sta (zpTo),y
	dey
	cpy #15
	bne ?copyDownCol2
	; Write the saved value from the bottom of the column
	txa
	sta (zpTo),y
	dey
	; Now at the end of column 1
	lda (zpTo),y	; save the bottom byte of the column
	tax
?copyDownCol1
	lda (zpFrom),y
	sta (zpTo),y
	dey
	bne ?copyDownCol1
	; Copy last entry
	lda (zpFrom),y
	sta (zpTo),y
	; Restore entry from bottom of column
	txa
	sta (zpFrom),y
	rts