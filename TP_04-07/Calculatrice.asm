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
			
Main		movea.l	#sInput,a0
			clr.b	d1
			clr.b	d2
			jsr		Print
			
			movea.l	#sBuffer,a0
			addq.b	#2,d2
			move.l	#60000,d3
			move.l	#8000,d4
			jsr		GetInput
			
			jsr		RemoveSpace			
			movea.l	#sResult,a0
			addq.b	#2,d2
			jsr 	Print
			
			addq.b	#2,d2
			
			movea.l	#sBuffer,a0
			jsr 	GetExpr
			bne		\error
			
\noError	jsr		Itoa
			jsr 	Print
			bra		\quit

\error		movea.l	#sError,a0
			jsr		Print
			
\quit		illegal
			
			; ==============================
			; Sous-programmes
			; ==============================

RemoveSpace	movem.l	d0/a0/a1,-(a7)
			movea.l	a0,a1

\loop		move.b	(a0)+,d0
			beq 	\quit
			
			cmpi.b	#' ',d0
			beq		\loop
			
			move.b	d0,(a1)+
			bra		\loop

\quit		movem.l	(a7)+,d0/a0/a1
			rts
			
			
IsCharError	movem.l	d0/a0,-(a7)

\loop		move.b	(a0)+,d0
			beq		\false
			
			cmpi.b	#'0',d0
			blo		\true
			
			cmpi.b	#'9',d0
			bls		\loop

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
			
			
Print		movem.l	a0/d0-d1,-(a7)

\loop		move.b	(a0)+,d0
			beq		\quit

			jsr 	PrintChar

			addq.b	#1,d1
			bra 	\loop

\quit		movem.l	(a7)+,a0/d0-d1
			rts


PrintChar	incbin	"PrintChar.bin"


GetInput	incbin	"GetInput.bin"


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


GetNum		movem.l	a1-a2/d1,-(a7)
			
			movea.l	a0,a1
			jsr		NextOp
			movea.l	a0,a2
						
			move.b	(a2),d1
			clr.b	(a2)
			
			movea.l	a1,a0
			jsr		Convert
			beq		\true
			
\false		move.b	d1,(a2)
			andi.b 	#%11111011,ccr
			bra 	\quit
			
\true		move.b	d1,(a2)
			movea.l	a2,a0
			ori.b	#%00000100,ccr

\quit		movem.l	(a7)+,a1-a2/d1
			rts
			
			
GetExpr		movem.l	a0/d1-d2,-(a7)
			jsr 	GetNum
			bne 	\false
			move.l	d0,d1
			
\loop		move.b 	(a0)+,d2
			beq		\true
			
			jsr		GetNum
			bne 	\false
			
			cmp.b	#'+',d2
			add.l	d0,d1
			bra 	\loop
			
			cmp.b	#'-',d2
			sub.l	d0,d1
			bra 	\loop
			
			cmp.b	#'*',d2
			muls.w	d0,d1
			bra		\loop
			
			tst.w	d0
			beq		\false
			divs.w	d0,d1
			ext.l	d1
			bra		\loop

\false		andi.b 	#%11111011,ccr
			bra 	\quit

\true		move.l	d1,d0
			ori.b	#%00000100,ccr

\quit		movem.l	(a7)+,a0/d1-d2
			rts
			
			
Uitoa		movem.l	a0/d0,-(a7)
			clr.w	-(a7)
			
\loop		andi.l	#$ffff,d0
			divu.w	#10,d0
			swap	d0
			
			addi.b	#'0',d0
			move.w	d0,-(a7)
			swap	d0
			
			tst.w	d0
			bne		\loop
			
\dequeue	move.w	(a7)+,d0
			move.b	d0,(a0)+
			bne		\dequeue
			
			movem.l	(a7)+,a0/d0
			rts
			
			
Itoa		movem.l	a0/d0,-(a7)
			tst.w 	d0
			bpl		\positive
			
\negative	move.b	#'-',(a0)+
			neg.w	d0
			
\positive	jsr		Uitoa
			
\quit		movem.l	(a7)+,a0/d0
			rts
			
			
			; ==============================
			; Données
			; ==============================

sInput		dc.b	"Veuillez saisir une expression :",0
sResult		dc.b	"Resultat :",0
sError		dc.b	"Erreur",0
sBuffer		ds.b	60
