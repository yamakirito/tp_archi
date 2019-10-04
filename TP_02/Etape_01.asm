			org 	$4

Vector_001	dc.l	Main

			org 	$500

Main 		clr.l	d1				; D1 = 0
			move.l	#$80000007,d0

loop1		addq.l	#1,d1			; D1 = $00000007
			subq.w	#1,d0			; D0 est sur w
			bne		loop1

			clr.l	d2				; D2 = 0
			move.l	#$fe2310,d0

loop2		addq.l 	#1,d2			; D2 = $7F1188
			subq.l	#2,d0
			bne		loop2

			clr.l	d3				; D3 = 0
			moveq.l	#125,d0

loop3		addq.l	#1,d3			; D3 = $7E
			dbra	d0,loop3		; DBRA = DBF

			clr.l	d4				; D4 = 0
			moveq.l	#10,d0

loop4		addq.l	#1,d4			; D4 = $14
			addq.l	#1,d0
			cmpi.l	#30,d0
			bne		loop4

			illegal