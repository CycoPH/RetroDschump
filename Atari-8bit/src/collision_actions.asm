	.local
; Calculate world collision information
; - which tile we are landing on
; - are we in the center of the tile
; Input:
;	- BallXPosition
;	- BallYPosition
;	- zpTopOfScreen
;	- zpFineScroll
; Each tile is 4x3 chars box, each char is 4x8 pixels
; - 16x24 pixels per tile
; Output:
;	Returns in Acc:
;		0 = Falling off the surface left or right
;		1 = hitting some tile
;
; 	- zpCollisionCentre - bit 1 (horizontal), bit 2 (vertical) 
;			if both bits are set then the ball is in the middle of the tile
; 	- zpCollisionX - 0-->6 index into the horizontal level info, outside that range = falling off
; 	- zpCollisionY - 0->41
;	zpCollisionTileNr - Which tile # was hit?
;	(zpLevelPtr) pointing to the tile in question
;	(zpLevelOffset) 16-bit offset of the tile in the level
;
; Method:
; zpCollisionX = (BallXPosition - BALL_LEFT_LIMIT - 3) / 16
; zpCollisionCentre = [(BallXPosition - BALL_LEFT_LIMIT - 3) & 15] 3-12 is in => bit 1 = 0/1
; Y = ((zpTopOfScreen % 3) * 8 + BallYPosition - BALL_TOP_LIMIT - 12 + zpFineScroll) % 24
; If 9 <= Y <= 19 then middle of tile vertically
; zpCollisionY = zpTopOfScreen/3 + ((zpTopOfScreen%3) * 8 + BallYPosition - BALL_TOP_LIMIT + 12 + zpFineScroll) / 24
;
CalcTileCollision
	; Calc which tile the ball is over now
	; First the X position
	lda BallXPosition
	sec
	sbc #BALL_LEFT_LIMIT+3		; Check left limit
	;
	; The HIGH nibble is the tile X position
	; The LOW nibble is the index into the tile
	tax		; save the X info
	lsr		; div by 16 (shift right by 4)
	lsr		; to get the high nibble
	lsr		; into a simple x index (0-15) 
	lsr		; 0-6 are valid
	sta zpCollisionX
	cmp #6+1
	bcc ?onTheSurface
	;
	; We are falling off left or right
	; return 0 from this function
	lda #0
	sta zpCollisionCentre			; Clear info about center of tile being hit
	sta zpCollisionTileNr			; We are hitting the empty block!
	rts

	; Still on the surface check Y
?onTheSurface
	; work out if we are hitting the action part of the tile 4-8-4, 2 pixels on each side are inactive
	; divide the x offset in the tile (low nibble of the x-position) by 4
	txa
	and #$0F
	cmp #4
	bcc ?isOut					; if x < 3 || x >= 13 then out else in
	cmp #12+4					; Make it a bit easier to hit the tile on the bottom
	bcs ?isOut

	lda #1
	bne ?setIt
?isOut
	lda #0
?setIt
	sta zpCollisionCentre		; Bit 1 is set then the middle x was hit

	;!##TRACE "ColX = %d" db($f9)

	; Calc if we hit the middle (9-19) lines of a 24 line tile
	; Things to take into account
	; V scroll 0-7
	; TopOfScreen 0-2
	;
	; First we calc how many lines we need to take into account for the offset 
	; into the 3 lines of a tile.  Each offset adds 8 lines
	lda zpTopOfScreen			; Y = (zpTopOfScreen % 3) * 8
?notInTop2
	sec
?modulus3:
	sbc #3
	bcs ?modulus3
	adc #3
	sta zpTemp2					; zpTemp2 is the offset into the top tile 0,1,2
	; Acc = 0, 1, 2
	asl
	asl
	asl
	adc BallYPosition			; Y = Y + BallYPosition

	; Calc if we hit the middle (6-19) lines of a 24 line tile
	sec
	sbc #BALL_TOP_LIMIT-12		; Y = Y - Y_Limit + 12[middle of ball] + 8 (level shift)
	clc
	adc zpFineScroll			; Y = (Y + FileScroll) % 24
	; y = y % 24
	sec
?modulus24:
	sbc #24
	bcs ?modulus24
	adc #24

	; Modulus 24 done
	; Check active range is 9-19
	;sta DebugTemp
	;!##TRACE "%d" @a
	;!##TRACE "Ypos = %d" (a)
	cmp #9-2
	bcc ?yNotInMiddle
	cmp #19+2
	bcs ?yNotInMiddle

	; In the middle, set bit 2 and or in the x middle check result
	lda #2
	ora zpCollisionCentre
	sta zpCollisionCentre
	;!##TRACE "In Middle"
