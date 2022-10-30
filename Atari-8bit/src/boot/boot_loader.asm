; Loader to display a quick message ASAP and turn off BASIC
; NOTE: The DL and text message a relocated to $8000
; Create a one line display list
; Put up a loading message
; Turn off BASIC
; If that fails then change the text and cycle border colours for ever
; The loader will be overridden by the normal game once it has run
	.bank 0,0
	*=$2000
	.local
; The decompression routine is located at $2000.
; It gets loaded first and then then boot loader
	.include "zx5.asm"
; -----------------------------------------------
; Hang in this loop until one VBI has happend
WaitForVBI
	lda RTCLOK60
?wait
	cmp RTCLOK60
	beq ?wait
	rts

LoaderDisplayList
	.byte $70,$70,$70       	; 24 blank lines
	.byte DL_LMS|DL_TEXT_6, 	;<(SCREEN+$100), >(SCREEN+$100) ; 1x mode 6 line + LMS + address
LoaderDisplayListAddress
	.byte <LoaderTxt, >LoaderTxt
	.byte DL_BLANK_4
	.byte DL_LMS|DL_TEXT_2, 	;<(SCREEN+$100), >(SCREEN+$100) ; 1x mode 6 line + LMS + address
	.byte <$A000, >$A000
	.byte $70,
	.byte DL_BLANK_4,DL_TEXT_2, DL_TEXT_2,DL_TEXT_2
	.byte DL_TEXT_2,DL_TEXT_2,DL_TEXT_2,DL_TEXT_2,DL_TEXT_2,DL_TEXT_2
	.byte DL_TEXT_2,DL_TEXT_2,DL_TEXT_2,DL_TEXT_2,DL_BLANK_8,DL_TEXT_2,DL_BLANK_8,DL_TEXT_2
	.byte $41,<LoaderDisplayList,>LoaderDisplayList 	; JVB ends display list
LoaderDisplayListEnd

	; Display wither one of these two lines of text
LoaderTxt
	.byte 0,0,0,"retro",13+64,"dschump",0,0,0,0

; Once the boot loader is done then its code can be overridden by the game
GAME_LOAD_FROM_HERE:
LoaderFailed
	.byte 0,0,0,"loading",0,"failed",0,0,0	

; -----------------------------------------------
; The boot loader code runs once and then can be
; overridden by the rest of the game code.
; We actually go back to the 'GAME_LOAD_FROM_HERE' address
; since those bytes are not shown after the boot loader
; has run ok
BOOT_LOADER
	jsr WaitForVBI

	; Setup a narrow screen width: 32 chars per line
	lda #2+32				;2 - normal, 32 - DMA on
	sta SDMCTL

	; Disable basic
	lda #$C0
	cmp RAMTOP
	beq ?RamOk
	sta RAMTOP
	sta RAMSIZ

	; turn off basic
	lda PORTB
	ora #$02
	sta PORTB

	; Check if BASIC ROM area is now writable
	lda $A000
	inc $A000
	cmp $A000
	beq ?RamNotOk		; No change so BASIC ROM is still there

	; Setup a narrow screen width: 32 chars per line
	;lda #~111101		;01 - narrow, 11-PM on, 1 - one line, 1-DMA on
	;sta SDMCTL

	lda #1				; Set BASICF to non-zero, so BASIC remains OFF after RESET
	sta BASICF
?RamOk
	jsr ?ShowIntroDL
	jsr ?DecompressBootMsg

	rts					; return to LOADER to continue the load process

; =========================================================
; From here the code is overriden by the rest of the game
; We don't need this anymore
EndOfBootLoaderAndUnZX5:
	; -------------------------------------------
	; Handle the BASIC not disabled error here
?RamNotOk
	jsr WaitForVBI

	lda #<LoaderFailed
	sta LoaderDisplayListAddress

	jsr ?ShowIntroDL

?waitForHellToFreezeOver
	inc COLOR1			; Change the background color to indicate that something has gone wrong
	jsr WaitForVBI
	jmp ?waitForHellToFreezeOver

; ---------------------------------------------------------
?ShowIntroDL:
	lda #0				; Clear the area where basic used to be
	ldx #0
?clear	
	sta $A000,x
	sta $A100,x
	sta $A200,x
	inx
	bne ?clear
	; Setup display list
	lda #<LoaderDisplayList
	sta SDLSTL
	lda #>LoaderDisplayList
	sta SDLSTL+1

	lda #$00
	sta COLOR2			; Background color to black
	rts

?DecompressBootMsg:
	lda #<BootMessage
	sta ZX5_INPUT
	lda #>BootMessage
	sta ZX5_INPUT+1

?FireUnZx5ToScreen
	lda #<$A000
	sta ZX5_OUTPUT
	lda #>$A000
	sta ZX5_OUTPUT+1

	jsr unZX5
	rts

	.include "boot-message-compressed.asm"

	; Setup the INITAD vector to call the code ASAP
	.bank 1
	* = $2e2
	.word BOOT_LOADER
