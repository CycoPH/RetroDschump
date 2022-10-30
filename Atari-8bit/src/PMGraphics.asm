; =============================================================================
; Player/Missile/Sprite drawing/interaction routines
; =============================================================================
	.local
InitPM
	; Set the PM size and position
	lda #0
	ldx #$C
?initLoop
	sta HPOSP0,x
	dex
	bpl ?initLoop

	; Clear the PM graphics area
	jsr ClearPMG

	; Set PM colors
	;LDA #$3A; $FA			; Player/Missile colours
	;STA PCOLOR0
	;LDA #$36; $f6
	;STA PCOLOR1
	;LDA #$3A; $fa
	;STA PCOLOR2
	;LDA #$36; $f6
	;STA PCOLOR3

	; Set priority of graphics
	lda #~00110001		; Overlaps of players have 3rd color + Player 0 - 3, playfield 0 - 3, BAK (background)
	sta GPRIOR

	; Set the start address of the PM graphics
	lda #>PM_SPRITE		; $A000
	sta PMBASE

	lda #3				; turn on missiles & players
	sta GRACTL			; no shadow for this one	

	rts

; ---------------------------------------------------------
; Clear the sprite graphics area to all 0
ClearPMG
	lda #0
	tax
?clearPMLoop
	;sta MISSILES,X
	sta PM0,x
	sta PM1,x
	sta PM2,x
	sta PM3,x
	inx
	bne ?clearPMLoop
	rts

; ---------------------------------------------------------
; Clear the 24 lines that the normal ball occupies
MiniClearPMG
	lda #0
	ldx BallYPosition	; Hight offset into the sprite memory
	ldy #23				; Line counter
?miniClearLoop	
	sta PM0,x
	sta PM1,x
	sta PM2,x
	sta PM3,x
	inx					; next line
	dey					; dec line counter
	bpl ?miniClearLoop
	rts

; ---------------------------------------------------------
; Turn off the screen, interrupts, and
; reset all sprites to offscreen left
TurnOff	
	lda #0
	sta DMACTL
	sta SDMCTL
	sta NMIEN
	ldx #$C
?off
	sta HPOSP0,x
	dex
	bpl ?off
	rts

; ---------------------------------------------------------
TurnOn
	; Interrupts on
	lda #NMI_VBI|NMI_DLI
	sta NMIEN
	; Setup a narrow screen width: 32 chars per line
	lda #~111101		;01 - narrow, 11-PM on, 1 - one line, 1-DMA on
	sta SDMCTL
	rts

; -----------------------------------------------
; Draw 3 2 1 into the sprite
; Done by expanding the left and right nibbles of 8 font bytes
; by using the ExpandTbl. Each entry in a nibble maps to an entry
; in the table that doubles the bits set
; 0001 -> 00000011
; 0010 -> 00001100
; 1111 -> 11111111
; Acc = 2,1,0
Draw321
	clc
	adc #17					; index = ACC + 17 (where 17 is the offset of 1 in the font table)
	asl						; index *= 8
	asl
	asl
	sta ?smcFONTGUI_LSB_Right	; Self modifying code: change the LSB of the LDA FONT_GUI,x command
	sta ?smcFONTGUI_LSB_Left	; Self modifying code: " but for the right hand side of the sprite

	ldx #0					; Zero the line counters
	stx zpVar1				; Index into the character byte (0-7)
	stx zpVar2				; Index into the sprite line (0-23)

?nextFontByte
	; Expand and draw the low nibble of the font byte
	lda FONT_GUI,x			; 3 byte op:BD LSB MSB where the LSB byte is being changed to the character offset
?smcFONTGUI_LSB_Right = * - 2
	and #15					; ACC = ExpandTbl[ FONT_GUI[x] & 15]
	tay
	lda ExpandTbl,y

	ldx zpVar2				; Draw the expanded nibble into the right sprites (2+3)
	sta PM2+116,x			; Horizontal expansion 2x
	sta PM3+116,x			; Vertical expansion 3x
	inx
	sta PM2+116,x
	sta PM3+116,x
	inx
	sta PM2+116,x
	sta PM3+116,x	

	; Expand and draw the high nibble of the font byte
	ldx zpVar1
	lda FONT_GUI,X			; 3 byte op:BD LSB MSB
?smcFONTGUI_LSB_Left = * - 2;
	lsr
	lsr
	lsr
	lsr
	tay
	lda ExpandTbl,y			; ACC = ExpandTbl[ FONT_GUI[x] >> 4]
	
	; Note the left nibble is only drawn to sprite 0
	; We don't touch sprite 1.
	; This gives us a nice color change left and right
	ldx zpVar2		; Draw the expanded nibble into the left sprite (0)
	sta PM0+116,x			; Horizontal expansion 2x
	inx						; Vertical expansion 3x
	sta PM0+116,x
	inx
	sta PM0+116,x
	inx
	stx zpVar2

	; Make sure we do 8 lines of this, expanding 8x8 to 16x24
	ldx zpVar1
	inx
	stx zpVar1
	cpx #8
	bcc ?nextFontByte

	rts

