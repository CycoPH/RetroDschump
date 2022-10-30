; Game loop events and support routines

; -----------------------------------------------
; Do something to end the level and start the
; next one
.local
EndLevel
	jsr DoDropDown
	jsr PlayLevelEndMusic

	jsr CloseTheCurtain

	jsr NextLevel			; return 0 => end game, 1 => continue
	beq	?endTheGame

	; Setup the next level
	jmp StartPlay

?endTheGame
	; Hide screen
	; Switch to a new font
	; Show The End screen and scroll it for a bit
	; Restart the whole game
	jsr FadeOut			; Fade to black game screen

	jsr PlayEndGameMusic

	lda #0				; initialize vertical scrolling value
	sta VSCROL			; initialize hardware register

	lda #>FONT_ENDSCREEN
	;lda #>FONT_GUI	; Font of the GUI
	sta WhichFontToUse

	lda #<SCREEN
	sta DisplayListVscrollAddress
	lda #>SCREEN
	sta DisplayListVscrollAddress+1

	lda #1				; scroll down
	sta zpScrollDirection

	lda #0
	sta zpTopOfScreen	; This is the top of the screen indicator	

	jsr DecompressEndScreen

	jsr FadeIn			; Show the screen

	lda #60				; Wait a little until we start scrolling
	sta zpTemp3
?waitALittleBitAtTheTop
	jsr	WaitForVBI
	dec zpTemp3
	bne ?waitALittleBitAtTheTop

	; Scroll until the bottom of the screen is shown
?showMoreInfo 
	jsr DoScrolling
	jsr	WaitForVBI
	jsr	WaitForVBI

	lda zpFineScroll
	and #1
	beq ?noParallax
	jsr ParallaxThisChar0
?noParallax

	; Check for fire button
	lda STRIG0
	beq ?noMoreWait
	; Check for START key
	lda CONSOL
	and #1
	beq ?noMoreWait
	
	lda zpTopOfScreen
	cmp #21+2+7-3-6 ; -3 for smaller end screen
	bcc ?showMoreInfo

	; Wait some more
	; Button/START takes us out
	jmp WaitForRestart
?noMoreWait
	jmp FadeAndStartOver

ParallaxThisChar0
	ldx FONT_ENDSCREEN+7
	lda FONT_ENDSCREEN+6
	sta FONT_ENDSCREEN+7
	lda FONT_ENDSCREEN+5
	sta FONT_ENDSCREEN+6
	lda FONT_ENDSCREEN+4
	sta FONT_ENDSCREEN+5
	lda FONT_ENDSCREEN+3
	sta FONT_ENDSCREEN+4
	lda FONT_ENDSCREEN+2
	sta FONT_ENDSCREEN+3
	lda FONT_ENDSCREEN+1
	sta FONT_ENDSCREEN+2
	lda FONT_ENDSCREEN+0
	sta FONT_ENDSCREEN+1
	stx FONT_ENDSCREEN
	rts
;================================================
; Blank out the level information by pulling
; blinds from left and right
VerticalCnt	.byte 0		; Vertical blinds counter

CloseTheCurtain
	lda #0			; 32 chars wide 0 = left (reset the left column offset)
	sta ?leftAdd	; SMC
	lda #31			; 31 is the right most character (reset the right column offset)
	sta ?rightAdd	; SMC
	lda #16	
	sta VerticalCnt	; 16 left and right columns to close the curtain

?nextVertical
	; Setup the drawing location
	; Start on the left (0), this gets modified (Self modifying code) to the next column
	lda #<SCREEN
	clc
	adc #0
?leftAdd = *-1				; Left column (0,1,2,...)
	sta outputPointer
	clc
	adc #31					; Right column (31,30,29,....)
?rightAdd = *-1
	sta zpToL
	lda #>SCREEN
	sta outputPointer+1
	sta zpToH

	; Clear the left and right hand sides
	ldy #0
	ldx #126			; 126 rows high
