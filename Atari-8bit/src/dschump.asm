; Memory layout:
; $6CE0 - $6FFF		Music player tables		(800 bytes)
; $7000 - $7326		Raster Music player		(806 bytes)
; $7327 - $77FF		FREE 					(1241 bytes)	==========
; $7800 - $7AE7		GUI font 				(232 bytes)
; $7A00 - $7AE7		GUI font 				(232 bytes)
; $7AE8 - $7B1E		Dislay Lists 			(55 bytes)
; $7B1F - $7B48		Level Hit Info			(42 bytes)
; $7B49 - $7BFF		FREE					(183 bytes)		==========
; $7C00 - $7FFF		Tile font				(1024 bytes)
; $8000 - $8FFF		Screen 					(4096 bytes)   
; $9000 - 			Music data
; $A000 - player missile $2000 (2048) in the basic area
; $A000 - $A1FF		Decompressed level data	(512 bytes)
; $A200 - $A3ff
; $A400 - 			Player 0
; $A500 - 			Player 1
; $A600 - 			Player 2
; $A700 - 			Player 3
; $A800 - $A9FF		End of game font		(512 bytes)


; Load the hardware port definitions
.OPT NO SYMDUMP
.include "POKEY.asm"
.include "ANTIC.asm"
.include "GTIA.asm"
.include "OS.asm"
.include "PIA.asm"
.OPT SYMDUMP

.include "definitions.asm"
.include "zero_page.asm"				; Define every piece of zero-page that we use

; Setup the boot loader code to remove BASIC
; LOADER => $2000
; INITAD => $2000
; Using .bank to force assembler to output the $2000, $2e2 sections first
.include "boot_loader.asm"

; ---------------------------------------------------------
; Start the actual game => $2000+xyz
	.bank
	.local
	* = GAME_LOAD_FROM_HERE; $2000 + size of decompressor and some other useful stuff
BOOT_THIS
	; Check for fire button click and release
?WaitForBoot
	lda STRIG0
	bne ?WaitForBoot
?StartPlayBoot
	lda STRIG0
	beq ?StartPlayBoot
	;
	; Set some basic variables
	.IF ONLY1LEVEL
	lda #1
	.ELSE
	lda #4
	.ENDIF
	sta MaxLevelReached

	; The game is loaded and we need to setup some things
	; Init POKEY
	lda #3				; Enable keyboard debounce/scanning
	sta SKCTL
	lda #0
	sta AUDCTL
	; Turn off ANTIC; makes machine 30% faster. Will enable the screen again when all is done
	;lda #0
	sta SDMCTL			; disable screen
	;sta VBIMode		; tell the VBI not to do anything

	; Save the original font of the machine
	lda CHBAS
	sta OriginalFontAddr

	jsr DetectPALorNTSC

	jsr ResetAudio

	jsr InitPM

	; Setup font usage
	jsr InitParallax

	; Setup display list in shadow reg, VBI will activate it
	lda #<DisplayList
	sta SDLSTL
	lda #>DisplayList
	sta SDLSTL+1

	; Load deferred vertical blank address
	ldx #>VBI
	ldy #<VBI
	lda #7
	jsr SETVBV

	; activate display list interrupt
	;lda #NMI_VBI|NMI_DLI
	;sta NMIEN	

	lda #1
	sta KBCODE				; Reset POKEY

	; -----------------------------------------------------
StartAllOver:
	lda #>FONT_GUI			; Font of the GUI
	sta CHBAS
	
	; Wait for button to be release
?waitForFireRelease
	lda STRIG0
	beq ?waitForFireRelease
	
	; Tell the VBI to do something
	lda #DO_VBI_MUSIC+DO_VBI_SCROLL+DO_VBI_BALL_ANIMATION+DO_DRAW_BALL+DO_LIMIT_MOVEMENT
	sta VBIMode

	jsr TurnOff
	jsr ClearPMG
	
	jsr SwitchIntroGui	; Show the intro gui

	jsr ResetGame		; Level 0, 4 lifes, 8 power, ball off to the right

	jsr PlayIntroMusic	; Start the intro music

