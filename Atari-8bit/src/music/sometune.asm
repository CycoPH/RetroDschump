; RMT4 file converted from DschumpMikerFinal.rmt with rmt2atasm
; Original size: $12c2 bytes @ $4000
    .local
RMT_SONG_DATA
?start
    .byte "RMT4"
?song_info
    .byte $40            ; Track length = 64
    .byte $10            ; Song speed
    .byte $01            ; Player Frequency
    .byte $01            ; Format version
; ptrs to tables
?ptrInstrumentTbl
    .word ?InstrumentsTable       ; start + $0010
?ptrTracksTblLo
    .word ?TracksTblLo            ; start + $0048
?ptrTracksTblHi
    .word ?TracksTblHi            ; start + $0087
?ptrSong
    .word ?SongData               ; start + $1246

; List of ptrs to instruments
?InstrumentsTable
    .word ?Instrument_0, ?Instrument_1, ?Instrument_2, ?Instrument_3, ?Instrument_4, ?Instrument_5, ?Instrument_6, ?Instrument_7
    .word ?Instrument_8, ?Instrument_9, ?Instrument_10, ?Instrument_11, ?Instrument_12, ?Instrument_13, ?Instrument_14, ?Instrument_15
    .word ?Instrument_16, ?Instrument_17, ?Instrument_18, ?Instrument_19, ?Instrument_20, ?Instrument_21, ?Instrument_22, ?Instrument_23
    .word ?Instrument_24, ?Instrument_25, ?Instrument_26, ?Instrument_27

?TracksTblLo
    .byte <?Track_00, <?Track_01, <?Track_02, <?Track_03, <?Track_04, <?Track_05, <?Track_06, <?Track_07
    .byte <?Track_08, <?Track_09, <?Track_0a, <?Track_0b, <?Track_0c, <?Track_0d, <?Track_0e, <?Track_0f
    .byte <?Track_10, <?Track_11, <?Track_12, <?Track_13, <?Track_14, <?Track_15, <?Track_16, <?Track_17
    .byte <?Track_18, <?Track_19, <?Track_1a, <?Track_1b, <?Track_1c, <?Track_1d, <?Track_1e, <?Track_1f
    .byte <?Track_20, <?Track_21, <?Track_22, <?Track_23, <?Track_24, <?Track_25, <?Track_26, <?Track_27
    .byte <?Track_28, <?Track_29, <?Track_2a, <?Track_2b, <?Track_2c, <?Track_2d, <?Track_2e, <?Track_2f
    .byte <?Track_30, <?Track_31, <?Track_32, <?Track_33, <?Track_34, <?Track_35, <?Track_36, <?Track_37
    .byte <?Track_38, <?Track_39, <?Track_3a, <?Track_3b, <?Track_3c, <?Track_3d, <?Track_3e
?TracksTblHi
    .byte >?Track_00, >?Track_01, >?Track_02, >?Track_03, >?Track_04, >?Track_05, >?Track_06, >?Track_07
    .byte >?Track_08, >?Track_09, >?Track_0a, >?Track_0b, >?Track_0c, >?Track_0d, >?Track_0e, >?Track_0f
    .byte >?Track_10, >?Track_11, >?Track_12, >?Track_13, >?Track_14, >?Track_15, >?Track_16, >?Track_17
    .byte >?Track_18, >?Track_19, >?Track_1a, >?Track_1b, >?Track_1c, >?Track_1d, >?Track_1e, >?Track_1f
    .byte >?Track_20, >?Track_21, >?Track_22, >?Track_23, >?Track_24, >?Track_25, >?Track_26, >?Track_27
    .byte >?Track_28, >?Track_29, >?Track_2a, >?Track_2b, >?Track_2c, >?Track_2d, >?Track_2e, >?Track_2f
    .byte >?Track_30, >?Track_31, >?Track_32, >?Track_33, >?Track_34, >?Track_35, >?Track_36, >?Track_37
    .byte >?Track_38, >?Track_39, >?Track_3a, >?Track_3b, >?Track_3c, >?Track_3d, >?Track_3e

; Track data
?Track_00
    .byte $3f, $07, $c9, $03, $cc, $03, $7e, $c9, $03, $ce, $03, $7e, $c9, $03, $cc, $03
    .byte $7e, $c9, $03, $ce, $03, $7e, $c9, $03, $cc, $03, $7e, $c9, $03, $c9, $07, $7e
    .byte $c9, $03, $c9, $07, $fe, $3d, $00, $d5, $03, $d6, $03, $7e, $d2, $03, $d3, $03
    .byte $7e, $cc, $03, $d6, $03, $7e, $d2, $03, $d3, $03, $7e, $cc, $03, $d6, $03, $7e
    .byte $d2, $03, $d5, $03, $d3, $03, $d0, $03, $ce, $03, $7e, $d0, $03, $ce, $03, $7e
    .byte $ff
?Track_01
    .byte $c9, $03, $c9, $07, $3e, $3e
?Track_02
    .byte $cd, $03, $cc, $03, $7e, $c9, $03, $ce, $03, $7e, $c9, $03, $cc, $03, $7e, $c9
    .byte $03, $ce, $03, $7e, $c9, $03, $cc, $03, $7e, $c9, $03, $c9, $07, $7e, $c9, $03
    .byte $c9, $07, $fe, $d4, $03, $d5, $03, $d8, $03, $7e, $d3, $03, $d2, $03, $d3, $03
    .byte $d4, $03, $d8, $03, $7e, $d3, $03, $d2, $03, $d3, $03, $d5, $03, $d1, $03, $7e
    .byte $d1, $03, $d1, $03, $be, $d0, $03, $be, $d0, $03, $7e, $ff
?Track_03
    .byte $cd, $03, $cc, $03, $7e, $c9, $03, $ce, $03, $7e, $c9, $03, $cc, $03, $7e, $c9
    .byte $03, $ce, $03, $7e, $c9, $03, $cc, $03, $7e, $c9, $03, $c9, $03, $7e, $c9, $03
    .byte $c9, $03, $fe, $d4, $03, $d5, $03, $d8, $03, $7e, $d3, $03, $d2, $03, $d3, $03
    .byte $d4, $03, $d8, $03, $7e, $d3, $03, $d2, $03, $d3, $03, $d5, $03, $d1, $03, $7e
    .byte $d1, $03, $d1, $03, $be, $d0, $03, $be, $cc, $03, $d1, $03, $ff