?nextLine
	lda #255				; Draw the blank character
	sta (outputPointer),y	; into the two ptrs (left=outputPointer / right=zpTo)
	sta (zpTo),y

	; Move the ptrs to the next line
	clc						; outputPtr += 32 (16 bit add)
	lda outputPointer
	adc #32
	sta outputPointer
	lda outputPointer+1
	adc #0
	sta outputPointer+1

	clc						; zpTo += 32 (16 bit add)
	lda zpToL
	adc #32
	sta zpToL
	lda zpToH
	adc #0
	sta zpToH

	dex
	bpl ?nextLine			; Finish all 126 rows in the left and right column

	; Do the next vertical line
	dec VerticalCnt
	lda VerticalCnt
	beq ?blindsAreClosed
	
	; Setup next vertical
	inc ?leftAdd
	dec ?rightAdd
	dec ?rightAdd

	; Do some slowdown to have it times nicely
	ldx #8
storeWait_CloseTheCurtain = *-1
?slowDown
	jsr WaitForVBI
	dex
	bpl ?slowDown
	jmp ?nextVertical

?blindsAreClosed
	ldx #50
storeWait_CloseTheCurtainEnd = *-1		
?slowDown2
	jsr WaitForVBI
	dex
	bpl ?slowDown2
	rts

; -----------------------------------------------
; We are about to go down a worm hole
; (zpLevelOffset) - src offset
; (zpLevelAction) - dest offset
DoWormhole
	jsr DoDropDown

	; Move level to new location
	; zpFineScroll = 0
	; zpTopOfScreen = ...
	; DisplayListVscrollAddress
	; (zpLevelAction) = 6 bit (Y) | 3 bit (X)

	; Calc the x position where the worm hole exits
	lda zpLevelActionL			; x = (zpLevelAction & 3) * 16 + BALL_LEFT_LIMIT + 14
	and #7						; low 3 bits are the x position (8 bytes wide)
	asl							; *16
	asl
	asl
	asl
	clc
	adc #BALL_LEFT_LIMIT+14
	sta BallXPosition			; and store the location
	sta HPOSP0
	sta HPOSP1
	
	; Calc the Y offset
	; screen is 21 lines high and we want to pop up in the middle
	; Set the Y position of the ball to be the middle of the screen
	lda #BALL_TOP_LIMIT+(BALL_BOTTOM_LIMIT-BALL_TOP_LIMIT)/2+8+1
	sta BallYPosition

	; Calc how far we jhave to scroll the screen to get the exit tile 
	; to be in the middle of the screen
	; zpTopOfScreen = ((zpLevelAction >> 3) & 63) * 3 - 9
	lda zpLevelActionH
	lsr							; shift the low bit into carry: y yyyy y000
	lda zpLevelActionL
	ror 						; yyyyyy00
	ror							; Cyyyyyy0
	ror							; CCyyyyyy
	and #63
	tay							; Y = y-offset
	; This is the Y offset of the tile (0-41) * 3
	sta zpTemp	; *1
	asl			; *2
	clc
	adc zpTemp	; *2 + *1 = 3x
	sec
	sbc #9
	bpl ?noNegFix
	; Make sure that the level does not go past 0
	; Limit to 0 and set the BallYPosition to the Y offset of the tile
	; currently in the Y reg
	tya
	asl
	asl
	asl 		; *8
	sta zpTemp
	asl			; *16
	clc
	adc zpTemp	; *8 + *16 = *24
	adc #BALL_TOP_LIMIT+7
	sta BallYPosition
	; Set the new top-of-screen
	lda #0
	beq ?allReady

	; Check if its all the way at the bottom
?noNegFix
	cmp #126-HEIGHT_OF_SCREEN
	bcc ?allReady
	; Too far down
	tya
	sec
	sbc #35
	asl
	asl
	asl 		; *8
	sta zpTemp
	asl			; *16
	clc
	adc zpTemp	; *8 + *16 = *24
	adc #BALL_TOP_LIMIT+7
	sta BallYPosition

	lda #126-HEIGHT_OF_SCREEN	; Set the top limit