?yNotInMiddle

	; Work out the y collision index
	; Two parts.
	; 1. Work out how far down the top of the screen is
	lda zpTopOfScreen			; Y = top of screen / 3
	sta zpTemp
	lsr
	adc  #21
	lsr
	adc  zpTemp
	ror
	lsr
	adc  zpTemp
	ror
	lsr
	adc  zpTemp
	ror
	lsr
	sta zpCollisionY			; Top of screen is showing this tile, it might have 3,2 or 1 line showing

	; 2. Work out how far down the ball is
	; 	 add that offset to the top of the screen offset and we have the level y offset
	lda zpTemp2					; Top of screen into tile offset 0,1,2
	asl							; * 8
	asl
	asl
	adc BallYPosition
	sec
	sbc #BALL_TOP_LIMIT-12			; acc = (BallPos - TopLimit) 0...max
	clc
	adc zpFineScroll
	; Divide by 24 to get the collision tile in Y
	lsr
	lsr
	lsr
	sta   zpTemp
	lsr
	lsr
	adc   zpTemp
	ror
	lsr
	adc   zpTemp
	ror
	lsr

	clc
	adc zpCollisionY
	sta zpCollisionY
	;
	; Got the x and y collision position
	; Calc ptr into the level data
	; 
	ldx zpCollisionX
	ldy zpCollisionY
	jsr CalcLevelPosition
	; Now have:
	;	(zpLevelPtr) pointing to the tile in question
	;	(zpLevelOffset) 16-bit offset of the tile in the level

	; Get the tile # at the current bounce position
	ldy #0
	lda (zpLevelPtr),y
	sta zpCollisionTileNr

	;!##TRACE "Collision xy=%d,%d on %d" db($f6) db($f7) db($f8)
	rts

; ---------------------------------------------------------	
; Fire the action associated with the zpCollisionTileNr
; Input:
; 	ACC = 0 - off surface, !0 = on surface
;	zpCollisionTileNr - # of the tile that was hit
;	(zpLevelPtr) pointing to the tile in question
;	(zpLevelOffset) 16-bit offset of the tile in the level
; If the tile we are landing on is !0 then zpCollisionX & zpCollisionY give its location
;
ActionCollision
	; Set the normal bounce SFX
	; If we hit something special it will set the SFX
	lda #SFX_NORMAL_BOUNCE
	sta SFX_Effect

	; if collision >= build_tiles => ?noActionToDo
	lda zpCollisionTileNr
	cmp #BUILD_TILES			; The first non action tile (32)
	bcs ?noActionToDo

	;!##TRACE "bounce on tile #%d Center=%d" @a db($f9)

	; On an action tile dispatch into the action routine
	; if the center check succeeds	
	; acc = tile to action
	tax							; X = tile nr
	ldy ActionOnlyInCenterTbl,x	; which centers do we want to check: bit 0 = horizontal, bit 1 = vertical
	beq ?noCenterCheck			; 0 - no checking, just do the action
	
	; Check that the correct bit is set
	lda zpCollisionCentre		; ACC = 1/H, 2/V or 3/H+V
	cpy #2						; check if the center check is VERTICAL only
	beq ?verticalCenterCheckOnly

	cpy #1
	beq ?horizonalCenterCheckOnly

	; Check for center hit vetical and horizontal
	cmp #3
	bne ?noActionToDo			; did not get a hit -> do nothing
	beq ?noCenterCheck

?verticalCenterCheckOnly
	and #2
	beq ?noActionToDo			; did not get a hit -> do nothing
	bne ?noCenterCheck

?horizonalCenterCheckOnly
	and #1
	beq ?noActionToDo			; did not get a hit -> do nothing

?noCenterCheck
	txa							; X = tile nr
	; Route to action routine
	; Dispatch via (zpTemp)
	asl				; *2 to get index into table
	tax
	lda ActionDispatchTable,x
	sta zpTemp
	inx
	lda ActionDispatchTable,x
	sta zpTemp2
	jmp (zpTemp)

	; No action tile hit:
	; - just bounce back
	; - give boost power
	; - play bounce sound
?noActionToDo	
	; No action, just normal graphics
	; Add some boost power
?finishWithBoost
	jsr AddBoost			; Give the player some boost power
	rts