EnterFromHelpScreen
	; Load the intro level
	lda #0
	sta zpLastJoystick
	jsr DecompressLevel				; unpack the level
	jsr InitScreen					; draw it
	jsr SetScreenStartPosition		; reset to the bottom

	; DLI for the intro
	lda #<DLIIntro
	sta VDSLST
	lda #>DLIIntro
	sta VDSLST+1

	jsr BlankGameScreen				; Make 100% sure the level screen is black

	lda #0							; Reset clock
	sta RTCLOK60
	
	jsr TurnOn						; Show the screen
	jsr	WaitForVBI
	jsr FadeIn
	
; -----------------------------------------------
WaitStart
	jsr WaitForVBI

	; Do parallax scrolling?
	lda zpTriggerActions
	and #DO_ACTION_PARALLAX			; Check if we need to do fake parallax scrolling
	beq ?noActionParallaxIntro
	; Yes do it
	jsr DoParallaxScrolling
?noActionParallaxIntro

	; Check for joystick Up/Down movement
	; Trigger the +- level operation once and wait until the stick returns to 15
	lda zpLastJoystick				; if (lastStick != 15) lastStick <= read joystick
	cmp #15							; 15 = no movement
	beq ?noStickStore
	lda STICK0						; get and store the stick position
	sta zpLastJoystick
?noStickStore
	lda STICK0						; Get the stick movement
	cmp	zpLastJoystick				; compare to the stored value
	sta zpLastJoystick				; save the new value
	beq ?noMenuMove					; if == then no level change

	; Check stick direction
	and #1							; if up then increase level number
	bne ?stickNotUp

	inc LevelCounter				; ++level
	
?stickNotUp
	; Check for stick down
	lda zpLastJoystick
	and #2
	bne ?stickNotDown

	dec LevelCounter				; --level
?stickNotDown
	
	; Check limits: 1 <= x <= MaxLevelReached
	lda LevelCounter
	beq ?setTo1						; <= 0 then set to 1
	bmi ?setTo1						; >= 128 then set to 1
	; Check top
	cmp MaxLevelReached
	bcs ?setToLimit
	bne ?allOk
?setTo1
	lda #1
	bne ?allOk
?setToLimit
	lda MaxLevelReached

?allok
	jsr SetLevel					; ACC = level #

?noMenuMove

	; Check for fire button
	lda STRIG0
	beq StartTheGame

	; Check for START key
	lda CONSOL
	and #1
	beq StartTheGame

	; Check for SELECT key
	lda CONSOL
	and #CONSOLE_SELECT
	beq StartHelpScreen
	
	; Loop for ever
	jmp WaitStart

; -----------------------------------------------
StartHelpScreen
	jmp ShowHelpScreen

; -----------------------------------------------
StartTheGame:
	jsr ResetScore					; Score = 0 and draw it

; -----------------------------------------------
; Reset everything and start playing a level
StartPlay:
	jsr FadeOut						; Fade to black game screen

	jsr TurnOff						; Hide everything
	jsr ClearPMG					; Clear the ball
	
	jsr InitMusic					; Silence the music

	; Load the level data
	lda LevelCounter
	jsr DecompressLevel				; unpack the level
	jsr InitScreen					; draw it
	jsr SetScreenStartPosition		; reset to the bottom

	lda LevelCounter
	jsr DisplayLevelNumber			; draw the level # into the gui

	; Clear all the counters
	lda #0
	sta zpTriggerActions
	sta VBIMode						; VB does nothing!
	sta DelayMovement
	sta DelayFrameAnim
	sta BallFrameCounter			; Reset the ball animation to the bottom/start frame

	jsr SetBallStartPosition		; Set where the ball will start
	jsr DrawBall					; Draw the ball onto the screen

	jsr BlankGameScreen				; Make 100% sure the level is black

	; Switch to the 3 2 1 message setup
	jsr Switch321Gui
	lda #1							; With top gui hint lines shown
	sta DingDingDongMode

	lda #<DLICount321				; Turn on the 3 2 1 DLI
	sta VDSLST
	lda #>DLICount321
	sta VDSLST+1

	jsr TurnOn						; DLI, VBI and screen are now on

	jsr	WaitForVBI

	; Wait for button to be released
