; Each level takes:
; 336 bytes - level data(8 * 42)
; 32 bytes - switch position table(16 * 2 bytes per position)
; 32 bytes - switch target position table(16 * 2 bytes per position)
; 16 bytes - switch action table(which tile is being switched in)
; 16 bytes - wormhole in position(16 * 2 byte per position)
; 16 bytes - wormhole out position(16 * 2 byte per position)
; 1 byte - level start x position
; 53 bytes - level hint
; 502 bytes in total
; Total level length:
; 	502 byte level info
; 10 bytes free
	* = LEVEL_DATA_ADDR
Level:
	.ds [8*42]		; 336 bytes

; 16 switch positions (32 bytes)
SwitchPositions:
	.ds [16*2]

; 16 switch target positions(32 bytes)
SwitchTarget:		; x,y - 1 to terminate list
	.ds [16*2]

;16 switch tile nr(these are the items that will be inserted into the map)
SwitchWhat:		; 16 bytes
	.ds 16

; 8 wormhole in positions (16 bytes)
WormholeIn:
	.ds [8*2]

; 8 wormhole out positions (16 bytes)
WormholeOut:
	.ds [8*2]

; Which tile is the ball starting on?
; 0-left most, 3-middle, 6-right most
; Each starting position is 16 pixels
LevelStartX = Level+0*8+7
LevelStartY = Level+1*8+7
LevelScreenTop = Level+2*8+7
LevelDirection = Level+3*8+7

; This text gets copied to GuiLevelMsg after the level has been decoded
LevelHint:
	.ds 64

; Mark level hit position
; If a bit is marked then a score can be gotten here, but you can only score it once.
; If the score was given then the bit is cleared.
; NOTE: This data is NOT loaded, but calculated once the level is unpacked!
; 42 bytes. 1 byte per level line, 1 bit per tile
* = END_OF_DISPLAY_LISTS
LevelHitInfo:
	.ds 42