?Track_04
    .byte $d3, $03, $cc, $07, $be, $cc, $07, $be, $cc, $07, $be, $cc, $07, $be, $cc, $07
    .byte $3e, $0a, $cc, $03, $ce, $03, $cb, $03, $cc, $03, $ce, $03, $cb, $03, $cc, $03
    .byte $cc, $03, $7e, $cc, $03, $cc, $03, $7e, $cc, $03, $ce, $03, $cb, $03, $cc, $03
    .byte $ce, $03, $cb, $03, $cc, $03, $cc, $03, $7e, $cc, $03, $cc, $03, $7e, $ff
?Track_05
    .byte $d3, $07, $cc, $07, $be, $cc, $07, $be, $cc, $07, $be, $cc, $07, $be, $cc, $07
    .byte $3e, $08, $d0, $07, $7e, $ce, $07, $cc, $07, $7e, $ce, $07, $d0, $07, $7e, $d1
    .byte $07, $cb, $07, $be, $cb, $07, $be, $ca, $03, $be, $ca, $03, $be, $c9, $03, $be
    .byte $cc, $03, $d1, $03, $ff
?Track_06
    .byte $d3, $07, $cc, $07, $be, $cc, $07, $be, $cc, $07, $be, $cc, $07, $be, $cc, $07
    .byte $3e, $08, $d0, $03, $7e, $ce, $03, $cc, $03, $7e, $ce, $03, $d0, $03, $7e, $d1
    .byte $03, $cb, $07, $be, $cb, $07, $be, $ca, $03, $be, $ca, $03, $be, $c9, $03, $be
    .byte $ce, $03, $cf, $03, $ff
?Track_07
    .byte $d0, $03, $ce, $07, $be, $ce, $07, $be, $ce, $07, $be, $ce, $07, $be, $cf, $03
    .byte $be, $cf, $07, $3e, $04, $cf, $03, $be, $cf, $03, $cf, $07, $be, $cf, $07, $be
    .byte $cf, $07, $be, $cf, $07, $3e, $0a, $ce, $07, $cf, $07, $7e, $ff
?Track_08
    .byte $d0, $03, $ce, $07, $be, $ce, $07, $be, $ce, $07, $be, $ce, $07, $be, $cf, $03
    .byte $be, $cf, $07, $3e, $04, $cf, $03, $be, $cf, $03, $cf, $07, $be, $cf, $07, $be
    .byte $cf, $07, $be, $cf, $07, $be, $ce, $07, $3e, $08, $ce, $03, $cf, $03, $ff
?Track_09
    .byte $d0, $03, $ce, $07, $be, $ce, $07, $be, $ce, $07, $be, $ce, $07, $be, $cf, $03
    .byte $be, $cf, $07, $3e, $04, $cf, $03, $be, $cf, $03, $cf, $07, $be, $cf, $07, $be
    .byte $cf, $07, $be, $cf, $07, $be, $ce, $07, $3e, $05, $ce, $07, $3d, $00, $fe, $ff
?Track_0a
    .byte $3f, $06, $c8, $13, $7e, $cc, $13, $c6, $13, $7e, $ca, $13, $7e, $c8, $13, $7e
    .byte $cc, $13, $7e, $c6, $13, $ca, $13, $7e, $cd, $13, $7e, $d4, $13, $3e, $04, $d4
    .byte $1b, $94, $1b, $14, $1b, $3e, $28
?Track_0b
    .byte $3f, $06, $d2, $2f, $7e, $d6, $2f, $7e, $d6, $2f, $7e, $d6, $2f, $d2, $2f, $7e
    .byte $d6, $2f, $7e, $d6, $2f, $d6, $2f, $7e, $d6, $2f, $7e, $d4, $2f, $7e, $d7, $2f
    .byte $7e, $d9, $2f, $7e, $d7, $2f, $d4, $2f, $7e, $d7, $2f, $7e, $d7, $2f, $d9, $2f
    .byte $7e, $d7, $2f, $7e, $ff
?Track_0c
    .byte $d6, $2f, $7e, $d6, $2f, $d7, $2f, $d6, $2f, $d4, $2f, $d2, $2f, $d4, $33, $7e
    .byte $d1, $33, $fe, $c8, $2f, $cd, $2f, $d1, $2f, $d4, $2f, $7e, $d4, $2f, $d6, $2f
    .byte $d4, $2f, $d2, $2f, $d1, $2f, $d2, $2f, $7e, $ca, $2f, $7e, $ca, $2f, $ca, $2f
    .byte $ca, $2f, $cd, $2f, $d2, $2f, $d6, $2f, $7e, $d6, $2f, $d7, $2f, $d6, $2f, $d4
    .byte $2f, $d2, $2f, $d4, $33, $7e, $d1, $33, $fe, $c8, $2f, $cb, $2f, $d1, $2f, $d9
    .byte $2f, $db, $2f, $d9, $2f, $d7, $2f, $d6, $2f, $d7, $2f, $d6, $33, $d4, $2f, $d2
    .byte $2f, $3e, $07
?Track_0d
    .byte $cb, $2f, $7e, $cf, $2f, $7e, $d2, $2f, $7e, $d6, $2f, $d7, $33, $7e, $d7, $33
    .byte $7e, $d7, $2f, $d6, $2f, $7e, $d4, $2f, $7e, $ca, $2f, $7e, $cd, $2f, $7e, $d2
    .byte $2f, $7e, $d4, $2f, $d6, $33, $7e, $d6, $33, $7e, $d6, $2f, $d4, $2f, $7e, $d2
    .byte $2f, $7e, $c8, $2f, $7e, $cd, $2f, $7e, $d1, $2f, $7e, $d2, $2f, $d4, $33, $7e
    .byte $d4, $33, $7e, $d4, $2f, $d2, $2f, $7e, $d1, $2f, $7e, $ca, $2f, $7e, $cd, $2f
    .byte $7e, $d2, $2f, $7e, $d4, $2f, $d6, $33, $7e, $d6, $33, $7e, $d6, $2f, $d7, $2f
    .byte $7e, $d9, $2f, $7e
