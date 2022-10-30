; Vertical Blank Interrupt
; Gets executed 50x per second PAL, 60x NTSC
;
DelayMovement	.byte 0
DelayFrameAnim 	.byte 0			; Delay the ball frame animation (every 3 VBI)
NeedRedraw		.byte 0
VBICounter		.byte 0

VBIMode			.byte 0			; 0 = do nothing
DO_VBI_MUSIC = 1
DO_VBI_SCROLL = 2
DO_VBI_BALL_ANIMATION = 4
DO_VBI_MOVEMENT = 8
DO_DRAW_BALL = 16
DO_LIMIT_MOVEMENT = 32

	.local

ExitVBIEarly
	JMP	XITVBV

VBINTSCDelay .byte 6

VBI
	lda #0
	sta NeedRedraw
	sta zpTriggerActions		; Reset actions for the main loop

	; Check for PAL/NTSC slowdown
	lda PAL
	cmp #$F
	bne DoVBI
	dec VBINTSCDelay
	bne DoVBI
	lda #6
	sta VBINTSCDelay
	;!##TRACE "skip Frame=%d" db($14)
	bne ExitVBIEarly
DoVBI
	;!##TRACE "Frame=%d" db($14)
	inc DelayMovement
	inc DelayFrameAnim
	inc VBICounter

	; Check if the VBI needs to do some work
	; Music, scroll, ball animation, ball movement
	lda VBIMode
	beq ExitVBIEarly			; 0 => Nothing to do, get out early

	; ---------------------------------
	; 1:DO_VBI_MUSIC - Check if music/sound playback is on?
	and #DO_VBI_MUSIC
	beq ?NoMusic
	jsr PlayMusic
?NoMusic

	; ---------------------------------
	; 2:DO_VBI_SCROLL - Check if scrolling is enabled
	; Only scroll every second frame
	lda VBIMode
	and #DO_VBI_SCROLL
	beq ?NoScrolling

	;lda RTCLOK60				; if (RTCLOK60 & 2 == 1) DoScrolling()
	lda VBICounter
	and #1
	bne ?NoScrolling
	; It's time to scroll	
	jsr DoScrolling				; Do the actiual scrolling (fine + course)
?NoScrolling

	; ---------------------------------
	; Check if we need to do frame animation and what ever triggers come from that?
	lda VBIMode
	and #DO_VBI_BALL_ANIMATION
	beq ?noNextFrame

	lda DelayFrameAnim			; if (DelayFrameAnim >= 3) { DelayFrameAnim = 0; NextBallFrame(); }
	cmp #3
	bcc ?noNextFrame
	; Do next frame
	lda #0
	sta DelayFrameAnim			; reset delay counter

	;!##TRACE "NextFrame"

	inc NeedRedraw				; mark for frame redraw
	
	jsr NextBallFrame			; return value will determine what to do: 0=Do collision
	; if Acc = 0 then trigger a collision check
	bne ?noCollisionTest
	; The ball is at the bottom frame
	; Set the check collision test flag
	lda zpTriggerActions
	ora #DO_ACTION_COLLISION
	sta zpTriggerActions

	lda #0
	sta PushBall				; Tell the ball that there is no pushing force on it

?noCollisionTest
?noNextFrame
	
	; ---------------------------------
	; Check for player movement
	; Every alternate frame do some work
	lda DelayMovement			; if A >= 2 then DoMovementChecks()
	cmp #2
	bcs ?DoMovementChecks
?noMovement
	jmp	LimitBallPosition

?DoMovementChecks
	;!##TRACE "Movement check"
	lda #0						; Reset movement delay
	sta DelayMovement
	;
	; Check if movement is enabled
	;
	lda VBIMode
	and #DO_VBI_MOVEMENT
	beq ?noMovement

	; Do player movement
	; X-Reg = -1,0,1		movement in x direction
	; Y-Reg = -1,0,1		movement in y direction
	ldx PushBall	; 0, 1 or $FF
	ldy #0			; 0, 1 or $FF

	; check for movement to the right
	lda STICK0
	and #8
	cmp #8
	beq ?NotRight
	inx			; X: 0 -> 1