?allReady
	sta zpTopOfScreen
	jsr SetScreenTopPosition

	jsr WaitForVBI				; Kills ACC

	lda #0
	sta zpFineScroll
	sta VSCROL
	;lda #0
	;sta zpTopOfScreen

	; Warp out
	lda #SFX_LEVEL_END
	sta SFX_Effect

	jsr DoRaiseBallAnim

	jsr WaitForVBI

	; Move the ball back into position
	lda BallXPosition			; Only using a single dual layer sprite
	sec
	sbc #4						; move in 4 pixels
	sta BallXPosition			; and store the location
	sta HPOSP0
	sta HPOSP1
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3

	lda BallYPosition			; Warp animation is 14 pixels (ball is 24)
	sec							; so move down 5 pixels to keep it in the center of the ball
	sbc #5
	sta BallYPosition

	; Setup the 
	lda #0
	sta BallFrameCounter
	jsr DrawBall

	jsr WaitForVBI

	lda #1+2+4+8+16+32			; VBI - all one again
	sta VBIMode

	rts

; -----------------------------------------------
; Ball is dropping into water
; 1. Show the drop animation
; 2. Play the splash sound 
.local
DoFallIntoWater
	jsr DoDropDown				; Drop down and return when the ball is gone

	lda #SFX_BANG
	sta SFX_Effect

?lostLife:

	; Check if there are lifes left?
	lda LifesLeft
	beq ?deadInTheWater
	jsr RemoveLife

	jsr FadeOut
	jsr SetScreenStartPosition		; reset to the bottom
	jsr ResetLevelInfo
	jsr SetBallStartPosition
	jsr ClearPMG
	jsr FadeIn

	lda #0
	sta BallFrameCounter
	jsr DrawBall

	; Wait for button to be release
?waitForRelease
	lda STRIG0
	beq ?waitForRelease

	jsr PlayDingDingDong

	lda #1+2+4+8+16+32			; VBI - all one again
	sta VBIMode

	rts	

?deadInTheWater
	; No more lifes
	jsr PlayNoLifesMusic
	jsr CloseTheCurtain

	jmp ShowGameOverScreen

; -----------------------------------------------
DoPopTheBall
	jsr DoPop

	lda #DO_VBI_MUSIC			; VBI just does the music
	sta VBIMode

	jsr WaitForVBI

	lda #0
	sta BallFrameCounter
	
	lda BallYPosition		; This only needs to happen once.
	clc
	adc BallFrameCounter
	sta zpSpriteToL			; zpSpriteToL is the same for all 4 players

	ldy #0					; This only needs to happen once.

	lda #>PM0				; High byte of $A400
	sta zpSpriteToH

	lda #0
	sta (zpSpriteToH),y

	iny

	jmp ?lostLife

; -----------------------------------------------
DoDropDown
	lda #DO_VBI_MUSIC			; VBI just does the music
	sta VBIMode

	jsr WaitForVBI

	jsr MiniClearPMG			; Clear the old ball

	lda BallXPosition			; Only using a single dual layer sprite
	clc
	adc #4						; move in 4 pixels
	sta BallXPosition			; and store the location
	sta HPOSP0
	sta HPOSP1

	lda BallYPosition			; Warp animation is 14 pixels (ball is 24)
	clc							; so move down 5 pixels to keep it in the center of the ball
	adc #5
	sta BallYPosition

	jsr DoDropBallAnim			; Animate just the ball warping away

	rts

; -----------------------------------------------
DoPop
	lda #DO_VBI_MUSIC			; VBI just does the music
	sta VBIMode

	jsr WaitForVBI

	jsr MiniClearPMG			; Clear the old ball

	lda BallXPosition			; Only using a single dual layer sprite
	clc
	adc #4						; move in 4 pixels
	sta BallXPosition			; and store the location
	sta HPOSP0
	sta HPOSP1

	lda BallYPosition			; Warp animation is 14 pixels (ball is 24)
	clc							; so move down 5 pixels to keep it in the center of the ball
	adc #5
	sta BallYPosition

	jsr DoPopBallAnim			; Animate just the ball warping away

	rts	

; -----------------------------------------------
DoAddLife
	jsr AddLife
	rts

; -----------------------------------------------
; Play the ding-ding-dong sound before the game
PlayDingDingDong
	; Setup new DLI for the 3 2 1 counter
	;jsr WaitForVBI
	lda #<DLICount321
	sta VDSLST
	lda #>DLICount321
	sta VDSLST+1

	; init the sound index
	lda #2
	sta DingPos