?Track_0e
    .byte $cb, $2f, $7e, $cf, $2f, $7e, $d2, $2f, $7e, $d6, $2f, $d7, $33, $7e, $d7, $33
    .byte $7e, $d7, $2f, $d6, $2f, $7e, $d4, $2f, $7e, $ca, $2f, $7e, $cd, $2f, $7e, $d2
    .byte $2f, $7e, $d4, $2f, $d6, $33, $7e, $d6, $33, $7e, $d6, $2f, $d4, $2f, $7e, $d2
    .byte $2f, $7e, $c8, $2f, $7e, $cd, $2f, $7e, $d1, $2f, $7e, $d2, $2f, $d4, $33, $7e
    .byte $d4, $33, $7e, $d4, $2f, $d2, $2f, $7e, $d1, $2f, $7e, $cd, $2f, $3e, $04, $cd
    .byte $33, $7e, $cd, $2f, $cd, $2f, $3e, $07
?Track_0f
    .byte $3f, $07, $be, $d7, $07, $fe, $e3, $07, $fe, $da, $07, $fe, $d9, $07, $fe, $dd
    .byte $07, $3e, $07, $d7, $07, $fe, $e3, $07, $fe, $da, $07, $fe, $d9, $07, $3e, $09
    .byte $ff
?Track_10
    .byte $be, $d5, $07, $fe, $e1, $07, $fe, $d8, $07, $fe, $d9, $07, $fe, $dd, $07, $3e
    .byte $07, $d5, $07, $fe, $e1, $07, $fe, $d8, $07, $7e, $dd, $07, $fe, $dc, $07, $fe
    .byte $d8, $07, $7e, $d4, $07, $7e, $ff
?Track_11
    .byte $d1, $03, $3e, $05, $d1, $03, $d1, $03, $be, $d1, $03, $7e, $ff
?Track_12
    .byte $d1, $03, $d1, $07, $3e, $3e
?Track_13
    .byte $3e, $0f, $ce, $03, $d0, $07, $7e, $d1, $03, $d1, $07, $fe, $3d, $00, $3e, $28
?Track_14
    .byte $3e, $0f, $ce, $03, $d0, $07, $7e, $d1, $03, $d1, $07, $fe, $3d, $00, $7e, $d0
    .byte $03, $3e, $05, $d0, $03, $3e, $05, $d7, $03, $7e, $d7, $03, $d7, $03, $d8, $03
    .byte $da, $03, $d8, $03, $be, $d8, $03, $3e, $11
?Track_15
    .byte $3e, $0f, $ce, $03, $d0, $03, $7e, $d1, $03, $d1, $03, $fe, $3d, $00, $7e, $d0
    .byte $03, $3e, $05, $d0, $03, $3e, $05, $d7, $03, $7e, $d7, $03, $d7, $03, $d8, $03
    .byte $da, $03, $d8, $03, $3e, $14
?Track_16
    .byte $7e, $d1, $07, $be, $d1, $07, $be, $d1, $07, $be, $d1, $07, $be, $d1, $07, $3e
    .byte $11, $d6, $03, $7e, $d6, $03, $d6, $03, $3e, $08, $d5, $03, $7e, $d5, $03, $d5
    .byte $03, $3e, $11
?Track_17
    .byte $7e, $d1, $07, $be, $d1, $07, $be, $d1, $07, $be, $d1, $07, $be, $d1, $07, $3e
    .byte $11, $d1, $07, $7e, $d3, $03, $d1, $07, $7e, $d3, $03, $d1, $03, $7e, $d3, $03
    .byte $ce, $03, $7e, $d0, $03, $d1, $03, $3e, $14
?Track_18
    .byte $7e, $d1, $07, $be, $d3, $07, $be, $d5, $07, $be, $d6, $07, $be, $d7, $03, $7e
    .byte $d8, $03, $d3, $07, $3e, $04, $d6, $03, $d5, $03, $7e, $d3, $03, $d1, $07, $be
    .byte $d3, $07, $be, $d5, $07, $be, $d3, $07, $be, $d3, $03, $d1, $03, $ce, $03, $ca
    .byte $07, $3e, $17
?Track_19
    .byte $7e, $d1, $07, $be, $d3, $07, $be, $d5, $07, $be, $d6, $07, $be, $d7, $03, $7e
    .byte $d8, $03, $d3, $07, $3e, $04, $d6, $03, $d5, $03, $7e, $d3, $03, $d1, $07, $be
    .byte $d2, $07, $be, $d3, $07, $be, $d5, $07, $be, $d6, $07, $3e, $1a
?Track_1a
    .byte $7e, $d1, $07, $be, $d3, $07, $be, $d5, $07, $be, $d6, $07, $be, $d7, $03, $7e
    .byte $d8, $03, $d3, $07, $3e, $04, $d6, $03, $d5, $03, $7e, $d3, $03, $d1, $07, $be
    .byte $d2, $07, $be, $d3, $07, $be, $d5, $07, $be, $d6, $07, $3e, $05, $d6, $07, $3d
    .byte $00, $3e, $13
?Track_1b
    .byte $db, $17, $fe, $db, $17, $3e, $07, $cf, $17, $db, $17, $cf, $17, $db, $17, $e0
    .byte $17, $7e, $d4, $17, $7e, $3d, $02, $3d, $01, $3d, $00, $3e, $29
?Track_1c
    .byte $d6, $2f, $7e, $d9, $2f, $7e, $db, $2f, $7e, $d9, $2f, $d6, $2f, $7e, $d9, $2f
    .byte $7e, $d9, $2f, $db, $2f, $7e, $d9, $2f, $7e, $d7, $2f, $7e, $db, $2f, $7e, $dd
    .byte $2f, $7e, $db, $2f, $d7, $2f, $7e, $db, $2f, $7e, $db, $2f, $dd, $2f, $7e, $db
    .byte $2f, $3e, $21
