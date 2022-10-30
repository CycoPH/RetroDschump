; All tables that the game uses

; =============================================================================
; Binary to decimal conversion
; =============================================================================

; 100 entries that map an index 0-99 to 10x0, 10x1, 10x2, ..., 10x9
; Divide by 10 table
; 100 bytes
Div10Table .rept 100
	.byte [*-Div10Table]/10
	.endr

; 100 entries that map an index to the 1s counter
; entry = i % 10
; ATASM does not have a modulus operator
; 100 bytes
Modulus10Table .rept 100
	.byte [*-Div10Table]%%10
	.endr
; Map from index to bit
BitIndex .byte 1,2,4,8,16,32,64,128

; =============================================================================
; G U I
; =============================================================================
WhichBoostChar	.byte 59,60,61,62

; =============================================================================
; C O L O R S
; =============================================================================
Color0Tbl	.byte 1,2,3,3,4,4,5,5,6, 6, 6, 7, 7, 8
Color1Tbl	.byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14
Color2Tbl	.byte 1,2,2,2,3,3,3,4,4, 4, 5, 5, 5, 6
Color3Tbl	.byte 0,0,1,1,1,1,2,2,2, 3, 3, 3, 4, 4

; =============================================================================
; S C A L E
; =============================================================================
ExpandTbl	.byte $0,$3,$C,$F,$30,$33,$3C,$3F,$C0,$C3,$CC,$CF,$F0,$F3,$FC,$FF

; =============================================================================
; G R A P H I C S
; =============================================================================

; ---------------------------------------------------------
; Default background of the level
; Used to fill the whole level before the actual level
; is drawn into the space. All blanks are not drawn.
; ---------------------------------------------------------
; Two lines of 32 bytes that get copies 64 times to fill the screen with the background info
; This is all the parallax scrolling info
; 7x background		6x(1 2 3)	7x background
SCREEN_BACKGROUND_SRC
	.byte 128,128, 128,128,128,128, 128,1,3,5, 1,3,5,1, 3,5,1,3, 5,1,3,5, 1,3,5,128, 128,128,128,128, 128,128		; 32 bytes of line 1
	.byte 128,128, 128,128,128,128, 128,2,4,6, 2,4,6,2, 4,6,2,4, 6,2,4,6, 2,4,6,128, 128,128,128,128, 128,128		; 32 bytes of line 1

	.include "tiles.asm"

; ---------------------------------------------------------
; Ball animation frames
; Source: DschumpBallTennisOneLayer.piskel
; https://www.cerebus.co.za/piskel/
; Exported to atari .asm with "Split pallete index into layers" turned on and the "Current colors" (3 colors) selected
;
; The ball animation is 24 lines (y) by 16 pixels (x) by 16 frames.
; The ball is created out of 4 sprites:
; Main: 	LEFT + RIGHT
; Overlay: 	LEFT + RIGHT
; ---------------------------------------------------------
; 16x 24 bytes offset
; Quick frame offset table: Map from index to offset into the ball animation
; Each entry is 24 bytes
; We use an index table instead of multiplying by 24 to get to a frame
FrameOffsetTbl .rept 16
			.word [*-FrameOffsetTbl]/2*22
			.endr

; 11x 14 bytes offset
WarpOffsetTbl .rept 11
			.word [*-WarpOffsetTbl]/2*14
			.endr

; ---------------------------------------------------------
; Ball animation frames
.include "DschumpBall.asm"

BallLeft = BallLeft0_lvl0_col0
BallRight = BallRight0_lvl0_col1
BallLeftOverlay = BallLeft0_lvl1_col0
BallRightOverlay = BallRight0_lvl1_col1

; ---------------------------------------------------------
; This is the exported piskel warp animation data
.include "DschumpWarp.asm"

PM_DschumpWarpOverlay = WarpFrm0_lvl1_col0

; ---------------------------------------------------------
.include "DschumpPop.asm"

PM_DschumpPopOverlay = POPFrm0_lvl1_col0