?waitForRelease
	lda STRIG0
	beq ?waitForRelease

	lda #DO_VBI_MUSIC				; VBI plays music
	sta VBIMode

	jsr ShowGameScreen				; Make sure that the game DLI has the correct colors set

	jsr PlayDingDingDong

	lda #0							; Without top gui changes
	sta DingDingDongMode

	; -------------------------------------------------
	; MAIN GAME LOOP
	; -------------------------------------------------
	lda #DO_VBI_MUSIC+DO_VBI_SCROLL+DO_VBI_BALL_ANIMATION+DO_VBI_MOVEMENT+DO_DRAW_BALL+DO_LIMIT_MOVEMENT
	sta VBIMode						; Turn on all VBI processing

	lda #255						; Clear the ESC flag
	sta CH

GameLoop
	lda RTCLOK60					; Wait for a refresh
?wait	
	cmp RTCLOK60
	beq ?wait

	; Check if there is anything that needs to be done
	lda zpTriggerActions
	beq GameLoop		; just wait until something is supposed to happen

	; -------------------------------------------------
	; Do parallax scrolling
	;
	lda zpTriggerActions
	and #DO_ACTION_PARALLAX			; Check if we need to do fake parallax scrolling
	beq ?noActionParallax
	; 
	; Yes, fake it
	;
	jsr DoParallaxScrolling
?noActionParallax

	; -------------------------------------------------
	; Do collision detection
	;
	lda zpTriggerActions			; Which action is to be triggered?
	and #DO_ACTION_COLLISION		; are we to do collision detection with the ball at the bottom of the bounce
	beq ?noActionCollision

	jsr CalcTileCollision			; zpCollision

	; Dispatch whatever there is to do at this bounce position
	jsr ActionCollision
	; This function can set other action bits

	; -----------------------------------------------------
?noActionCollision

	lda zpTriggerActions			; Which action is to be triggered?
	and #DO_BOOST_UPDATE			; give the player a power boost?
	beq ?noBoostUpdate

	jsr DisplayBoostLevel			; Update the boost level bar

?noBoostUpdate
	; -----------------------------------------------------
	lda zpTriggerActions			; Which action is to be triggered?
	and #DO_END_LEVEL				; end the level?
	beq ?noEndLevel

	jmp EndLevel
?noEndLevel

	; -----------------------------------------------------
	lda zpTriggerActions			; Which action is to be triggered?
	and #DO_WORM_HOLE				; go down a worm hole
	beq ?noWormhole

	jsr DoWormhole
?noWormhole

	; -----------------------------------------------------
	lda zpTriggerActions			; Which action is to be triggered?
	and #DO_CRASH					; Fall into the water
	beq ?noFalling

	jsr DoFallIntoWater
?noFalling

	; -----------------------------------------------------
	lda zpTriggerActions			; Which action is to be triggered?
	and #DO_POP						; Pop the ball
	beq ?noPopping

	jsr DoPopTheBall
?noPopping

	; -----------------------------------------------------
	lda zpTriggerActions			; Which action is to be triggered?
	and #DO_ADD_LIFE				; Add life
	beq ?noAddLife

	jsr DoAddLife
?noAddLife
	
	; -----------------------------------------------------
	; Nothing else to do but loop
	lda #0
	sta zpTriggerActions

	; Test the the ESC key
	lda CH
	cmp #28
	bne ?noESC
	lda #255
	sta CH
	jmp StartAllOver
?noESC

	jmp GameLoop

; ---------------------------------------------------------
; The game DLI will use these colors for COLPF0-3
BlankGameScreen:
	lda #0
	sta storeCol0
	sta storeCol1
	sta storeCol2
	sta storeCol3
	rts

; ---------------------------------------------------------
; With NTSC modifiers
ShowGameScreen:
	ldx #13
	lda Color0Tbl,X
	sta storeCol0
	lda Color1Tbl,X
	sta storeCol1
	lda Color2Tbl,X
	ora #$80
storeCol2ShowGameScreen = *-1	; NTSC Self Modifying Code
	sta storeCol2
	lda Color3Tbl,X
	ora #$A0
storeCol3ShowGameScreen = *-1	; NTSC Self Modifying Code
	sta storeCol3
	rts