?Track_1d
    .byte $d9, $2f, $7e, $d9, $2f, $db, $2f, $d9, $2f, $d7, $2f, $d6, $2f, $d7, $33, $7e
    .byte $d4, $33, $fe, $cd, $2f, $d1, $2f, $d4, $2f, $d7, $2f, $7e, $d7, $2f, $d9, $2f
    .byte $d7, $2f, $d6, $2f, $d4, $2f, $d6, $2f, $7e, $cd, $2f, $7e, $cd, $2f, $cf, $2f
    .byte $cd, $2f, $d2, $2f, $d6, $2f, $d9, $2f, $7e, $d9, $2f, $db, $2f, $d9, $2f, $d7
    .byte $2f, $d6, $2f, $d7, $33, $7e, $d4, $33, $fe, $cd, $2f, $d1, $2f, $d4, $2f, $dd
    .byte $2f, $de, $2f, $dd, $2f, $db, $2f, $d9, $2f, $db, $2f, $d9, $2f, $d7, $2f, $d6
    .byte $2f, $3e, $07
?Track_1e
    .byte $cf, $2f, $7e, $d2, $2f, $7e, $d7, $2f, $7e, $d9, $2f, $db, $33, $7e, $db, $33
    .byte $7e, $db, $2f, $d9, $2f, $7e, $d7, $2f, $7e, $cd, $2f, $7e, $d2, $2f, $7e, $d6
    .byte $2f, $7e, $d7, $2f, $d9, $33, $7e, $d9, $33, $7e, $d9, $2f, $d7, $2f, $7e, $d6
    .byte $2f, $7e, $cd, $2f, $7e, $d1, $2f, $7e, $d4, $2f, $7e, $d6, $2f, $d7, $33, $7e
    .byte $d7, $33, $7e, $d7, $2f, $d6, $2f, $7e, $d4, $2f, $7e, $cd, $2f, $7e, $d2, $2f
    .byte $7e, $d6, $2f, $7e, $d7, $2f, $d9, $33, $7e, $d9, $33, $7e, $d9, $2f, $db, $2f
    .byte $7e, $dc, $2f, $7e
?Track_1f
    .byte $cf, $2f, $7e, $d2, $2f, $7e, $d7, $2f, $7e, $d9, $2f, $db, $33, $7e, $db, $33
    .byte $7e, $db, $2f, $d9, $2f, $7e, $d7, $2f, $7e, $cd, $2f, $7e, $d2, $2f, $7e, $d6
    .byte $2f, $7e, $d7, $2f, $d9, $33, $7e, $d9, $33, $7e, $d9, $2f, $d7, $2f, $7e, $d6
    .byte $2f, $7e, $cd, $2f, $7e, $d1, $2f, $7e, $d4, $2f, $7e, $d6, $2f, $d7, $33, $7e
    .byte $d7, $33, $7e, $d7, $2f, $d6, $2f, $7e, $d4, $2f, $7e, $d2, $2f, $3e, $04, $d2
    .byte $33, $7e, $d2, $2f, $d2, $2f, $3e, $07
?Track_20
    .byte $cb, $0b, $3e, $0b, $ca, $0b, $3e, $0b, $cb, $0b, $3e, $0b, $ca, $0b, $3e, $1b
?Track_21
    .byte $c9, $0b, $3e, $0b, $ca, $0b, $3e, $0b, $c9, $0b, $3e, $0b, $ca, $0b, $3e, $1b
?Track_22
    .byte $d5, $03, $3e, $05, $d5, $03, $d5, $03, $be, $d5, $03, $3e, $35
?Track_23
    .byte $d5, $03, $d5, $07, $3e, $3e
?Track_24
    .byte $3e, $13, $d5, $07, $fe, $3d, $00, $3e, $28
?Track_25
    .byte $3e, $13, $d5, $07, $fe, $3d, $00, $7e, $cc, $03, $3e, $05, $cc, $03, $3e, $20
?Track_26
    .byte $7e, $d5, $07, $be, $d5, $07, $be, $d4, $07, $be, $d5, $07, $be, $d8, $07, $fe
    .byte $d6, $03, $d3, $03, $d0, $07, $3e, $2c
?Track_27
    .byte $7e, $d5, $07, $be, $d5, $07, $be, $d4, $07, $be, $d5, $07, $be, $d8, $07, $fe
    .byte $d6, $03, $d3, $03, $d0, $07, $3e, $0b, $d5, $07, $be, $d5, $07, $be, $d5, $03
    .byte $3e, $1a
?Track_28
    .byte $cf, $0f, $c2, $0f, $7e, $ce, $0f, $ce, $0f, $7e, $ce, $0f, $c2, $0f, $7e, $ce
    .byte $0f, $ce, $0f, $7e, $ce, $0f, $c3, $0f, $7e, $cf, $0f, $cf, $0f, $7e, $cf, $0f
    .byte $c3, $0f, $7e, $cf, $0f, $cf, $0f, $7e, $cf, $0f, $c3, $0f, $7e, $cf, $0f, $cf
    .byte $0f, $7e, $cf, $0f, $c3, $0f, $7e, $cf, $0f, $cf, $0f, $7e, $cf, $0f, $c3, $0f
    .byte $7e, $cf, $0f, $cf, $0f, $7e, $cf, $0f, $c3, $0f, $7e, $cf, $0f, $cf, $0f, $3e
    .byte $11
?Track_29
    .byte $cf, $0f, $c2, $0f, $7e, $ce, $0f, $ce, $0f, $7e, $ce, $0f, $c2, $0f, $7e, $ce
    .byte $0f, $ce, $0f, $7e, $ce, $0f, $c3, $0f, $7e, $cf, $0f, $cf, $0f, $7e, $cf, $0f
    .byte $c3, $0f, $7e, $cf, $0f, $cf, $0f, $7e, $cf, $0f, $c3, $0f, $7e, $cf, $0f, $cf
    .byte $0f, $7e, $cf, $0f, $c3, $0f, $7e, $cf, $0f, $cf, $0f, $7e, $cf, $0f, $c3, $0f
    .byte $3e, $1a
?Track_2a
    .byte $7e, $08, $12, $7e, $0c, $12, $06, $12, $7e, $0a, $12, $7e, $08, $12, $7e, $0c
    .byte $12, $7e, $06, $12, $0a, $12, $7e, $0d, $12, $7e, $14, $12, $fe, $e0, $1b, $a0
    .byte $1b, $20, $1b, $3e, $28