; Each of the 16 action tiles has a action dispatch routine here
ActionDispatchTable
	.word Do_FallDown, Do_WormHoleAction				; #0, #1
	.word Do_HitSwitch, Do_HitSwitch, 					; #2, #3
	.word Do_HitSwitch10, Do_HitSwitch10				; #4, #5
	.word Do_HitSwitch20, Do_HitSwitch20				; #6, #7
	.word Do_HitSwitch, Do_HitSwitch					; #8, #9
	.word Do_HitSwitch, Do_HitSwitch					; #10, #11
	.word Do_Break1, Do_Break2, Do_Break3, Do_TheEnd	; #12, #13, #14, #15
	.word Do_FallHole, Do_FallHole						; #16, #17
	.word Do_PickupBlue, Do_PickupGreen					; #18, #19
	.word Do_ToggleArrow, Do_DownArrow, Do_UpArrow		; #20, #21, #22
	.word Do_PopBall									; #23
	.word Do_BreakFake1,Do_BreakFake2,Do_BreakFake3		; #24, #25, #26
	.word Do_PoolBlue,Do_PoolGreen						; #27, #28
	.word Do_AddLife									; #29
	.word Do_PushRight,Do_PushLeft						; #30, #31

; For each of the 32 action tiles we mark if the action can only happen if the ball hits the center of the tile
ActionOnlyInCenterTbl
	.byte 0		; Blank - you fall no matter what
	.byte 3		; worm hole
	.byte 3,3,3,3,3,3,3,3,3,3 ; 10x switches, you need the center
	.byte 0,0,0	; break anywhere
	.byte 2		; TheEnd needs center Y
	.byte 3,3	; #16,17 - hole in the middle of the tile
	.byte 3,3	; Pickups
	.byte 3,3,3	; Direction changes
	.byte 0		; #23 - pop ball
	.byte 0,0,0	; fake break
	.byte 3,3	; blue and green pools
	.byte 2		; Add life
	.byte 0,0	; Push Right, Push Left

Do_Nothing
	jmp ?finishWithBoost

; ---------------------------------------------------------
Do_AddLife
	lda #TILE_FLAT_NO_PINS
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_FLAT_PINNED + draw to screen

	lda zpTriggerActions
	ora #DO_ADD_LIFE
	sta zpTriggerActions

	lda #SFX_ADD_LIFE
	sta SFX_Effect

	rts

; ---------------------------------------------------------
Do_PopBall
	lda #TILE_FLAT_PINNED
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_FLAT_PINNED + draw to screen
	
	lda zpTriggerActions
	ora #DO_POP
	sta zpTriggerActions

	lda #SFX_BANG
	sta SFX_Effect

	rts

; ---------------------------------------------------------
; Up and Down arrows change the direction of world movement
Do_DownArrow
?goDown
	lda #BALL_BACKWARD				; Make sure the ball now runs backwards (top to bottom)
	sta BallDirection

	lda #SCROLL_DOWN
?storeDirection
	sta zpScrollDirection

	; Play arrow hit sound
	lda #SFX_ARROW
	sta SFX_Effect
	
?noDirectionChange
	rts

; ---------------------------------------------------------
Do_UpArrow
?goUp
	lda #BALL_FORWARD			; Make sure the ball now runs forward (bottom to top)
	sta BallDirection

	lda #SCROLL_UP
	bmi ?storeDirection			; Store the new direction and play the arrow SFX

; ---------------------------------------------------------
Do_ToggleArrow
	lda zpScrollDirection
	bmi ?goDown
	bpl ?goUp

; ---------------------------------------------------------
; Pickup a blue pill. Give 10 power up
Do_PickupBlue
	lda #TILE_FLAT_PINNED
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_FLAT_PINNED + draw to screen

	lda #50
	jsr JustAddScore

	lda #10
	jsr AddBoostPacket

	lda #SFX_PICKUP
	sta sfx_effect
	rts

; ---------------------------------------------------------
; Pikcup a green pill. Give 32 power up
Do_PickupGreen
	lda #TILE_FLAT_NO_PINS
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_FLAT_PINNED + draw to screen

	lda #100
	jsr JustAddScore

	lda #32
	jsr AddBoostPacket

	lda #SFX_PICKUP
	sta sfx_effect
	rts

; ---------------------------------------------------------
; Hit a switch
;	zpCollisionTileNr - Which tile # was hit?
;	(zpLevelPtr) pointing to the tile in question
;	(zpLevelOffset) 16-bit offset of the tile in the level
Do_HitSwitch10
	lda #10
	jsr JustAddScore
	jmp Do_HitSwitch