; ---------------------------------------------------------
; Fade from black to the final game colours
; With NTSC modifiers
FadeIn
	ldx #0
?finloop
	jsr WaitForVBI
	lda Color0Tbl,X
	sta storeCol0
	lda Color1Tbl,X
	sta storeCol1
	lda Color2Tbl,X
	ora #$80
storeCol2SFadeIn = *-1			; NTSC Self Modifying Code
	sta storeCol2
	lda Color3Tbl,X
	ora #$A0
storeCol3SFadeIn = *-1			; NTSC Self Modifying Code
	sta storeCol3
	inx
	cpx #14
	bne ?finloop
	rts

; -----------------------------------------------
; Fade to black
; With NTSC modifiers
FadeOut
	ldx #13
?foutloop
	jsr WaitForVBI
	lda Color0Tbl,X
	sta storeCol0
	lda Color1Tbl,X
	sta storeCol1
	lda Color2Tbl,X
	ora #$80
storeCol2SFadeOut = *-1	
	sta storeCol2
	lda Color3Tbl,X
	ora #$A0
storeCol3SFadeOut = *-1
	sta storeCol3
	dex
	dex
	bpl ?foutloop
	jsr BlankGameScreen
	rts

; ---------------------------------------------------------
; Fill the screen with the default parallax scrolling data
InitScreen
	; Copy the 64 bytes from the (SCREEN_BACKGROUND_SRC) to the (zpDrawPtr) 64 tiles
	lda #<SCREEN_BACKGROUND_SRC		; Setup src ptr
	sta zpFromL
	lda #>SCREEN_BACKGROUND_SRC
	sta zpFromH

	lda #<SCREEN					; Setup dest ptr
	sta zpDrawPtrL
	lda #>SCREEN
	sta zpDrawPtrH
	; Copy 64x 64 chars (4096 to fill the whole level)
	ldx #64
?copyNextBackground64
	ldy #64		; byte counter
?copyBackgroundInner
	lda (zpFrom),y
	sta (zpDrawPtr),y
	dey
	bpl ?copyBackgroundInner
	; Add 64 to draw target
	clc
	lda zpDrawPtrL
	adc #64
	sta zpDrawPtrL
	lda #0
	adc zpDrawPtrH
	sta zpDrawPtrH
	; Next block
	dex						
	bne ?copyNextBackground64
	; screen is now filled with background info

	; Draw the level
	lda #[<SCREEN]+2		; Start drawing the level 2 bytes into the screen space
	sta zpDrawPtrL
	lda #>SCREEN
	sta zpDrawPtrH

	lda #<Level				; Setup the source ptr
	sta zpLevelPtrL
	lda #>Level
	sta zpLevelPtrH

	lda #42
	sta zpGenCounter		; How many level lines to draw?

	ldy #0
?nextLevelLine		
	ldx #7					; 7 bytes/tiles per line
?nextTile
	lda	(zpLevelPtr), y
	jsr DrawTile
	iny
	dex
	bne ?nextTile			; Still got items on the line

	dec zpGenCounter
	beq ?endOfLevelDraw

	iny					; skip byte 8
	; if Y == 0 then we've done 256 bytes and we move the zpLevelPtr by 256
	cpy #0
	bne ?stillInSamePage
	;
	; Page is full, bump the H 
	inc zpLevelPtrH
?stillInSamePage

	; Skip to next draw position
	clc
	lda zpDrawPtrL
	adc #4+32*2
	sta zpDrawPtrL
	bcc ?noCarryDraw1
	inc zpDrawPtrH
?noCarryDraw1
	jmp ?nextLevelLine
?endOfLevelDraw
	; fall through to ResetLevelInfo

; ---------------------------------------------------------
ResetLevelInfo
	lda LevelDirection
	sta zpScrollDirection
	bmi ?resetUp
	lda #0
	beq ?resetStore
?resetUp
	lda #7
?resetStore
	sta zpFineScroll
	sta VSCROL			; initialize hardware register

	rts