?Track_2b
    .byte $d2, $37, $be, $d2, $37, $cd, $37, $be, $cd, $37, $d2, $37, $be, $d2, $37, $7e
    .byte $d9, $37, $d2, $37, $cd, $37, $d4, $37, $be, $d4, $37, $cf, $37, $7e, $d4, $37
    .byte $7e, $cd, $37, $be, $cd, $37, $d4, $37, $cd, $37, $cf, $37, $d1, $37, $3e, $20
?Track_2c
    .byte $d2, $37, $be, $d2, $37, $cd, $37, $be, $cd, $37, $d2, $37, $be, $d2, $37, $7e
    .byte $cd, $37, $d2, $37, $cd, $37, $d4, $37, $be, $d4, $37, $cf, $37, $be, $cf, $37
    .byte $cd, $37, $be, $cd, $37, $d4, $37, $7e, $cd, $37, $3e, $21
?Track_2d
    .byte $d2, $37, $be, $d2, $37, $cd, $37, $7e, $d2, $37, $7e, $cd, $37, $be, $cd, $37
    .byte $d4, $37, $be, $d4, $37, $cd, $37, $be, $cd, $37, $cf, $37, $7e, $d1, $37, $7e
    .byte $d2, $37, $be, $d2, $37, $cd, $37, $be, $cd, $37, $d2, $37, $be, $d2, $37, $d9
    .byte $37, $7e, $d2, $37, $7e, $cd, $37, $be, $cd, $37, $d4, $37, $be, $d4, $37, $cd
    .byte $37, $be, $cd, $37, $d4, $37, $7e, $cd, $37, $7e, $d2, $37, $be, $d2, $37, $cd
    .byte $37, $fe
?Track_2e
    .byte $d2, $37, $be, $d2, $37, $cd, $37, $7e, $d2, $37, $7e, $cd, $37, $be, $cd, $37
    .byte $d4, $37, $be, $d4, $37, $cd, $37, $be, $cd, $37, $cf, $37, $7e, $d1, $37, $7e
    .byte $d2, $37, $be, $d2, $37, $cd, $37, $be, $cd, $37, $d2, $37, $be, $d2, $37, $d9
    .byte $37, $7e, $d2, $37, $7e, $cd, $37, $be, $cd, $37, $d4, $37, $be, $d4, $37, $cd
    .byte $37, $be, $cd, $37, $d4, $37, $7e, $cd, $37, $bf, $1f
?Track_2f
    .byte $d7, $37, $be, $d7, $37, $d2, $37, $be, $d2, $37, $d7, $37, $be, $d7, $37, $d2
    .byte $37, $d7, $37, $d2, $37, $d7, $37, $d2, $37, $be, $d2, $37, $d9, $37, $be, $d9
    .byte $37, $d2, $37, $be, $d2, $37, $d9, $37, $d2, $37, $d9, $37, $d2, $37, $cd, $37
    .byte $be, $cd, $37, $d4, $37, $be, $d4, $37, $cd, $37, $be, $cd, $37, $d4, $37, $cd
    .byte $37, $d4, $37, $d4, $37, $d2, $37, $be, $d2, $37, $d9, $37, $be, $d9, $37, $d2
    .byte $37, $be, $d2, $37, $d9, $37, $7e, $d2, $37, $7e
?Track_30
    .byte $d7, $37, $be, $d7, $37, $d2, $37, $be, $d2, $37, $d7, $37, $be, $d7, $37, $d2
    .byte $37, $d7, $37, $d2, $37, $d7, $37, $d2, $37, $be, $d2, $37, $d9, $37, $be, $d9
    .byte $37, $d2, $37, $be, $d2, $37, $d9, $37, $d2, $37, $d9, $37, $d2, $37, $cd, $37
    .byte $be, $cd, $37, $d4, $37, $be, $d4, $37, $cd, $37, $be, $cd, $37, $d4, $37, $cd
    .byte $37, $d4, $37, $d4, $37, $d2, $37, $be, $d2, $37, $d9, $37, $be, $d9, $37, $d2
    .byte $37, $7e, $cd, $37, $7e, $cf, $37, $7e, $d1, $37, $7e
?Track_31
    .byte $3e, $04, $da, $07, $fe, $de, $07, $fe, $d6, $07, $fe, $e2, $07, $3e, $0b, $da
    .byte $07, $fe, $de, $07, $fe, $d6, $07, $fe, $e2, $07, $3e, $17
?Track_32
    .byte $3e, $04, $d8, $07, $fe, $dc, $07, $fe, $d6, $07, $fe, $e2, $07, $3e, $0b, $d8
    .byte $07, $fe, $dc, $07, $fe, $dd, $3b, $fe, $dc, $3b, $fe, $d8, $3b, $7e, $d4, $3b
    .byte $3e, $11
?Track_33
    .byte $7e, $d1, $0b, $be, $d8, $0b, $be, $d1, $0b, $be, $d8, $0b, $be, $d1, $0b, $be
    .byte $d5, $0b, $be, $d1, $0b, $be, $cc, $0b, $be, $d8, $0b, $be, $d3, $0b, $be, $d8
    .byte $0b, $be, $d3, $0b, $be, $d8, $0b, $be, $cc, $0b, $be, $d8, $0b, $be, $d3, $0b
    .byte $3e, $11
?Track_34
    .byte $7e, $d1, $0b, $d1, $0b, $d1, $0b, $dd, $0b, $d1, $0b, $d1, $0b, $d1, $0b, $3e
    .byte $04, $ff
?Track_35
    .byte $7e, $d1, $0b, $be, $d8, $0b, $be, $d1, $0b, $be, $d8, $0b, $be, $d1, $0b, $be
    .byte $d5, $0b, $be, $d1, $0b, $be, $cc, $0b, $be, $d8, $0b, $be, $d3, $0b, $be, $d8
    .byte $0b, $be, $d3, $0b, $be, $cb, $0b, $3e, $05, $cc, $0b, $be, $cc, $0b, $3e, $11
?Track_36
    .byte $7e, $d1, $0b, $be, $d8, $0b, $be, $d1, $0b, $be, $d8, $0b, $be, $d1, $0b, $be
    .byte $d5, $0b, $be, $d1, $0b, $be, $cc, $0b, $be, $d8, $0b, $be, $d3, $0b, $be, $d8
    .byte $0b, $be, $d3, $0b, $be, $cb, $0b, $3e, $05, $cc, $0b, $3e, $14
