			org		$4
			
vector_001	dc.l	Main

			org		$500
			
Main		movea.l	#String,a0
			jsr		RemoveSpace
			movea.l	#Stringtest,a2
			
			illegal

RemoveSpace	movem.l	d0/a0/a1,-(a7)
			clr.l	d0

\loop		move.b	(a0)+,d0
			beq 	\quit
			
			cmp.b	#' ',d0
			beq		\loop
			
			move.b	d0,(a1)+
			bra		\loop

\quit		movem.l	(a7)+,d0/a1/a0
			rts

String		dc.b	" 5 +  12 ",0
Stringtest	dc.b	"5+12"