Do_HitSwitch20
	lda #20
	jsr JustAddScore

Do_HitSwitch
	lda #SFX_SWITCH
	sta SFX_Effect

	; Search the Switch Position list for the current level offset
	; which is stored in (zpLevelOffset)
	ldx #0							; index into SwitchPosition table
	ldy #16							; loop counter, the number of positions to test
?checkNextSwitchPosition
	lda SwitchPositions,x			; Get the low byte or the switch position
	cmp zpLevelOffsetL
	beq ?switchLowMatches
	; no match, move to next entry in list
	inx								; move to high byte
	lda SwitchPositions,x			; Get the high byte of the switch position
	cmp #$FF						; End of list marker
	beq ?noHitOnAnySwitch
?nextCheck
	inx								; move to next low byte
	dey								; Loop again
	bne ?checkNextSwitchPosition
	;
	; Did not hit anything
	;
?noHitOnAnySwitch
	; This switch has no position stored in the SwitchPositions table
	rts

?switchLowMatches
	inx								; move to high byte
	lda SwitchPositions,x			; Get the high byte
	cmp #$FF						; End of list marker
	beq ?noHitOnAnySwitch
	cmp zpLevelOffsetH				; Do we have the same in the high byte
	bne ?nextCheck					; no => ?nextCheck

	; We now have (zpLevelOffset) matching an entry in the SwitchPositions[] array
	; x is the high byte offset, save it so we can work with it later
	stx zpTemp3

	; Got a hit in low and high
	; 1. Switch the current tile from on -> off (in the level and the screen)
	; 2. Set new target tile in level and screen
	ldx zpCollisionTileNr
	lda SwitchAlternative,x
	; Change the switch from on -> off
	;lda #TILE_SWITCH_DOWN_PINNED
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = XYZ + draw to screen

	; Get the level target offset from the SwitchTarget[]
	; Store in (zpLevelPtr) so that we have direct access to the byte in the level
	; Also store in (zpTo) so that we can calc X & Y coordinates to draw on the screen (zpDrawPtr)
	;
	; X-Reg still holds the high byte offset that we can use to access a word table
	ldx zpTemp3						; Load the saved X reg again
	lda SwitchTarget,x 				; Get the Y of the target
	sta zpLevelOffsetH				; zpLevelOffset = SwitchTarget[x] high byte
	; move back to low byte
	dex
	lda SwitchTarget,x
	sta zpLevelOffsetL				; zpLevelOffset = SwitchTarget[x] low byte
	; Get the tile that needs to be written into the level and draw on the screen
	txa
	lsr								; x = x / 2		switch from word index to byte index
	tax
	stx zpTemp3
	lda SwitchWhat,x
	sta zpLevelTile					; zpLevelTile = the tile that needs to be blasted
	jsr SetNewTile					; (zpLevelOffset) = TILE_BUTTON_DOWN + draw to screen

	; Now save the tile we switched out into the SwitchWhat table so that
	; when we hit the switch again it will switch back to the original value
	ldx zpTemp3
	lda zpLevelPrevTile
	sta SwitchWhat,x

	rts
	; 12 Byte table with what a switch changes into when hit
	; Which tile will be switched in for each of the switch types?
	; Tile 2 = Switch up 4 pins ==> Switch down 4 pins
	; Tile 3 = Switch down 4 pins ==> Switch up 4 pins
SwitchAlternative
	.byte 0,0
	.byte TILE_SWITCH_DOWN_PINNED	; #2 <-- TILE_SWITCH_UP_PINNED
	.byte TILE_SWITCH_UP_PINNED		; #3 <-- TILE_SWITCH_DOWN_PINNED
	.byte TILE_SWITCH_DOWN_BLUE		; #4 <-- TILE_SWITCH_UP_BLUE
	.byte TILE_SWITCH_UP_BLUE		; #5 <-- TILE_SWITCH_DOWN_BLUE
	.byte TILE_SWITCH_DOWN_GREEN	; #6 <-- TILE_SWITCH_UP_GREEN
	.byte TILE_SWITCH_UP_GREEN		; #7 <-- TILE_SWITCH_DOWN_GREEN
	.byte TILE_SWITCH_DOWN			; #8 <-- TILE_SWITCH_UP
	.byte TILE_SWITCH_UP			; #9 <-- TILE_SWITCH_DOWN
	.byte TILE_SWITCH_OFF_DOWN_PINNED	; #10 <-- TILE_SWITCH_ONCE_UP	-> changes into non action tile
	.byte TILE_SWITCH_OFF_DOWN_NO_PINS	; #11 <-- TILE_SWITCH_ONCE_DOWN -> changes into non action tile