?Track_37
    .byte $7e, $d1, $0b, $7e, $d5, $0b, $cc, $0b, $7e, $cc, $0b, $d1, $0b, $7e, $d5, $0b
    .byte $d1, $0b, $7e, $cc, $0b, $d1, $0b, $be, $d8, $0b, $7e, $d6, $0b, $d3, $0b, $7e
    .byte $ca, $0b, $d6, $0b, $7e, $d6, $0b, $d3, $0b, $7e, $d6, $0b, $cc, $0b, $7e, $d6
    .byte $0b, $d3, $0b, $7e, $d6, $0b, $cc, $0b, $7e, $d5, $0b, $d1, $0b, $7e, $d5, $0b
    .byte $cc, $0b, $7e, $d5, $0b, $d1, $0b, $7e, $d5, $0b, $cc, $0b, $3e, $11
?Track_38
    .byte $7e, $d1, $0b, $7e, $d5, $0b, $cc, $0b, $7e, $cc, $0b, $d1, $0b, $7e, $d5, $0b
    .byte $d1, $0b, $7e, $cc, $0b, $d1, $0b, $be, $d8, $0b, $7e, $d6, $0b, $d3, $0b, $be
    .byte $cb, $0b, $be, $cc, $0b, $be, $d8, $0b, $be, $ce, $0b, $be, $cd, $0b, $be, $cc
    .byte $0b, $be, $cc, $0b, $be, $d1, $0b, $3e, $14
?Track_39
    .byte $7e, $ca, $0b, $7e, $d6, $0b, $ce, $0b, $7e, $d1, $0b, $ca, $0b, $7e, $d6, $0b
    .byte $ce, $0b, $7e, $d8, $0b, $cf, $0b, $7e, $d8, $0b, $cf, $0b, $7e, $d8, $0b, $cf
    .byte $0b, $7e, $d8, $0b, $cf, $0b, $7e, $d8, $0b, $d1, $0b, $7e, $d8, $0b, $cc, $0b
    .byte $7e, $cc, $0b, $d1, $0b, $7e, $cc, $0b, $d1, $0b, $7e, $cc, $0b, $ca, $0b, $7e
    .byte $ce, $0b, $d1, $0b, $7e, $d1, $0b, $d1, $0b, $7e, $d1, $0b, $ce, $0b, $3e, $11
?Track_3a
    .byte $7e, $ca, $0b, $7e, $d6, $0b, $ce, $0b, $7e, $d1, $0b, $ca, $0b, $7e, $d6, $0b
    .byte $ce, $0b, $7e, $d8, $0b, $cf, $0b, $7e, $d8, $0b, $cf, $0b, $7e, $d8, $0b, $cf
    .byte $0b, $7e, $d8, $0b, $cf, $0b, $7e, $d8, $0b, $d1, $0b, $7e, $d8, $0b, $cc, $0b
    .byte $7e, $cc, $0b, $d1, $0b, $7e, $cc, $0b, $d1, $0b, $7e, $cc, $0b, $ca, $0b, $be
    .byte $d3, $0b, $be, $d1, $0b, $be, $ce, $0b, $ca, $0b, $3e, $10
?Track_3b
    .byte $00, $1f, $0b, $27, $00, $23, $0b, $27, $00, $1f, $0b, $27, $00, $23, $0b, $27
    .byte $00, $1f, $0b, $27, $00, $23, $0b, $27, $00, $1f, $0b, $27, $00, $23, $0b, $27
    .byte $00, $23, $40, $22, $40, $21, $be, $00, $23, $40, $22, $00, $23, $3e, $28
?Track_3c
    .byte $00, $22, $0b, $26, $0b, $26, $00, $22, $0b, $26, $0b, $26, $00, $22, $0b, $26
    .byte $0b, $26, $0b, $26, $00, $22, $0b, $26, $0b, $26, $00, $22, $0b, $26, $0b, $26
    .byte $bf, $00
?Track_3d
    .byte $00, $1e, $3e, $09, $00, $1e, $7e, $00, $1e, $3e, $07, $bc, $29, $7e, $b7, $29
    .byte $7e, $00, $1e, $3e, $09, $00, $1e, $7e, $00, $1e, $3e, $05, $c7, $27, $c7, $27
    .byte $c7, $27, $7e, $c7, $27, $3e, $11
?Track_3e
    .byte $00, $1e, $3e, $09, $00, $1e, $7e, $00, $1e, $3e, $07, $bc, $29, $7e, $37, $2a
    .byte $7e, $00, $1e, $3e, $09, $00, $1e, $7e, $00, $1e, $3e, $07, $cc, $17, $7e, $c8
    .byte $17, $3e, $11

; Song data
?SongData
?line_00:  .byte $ff, $ff, $ff, $ff
?line_01:  .byte $fe, $00, <?line_00, >?line_00
?line_02:  .byte $00, $11, $22, $33
?line_03:  .byte $00, $11, $22, $33
?line_04:  .byte $00, $11, $22, $33
?line_05:  .byte $01, $12, $23, $34
?line_06:  .byte $00, $13, $24, $33
?line_07:  .byte $02, $14, $25, $35
?line_08:  .byte $00, $13, $24, $33
?line_09:  .byte $03, $15, $25, $36
?line_0a:  .byte $04, $16, $26, $37
?line_0b:  .byte $05, $17, $27, $38
?line_0c:  .byte $04, $16, $26, $37
?line_0d:  .byte $06, $17, $27, $38
?line_0e:  .byte $07, $18, $28, $39
?line_0f:  .byte $08, $19, $29, $3a
?line_10:  .byte $07, $18, $28, $39
?line_11:  .byte $09, $1a, $29, $3a
?line_12:  .byte $fe, $06, <?line_06, >?line_06
?line_13:  .byte $0a, $1b, $2a, $3b
?line_14:  .byte $fe, $00, <?line_00, >?line_00
?line_15:  .byte $0b, $1c, $2b, $3c
?line_16:  .byte $0b, $1c, $2c, $3c
?line_17:  .byte $0c, $1d, $2d, $3c
?line_18:  .byte $0c, $1d, $2e, $3c
?line_19:  .byte $0d, $1e, $2f, $3c
?line_1a:  .byte $0e, $1f, $30, $3c
?line_1b:  .byte $fe, $15, <?line_15, >?line_15
?line_1c:  .byte $0f, $20, $31, $3d
?line_1d:  .byte $10, $21, $32, $3e
?line_1e:  .byte $fe, $1c, <?line_1c, >?line_1c


