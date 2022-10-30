; All the general variables that the game uses

; 32-bit score counter
;Score		.byte 0,0,0,0
;ScoreToAdd	.byte 0			; How much is being added to the score

; =============================================================================
; Location of the ball and animation info
; =============================================================================
;BallXPosition		= zpVariables	;.byte BALL_START_X
;BallYPosition		= zpVariables+1	;.byte BALL_START_Y
;BallFrameCounter	.byte 0
;BallDirection		.byte BALL_FORWARD
;NextBallDirection	.byte 0					; If non-zero then its the direction the ball will move on the next bounce

; =============================================================================
; GUI variables
; =============================================================================
;LevelCounter	.byte 1			; Used by the rest of the game to access the level information
;MaxLevelReached	.byte 4			; How far did we get in the game, give 3+1 levels grace
;LifesLeft		.byte 0			; How many lifes are left
;BoostLevel		.byte 0			; 0 - 32
OriginalFontAddr .byte 0		; Where is the original font located

