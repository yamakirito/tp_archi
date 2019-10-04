			org $4

Vector_001	dc.l	Main

			org $500

Main 		movea.l #TAB,a0
			movea.l	#TAB1,a1

			move.b 	1(a0),d0
			move.b	3(a0),d1
			add.b	d1,d0
			move.b	d0,SUM8

			move.w	(a0)+,d0
			move.w	(a0)+,d1
			add.w	d1,d0
			move.w	d0,SUM16

			move.w	2(a0),d0
			move.w	(a0)+,d1
			add.w	d1,d0
			move.w	d0,SUM16B

			move.l	(a1)+,d0
			move.l	(a1)+,d1
			add.l	d1,d0
			move.l	d0,SUM32

			illegal

			org $550

TAB			dc.w	$B4,$4C,$4AC9,$D841
TAB1		dc.l	$FFFFFFFF,$00000015
SUM8		ds.b	1
SUM16		ds.w	1
SUM16B		ds.w	1
SUM32		ds.l	1

; Addition sur 8 bits : $B4 + $4C = $00, C = 1, V = 0, Z = 1, N = 0
; Addition sur 16 bits : $B4 + $4C = $0100, C = 0, V = 0, Z = 0, N = 0
; Addition sur 16 bits : $4AC9 + $D841 = $ 230A, C = 1, V = 1, Z = 0, N = 0
; Addition sur 32 bits : $FFFFFFFF + $00000015 = $00000014, C = 1, V = 0, Z = 0, N = 0