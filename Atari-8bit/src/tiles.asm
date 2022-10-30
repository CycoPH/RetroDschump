; Dschump 4x3 tiles; Action tiles
tiles:
			.word tile0,tile1,tile2,tile3,
			.word tile4,tile5,tile6,tile7,
			.word tile8,tile9,tile10,tile11,
			.word tile12,tile13,tile14,tile15,
			.word tile16,tile17,tile18,tile19,
			.word tile20,tile21,tile22,tile23,
			.word tile24,tile25,tile26,tile27,
			.word tile28,tile29,tile30,tile31,
; Build tiles: 32 ...
			.word build32,build33,build34,build35,
			.word build36,build37,build38,build39,
			.word build40,build41,build42,build43,
			.word build44,build45,build46,build47,
			.word build48,build49,build50,build51,
			.word build52,build53,build54,build55,
			.word build56,build57,build58,build59,
			.word build60,build61,build62,build63,
;
; What chars make up the individual tiles ?
; Two types of tiles:
; 1.Action tiles - these do something when you land on them
; 2.Build tiles - just decoration
;
; Action tiles
tile0	.byte	128,128,128,128, 128,128,128,128, 128,128,128,128		; #0 Blank
tile1	.byte	19,20,21,22, 11,127,23,14, 24,25,26,27					; #1 Worm hole
tile2	.byte	41,42,42,43, 44,125,125,45, 46,47,47,48					; #2 Switch up 4 pins
tile3	.byte	34,35,35,36, 37,125,125,37, 38,39,39,40					; #3 Switch down 4 pins
tile4	.byte	52,83,83,53, 44,124,124,45, 54,84,84,55					; #4 Switch up blue
tile5	.byte	56,85,85,57, 37,124,124,37, 58,86,86,59					; #5 Switch down blue
tile6	.byte	52,211,211,53, 44,252,252,45, 54,212,212,55				; #6 Switch up green
tile7	.byte	56,213,213,57, 37,252,252,37, 58,214,214,59				; #7 Switch down green
tile8	.byte	52,42,42,53, 44,125,125,45, 54,47,47,55					; #8 Switch up no pins
tile9	.byte	56,35,35,57, 37,125,125,37, 58,39,39,59					; #9 Switch down no pins
tile10	.byte	41,42,42,43, 44,125,125,45, 46,47,47,48					; #10 OneTime Switch up 4 pins
tile11	.byte	56,35,35,57, 37,125,125,37, 58,39,39,59					; #11 OneTime Switch down no pins
tile12	.byte	7,29,29,10, 30,75,76,31, 15,33,33,18					; #12 Break step 1/3
tile13	.byte	7,29,29,10, 30,77,78,31, 15,33,33,18					; #13 Break step 2/3
tile14	.byte	79,80,80,10, 30,77,78,31, 15,81,82,18					; #14 Break step 3/3
tile15	.byte	7,29,29,10, 248,249,250,251, 15,33,33,18				; #15 The End
tile16	.byte	34,49,49,50, 37,0,0,37, 38,51,51,40						; #16 Hole 4 pins
tile17	.byte	56,49,49,57, 37,0,0,37, 58,51,51,59						; #17 Hole no pins
tile18	.byte	41,42,42,43, 44,96,97,45, 46,47,47,48					; #18 Pickup blue
tile19	.byte	52,42,42,53, 44,224,225,45, 54,47,47,55					; #19 Pickup green
tile20	.byte	19,230,231,22, 30,232,233,31, 24,234,235,27				; #20 Toggle arrow
tile21	.byte	19,29,29,22, 30,228,229,31, 24,33,33,27					; #21 Down arrow
tile22	.byte	19,29,29,22, 30,226,227,31, 24,33,33,27					; #22 Up arrow
tile23	.byte	7,29,29,10, 244,245,117,118, 15,33,33,18				; #23 Spikes
tile24	.byte	7,29,29,10, 30,75,76,31, 15,33,33,18					; #24 Break 1->2
tile25	.byte	7,29,29,10, 30,77,78,31, 15,33,33,18					; #25 Break 2->3
tile26	.byte	79,80,80,10, 30,77,78,31, 15,81,82,18					; #26 Break 3->Blank
tile27	.byte	7,62,63,10, 11,64,65,14, 15,66,67,18					; #27 Blue pool
tile28	.byte	7,190,191,10, 11,192,193,14, 15,194,195,18				; #28 Green pool
tile29	.byte	19,29,29,22, 94,224,225,95, 24,33,33,27					; #29 Add life
tile30	.byte	19,29,29,22, 30,219,91,31, 24,33,33,27					; #30 No left movement
tile31	.byte	19,29,29,22, 30,90,218,31, 24,33,33,27					; #31 No right movement
; Build tiles: 32 ...
build32	.byte	7,8,9,10, 11,12,13,14, 15,16,17,18						; #32 Hole closed 4 pins
build33	.byte	7,29,29,10, 30,125,125,31, 15,33,33,18					; #33 Flat 4 pins
build34	.byte	7,29,29,22, 30,125,125,31, 24,33,33,18					; #34 Flat 2 pins tl-br
build35	.byte	19,29,29,10, 30,125,125,31, 15,33,33,27					; #35 Flat 2 pins tr-bl
build36	.byte	19,29,29,22, 30,125,125,31, 24,33,33,27					; #36 Flat no pins
build37	.byte	68,69,70,71, 30,125,30,125, 24,33,24,33					; #37 Left raised
build38	.byte	71,71,71,71, 125,125,125,125, 33,33,33,33				; #38 Mid raised
build39	.byte	71,72,73,74, 125,31,125,31, 33,27,33,27					; #39 Right raised
build40	.byte	41,42,42,43, 44,87,88,45, 46,47,47,48					; #40 Pyramid
build41	.byte	34,35,35,50, 37,125,125,45, 38,47,47,48					; #41 Black square
build42	.byte	28,29,29,220, 30,125,125,31, 32,33,33,221				; #42 Alt flat no pins
build43	.byte	34,49,49,36, 37,127,127,37, 38,51,51,40					; #43 OneTime Switch down black 4 pins
build44	.byte	56,49,49,57, 37,127,127,37, 58,51,51,59					; #44 OneTime Switch down black no pins
build45	.byte	19,8,9,22, 11,12,13,14, 24,16,17,27						; #45 Hole closed no pins
build46	.byte	7,238,239,10, 240,241,242,243, 15,33,33,18				; #46 Hint Up
build47	.byte	7,29,29,10, 240,241,242,243, 15,236,237,18				; #47 Hint Down
build48	.byte	7,10,19,29, 15,18,30,125, 19,29,125,125					; #48 Free
build49	.byte	29,29,29,29, 125,125,125,125, 125,7,10,125				; #49 Free
build50	.byte	29,22,7,10, 125,31,15,18, 125,125,29,22					; #50 Free
build51	.byte	29,29,29,29, 125,125,125,125, 125,125,125,125			; #51 Free
build52	.byte	7,29,29,29, 30,19,29,29, 30,30,7,29						; #52 Free
build53	.byte	29,29,29,10, 29,29,22,31, 29,10,31,31					; #53 Free
build54	.byte	19,22,19,29, 24,27,30,125, 19,29,125,125				; #54 Free
build55	.byte	29,22,19,22, 125,31,24,27, 125,125,29,22				; #55 Free
build56	.byte	24,33,125,125, 7,10,30,125, 15,18,24,33					; #56 Free
build57	.byte	125,15,18,125, 125,125,125,125, 33,33,33,33				; #57 Free
build58	.byte	125,125,33,27, 125,31,7,10, 33,27,15,18					; #58 Free
build59	.byte	125,125,125,125, 125,125,125,125, 33,33,33,33			; #59 Free
build60	.byte	30,30,15,33, 30,24,33,33, 15,33,33,33					; #60 Free
build61	.byte	33,18,31,31, 33,33,27,31, 33,33,33,18					; #61 Free
build62	.byte	24,33,125,125, 19,22,30,125, 24,27,24,33				; #62 Free
build63	.byte	125,125,33,27, 125,31,19,22, 33,27,24,27				; #63 Free