; Instrument data
* = $5000
?Instrument_0
    .byte $0c, $0c, $31, $31, $00, $00, $00, $00, $00, $00, $00, $00, $00, $88, $0a, $00
    .byte $55, $0a, $00, $44, $0a, $00, $33, $0a, $00, $33, $0a, $00, $22, $0a, $00, $22
    .byte $0a, $00, $22, $0a, $00, $22, $0a, $00, $22, $0a, $00, $22, $0a, $00, $11, $00
    .byte $00, $00, $00, $00
?Instrument_1
    .byte $0c, $0c, $31, $31, $00, $00, $40, $00, $00, $00, $00, $00, $00, $aa, $0a, $00
    .byte $66, $0a, $00, $66, $0a, $00, $55, $0a, $00, $44, $0a, $00, $33, $0a, $00, $33
    .byte $0a, $00, $33, $0a, $00, $22, $0a, $00, $22, $0a, $00, $22, $0a, $00, $22, $0a
    .byte $00, $22, $0a, $00
?Instrument_2
    .byte $0c, $0c, $28, $28, $00, $00, $80, $00, $00, $00, $00, $00, $00, $bb, $0c, $00
    .byte $88, $0c, $00, $66, $0c, $00, $66, $0c, $00, $55, $0c, $00, $55, $0c, $00, $55
    .byte $0c, $00, $44, $0c, $00, $44, $0c, $00, $44, $0c, $00
?Instrument_3
    .byte $0c, $0c, $19, $19, $00, $20, $00, $00, $00, $00, $00, $00, $02, $33, $02, $00
    .byte $22, $02, $00, $11, $02, $00, $11, $02, $00, $00, $00, $00
?Instrument_4
    .byte $0d, $0d, $35, $35, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c, $bb, $0a
    .byte $00, $88, $0a, $00, $66, $0a, $0c, $33, $0a, $00, $33, $0a, $00, $55, $0a, $00
    .byte $44, $0a, $00, $55, $0a, $00, $44, $0a, $00, $33, $0a, $00, $11, $0a, $00, $11
    .byte $0a, $00, $00, $00, $00, $00, $00, $00
?Instrument_5
    .byte $0c, $0c, $1c, $1c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $66, $0e, $00
    .byte $55, $0e, $00, $44, $0e, $00, $44, $0e, $00, $33, $0e, $00, $33, $0e, $00
?Instrument_6
    .byte $0c, $0c, $25, $25, $00, $00, $30, $00, $00, $00, $00, $00, $00, $bb, $0e, $00
    .byte $88, $0e, $00, $66, $0e, $00, $55, $0e, $00, $44, $0e, $00, $33, $0e, $00, $22
    .byte $0e, $00, $22, $0e, $00, $22, $0e, $00
?Instrument_7
    .byte $0c, $0c, $2b, $2b, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $12, $06
    .byte $99, $1a, $c0, $99, $1a, $d0, $88, $1a, $e0, $44, $18, $06, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
?Instrument_8
    .byte $0c, $0c, $28, $28, $00, $00, $00, $00, $00, $00, $00, $00, $00, $66, $18, $03
    .byte $77, $1a, $90, $66, $1a, $a0, $55, $1a, $c0, $44, $18, $03, $33, $18, $03, $33
    .byte $18, $03, $22, $18, $03, $00, $00, $00, $00, $00, $00
?Instrument_9
    .byte $0c, $0c, $16, $16, $00, $00, $00, $00, $00, $00, $00, $00, $30, $55, $08, $00
    .byte $22, $08, $00, $11, $08, $00, $00, $00, $00
?Instrument_10
    .byte $0c, $0c, $1f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $77, $02, $00
    .byte $55, $08, $00, $44, $02, $05, $33, $08, $00, $33, $08, $00, $22, $00, $00, $00
    .byte $00, $00
?Instrument_11
    .byte $0c, $0c, $25, $25, $00, $00, $00, $00, $00, $00, $00, $00, $00, $66, $0a, $00
    .byte $55, $0a, $00, $44, $0a, $00, $44, $0a, $00, $33, $0a, $00, $22, $0a, $00, $22
    .byte $0a, $00, $11, $0a, $00, $00, $00, $00
?Instrument_12
    .byte $0c, $0c, $31, $31, $00, $00, $00, $00, $00, $00, $00, $00, $00, $66, $0a, $00
    .byte $55, $0a, $00, $44, $0a, $00, $44, $0a, $00, $33, $0a, $00, $33, $0a, $00, $33
    .byte $0a, $00, $33, $0a, $00, $33, $0a, $00, $22, $0a, $00, $11, $0a, $00, $11, $0a
    .byte $00, $00, $00, $00
?Instrument_13
    .byte $0c, $0c, $2e, $2e, $00, $00, $40, $00, $00, $00, $00, $00, $00, $aa, $0c, $00
    .byte $99, $0c, $00, $88, $0c, $00, $77, $0c, $00, $55, $0c, $00, $55, $0c, $00, $44
    .byte $0c, $00, $44, $0c, $00, $44, $0c, $00, $44, $0c, $00, $44, $0c, $00, $33, $0c
    .byte $00
?Instrument_14
    .byte $0c, $0c, $31, $31, $00, $00, $40, $00, $01, $02, $00, $00, $00, $aa, $0a, $00
    .byte $66, $0a, $00, $66, $0a, $00, $55, $0a, $00, $44, $0a, $00, $33, $0a, $00, $33
    .byte $0a, $00, $33, $0a, $00, $22, $0a, $00, $22, $0a, $00, $22, $0a, $00, $22, $0a
    .byte $00, $22, $0a, $00
?Instrument_15
    .byte $0e, $0c, $24, $24, $00, $00, $40, $00, $00, $00, $00, $00, $00, $05, $09, $66
    .byte $0a, $00, $55, $0a, $00, $55, $0a, $00, $44, $0a, $00, $33, $0a, $00, $33, $0a
    .byte $00, $33, $0a, $00, $33, $0a, $00
