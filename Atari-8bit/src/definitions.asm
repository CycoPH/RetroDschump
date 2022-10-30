; =============================================================================
; Location of various areas
; =============================================================================

PLAYER 			= $7000		; Where is the RMT player to be located
SCREEN 			= $8000		; Level byte data is located here (4096 bytes)
MUSIC_DATA 		= $9000		; Where are the music and the sound effects located

LEVEL_DATA_ADDR	= $A000		; Decompressed level data goes here. Space not used by sprites (512 bytes)
PM_SPRITE 		= $A000		; Player/Missile graphics (Sprite memory location)
PM0 			= PM_SPRITE + $400
PM1 			= PM0 + $100
PM2 			= PM1 + $100
PM3 			= PM2 + $100

; =============================================================================
; Game data specifications
; =============================================================================
STEREOMODE	= 0

NUM_LIFES_RESET = 4			; 5 lifes (1 current + 4 extra)
BOOST_LEVEL_RESET = 8		; 8/32 is the starting power level

WIDTH_OF_SCREEN = 32
HEIGHT_OF_SCREEN = 21
VERTICAL_SCROLL_MAX = 8     ; ANTIC mode 4 has 8 scan lines
MAX_TOP_OF_SCREEN = (128-HEIGHT_OF_SCREEN)

; Scroll directions
SCROLL_UP = 128
NO_SCROLL = 0
SCROLL_DOWN = 1
INITIAL_SCROLL_DIRECTION = SCROLL_UP	; 128 to scroll up, 0 to stop scrolling, 1 to scroll down

; Ball direction
BALL_FORWARD = 1
BALL_BACKWARD = 128

; Parallax scrolling speed
PARALLAX_SPEED_BACKGROUND = 2
PARALLAX_SPEED_LEVEL1 = 3

; How far can the ball move
BALL_LEFT_LIMIT = 62
BALL_RIGHT_LIMIT = 178

BALL_TOP_LIMIT = 49
BALL_BOTTOM_LIMIT = 190

; X & Y start positions of the ball
BALL_START_LEVEL0_X = 160
BALL_START_X = 120
BALL_START_Y = 189
BALL_START_LEFT = 120-48

; Action bits
; For each action that needs to be performed ASAP
; there is one bit in the zpTriggerActions variable
DO_ACTION_PARALLAX = 1				; do parallax scrolling
DO_ACTION_COLLISION = 2				; at the bottom of the bounce check for tile action or fall
DO_BOOST_UPDATE = 4					; update the boost level indicator
DO_END_LEVEL = 8					; end the level
DO_WORM_HOLE = 16					; jump through a worm hole
DO_POP = 32							; pop the ball
DO_ADD_LIFE = 64					; Add life
DO_CRASH = 128

; Tile numbers
TILE_EMPTY = 0						; Nothing here fall down
TILE_WORM_HOLE = 1					; In and out somewhere else
TILE_SWITCH_UP_PINNED = 2			; Button off, no action yet
TILE_SWITCH_DOWN_PINNED = 3
TILE_SWITCH_UP_BLUE = 4
TILE_SWITCH_DOWN_BLUE = 5
TILE_SWITCH_UP_GREEN = 6
TILE_SWITCH_DOWN_GREEN = 7
TILE_SWITCH_UP = 8
TILE_SWITCH_DOWN = 9
TILE_SWITCH_ONCE_UP = 10
TILE_SWITCH_ONCE_DOWN = 11
TILE_BREAK1 = 12
TILE_BREAK2 = 13
TILE_BREAK3 = 14
TILE_THE_END = 15
TILE_MID_HOLE_PINNED = 16
TILE_MID_HOLE = 17
TILE_PICKUP_BLUE = 18
TILE_PICKUP_GREEN = 19
TILE_SWITCH_DIRECTION = 20			; Toggle scroll direction
TILE_DOWN_ARROW = 21				; Change scroll direction to down
TILE_UP_ARROW = 22					; Change scroll direction to up
TILE_SWITCH_STOP = 23
TILE_FAKE_BREAK1 = 24
TILE_FAKE_BREAK2 = 25
TILE_FAKE_BREAK3 = 26

BUILD_TILES = 32					; This is the start of the build tiles, no action on them
TILE_HOLE_CLOSED_PINNED = 32		; 17
TILE_FLAT_PINNED = 33
TILE_FLAT_2_PINS_TLBR = 34
TILE_FLAT_2_PINS_TRBL = 35
TILE_FLAT_NO_PINS = 36

TILE_HOLE_BLUE = 37
TILE_LEFT_RAISED = 38
TILE_MID_RAISED = 39
TILE_RIGHT_RAISED = 40
TILE_NEARLY_FLAT_NO_PINS = 41
TILE_HOLE_GREEN = 42
TILE_SWITCH_OFF_DOWN_PINNED = 43
TILE_SWITCH_OFF_DOWN_NO_PINS = 44

TILE_HOLE_GRAY = 45

; Sound effects used
SFX_PUSH = 15+0				; 1
SFX_END_OF_LEVEL = 15+1		; 3
SFX_NORMAL_BOUNCE = 15+2		; 6
SFX_SCORE_BOUNCE = 15+3		;7
SFX_FIRE = 15+4				; 11
SFX_ARROW = 15+4				; 11
SFX_PICKUP = 15+5				; 12
SFX_ADD_LIFE = 15+6			; 13
SFX_SWITCH = 15+7				; 15
SFX_BANG = 15+8				; 15 Fall into water
SFX_BREAK = 15+9				; 16
SFX_LEVEL_END = 15+10			; 19
SFX_WARP_IN = 15+11			; 20
SFX_NO_WARP = 15+12			; 22			; Worm hole is closed, sorry
SFX_NONE = $ff

; =============================================================================
; ATARI Hardware
; =============================================================================
BASICF = $3f8