; ---------------------------------------------------------
; Set ball start position;
; Sprite 0+1 on the left
; Sprite 2+3 on the right
SetBallStartPosition
	lda LevelStartX
	asl
	asl
	asl
	asl
	adc #BALL_START_LEFT

?shortCutBallReset
	sta BallXPosition
	sta HPOSP0
	sta HPOSP1
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3

	; Tell the sprite ptrs where the balls's Y position is
	;lda #BALL_START_Y
	lda LevelStartY
	asl
	asl
	asl
	sta zpTemp3
	asl
	adc zpTemp3
	adc #BALL_TOP_LIMIT
	sta BallYPosition

	; In which direction is the ball animating (forward)
	;lda #BALL_FORWARD
	lda LevelDirection
	eor #128
	sta BallDirection

	lda #0
	sta BallFrameCounter

	rts

; ---------------------------------------------------------
; Put the ball somewhere to the right and at the bottom of the screen
PlaceBallInLevel0
	lda #BALL_START_LEVEL0_X
	jsr ?shortCutBallReset

	lda #BALL_START_Y
	sta BallYPosition

	lda #BALL_FORWARD
	sta BallDirection
	rts

; ---------------------------------------------------------
; DrawBall()
; Copy the correct ball animation frame into the 24 bytes
; - BallFrameCounter - Calculate the bounce frame to draw
; - BallYPosition - Vertical position where to copy the 24 player bytes to
DrawBall
	lda BallFrameCounter
	asl
	tax
	lda FrameOffsetTbl,x	; get low
	sta zpSpriteTempL
	lda FrameOffsetTbl+1,x	; get high
	sta zpSpriteTempH
	; (zpSpriteTemp) is the offset into a sprite's animation frames: zpSpriteTemp = BallFrameCounter * 24 
	clc
	lda #<BallLeft
	adc zpSpriteTempL
	sta zpSpriteFromL
	lda #>BallLeft
	adc zpSpriteTempH
	sta zpSpriteFromH
	; (spSpriteFrom) = ptr to the start of the sprite frame

	lda BallYPosition		; This only needs to happen once.
	sta zpSpriteToL			; zpSpriteToL is the same for all 4 players

	lda #>PM0				; High byte of $A400
	sta zpSpriteToH
	jsr CopySprite			; (spSpriteFrom) -> (spSpriteTo) Sprite 0

	; Do the same for sprite 1 (the left overlay)
	clc
	lda #<BallLeftOverlay
	adc zpSpriteTempL
	sta zpSpriteFromL
	lda #>BallLeftOverlay
	adc zpSpriteTempH
	sta zpSpriteFromH		; (spSpriteFrom) = & BallLeftOverlay[BallFrameCounter]
	inc zpSpriteToH			; Bump to $A500. The value was already $A4 from the previous copy
	jsr CopySprite			; (spSpriteFrom) -> (spSpriteTo) Sprite 1

	; Do the same for sprite 2 (the right base)
	clc
	lda #<BallRight
	adc zpSpriteTempL
	sta zpSpriteFromL
	lda #>BallRight
	adc zpSpriteTempH
	sta zpSpriteFromH		; (spSpriteFrom) = & BallRight[BallFrameCounter]
	inc zpSpriteToH			; Bump to $A600
	jsr CopySprite			; (spSpriteFrom) -> (spSpriteTo) Sprite 2

	; Do the same for sprite 3 (the right overlay)
	clc
	lda #<BallRightOverlay
	adc zpSpriteTempL
	sta zpSpriteFromL
	lda #>BallRightOverlay
	adc zpSpriteTempH
	sta zpSpriteFromH		; (spSpriteFrom) = & BallRight[BallFrameCounter]
	inc zpSpriteToH			; Bump to $A700
	jsr CopySprite			; (spSpriteFrom) -> (spSpriteTo) Sprite 3

	rts

; ---------------------------------------------------------
; DoDropBallAnim()
; Draw the 10 frames of the ball warp animation
DoDropBallAnim
	lda #0
	sta BallFrameCounter		; 1st frame of the ball drop

	jsr PrepareDropBallDraw		; Switch to the warp animation

?dropLoop
	jsr DrawWarpBall

	; Wait for 4 vertical blanks to slow the whole animation a little
	ldx #4
storeNTSCWait_DoDropBallAnim = *-1
?waitOut
	jsr WaitForVBI
	dex
	bpl ?waitOut

	inc BallFrameCounter
	lda BallFrameCounter
	cmp #10
	bcc ?dropLoop

	jsr MiniClearPMG			; Clear the warp animation

	rts

; ---------------------------------------------------------
; DoPopBallAnim()
; Draw the 170 frames of the ball pop animation
DoPopBallAnim
	lda #0
	sta BallFrameCounter		; 1st frame of the ball drop

	jsr PreparePopBallDraw		; Switch to the pop animation

?popLoop
	jsr DrawWarpBall

	; Wait for 4 vertical blanks to slow the whole animation a little
	ldx #3
