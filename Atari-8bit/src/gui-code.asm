; All the code and data to handle the title screen and in game gui
	.local
ResetGame
	jsr ResetLevel
	jsr ResetLifes
	jsr ResetBoostLevel
	jsr PlaceBallInLevel0
	rts

; ---------------------------------------------------------
; Into screen has one mode 6 line and one mode 4 line
; Copy the 6 bytes from DLGame -> GameOrIntroOverride
SwitchGameGui
	lda #>FONT_GAME_GUI	; Font of the GUI
	sta CHBAS

	ldx #5
?nextGameGuiByte
	lda DLGame,X
	sta GameOrIntroOverride,x
	dex
	bpl ?nextGameGuiByte

	rts

; ---------------------------------------------------------
; Intro screen has one mode 6 line and one mode 4 line
; Copy the 6 bytes from DLGame -> GameOrIntroOverride
Switch321Gui
	ldx #63				; Copy the level msg bytes
?NextMsgByte
	lda LevelHint,x
	sta GuiLevel,x
	dex
	bpl ?NextMsgByte

	ldx #5
?next321GuiByte
	lda DL321,X
	sta GameOrIntroOverride,x
	dex
	bpl ?next321GuiByte

	rts	

; ---------------------------------------------------------
; Intro screen has one mode 6 line and one mode 4 line
; Copy the 6 bytes from DLIntro -> GameOrIntroOverride
SwitchIntroGui
	ldx #5
?nextIntroGuiByte
	lda DLIntro,X
	sta GameOrIntroOverride,x
	dex
	bpl ?nextIntroGuiByte

	rts

; ---------------------------------------------------------
; Level counter handlers
ResetLevel
	lda #1
; ---------------------------------------------------------
; A = 0-99
SetLevel
	sta LevelCounter
; ---------------------------------------------------------
; Print the levelCounter into the two gui locations
DisplayLevelNumber
	; Clear the 10s
	lda #32
	sta LevelIndicatorTens
	lda #0
	sta GuiIntroLevelIndicator
	
	ldx LevelCounter
	; 10s
	lda Div10Table,x
	beq ?no10s
	clc
	adc #16
	sta LevelIndicatorTens
	sta GuiIntroLevelIndicator
?no10s	
	; 1s
	clc
	lda Modulus10Table,x
	adc #16
	sta LevelIndicatorOnes
	sta GuiIntroLevelIndicator+1
	rts

; ---------------------------------------------------------
; NextLevel()
; Increase the level counter
; Check if we've reached the end of the game
; Return: ACC = 0 - if no more levels are available (end the game)
;		  ACC = 1 - if the next level can be played
NextLevel
	inc LevelCounter	; used in the rest of the game
	; Check if we've hit the end of the levels
	; If that happens then we reset the whole game and start from 0
	lda LevelCounter
	asl
	tax
	lda AllLevels+1,x		; MSB of the level ptr
	cmp #255				; check for -1
	bne ?nextLevelIsOk

	lda #0
	rts

?nextLevelIsOk
	lda LevelCounter
	cmp MaxLevelReached
	bcc ?isBelowMaxLevel
	sta MaxLevelReached		; This is how far the player has gotten
?isBelowMaxLevel

	jsr SetLevel
	
	lda #1					; return 1 to indicate play next level
	rts

; ---------------------------------------------------------
; Lifes left handlers
ResetLifes
	lda #NUM_LIFES_RESET		; You start with 4 balls
	sta LifesLeft
	; fall through to display the lifes

DisplayLifes
	ldx #0						; start drawing on the left side
	ldy #NUM_LIFES_RESET

?drawLifesLoop
	cpy LifesLeft
	beq ?gotThisLife
	bcs ?notThisOne

?gotThisLife
	lda #27				; Left side of ball
	sta LifesIndicator,x
	inx
	lda #28				; Right side of ball
	sta LifesIndicator,x
	inx
	jmp ?nextOne
?notThisOne
	lda #32				; Blank for left and right of ball
	sta LifesIndicator,x
	inx
	sta LifesIndicator,x
	inx
?nextOne
	dey
	bne ?drawLifesLoop
	rts

; ---------------------------------------------------------
; Remove one life and display the life indicator
RemoveLife
	dec LifesLeft
	jmp DisplayLifes

; ---------------------------------------------------------
; Add one life and display the life indicator
AddLife
	inc LifesLeft
	lda LifesLeft
	cmp #NUM_LIFES_RESET
	bcs ?hitLimit
	jmp DisplayLifes
?hitLimit:	
	lda #NUM_LIFES_RESET
	sta LifesLeft
	jmp DisplayLifes

; ---------------------------------------------------------
ResetBoostLevel
	lda #BOOST_LEVEL_RESET
	sta BoostLevel
	; Fall through to draw the boost level bar

; Algo is:
; load level into Y
; while not end of bar
; 	if (level < 4) DrawEndOrClear
;	else DrawFullSegment
;	level -= 4
;	if (level < 0) level = 0
; 	
DisplayBoostLevel
	ldx #0			; start drawing with the first char
	ldy BoostLevel
