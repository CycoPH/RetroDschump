; All code related to levels
; CalcLevelPosition - X,Y => zpLevelPtr, zpLevelOffset

; Calculate the level position
; Input:
; 	X-reg = x position
; 	Y-reg = y position
; Output:
;	(zpLevelPtr) pointing to the tile in question
;	(zpLevelOffset) 16-bit offset of the tile in the level
CalcLevelPosition
	txa
	sta zpLevelPtrL		; Store X position in L
	tya 				; Store Y postion in zpTemp
	sta zpTemp

	lda #0
	sta zpLevelPtrH		; Clear H
	
	; 16-bit (y,acc) * 8
	clc					; clear carry and shift 3x
	asl zpTemp			; << 1
	rol					; carry into bit 0
	asl zpTemp			; << 1
	rol					; carry into bit 0
	asl zpTemp			; << 1
	rol					; carry into bit 0
	tax					; save Acc - High byte of result

	; Add the low byte remainder in zpTemp to zpLevelPtrL (final low-byte)
	lda zpTemp
	clc
	adc zpLevelPtrL
	sta zpLevelPtrL
	sta zpLevelOffsetL
	txa
	adc zpLevelPtrH
	sta zpLevelPtrH
	sta zpLevelOffsetH
	; (zpLevelOffsetL, zpLevelOffsetH) 16-bit offset into the level

	; Add the location of the level data
	clc
	lda zpLevelPtrL		; zpLevelPtr += #level
	adc #<Level
	sta zpLevelPtrL
	lda #>Level
	adc zpLevelPtrH
	sta zpLevelPtrH

	rts

;================================================
; Input:
; Acc = 0 based index of level to decompress
DecompressLevel
	asl		; Acc * 2
	tax
	lda AllLevels,X
	sta ZX5_INPUT
	lda [AllLevels+1],X
	sta ZX5_INPUT+1

	lda #<Level
	sta ZX5_OUTPUT
	lda #>Level
	sta ZX5_OUTPUT+1

	jsr unZX5
	jmp BuildLevelBitInfo

;================================================
DecompressEndScreen
	lda #<TheEndScreen
	sta ZX5_INPUT
	lda #>TheEndScreen
	sta ZX5_INPUT+1

?FireUnZx5ToScreen
	lda #<Screen
	sta ZX5_OUTPUT
	lda #>Screen
	sta ZX5_OUTPUT+1

	jmp unZX5

;================================================
DecompressGameOverScreen
	lda #<GameOverScreen
	sta ZX5_INPUT
	lda #>GameOverScreen
	sta ZX5_INPUT+1

	jmp ?FireUnZx5ToScreen

;================================================
DecompressHelpScreen
	lda #<TheHelpScreen
	sta ZX5_INPUT
	lda #>TheHelpScreen
	sta ZX5_INPUT+1

	jmp ?FireUnZx5ToScreen		

;================================================
; For each of the 336 level bytes set a bit in
; the "LevelHitInfo" array if the tile is a
; non-action tile.  This is used to add a score
; for each tile we hit (but only once)
BuildLevelBitInfo:
	lda #<Level
	sta zpLevelPtrL
	lda #>Level
	sta zpLevelPtrH

	lda #0
	sta	zpTemp				; used to count the lines

?nextLevelLine
	lda #0
	sta zpGenCounter		; This is where we will accumulate the bit information

	;ldy #0
	tay
?nextByteInLine
	lda (zpLevelPtr),y
	cmp #BUILD_TILES
	bcc ?dontSetTheBit

	lda BitIndex,y			; get the bit for this tile
	ora zpGenCounter
	sta zpGenCounter

?dontSetTheBit
	iny
	cpy #7					; Only need 7 bytes of the level
	bcc ?nextByteInLine

	; Store the zpGenCounter into LevelHitInfo[..]
	lda zpGenCounter
	ldy zpTemp
	sta LevelHitInfo,y
	;!##TRACE "LevelHitInfo[%d] = %d" @y @a

	; Move the zpLevelPtr to the next line: +8 bytes
	clc
	lda zpLevelPtrL
	adc #8
	sta zpLevelPtrL
	bcc ?noHighBit
	inc zpLevelPtrH

?noHighBit
	iny
	sty zpTemp

	cpy #42
	bcc ?nextLevelLine

	rts

;================================================
; Include all the level data
.include "level0.asm"
.include "level1.asm"
.IF ONLY1LEVEL
.ELSE
.include "level2.asm"
.include "level3.asm"
.include "level4.asm"
.include "level5.asm"
.include "level6.asm"
.include "level7.asm"
.include "level8.asm"
.include "level9.asm"
.include "level10.asm"
.include "level11.asm"
.include "level12.asm"
.include "level13.asm"
.include "level14.asm"
.include "level15.asm"
.include "level16.asm"
.ENDIF
.include "TheEndScreen.asm"		; compressed 32x21 screen info
.include "GameOverScreen.asm"
.include "TheHelpScreen.asm"

;================================================
; List of level pointers
AllLevels:
	.word Level0,
	.word Level1
.IF ONLY1LEVEL
	.word -1
.ELSE
	.word Level2, Level3, Level4
	.word Level5, Level6, Level7, Level8
	.word Level9, Level10, Level11, Level12
	.word Level13, Level14, Level15, Level16
	.word -1	; The end of the level
.ENDIF
