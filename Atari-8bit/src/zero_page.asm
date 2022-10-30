;
; All zero page definitions go here
;
; ---------------------------
; unzx5 $80 - $8F

; =============================================================================
; Location of the ball and animation info
; =============================================================================
zpVariables = $90
BallXPosition		= zpVariables	;.byte BALL_START_X
BallYPosition		= zpVariables+1	;.byte BALL_START_Y
BallFrameCounter	= zpVariables+2
BallDirection		= zpVariables+3
NextBallDirection	= zpVariables+4
PushBall			= zpVariables+5

; =============================================================================
; GUI variables
; =============================================================================
LevelCounter		= zpVariables+6
MaxLevelReached		= zpVariables+7
LifesLeft			= zpVariables+8
BoostLevel			= zpVariables+9

; 32-bit score counter
Score				= zpVariables+10 ;11,12,13
ScoreToAdd			= zpVariables+14

; $9F free

; ---------------------------------------------------------
zp_Info = $A0
zpTriggerActions = zp_Info			; the main loop will wait until this value is non-zero
zpScrollDirection = zp_Info+1		; 0-stand still, 1-up, $80-down

zpParallaxCounter0 = zp_Info+2
zpParallaxCounter1_6 = zp_Info+3

zpSpriteTemp = zp_Info+4;
zpSpriteTempL = zp_Info+4;
zpSpriteTempH = zp_Info+5

zpTemp = zp_Info+6
zpTemp2 = zp_Info+7

outputPointer = zp_Info+8			; 2 bytes 8+9

; ---------------------------------------------------------
; Zero-page for the RasterMusicPlayer
; $CB - $DD (19 bytes)
; ---------------------------------------------------------
; Zero-page for the game
; $E0 - $FF (32 bytes)
z_Regs = $E0
; zpFrom and to should NOT be used in the VBI or DLI
; General copy ptr (FROM)
zpFrom = z_Regs
zpFromL  = z_Regs
zpFromH  = z_Regs+1
; General copy ptr (TO)
zpTo = z_Regs+2
zpToL  = z_Regs+2
zpToH  = z_Regs+3

; Screen draw ptr
zpDrawPtr = z_Regs+4
zpDrawPtrL = z_Regs+4
zpDrawPtrH = z_Regs+5

zpSaveX = z_Regs+6
zpSaveY = z_Regs+7

zpLevelPtr = z_Regs+8
zpLevelPtrL = z_Regs+8
zpLevelPtrH = z_Regs+9
zpLevelOffsetL = z_Regs+$A	; 16-bit number = X + Y*8
zpLevelOffsetH = z_Regs+$B	;
zpLevelTile = z_Regs+$C		; Can share this reg
zpLevelPrevTile = z_Regs+$D
zpGenCounter = z_Regs+$C	; Used to draw the screen

zpLevelAction = z_Regs+$E
zpLevelActionL = z_Regs+$E	; Offset in the level where the action is going to take place. Wormhole exit
zpLevelActionH = z_Regs+$F

zpTopOfScreen = z_Regs+$10	; Value can range from 0 -> 128-screen_height; This is the current top of the screen
zpFineScroll = z_Regs+$11	; Value used to store VSCROL value

zpSpriteFrom = z_Regs+$12
zpSpriteFromL = z_Regs+$12
zpSpriteFromH = z_Regs+$13

zpSpriteTo = z_Regs+$14
zpSpriteToL = z_Regs+$14
zpSpriteToH = z_Regs+$15

zpCollisionX = z_Regs+$16		; horizontal tile# we are jumping on
zpCollisionY = z_Regs+$17		; vertical tile# we are jumping on
zpCollisionTileNr = z_Regs+$18	; Which tile did we collide with
zpCollisionCentre = z_Regs+$19;	; clear if we did not hit the 8x8 centre of the tile

;zpPrintPtr = z_Regs+$1A			; Printing to a location
;zpPrintPtrL = z_Regs+$1A
;zpPrintPtrH = z_Regs+$1B
;zpAltFromPtr = z_Regs+$1A			; alternative from ptr
;zpAltFromPtrL = z_Regs+$1A
;zpAltFromPtrH = z_Regs+$1B
zpVar1 = z_Regs+$1A
zpVar2 = z_Regs+$1B

zpConfig = z_Regs+$1C			; Each bit can be used to disable a specific feature
								; bit 1 - no sound
zpSfx = z_Regs+$1D
zpLastJoystick = z_Regs+$1E		; Last joystick value

zpTemp3 = z_Regs+$1F

