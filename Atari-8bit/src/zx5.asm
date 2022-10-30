	.local
ZP = $80
ZX5_OUTPUT = ZP + 0
ZX5_INPUT = ZP + 2
zp_zx5_copysrc = ZP + 4
zp_zx5_offset = ZP + 6
zp_zx5_offset2 = ZP + 8
zp_zx5_offset3 = ZP + $A
zp_zx5_len = ZP + $C
zp_zx5_pnb = ZP + $E

unZX5
	lda #$ff
	sta zp_zx5_offset
	sta zp_zx5_offset+1
	ldy #$00
	sty zp_zx5_len
	sty zp_zx5_len+1
	lda #$80

?dzx5s_literals
	jsr ?dzx5s_elias
	pha
?cop0
	jsr zx5_get_byte
	ldy #$00
	sta (ZX5_OUTPUT),y
	; inw ZX5_OUTPUT
	inc ZX5_OUTPUT
	bne ?skipIncOutput
	inc ZX5_OUTPUT+1
?skipIncOutput
	lda zp_zx5_len
	bne ?skipLen1
	dec zp_zx5_len+1
?skipLen1
  	dec zp_zx5_len
	bne ?cop0
	lda zp_zx5_len+1
	bne ?cop0
	pla
	asl
	bcs ?dzx5s_other_offset

?dzx5s_last_offset
	jsr ?dzx5s_elias
?dzx5s_copy  
	pha
	lda ZX5_OUTPUT
	clc
	adc zp_zx5_offset
	sta zp_zx5_copysrc
	lda ZX5_OUTPUT+1
	adc zp_zx5_offset+1
	sta zp_zx5_copysrc+1
	ldy #$00
	ldx zp_zx5_len+1
	beq ?Remainder
?Page  
	lda (zp_zx5_copysrc),y
	sta (ZX5_OUTPUT),y
	iny
	bne ?Page
	inc zp_zx5_copysrc+1
	inc ZX5_OUTPUT+1
	dex
	bne ?Page
?Remainder   
	ldx zp_zx5_len
	beq ?copyDone
?copyByte
	lda (zp_zx5_copysrc),y
	sta (ZX5_OUTPUT),y
	iny
	dex
	bne ?copyByte
	tya
	clc
	adc ZX5_OUTPUT
	sta ZX5_OUTPUT
	bcc ?copyDone
	inc ZX5_OUTPUT+1
?copyDone 
	stx zp_zx5_len+1
	stx zp_zx5_len
	pla
	asl
	bcc ?dzx5s_literals

?dzx5s_other_offset
	asl
	bne ?dzx5s_other_offset_skip
	jsr zx5_get_byte
	;sec ; can be removed if decompress from memory rather than file
	rol
?dzx5s_other_offset_skip
	bcc ?dzx5s_prev_offset

?dzx5s_new_offset
	sta zp_zx5_pnb
	asl
	ldx zp_zx5_offset2
	stx zp_zx5_offset3
	ldx zp_zx5_offset2+1
	stx zp_zx5_offset3+1
	ldx zp_zx5_offset
	stx zp_zx5_offset2
	ldx zp_zx5_offset+1
	stx zp_zx5_offset2+1
	ldx #$fe
	stx zp_zx5_len
	jsr ?dzx5s_elias_loop
	pha
	ldx zp_zx5_len
	inx
	stx zp_zx5_offset+1
	bne ?nextByte
	pla
	rts   ; The end
?nextByte
	jsr zx5_get_byte
	sta zp_zx5_offset
	ldx #$00
	stx zp_zx5_len+1
	inx
	stx zp_zx5_len
	pla
	dec zp_zx5_pnb
	bmi ?skipBacktrack
	jsr ?dzx5s_elias_backtrack
?skipBacktrack
	; inw zp_zx5_len
	inc zp_zx5_len
	bne ?skipLenIncHigh
	inc zp_zx5_len+1
?skipLenIncHigh	
	jmp ?dzx5s_copy

?dzx5s_prev_offset
	asl
	bcc ?dzx5s_second_offset
	ldy zp_zx5_offset2
	ldx zp_zx5_offset3
	sty zp_zx5_offset3
	stx zp_zx5_offset2
	ldy zp_zx5_offset2+1
	ldx zp_zx5_offset3+1
	sty zp_zx5_offset3+1
	stx zp_zx5_offset2+1

?dzx5s_second_offset
	ldy zp_zx5_offset2
	ldx zp_zx5_offset
	sty zp_zx5_offset
	stx zp_zx5_offset2
	ldy zp_zx5_offset2+1
	ldx zp_zx5_offset+1
	sty zp_zx5_offset+1
	stx zp_zx5_offset2+1
	jmp ?dzx5s_last_offset

?dzx5s_elias 
	inc zp_zx5_len
?dzx5s_elias_loop
	asl
	bne ?dzx5s_elias_skip
	jsr zx5_get_byte
	;sec ; can be removed if decompress from memory rather than file
	rol
?dzx5s_elias_skip
	bcc ?dzx5s_elias_backtrack
	rts
?dzx5s_elias_backtrack
	asl
	rol zp_zx5_len
	rol zp_zx5_len+1
	jmp ?dzx5s_elias_loop

zx5_get_byte
	ldy #0
	lda (ZX5_INPUT),y
	inc ZX5_INPUT
	bne ?skipIncInput
	inc ZX5_INPUT+1
?skipIncInput	
	rts

;zx5_get_byte
;	lda  $ffff
;ZX5_INPUT = *-2
;	;inw  ZX5_INPUT
;	inc ZX5_INPUT
;	bne ?skipIncInput
;	inc ZX5_INPUT+1
;?skipIncInput	
;	rts
ZX5_END