?nextBoostLevel	
	cpy #4
	bcc ?endPhase
	; > 4 so draw full bar
	lda #63				; full bar segment (4 slots)
?drawBoostChar
	sta BoostBar,x		; draw the char
	inx					; move to next spot
	; take 4 off the boost level
	dey
	dey
	dey
	dey
	bpl ?noReset
	ldy #0
?noReset
	; Are there more chars to draw?
	cpx #8
	bcc ?nextBoostLevel

	; Clear the boost bar draw command
	lda zpTriggerActions
	and #DO_BOOST_UPDATE^$FF	; Clear the boost draw bit
	sta zpTriggerActions

	;ldx zpSaveX
	;ldy zpSaveY
	rts
?endPhase
	; Not a full bar, 0,1,2,3
	sty zpTemp3					; Save Y
	tya
	and #3
	tay
	lda WhichBoostChar,y		; This is the char to draw
	ldy zpTemp3
	jmp ?drawBoostChar

; ---------------------------------------------------------
; void AddBoost()
; Add 1 to the boost level
; Draws the new boost level
AddBoost
	inc BoostLevel				;+1 for the boost level

	lda #5
	jsr CheckToAddScore

	lda BoostLevel
?checkBoostTop
	cmp #33
	bcc ?boostIsOk
	lda #32
	sta BoostLevel
?boostIsOk
	jmp DisplayBoostLevel		; That will return from the function

; ---------------------------------------------------------
; void AddBoostPacket(Acc)
; Acc = is the amount to add to the boost level
; Draws the new boost level
AddBoostPacket
	clc
	adc BoostLevel
	sta BoostLevel
	jmp ?checkBoostTop

; --------------------------------------------------------
; DRAW SCORE
; 0 1 2 3 4 5 6
DrawScore	
	ldx Score
	; 10s
	lda Div10Table,x
	clc
	adc #16
	sta ScoreIndicator+5
	; 1s
	lda Modulus10Table,x
	adc #16
	sta ScoreIndicator+6
	; 1000s
	ldx Score+1
	lda Div10Table,x
	adc #16
	sta ScoreIndicator+3
	; 100s
	lda Modulus10Table,x
	adc #16
	sta ScoreIndicator+4
	; 100000s
	ldx Score+2
	lda Div10Table,x
	adc #16
	sta ScoreIndicator+1
	; 10000s
	lda Modulus10Table,x
	adc #16
	sta ScoreIndicator+2
	;
	ldx Score+3
	lda Modulus10Table,x
	adc #16
	sta ScoreIndicator
	rts

; --------------------------------------------------------
; ADD SCORE
; Add Acc to the "score"
Add2Score
	;!##TRACE "add score xy=%d,%d,%d,%d + %d" db(score) db(score+1) db(score+2) db(score+3) @a
	clc					; a = a + score[0] 
	adc Score
	cmp #100			; if a >= 100
	bcc ?below100Lo		; set carry
	sbc #100			; a = a - 100
?below100Lo:		
	sta Score			; store the remainder in score
	bcc ?endScoreAdd	; if no carry is set then no overflow past 100

	; There was overflow past 100 add 1 to the next byte of the score
	lda Score+1			; a = score[1]
	adc #0				; a = a + 1
	cmp #100			; if a >= 100
	bcc ?below100Hi		;
	sbc #100
?below100Hi		
	sta Score+1
	bcc ?endScoreAdd	; if no carry is set then no overflow past 100

	; There was overflow past 100 add 1 to the next byte of the score
	lda Score+2			; a = score[1]
	adc #0				; a = a + 1
	cmp #100			; if a >= 100
	bcc ?below100_B2	;
	sbc #100
?below100_B2
	sta Score+2
	bcc ?endScoreAdd	; if no carry is set then no overflow past 100

	inc Score+3
?endScoreAdd
	rts

; --------------------------------------------------------
; ACC = # of points to add
CheckToAddScore
	sta scoreToAdd			; Save the points to add for later
	; First check if the score at this position has already been given
	; zpCollisionX & zpCollisionY
	ldy zpCollisionX
	ldx BitIndex,y			; Which bit are we working with
	stx ?CheckValue

	ldy zpCollisionY
	lda LevelHitInfo,y		; Get the byte for the level line: ACC = LevelHitInfo[zpCollisionY]
	and #0					; SMC: store the value we are checking here
?CheckValue = *-1
	bne ?addToScore
	rts

?addToScore:
	; Clear the bit
	txa						; Invert all the bits and get ready to and the current level info with it
	eor #$FF
	sta ?AndValue

	lda #SFX_SCORE_BOUNCE
	sta SFX_Effect

	lda LevelHitInfo,y
	and #0
?AndValue = *-1
	sta LevelHitInfo,y

	; The bit has now been cleared
	; Now add the score for this tile
	lda scoreToAdd
JustAddScore
	jsr Add2Score
	jsr DrawScore
	rts

; --------------------------------------------------------
ResetScore
	lda #0
	sta Score
	sta Score+1
	sta Score+2
	sta Score+3
	jsr DrawScore
	rts