storeNTSCWait_DoPopBallAnim = *-1
?waitPop
	jsr WaitForVBI
	dex
	bpl ?waitPop

	inc BallFrameCounter
	lda BallFrameCounter
	cmp #7
	bcc ?popLoop

	jsr MiniClearPMG			; Clear the warp animation

	rts

; ---------------------------------------------------------
; DoRaiseBallAnim()
; Draw the 10 frames of the ball warp animation
DoRaiseBallAnim
	lda #9
	sta BallFrameCounter		; 1st frame of the ball drop

	jsr PrepareDropBallDraw		; Switch to the warp animation

?raiseLoop
	jsr DrawWarpBall

	; Wait
	ldx #4
storeNTSCWait_DoRaiseBallAnim = *-1
?waitIn
	jsr WaitForVBI
	dex
	bpl ?waitIn

	dec BallFrameCounter
	bpl ?raiseLoop

	rts	

; ---------------------------------------------------------
; DrawWarpBall() - 
; - BallFrameCounter - Calculate the bounce frame to draw
; - BallYPosition - Vertical position where to copy the 24 player bytes to
DrawWarpBall
	lda BallFrameCounter
	asl
	tax
	lda WarpOffsetTbl,x		; LSB
	sta zpSpriteTempL
	lda WarpOffsetTbl+1,x	; MSB
	sta zpSpriteTempH
	; (zpSpriteTempL) is the offset into a sprite's animation frames
	clc
	lda #<PM_DschumpWarp
SMC_DrawBallLSB = *-1
	adc zpSpriteTempL
	sta zpSpriteFromL
	lda #>PM_DschumpWarp
SMC_DrawBallMSB = *-1	
	adc zpSpriteTempH
	sta zpSpriteFromH

	; How far down the screen?
	lda BallYPosition		; This only needs to happen once.
	sta zpSpriteToL			; zpSpriteToL is the same for all 4 players

	lda #>PM0				; High byte of $A400
	sta zpSpriteToH

	; (spSpriteFrom) -> (spSpriteTo) for 14 bytes
	ldy #13
	jsr ?copySpriteLoop		; Jump into the CopySprite() function after the Y reg has been set

	; Do the same for the overlay on sprite 1
	clc
	lda #<PM_DschumpWarpOverlay		; SMC - either the warp or the pop animation
SMC_DrawBallOverlayLSB = *-1
	adc zpSpriteTempL
	sta zpSpriteFromL
	lda #>PM_DschumpWarpOverlay
SMC_DrawBallOverlayMSB = *-1
	adc zpSpriteTempH
	sta zpSpriteFromH

	inc zpSpriteToH			; Bump to $A500 (sprite 1)
	
	ldy #13
	jsr ?copySpriteLoop		; Jump into the CopySprite() function after the Y reg has been set

	rts

; ---------------------------------------------------------
; Modify the code to draw either the warp or the pop animation
PrepareDropBallDraw:
	lda #<PM_DschumpWarp
	sta SMC_DrawBallLSB
	lda #>PM_DschumpWarp
	sta SMC_DrawBallMSB

	lda #<PM_DschumpWarpOverlay
	sta SMC_DrawBallOverlayLSB
	lda #>PM_DschumpWarpOverlay
	sta SMC_DrawBallOverlayMSB

	rts

PreparePopBallDraw:
	lda #<PM_DschumpPop
	sta SMC_DrawBallLSB
	lda #>PM_DschumpPop
	sta SMC_DrawBallMSB

	lda #<PM_DschumpPopOverlay
	sta SMC_DrawBallOverlayLSB
	lda #>PM_DschumpPopOverlay
	sta SMC_DrawBallOverlayMSB

	rts

; ---------------------------------------------------------
; Copy 24 (or Y) bytes from (zpSpriteFrom) to (zpSpriteTo)
CopySprite
	ldy #23
?copySpriteLoop
	lda (zpSpriteFrom),y
	sta (zpSpriteTo),y
	dey
	bpl ?copySpriteLoop
	rts


; ---------------------------------------------------------
; Move the ball animation to the next frame
; 16 frames
; 0 = at the bottom
; return value: Acc = 0 (do collision)
NextBallFrame
	lda BallDirection
	bmi ?moveDown
	inc BallFrameCounter
?doCheck
	lda BallFrameCounter
	and #15
	sta BallFrameCounter
	beq ?checkDirChange
	rts
?moveDown
	dec BallFrameCounter
	jmp	?doCheck
; Check if the BallDirection need to change	
?checkDirChange
	lda NextBallDirection
	beq ?noChange
	sta BallDirection
	; +ve ball is going up
	; -ve ball is going down
	bmi ?goingDown
	; Going up
	lda #SCROLL_UP
	bmi ?storeScrollDirection

?goingDown
	lda #SCROLL_DOWN
?storeScrollDirection	
	sta zpScrollDirection

?reset	
	lda #0						; Clear the ball direction change request
	sta NextBallDirection
?noChange
	rts