?NotRight
	; check for movement to the top
	lda STICK0
	and #1
	cmp #1
	beq ?NotUp
	dey 		; Y: 0 -> FF
?NotUp
	; check for movement to the bottom
	lda STICK0
	and #2
	cmp #2
	beq ?NotDown
	iny			; Y: 0 -> 1
?NotDown
	; check for movement to the left
	lda STICK0
	and #4
	cmp #4
	beq ?NotLeft
	dex			; X: 0 -> FF
?NotLeft
	; Check if boost can be used
	; only if we are moving
	cpx #0
	bne ?checkBoost
	cpy #0
	bne ?checkBoost
	beq ?noDoubleSpeed

?checkBoost
	; Check for boost
	; if the trigger is down and there is boost power left
	; then double the movement direction (x2)
	lda STRIG0
	bne ?NoDoubleSpeed

	lda BoostLevel
	beq ?noDoubleSpeed
	
	; Make a sound
	lda #SFX_FIRE
	sta SFX_Effect2

	dec BoostLevel				; Use one boost unit

	lda zpTriggerActions
	ora #DO_BOOST_UPDATE		; Tell the main loop to update the boost level bar
	sta zpTriggerActions

	; Double the X & Y movements
	txa
	asl
	tax
	tya
	asl
	tay

?noDoubleSpeed	
	; Apply the movement vector to the ball X&Y positions
	cpx #0
	beq ?noLeftRight

	; Self modifying code
	; X-reg is -2,-1,0,1,2
	stx ?smcAddX+1
	lda BallXPosition
	clc
 ?smcAddX
 	adc #0
	sta BallXPosition

?noLeftRight
	; Apply up/down
	cpy #0
	beq ?noUpDown
	; There is Y movement
	inc NeedRedraw					; mark for redraw

	; Self modifying code to do the movement
	; Y-reg is -2,-1,0,1,2
	sty ?smcAddY+1
	lda BallYPosition
	clc
?smcAddY
	adc #0
	sta BallYPosition

?noUpDown
	; -----------------------------------------------------
	; Limit the ball movement to a specific section of the screen
LimitBallPosition
	lda VBIMode
	and #DO_LIMIT_MOVEMENT
	beq ?noLimitMovement

	; Limit ball movement
	lda BallXPosition
	tax
	cmp #BALL_LEFT_LIMIT
	bcs ?LeftOk
	; Too far left
	lda #BALL_LEFT_LIMIT
	sta BallXPosition
	bne ?RightOk				; quick jump to vertical check
?LeftOk
	cpx #BALL_RIGHT_LIMIT
	bcc ?RightOk
	; Too far right
	lda #BALL_RIGHT_LIMIT
	sta BallXPosition

?RightOk
	lda BallYPosition
	tax
	cmp #BALL_TOP_LIMIT
	bcs ?TopOk
	; Too far up
	lda #BALL_TOP_LIMIT
	sta BallYPosition
	bne ?BottomOk
?TopOk
	cpx #BALL_BOTTOM_LIMIT
	bcc ?BottomOk
	; Too far down
	lda #BALL_BOTTOM_LIMIT
	sta BallYPosition
?BottomOk

?noLimitMovement
	; Check for ball drawing
	lda VBIMode
	and #DO_DRAW_BALL
	beq ?NoRedraw
	; Apply the X & Y position to the sprite
	; Set the X position
	; Two sprites next to each other and two on top of each other
	; 02
	; 13
	lda BallXPosition
	sta HPOSP0
	sta HPOSP1
	;!##TRACE "Ball x=%d" @a
	clc
	adc #8
	sta HPOSP2
	sta HPOSP3

?checkRedraw
	lda NeedRedraw
	beq ?NoRedraw
	;!##TRACE "Draw ball"
	jsr DrawBall
?NoRedraw
	; End the Vertical Blank Interrupt
	JMP	XITVBV
