DetectPALorNTSC
	lda PAL
	cmp #$F		; Check for NTSC
	bne ?isPAL
	; NTSC

	LDA #$3A; $FA			; Player/Missile colours
	STA PCOLOR0
	STA PCOLOR2
	LDA #$36; $f6
	STA PCOLOR1
	STA PCOLOR3

	lda #$00
	sta COLOR4			; Background color
	lda #$3A			; Retro-Dschump text color
	sta COLOR0
	lda #$0C
	sta COLOR1
	lda #$74+$20
	sta COLOR2
	lda #$4
	sta COLOR3	

	; ShowGameScreen SMC
	lda #$80+$10
	sta storeCol2ShowGameScreen
	sta storeCol2SFadeIn
	sta storeCol2SFadeOut

	lda #$A0+$10
	sta	storeCol3ShowGameScreen
	sta storeCol3SFadeIn
	sta storeCol3SFadeOut

	; 3 2 1 color correction
	lda #$86+$10
	sta storeCol2_DLICount321
	lda #$a4+$10
	sta storeCol3_DLICount321

	; Change some slowdown timers
	; Set the curtain slowdown timer 
	lda #10			; 8/50 * 60
	sta storeWait_CloseTheCurtain
	lda #60
	sta storeWait_CloseTheCurtainEnd

	; Ding Ding dong slow down
	lda #60
	sta storeWait_PlayDingDingDong

	; Drop/Raise ball animation slow down
	lda #4+1
	sta storeNTSCWait_DoDropBallAnim
	sta storeNTSCWait_DoRaiseBallAnim

	; Pop ball animation slow down
	lda #3+1
	sta storeNTSCWait_DoPopBallAnim

	rts
	
	; PAL
?isPAL
	LDA #$FA			; Player/Missile colours
	STA PCOLOR0
	STA PCOLOR2
	LDA #$F6
	STA PCOLOR1
	STA PCOLOR3

	lda #$00
	sta COLOR4			; Background color
	lda #$1A			; Retro-Dschump text color
	sta COLOR0
	lda #$0C
	sta COLOR1
	lda #$74
	sta COLOR2
	lda #$4
	sta COLOR3	

	rts