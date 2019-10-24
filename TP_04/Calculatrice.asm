			; ==============================
			; Initialisation des vecteurs
			; ==============================
			
			org		$0
			
vector_000	dc.l	$ffb500
vector_001	dc.l	Main

			; ==============================
			; Programme principal
			; ==============================
			
			org		$500
			
Main		lea 	sTest,a0
			move.b	#24,d1
			move.b	#20,d2
			jsr		Print
			
			movea.l	cTest,a0
			jsr		GetNum
			
			illegal
			
			; ==============================
			; Sous-programmes
			; ==============================

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
			move.l	a0,-(a7)
			
\loop		tst.b	(a0)+
			beq		\quit
			
			addq.l	#1,d0
			bra		\loop
			
\quit		move.l	(a7)+,a0
			rts
			
			
IsMaxError	movem.l d0/a0,-(a7)
			jsr 	StrLen
			
			cmpi.b	#5,d0
			blo		\false
			bhi		\true
			
			move.b	#'3',(a0)+
			blo		\false
			bhi		\true
			
			move.b	#'2',(a0)+
			blo		\false
			bhi		\true
			
			move.b	#'7',(a0)+
			blo		\false
			bhi		\true
			
			move.b	#'6',(a0)+
			blo		\false
			bhi		\true
			
			move.b	#'7',(a0)
			bhi		\true

\false		andi.b	#%11111011,ccr
			bra 	\quit

\true		ori.b	#%00000100,ccr
			
\quit 		movem.l	(a7)+,d0/a0
			rts
			
			
Atoui		movem.l	d0/a0,-(a7)
			clr.l	d1
			clr.l 	d0

\loop		move.b	(a0)+,d0
			beq 	\quit
			
			subi.b	#'0',d0
			
			mulu.w	#10,d1
			add.l	d0,d1
			
			bra		\loop

\quit		movem.l	(a7)+,d0/a0
			rts	
					
					
Convert		tst.b 	(a0)
			beq		\false
			
			jsr		IsCharError
			beq		\false
			
			jsr		IsMaxError
			beq		\false
			
			jsr		Atoui
			
\true		ori.b	#%00000100,ccr
			rts
			
\false		andi.b	#%11111011,ccr
			rts
			
			
Print		movem.l	a0/d0,-(a7)

\loop		move.b	(a0)+,d0
			beq		\quit

			addq.b	#1,d1

			jsr 	PrintChar
			bra 	\loop

\quit		movem.l	(a7)+,a0/d0
			rts


PrintChar	incbin	"PrintChar.bin"


NextOp		tst.b	(a0)
			beq		\quit
			
			cmpi.b	#'+',(a0)
			beq		\quit
			
			cmpi.b	#'*',(a0)
			beq		\quit
			
			cmpi.b	#'-',(a0)
			beq		\quit
			
			cmpi.b	#'/',(a0)
			beq 	\quit
			
			addq.l	#1,a0
			bra		NextOp
			
\quit		rts


GetNum		clr.l 	d0
			movem.l	a1/a2/d1,-(a7)
			
			movea.l	a0,a1
			jsr		NextOp
			movea.l	a0,a2
						
			move.b	(a2),d1
			move.b	#0,(a0)
			
			movea.l	a1,a0
			jsr		Convert
			beq		\false
			
\true		move.b	d1,(a2)
			movea.l	a2,a0
			movem.l	(a7)+,a1/a2/d1
			rts
			
\false		movem.l	(a7)+,a1/a2/d1
			rts

			; ==============================
			; Données
			; ==============================

sTest		dc.b	"Hello World",0
String		dc.b	" 5 +  12 ",0
cTest		dc.b	"104+9*2-3",0