; ---------------------------------------------------------
SetScreenStartPosition
	; Move the display to the bottom of the level
	; lda #126-HEIGHT_OF_SCREEN
	lda LevelScreenTop
	sta zpTopOfScreen					; This is the first line visible of the level
	; Fall through to the routine that sets the value

; Acc = top of screen
SetScreenTopPosition
	ldx #0
	stx zpTemp
	
	asl
	rol zpTemp
	asl
	rol zpTemp
	asl
	rol zpTemp
	asl
	rol zpTemp
	asl
	rol zpTemp
	; A = top*32 low
	; zpTemp = top*32 high
	clc
	adc #<screen
	sta DisplayListVscrollAddress
	lda #>screen
	adc zpTemp
	sta DisplayListVscrollAddress+1

	rts
	
; ---------------------------------------------------------
; Set a tile in the level and draw it onto the screen
;
; SetNewTile(zpLevelOffset, zpLevelTile)
; Input: 
; 	(zpLevelOffset) - # of bytes into the level (0-335), note each line is 8 bytes wide
;	zpLevelTile
; Returns:
;	zpGenCounter - The tile what used to be at the level
SetNewTile
	; Calc the (zpLevelPtr) to the tile to be updated
	clc							; Setup (zpLevelPtr) = where to draw to
	lda zpLevelOffsetL
	adc #<Level
	sta zpLevelPtrL
	lda #>Level
	adc zpLevelOffsetH
	sta zpLevelPtrH

	; zpLevelPrevTile = Level[zpLevelOffset] - Get the tile that is currently at this level index
	ldy #0
	lda (zpLevelPtr), y
	sta zpLevelPrevTile
	; Set the new tile in the level data
	lda zpLevelTile
	sta (zpLevelPtr), y			; Level[zpLevelOffset] = zpLevelTile

	; Now draw the tile onto the screen
	; (zpLevelOffset) = 6 bit (Y) | 3 bit (X)
	; Convert that into: (zpDrawPtrL) = #Screen + (Y * 3*32) + (X*4+2)
	; (zpDrawPtr) will be the place where we start drawing the tile
	lda zpLevelOffsetL
	and #7
	asl
	asl
	adc #2
	sta zpDrawPtrL
	sta zpFromL

	; Shift the Y (6 bits) so that we can add to 2x to get a total of 3* Y
	lda zpLevelOffsetH
	sta zpTemp				; zpTemp = High byte of level offset
	lda zpLevelOffsetL
	and #~11111000			; Mask off X (3 bits)
	lsr zpTemp				; 1 1111 1000 (Y in top 6 bits) move the bit 0 into carry flag
	ror						; 0 1111 1100 (Y in low byte now) move carry flag into bit 7
	lsr						; 0 0111 1110 (This is now Y*2)
	sta zpTemp				; Y * 2
	lsr						; 0 0011 1111
	sta zpFromH
	adc zpTemp				; Acc = Y + (Y*2) i.e. Acc = Y*3
	; Now we need to multiply by 32 to get the index into the screen
	ldx #0
	stx zpToH
	asl						; Y = Y * 2
	rol zpToH				; total * 2
	asl
	rol zpToH				; total * 4
	asl
	rol zpToH				; total * 8
	asl
	rol zpToH				; total * 16
	asl
	rol zpToH				; total * 32
	;sta zpPrintPtrL			; (zpPrintPtrL, zpToH) = Y Offset and zpFromL is the X Offset
	; (zpTo) = byte offset of Y
	; Add the already calculated X
	clc
	adc zpDrawPtrL
	sta zpDrawPtrL
	lda #>screen
	adc zpToH
	sta zpDrawPtrH

	lda zpLevelTile
	beq SpecialBlankDraw
	jmp DrawTile

; ---------------------------------------------------------
; Draw a blank tile.
; Not as easy as drawing a normal 4x3 tile as we need to copy the correct
; data from the SCREEN_BACKGROUND_SRC array, which is:
; - 32x2 bytes
; - 2 lines of background image
SpecialBlankDraw:
	; (zpDrawPtr) where to draw the tile to
	; zpFromH = tile Y offset
	; zpFromL = tile X Offset
	;
	lda zpFromH
	and #1				; only interested in bit 0
	asl
	asl
	asl
	asl
	asl					; Y offset into SCREEN_BACKGROUND_SRC
	clc
	adc zpFromL
	tax					; Reg X = (YOffset & 1) * 32 => the offset into line 0 or line 1 of the background 
	
	ldy #0				; Y = draw offset (4 bytes per tile line)
