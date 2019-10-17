			org		$4
			
vector_001	dc.l	Main

			org		$500
			
Main		movea.l	#String,a0
			jsr		RemoveSpace
			
			jsr 	IsCharError
			
			illegal

RemoveSpace	movea.l	#String,a1
			clr.l	d0
			movem.l	d0/a0/a1,-(a7)

\loop		move.b	(a0)+,d0
			beq 	\quit
			
			cmp.b	#' ',d0
			beq		\loop
			
			move.b	d0,(a1)+
			bra		\loop

\quit		move.b	#0,(a1)+
			movem.l	(a7)+,d0/a0/a1
			movea.l	#0,a1
			rts
			
IsCharError	clr.l	d0
			movem.l	d0/a0,-(a7)

\loop		move.b	(a0)+,d0
			beq		\false
			
			cmp.b	#'0',d0
			blo		\true
			
			cmp.b	#'9',d0
			bhi		\true
			
			bra		\loop

\true		ori.b	#%00000100,ccr
			bra 	\quit

\false		andi.b	#%11111011,ccr
			bra		\quit
	
\quit		movem.l (a7)+,d0/a0
			rts
			
IsMaxError	clr.l 	d0
			clr.l	d1
			movem.l d0/d1/a0,-(a7)
			
\loop		move.b	(a0)+,d1
			beq 	\quit
			
\quit 		movem.l	(a7)+,d0/d1/a0
			rts

String		dc.b	" 5 +  12 ",0
String1		dc.b	"56",0
String2		dc.b	"3d42",0
