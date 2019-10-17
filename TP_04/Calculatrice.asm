			org		$4
			
vector_001	dc.l	Main

			org		$500
			
Main		movea.l	#String,a0
			jsr		RemoveSpace
			
			movea.l	#String1,a1
			jsr 	IsMaxError
			movea.l	#String2,a1
			jsr 	IsMaxError
			movea.l	#String3,a1
			jsr 	IsMaxError
			movea.l	#String4,a1
			jsr 	IsMaxError
			
			illegal


RemoveSpace	movea.l	#String,a1
			clr.l	d0
			movem.l	d0/a0/a1,-(a7)

\loop		move.b	(a0)+,d0
			beq 	\quit
			
			cmpi.b	#' ',d0
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
			
			cmpi.b	#'0',d0
			blo		\true
			
			cmpi.b	#'9',d0
			bhi		\true
			
			bra		\loop

\true		ori.b	#%00000100,ccr
			bra 	\quit

\false		andi.b	#%11111011,ccr
	
\quit		movem.l (a7)+,d0/a0
			rts


StrLen		clr.l	d0
			move.l	a1,-(a7)
			
\loop		tst.b	(a1)+
			beq		\quit
			
			addq.l	#1,d0
			bra		\loop
			
\quit		move.l	(a7)+,a1
			rts
			
			
IsMaxError	movem.l d0/a1,-(a7)
			jsr 	StrLen
			
			cmpi.b	#5,d0
			blo		\false
			bhi		\true
			
			move.b	#'3',(a1)+
			blo		\false
			bhi		\true
			
			move.b	#'2',(a1)+
			blo		\false
			bhi		\true
			
			move.b	#'7',(a1)+
			blo		\false
			bhi		\true
			
			move.b	#'6',(a1)+
			blo		\false
			bhi		\true
			
			move.b	#'7',(a1)
			bhi		\true

\false		andi.b	#%11111011,ccr
			bra 	\quit

\true		ori.b	#%00000100,ccr
			
\quit 		movem.l	(a7)+,d0/a1
			rts
			
			
Atoui		movem.l	d0/a1,-(a7)
			clr.l	d1
			clr.l 	d0

\loop		move.b	(a1)+,d0
			beq 	\quit
			
			subi.b	#'0',d0
			
			mulu.w	#10,d1
			add.l	d0,d1
			
			bra		\loop

\quit		movem.l	(a7)+,d0/a1
			rts	
			
					
Convert		move.b	(a1),d0
			beq		\false
			
			jsr		IsCharError
			beq		\false
			
			jsr		IsMaxError
			beq		\false
			
			jsr		Atoui
			bra 	\true

\false		andi.b	#%11111011,ccr
			bra 	\quit

\true		ori.b	#%00000100,ccr

\quit		rts

String		dc.b	" 5 +  12 ",0
String1		dc.b	"56",0
String2		dc.b	"32742",0
String3		dc.b	"32769",0
String4		dc.b	"353456",0