?myDraw
	lda SCREEN_BACKGROUND_SRC,x
	sta (zpDrawPtr),y
	iny
	lda SCREEN_BACKGROUND_SRC+1,x
	sta (zpDrawPtr),y
	iny
	lda SCREEN_BACKGROUND_SRC+2,x
	sta (zpDrawPtr),y
	iny
	lda SCREEN_BACKGROUND_SRC+3,x
	sta (zpDrawPtr),y
	; Move the drawing ptr
	tya
	clc
	adc #32-3
	tay
	; move the src ptr (x); Line 0 (0-31)-> Line 1(32-63) -> Line 0
	txa
	adc #32				; Move to next line
	and #63				; wrap around at 64
	tax

	cpy #32*3			; If the Y-offset < 3 lines then draw next line
	bcc ?myDraw

	rts

; ---------------------------------------------------------
; (zpDrawPtr) where to draw the tile to
; A = tile #
; X & Y are preserved
; Acc=Tile # => (zpFrom)
; (zpDrawPtr) is moved to the position of the next tile
	.LOCAL
DrawTile
	cmp #0
	bne ?drawIt
	; Skip the 0 tile, just move 4 forward
	clc
	lda zpDrawPtrL
	adc #4
	sta zpDrawPtrL
	bcc ?noCarryDraw1
	inc zpDrawPtrH
?noCarryDraw1
	rts
	; Go and draw a tile
?drawIt	
	; Save X & Y
	stx zpSaveX
	sty zpSaveY

	; Get the src address of the tile into (zpFrom)
	asl		; *2
	tax
	lda tiles,x
	sta zpFromL
	lda tiles+1,x
	sta zpFromH

	; Draw 4 bytes per loop
	ldx #3
?loopDraw
	ldy #0
	lda (zpFrom),y
	sta (zpDrawPtr),y
	iny
	lda (zpFrom),y
	sta (zpDrawPtr),y
	iny
	lda (zpFrom),y
	sta (zpDrawPtr),y
	iny
	lda (zpFrom),y
	sta (zpDrawPtr),y
	; Move the drawing ptr
	clc
	lda zpDrawPtrL
	adc #32
	sta zpDrawPtrL
	bcc ?noCarryDraw
	inc zpDrawPtrH
?noCarryDraw
	; Move the src ptr
	clc
	lda zpFromL
	adc #4
	sta zpFromL
	bcc ?noCarryFrom
	inc zpFromH
?noCarryFrom
	dex
	bne ?loopDraw
	; Adjust the draw ptr to the start of the next tile
	sec
	lda zpDrawPtrL
	sbc #WIDTH_OF_SCREEN*3-4
	sta zpDrawPtrL
	lda zpDrawPtrH
	sbc #0
	sta zpDrawPtrH
	; Restore X & Y
	ldx zpSaveX
	ldy zpSaveY
	rts

; =============================================================================
; Include the other source files
; Will all be injected into the $2000... range
; =============================================================================

	.include "events.asm"
	.include "collision_actions.asm"

	.include "pmgraphics.asm"
	.include "scrolling.asm"

	.include "dli.asm"
	.include "vbi.asm"

	.include "parallax.asm"
	.include "gui-code.asm"

	.include "tables.asm"
	.include "variables.asm"
	.include "colours.asm"

	.include "levels.asm"

	; Music
	.include "music/music.asm"
	;
	; The end of the $2000... space

	.include "gui-data.asm"


	.include "font_end.asm"				; $A800
	.include "font_gui.asm"				; $7800 - $7AE7
	.include "display_list.asm"			; $7AE8 - $7B1D
	.include "font_tiles.asm"			; $7C00

	.include "level_layout.asm"			; $7000

; ---------------------------------------------------------	
; Tell DOS where to boot the program when loaded
	.bank
	* = $A000 + 40*15
	.sbyte "Fire to start..."
	.bank
	* = $2e0
	.word BOOT_THIS