; ---------------------------------------------------------
; First stage breaking tile
; Swop to breaking tile 2
Do_Break1
	lda #TILE_BREAK2
?contBreak1
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_BUTTON_DOWN + draw to screen

	lda #SFX_BREAK
	sta SFX_Effect

	lda #0
	sta SoundIndex+SFX_BREAK
	rts

Do_Break2
	lda #TILE_BREAK3
?contBreak2
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_BUTTON_DOWN + draw to screen

	lda #SFX_BREAK
	sta SFX_Effect
	lda #1
	sta SoundIndex+SFX_BREAK
	rts

Do_Break3
	lda #TILE_THE_END
?contBreak3	
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_BUTTON_DOWN + draw to screen

	lda #SFX_BREAK
	sta SFX_Effect

	lda #2
	sta SoundIndex+SFX_BREAK
	rts

; ---------------------------------------------------------
; This breaking tile sequence ends in a blank tile
Do_BreakFake1
	lda #TILE_FAKE_BREAK2
	jmp ?contBreak1

Do_BreakFake2
	lda #TILE_FAKE_BREAK3
	jmp ?contBreak2

Do_BreakFake3
	lda #TILE_EMPTY
	jmp ?contBreak3

; ---------------------------------------------------------
; TheEnd - End the level
Do_TheEnd
	lda #SFX_LEVEL_END
	sta SFX_Effect

	lda zpTriggerActions
	ora #DO_END_LEVEL
	sta zpTriggerActions
	
	rts

; ---------------------------------------------------------
; (zpLevelOffset)
Do_WormHoleAction
	lda #SFX_NO_WARP				; Play this sound if the warp hole is closed
	sta SFX_Effect

	; Search the WormholeIn list for the current level offset
	; which is stored in (zpLevelOffset)
	ldx #0							; index into SwitchPosition table
	ldy #7							; loop counter, the number of positions to test (8)
?checkNextWarpPosition
	lda WormholeIn+1,x				; Get the high byte or the wormhole position
	bmi ?noHitOnAnyWormhole			; Got a -1 so reached end of list
	;
	cmp zpLevelOffsetH
	bne ?nextWormholeCheck
	; High matches, check low
	lda WormholeIn,x				; Get the low byte of the wormhole position
	cmp zpLevelOffsetL
	beq ?gotTheWormhole
?nextWormholeCheck
	inx								; move to next index byte
	inx
	dey								; Loop again
	bpl ?checkNextWarpPosition
	;
	; Did not hit anything
	;
?noHitOnAnyWormhole
	; This wormhole has no position stored in the WormholeIn table
	rts

?gotTheWormhole
	; Save the location where the worm hole exit is
	lda WormholeOut,x
	sta zpLevelActionL
	lda WormholeOut+1,x
	sta zpLevelActionH

	; Setup the action for the main loop 
	lda zpTriggerActions
	ora #DO_WORM_HOLE
	sta zpTriggerActions

	lda #SFX_WARP_IN				; Play the warping sound
	sta SFX_Effect

	rts

; ---------------------------------------------------------
Do_FallHole
Do_FallDown
	; Setup the action for the main loop 
	lda zpTriggerActions
	ora #DO_CRASH
	sta zpTriggerActions

	lda #SFX_NONE
	sta SFX_Effect
	rts

; ---------------------------------------------------------
; Jump into a blue pool. Give 5 power up and some score
Do_PoolBlue
	lda #25
	jsr JustAddScore

?shortcutToPoolActionPart2:
	lda #TILE_HOLE_CLOSED_PINNED
	sta zpLevelTile
	jsr SetNewTile					; (zpLevelOffset) = TILE_HOLE_CLOSED_PINNED + draw to screen

	lda #5
	jsr AddBoostPacket

	lda #SFX_PICKUP
	sta SFX_Effect
	rts

	; ---------------------------------------------------------
; Jump into a blue pool. Give 5 power up and some score
Do_PoolGreen
	lda #50
	jsr JustAddScore

	jmp ?shortcutToPoolActionPart2

Do_PushRight
	lda #1
	bne ?storePush
Do_PushLeft
	lda #255
?storePush
	sta PushBall

	lda #SFX_PUSH
	sta SFX_Effect
	rts