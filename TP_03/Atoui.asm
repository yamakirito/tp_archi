			org		$4
			
vector_001	dc.l	Main

			org 	$500
			
Main		movea.l	#String1,a0
			jsr		Atoui
			
			movea.l	#String2,a0
			jsr		Atoui
			
			movea.l	#String3,a0
			jsr		Atoui
			
			illegal

Atoui		movem.l	d1/a0,-(a7)
			clr.l	d1
			clr.l 	d0

\loop		move.b	(a0)+,d1
			beq 	\quit
			
			subi.b	#'0',d1
			
			mulu.w	#10,d0
			add.l	d1,d0
			
			bra		\loop

\quit		movem.l	(a7)+,d1/a0
			rts

String1 	dc.b	"52146",0
String2		dc.b	"309",0
String3		dc.b	"2570",0