?ding
	ldy #SFX_PUSH*2
	ldx DingPos					; Channel 2, 1, 0
	lda DingDingDong,X			; Get the note
	jsr rmt_sfx					; RMT_SFX start tone (It works only if FEAT_SFX is enabled !!!)

	lda DingPos
	jsr Draw321

	ldy #50
storeWait_PlayDingDingDong = *-1
?wait2
	lda RTCLOK60
?wait1	
	cmp RTCLOK60
	beq ?wait1
	dey
	bne ?wait2

	ldx DingPos
	dex
	stx DingPos
	bpl ?ding

	jsr ClearPMG
	jsr DrawBall


?waitForRelease2
	lda STRIG0
	beq ?waitForRelease2	

	; Restore the game's DLI
	jsr WaitForVBI
	jsr SwitchGameGui				; Show the game gui
	lda #<DLIGame
	sta VDSLST
	lda #>DLIGame
	sta VDSLST+1

	lda #255						; Reset key code
	sta CH

	rts

DingDingDong .byte  40, 20, 20, 20
DingPos .byte 3
;DingDingDongTxt .SBYTE "A123"

; =============================================================================
.local
ShowGameOverScreen
	; Hide screen
	; Switch to a new font
	; Show The End screen and scroll it for a bit
	; Restart the whole game
	jsr FadeOut			; Fade to black game screen

	lda #0				; initialize vertical scrolling value
	sta VSCROL			; initialize hardware register

	lda #>FONT_ENDSCREEN
	sta WhichFontToUse

	lda #<SCREEN
	sta DisplayListVscrollAddress
	lda #>SCREEN
	sta DisplayListVscrollAddress+1

	lda #1				; scroll down
	sta zpScrollDirection

	lda #0
	sta zpTopOfScreen	; This is the top of the screen indicator	

	jsr DecompressGameOverScreen

	jsr FadeIn			; Show the screen

	; Wait some more
	; Button/START takes us out
WaitForRestart
?waitALittleBitAtTheBottom
	jsr	WaitForVBI
	jsr	WaitForVBI
	jsr ParallaxThisChar0
	; Check for fire button
	lda STRIG0
	beq ?noMoreWait
	; Check for START key
	lda CONSOL
	and #1
	beq ?noMoreWait
	bne ?waitALittleBitAtTheBottom
?noMoreWait
FadeAndStartOver

	; Hide screen and reset everything
	jsr FadeOut			; Fade to black game screen

	lda #>FONT_TILES
	sta WhichFontToUse

	jmp StartAllOver

; =============================================================================
.local
ShowHelpScreen
	; Hide screen
	; Switch to a new font
	; Show The End screen and scroll it for a bit
	; Restart the whole game
	jsr FadeOut			; Fade to black game screen

	lda #DO_VBI_MUSIC+DO_VBI_BALL_ANIMATION+DO_DRAW_BALL				; VBI plays music
	sta VBIMode

	lda #0				; initialize vertical scrolling value
	sta VSCROL			; initialize hardware register

	lda #>FONT_ENDSCREEN
	sta WhichFontToUse

	lda #<SCREEN
	sta DisplayListVscrollAddress
	lda #>SCREEN
	sta DisplayListVscrollAddress+1

	lda #1				; scroll down
	sta zpScrollDirection

	lda #0
	sta zpTopOfScreen	; This is the top of the screen indicator	

	jsr DecompressHelpScreen

	jsr FadeIn			; Show the screen

	; Wait some more
	; Button/START takes us out
?waitALittleBitAtTheBottom
	jsr	WaitForVBI
	jsr	WaitForVBI
	jsr ParallaxThisChar0
	; Check for fire button
	lda STRIG0
	beq ?noMoreWait
	; Check for START key
	lda CONSOL
	and #1
	beq ?noMoreWait
	bne ?waitALittleBitAtTheBottom
?noMoreWait
	; Hide screen and reset everything
	jsr FadeOut			; Fade to black game screen

	lda #>FONT_TILES
	sta WhichFontToUse

	lda #DO_VBI_MUSIC+DO_VBI_SCROLL+DO_VBI_BALL_ANIMATION+DO_DRAW_BALL+DO_LIMIT_MOVEMENT
	sta VBIMode

	jmp EnterFromHelpScreen
