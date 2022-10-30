	.local

; Reset the audio
; Write 0 to the audio channel registers
ResetAudio
	lda #0
	ldy #8
ResetAudioLoop
	sta AUDF1,y
	dey
	bpl ResetAudioLoop
	rts

InitMusic
	lda #0						;starting song line 0-255 to A reg
?PlayMusic	
	ldx #<RMT_SONG_DATA			;low byte of RMT module to X reg
	ldy #>RMT_SONG_DATA			;hi byte of RMT module to Y reg
	jmp RASTERMUSICTRACKER		;Init

PlayIntroMusic
	lda #2+4						;starting song line 0-255 to A reg
	bne ?PlayMusic

PlayLevelEndMusic
	lda #$13 ;7					; End of level track
	bne ?PlayMusic

PlayNoLifesMusic
	lda #$1C ;9					; Game Over
	bne ?PlayMusic

PlayEndGameMusic
	lda #$15 ;11				; You finished the game, Try again!
	bne ?PlayMusic

;----------------------------------------------------------
PlayMusic
	lda SFX_Effect2
	bmi ?NoSfx2

	tax
	inc SoundIndex,x			; Move to the next sound index value
	asl							; acc = sfx * 2
	tay							; Y = Instrument #
	asl							; SFX * 4
	sta zpSfx							
	; Get the offset into the sfx note table
	lda SoundIndex,x
	and #3
	cli
	adc zpSfx
	tax
	lda SoundTable,x			; Get the note to play (0..60)
	;!##TRACE "SFX2 play ch1 note %d instr=%d" @a y
	ldx #0						; Channel #0
	jsr rmt_sfx					; play on channel 2

	lda #255
	sta SFX_Effect2

?NoSfx2
	lda SFX_Effect
	;##TRACE "SFX1 effect#=%d" @a
	bmi ?noSoundEffect
	; Play a sound effect
	tax
	inc SoundIndex,x			; Move to the next sound index value
	asl							; acc = sfx * 2
	tay
	asl							; SFX * 4
	sta zpSfx							
	; Get the offset into the sfx note table
	lda SoundIndex,x
	and #3
	cli
	adc zpSfx
	tax
	lda SoundTable,x			;Get the note to play (0..60)
								;Y = 2,4,..,16	instrument number * 2 (0,2,4,..,126)
	;lda #20					;A = 12			note (0..60)
	;!##TRACE "SFX1 play ch0 note %d instr=%d" @a y
	ldx #3						;X = 3			channel (0..3 or 0..7 for stereo module)
	jsr rmt_sfx					;RMT_SFX start tone (It works only if FEAT_SFX is enabled !!!)

	lda #$ff
	sta SFX_Effect				;re-init value

?noSoundEffect	
	;lda PAL
	;cmp #$F
	;bne CallPlay
	;dec MusicDelay
	;bne CallPlay
	;lda #6
	;sta MusicDelay
	;bne PlayMusicExit
;CallPlay
	jsr RMT_PLAY
PlayMusicExit
	rts

;MusicDelay	.byte 1				; NTSC/PAL sound adjustment
SFX_Effect	.byte $FF			; This is the sound to be played
SFX_Effect2	.byte $FF

; For each sound effect we have a progress counter
; Everytime a SFX is played we increase the progress counter by 1
; This is used as an index into the SoundTable which gives a slightly different
; sound to the SFX everytime it is played.
; Cycle after 4x being played
SoundIndex	;.byte 0,0,0,0,0,0,0,0	; How far into the sound table are we.  On every bounce we up the value, so the sound patterns change
			;.byte 0,0,0,0,0			; 13x counters, one for each SFX being used
			;.byte 0,0,0
			;.byte 0,0,0,0,0,0,0,0
			;.byte 0,0,0,0
			; DANGER
			; Code can be commented out since we never play any of the first sounds are SFX
SoundTable
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			.byte 0,0,0,0
			; SFX table for Miker adjusted RMT with new instrument order
			.byte 10,5,20,15	; 0: 1-Push
			.byte 10,5,20,15	; 1: 3-End of level bounce
			.byte 0,3,3,5		; 2: 6-Bounce
			.byte 0,1,1,0		; 3: 7-Bounce with score
			.byte 20,30,20,30	; 4: 11 - Arrows / Fire button
			.byte 10,5,20,15	; 5: 12 - Pickup
			.byte 20,30,20,30	; 6: 13 - Add a life
			.byte 10,5,20,15	; 7: 14 - Switch
			.byte 12,14,12,14	; 8: 15 - Bank Pop
			.byte 10,5,20,15	; 9: 16 - Break tile
			.byte 0,20,15,30	; 10: 19 - level-end
			.byte 5,10,20,25	; 11: 20 - warp in
			.byte 3,3,7,7		; 12: 22 - no warp

			; Old SFX tables for original instrument order
			; .byte 10,5,20,15	; SFX 0
			; .byte 10,5,20,15
			; .byte 10,5,20,15
			; .byte 10,5,20,15	; End of level bounce
			; .byte 10,5,20,15
			; .byte 10,15,12,18	; SFX 5: Normal bounce sound
			; .byte 0,3,3,5		; Bounce
			; .byte 0,1,1,0		; Bounce with score
			; .byte 0,3,3,5		; Alt bounce
			; .byte 10,5,20,15
			; .byte 10,5,20,15	; SFX 10
			; .byte 20,30,20,30	; SFX 11 - Arrows
			; .byte 10,5,20,15
			; .byte 20,30,20,30	; SFX 13: switch
			; .byte 10,5,20,15
			; .byte 12,14,12,14	; low bounce
			; .byte 10,5,20,15
			; .byte 0,10,15,20
			; .byte 22,10,20,5	; 18
			; .byte 0,20,15,30	; 19 - level-end
			; .byte 5,10,20,25	; SFX 20
			; .byte 2,2,6,6
			; .byte 3,3,7,7		; SFX 22

END_OF_MUSIC_CODE = *

; =============================================================================

.OPT NO SYMDUMP
.include "rmtplayr.asm"			; include RMT player routine
.OPT SYMDUMP

* = MUSIC_DATA
.include "sometune.asm"

* = END_OF_MUSIC_CODE


