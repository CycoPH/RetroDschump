; -----------------------------------------------------
; DoScrolling()
; Routines to help scroll the screen up and down
; Fine and course scrolling is done here
; NB: Parallax scrolling is done in the main loop
; Inputs:
; - zpScrollDirection = -ve=up +ve=down 0=nothing
; - zpFineScroll = 0-7 the fine scroll value
; - zpTopOfScreen = On which line of the screen is the top of the screen
;					0 - (141-SCREEN_HEIGHT)
;
; Outputs:
; - zpTriggerActions |= DO_ACTION_PARALLAX
;
	.local
DoScrolling
	; Tell the main loop to do a parallax scroll
	lda zpTriggerActions
	ora #DO_ACTION_PARALLAX
	sta zpTriggerActions

	; In which direction are we scrolling? Up/Down/Nothing
	lda zpScrollDirection
	beq ?noMovement			; if direction == 0 then do nothing
	bmi ?scrollUp
	; Value is +ve and != 0
	; Scrolling down
	inc zpFineScroll			; fine scroll one line down
	
	; Check if the fine scroll limit (8) has been hit (one past the limit)
	lda zpFineScroll
	cmp #VERTICAL_SCROLL_MAX 	; 8 means we reset fine and do a coarse scroll
	bcc ?endScrolling			; not hit the limit yet

	; Hit/Passed the fine scroll limit
	; Do a coarse scroll down
	inc zpTopOfScreen			; Move to the next line
	lda zpTopOfScreen			; Check if we've hit the bottom line
	cmp #MAX_TOP_OF_SCREEN
	bcs ?hitBottomLimit			; Not past the bottom

	; store new coarse vertical scroll value in the display list
	clc
	lda DisplayListVscrollAddress
	adc #32
	sta DisplayListVscrollAddress
	lda DisplayListVscrollAddress+1
	adc #0
	sta DisplayListVscrollAddress+1

	; Reset fine scroll
	lda #0
?endScrolling	
	sta zpFineScroll
	sta VSCROL					; Write the fine scroll to the hardware
	rts
?noMovement
	lda zpFineScroll
	jmp ?endScrolling

?hitBottomLimit
	dec zpFineScroll			; take away the file scroll again
	dec zpTopOfScreen

	lda #SCROLL_UP
	sta zpScrollDirection		; Switch to scrolling up

	lda #0
	sta zpScrollDirection		; Stop of level from moving!

	lda #BALL_FORWARD			; On the next bounce switch the ball direction
	sta NextBallDirection

	lda #SFX_END_OF_LEVEL		; Play arrow hit sound
	sta SFX_Effect2

	rts
	; -----------------------------------------------------
?scrollUp
	dec zpFineScroll			; fine scroll one scan-line up
	lda zpFineScroll			; if V >= 0 nothing else to do
	bpl ?endScrolling
	
	; Hit the fine scroll limit
	;
	; Do a coarse scroll up
	; For as long as the top of the screen value is >= 0 we are ok
	; If it goes -ve then we hit the top of the map and have to start
	; the going in the opposite direction
	dec zpTopOfScreen
	bmi ?hitTopLimit

	; store new coarse vertical scroll value in the display list
	sec
	lda DisplayListVscrollAddress
	sbc #32
	sta DisplayListVscrollAddress
	lda DisplayListVscrollAddress+1
	sbc #0
	sta DisplayListVscrollAddress+1
	; Reset fine scroll
	lda #VERTICAL_SCROLL_MAX-1
	jmp ?endScrolling

	; We've reached the top of the map
	; - Reset a bunch of stuff
	; - Stop the scrolling
	; Note the ball is still rolling in the upward direction
?hitTopLimit
	lda #0
	sta zpFineScroll			; Reset fine scroll and top of screen
	sta zpTopOfScreen
	sta zpScrollDirection		; Stop of level from moving!

	lda #BALL_BACKWARD			; On the next bounce switch the ball direction
	sta NextBallDirection

	lda #SFX_END_OF_LEVEL		; Play arrow hit sound
	sta SFX_Effect2

	rts