?Instrument_16
    .byte $0c, $0c, $37, $22, $05, $00, $20, $00, $00, $00, $00, $00, $00, $66, $18, $00
    .byte $ff, $06, $00, $ee, $06, $00, $dd, $06, $00, $cc, $06, $00, $bb, $06, $00, $bb
    .byte $06, $00, $55, $06, $00, $55, $06, $00, $44, $06, $00, $44, $06, $00, $44, $06
    .byte $00, $44, $06, $00, $33, $06, $00, $33, $06, $00
?Instrument_17
    .byte $0c, $0c, $0d, $0d, $00, $00, $80, $00, $00, $00, $00, $00, $00, $ee, $02, $00
?Instrument_18
    .byte $0c, $0c, $0d, $0d, $00, $00, $80, $00, $00, $00, $00, $00, $00, $ff, $02, $00
?Instrument_19
    .byte $0c, $0c, $55, $55, $00, $00, $80, $00, $1c, $00, $01, $00, $00, $11, $08, $00
    .byte $11, $08, $01, $22, $08, $02, $22, $08, $03, $33, $08, $04, $33, $08, $05, $44
    .byte $08, $06, $44, $08, $07, $55, $08, $08, $55, $08, $09, $66, $08, $0a, $66, $08
    .byte $0b, $77, $08, $0c, $77, $08, $0d, $88, $08, $0e, $88, $08, $0f, $99, $08, $10
    .byte $99, $08, $11, $aa, $08, $12, $aa, $08, $13, $bb, $08, $14, $cc, $08, $15, $dd
    .byte $08, $16, $ee, $08, $17, $ff, $08, $18
?Instrument_20
    .byte $0c, $0c, $5e, $5e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $bb, $0a, $04
    .byte $bb, $0a, $04, $00, $00, $00, $00, $00, $00, $bb, $0a, $00, $bb, $0a, $00, $00
    .byte $00, $00, $00, $00, $00, $bb, $0a, $05, $bb, $0a, $05, $00, $00, $00, $00, $00
    .byte $00, $bb, $0a, $07, $bb, $0a, $07, $00, $00, $00, $00, $00, $00, $bb, $0a, $0c
    .byte $99, $0a, $0c, $77, $0a, $0c, $66, $0a, $0c, $55, $0a, $0c, $44, $0a, $0c, $33
    .byte $0a, $0c, $22, $0a, $0d, $22, $0a, $0c, $11, $0a, $0b, $11, $0a, $0c, $00, $00
    .byte $00
?Instrument_21
    .byte $10, $0e, $26, $1a, $04, $00, $40, $00, $00, $00, $00, $00, $00, $03, $07, $0e
    .byte $0c, $88, $0a, $00, $cc, $0a, $00, $ee, $0a, $00, $ff, $0a, $00, $cc, $0a, $00
    .byte $99, $0a, $00, $77, $0a, $00, $66, $0a, $00
?Instrument_22
    .byte $11, $11, $5d, $5d, $04, $00, $00, $00, $01, $01, $00, $00, $0e, $12, $15, $0e
    .byte $0e, $00, $77, $0a, $0c, $88, $0a, $00, $aa, $0a, $00, $88, $0a, $00, $77, $0a
    .byte $00, $77, $0a, $0c, $88, $0a, $00, $aa, $0a, $00, $88, $0a, $00, $77, $0a, $00
    .byte $77, $0a, $0c, $88, $0a, $00, $aa, $0a, $00, $88, $0a, $00, $77, $0a, $00, $77
    .byte $0a, $0c, $88, $0a, $00, $aa, $0a, $00, $88, $0a, $00, $77, $0a, $00, $33, $0a
    .byte $0c, $33, $0a, $00, $44, $0a, $00, $33, $0a, $00, $33, $0a, $00, $00, $00, $00
?Instrument_23
    .byte $0c, $0c, $3a, $3a, $00, $00, $00, $00, $00, $00, $00, $00, $00, $bb, $10, $03
    .byte $77, $0a, $00, $99, $10, $04, $88, $10, $04, $77, $10, $04, $66, $10, $04, $55
    .byte $10, $05, $44, $10, $05, $33, $10, $05, $33, $10, $05, $22, $10, $06, $22, $10
    .byte $06, $11, $10, $06, $11, $10, $06, $11, $10, $07, $00, $00, $00
?Instrument_24
    .byte $0c, $0c, $2e, $0d, $00, $00, $80, $00, $00, $00, $00, $00, $00, $ff, $0a, $00
    .byte $ff, $8a, $00, $ff, $8a, $00, $ff, $0a, $03, $ff, $8a, $03, $ff, $8a, $03, $ff
    .byte $0a, $07, $ff, $8a, $07, $ff, $8a, $07, $ff, $0a, $03, $ff, $8a, $03, $ff, $8a
    .byte $03
?Instrument_25
    .byte $0e, $0c, $18, $0f, $4f, $00, $10, $00, $00, $00, $00, $00, $00, $00, $00, $ee
    .byte $3a, $01, $cc, $0a, $07, $aa, $0a, $0c, $66, $0a, $13
?Instrument_26
    .byte $0f, $0c, $55, $55, $00, $00, $80, $00, $05, $00, $00, $00, $00, $09, $05, $0c
    .byte $55, $0a, $00, $55, $0a, $00, $77, $0a, $00, $77, $0a, $00, $88, $0a, $00, $88
    .byte $0a, $00, $88, $0a, $00, $88, $0a, $00, $88, $0a, $00, $88, $0a, $00, $88, $0a
    .byte $00, $88, $0a, $00, $77, $0a, $00, $77, $0a, $00, $66, $0a, $00, $66, $0a, $00
    .byte $66, $0a, $00, $55, $0a, $00, $55, $0a, $00, $44, $0a, $00, $44, $0a, $00, $33
    .byte $0a, $00, $22, $0a, $00, $22, $0a, $00
?Instrument_27
    .byte $0c, $0c, $25, $25, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $10, $03
    .byte $ff, $1a, $d0, $ff, $1a, $e0, $bb, $1a, $f0, $77, $1a, $f8, $44, $10, $04, $33
    .byte $10, $04, $33, $10, $04, $00, $10, $00