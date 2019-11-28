				; ==============================
				; Définition des constantes
				; ==============================
			
				; Mémoire vidéo
				; ------------------------------
			
VIDEO_START 	equ		$ffb500							; Adresse de départ
VIDEO_WIDTH		equ		480								; Largeur en pixels
VIDEO_HEIGHT	equ		320								; Hauteur en pixels
VIDEO_SIZE		equ 	(VIDEO_WIDTH*VIDEO_HEIGHT/8)	; Taille en octets
BYTE_PER_LINE	equ		(VIDEO_WIDTH/8)					; Nombre d'octets par ligne

				; ==============================
				; Initialisation des vecteurs
				; ==============================
				
				org  	$0
				
vector_000		dc.l	VIDEO_START						; Valeur initiale de A7
vector_001		dc.l	Main							; Valeur initiale du PC

				; ==============================
				; Programme principal
				; ==============================
				
				org		$500
				
Main			jsr		WhiteSquare32

				move.l	#$0,d0
				jsr		FillScreen
				
				jsr		WhiteSquare128

				move.l	#$ffffffff,d0
				jsr		FillScreen

				move.l	#$f0f0f0f0,d0
				jsr		FillScreen
				
				move.l	#$fff0fff0,d0
				jsr		FillScreen
				
				move.l	#$0,d0
				jsr		FillScreen
				
				jsr		HLines
				
				illegal

				; ==============================
				; Sous-programmes
				; ==============================
				
FillScreen		movem.l	d7/a0,-(a7)
				lea 	VIDEO_START,a0
				move.w	#VIDEO_SIZE/4-1,d7
				
\loop			move.l	d0,(a0)+
				dbra	d7,\loop
				
				movem.l	(a7)+,d7/a0
				rts

;				movea.l	#$ffb500,a0
;
;\loop			move.l	d0,(a0)+
;				cmpa.l	VIDEO_END,a0
;				bls		\loop
;				
;\quit			rts


HLines			movem.l	d6/d7/a0,-(a7)
				lea		VIDEO_START,a0
				move.l	#VIDEO_HEIGHT/16-1,d7
				
\loop			move.w	#BYTE_PER_LINE*8/4-1,d6

\white_loop		move.l	#$ffffffff,(a0)+
				dbra	d6,\white_loop
				
				move.w	#BYTE_PER_LINE*8/4-1,d6
				
\black_loop		clr.l	(a0)+
				dbra	d6,\black_loop
				
				dbra	d7,\loop
				
				movem.l	(a7)+,d6/d7/a0
				rts

;				movea.l	#$ffb500,a0
;				move.l	#$ffffffff,d0
;				clr.l	d1
;				
;\loop			move.l	d0,(a0)+
;				addq.l	#1,d1
;				
;				cmpi.l	#$78,d1
;				blo		\loop
;				
;				cmpa.l	VIDEO_END,a0
;				bhi		\quit
;				
;				clr.l	d1
;				adda.l	#$1E0,a0
;				
;				cmpa.l	VIDEO_END,a0
;				bls		\loop
;
;\quit			rts

WhiteSquare32	movem.l	d0/d6/d7/a0,-(a7)
				lea		VIDEO_START,a0

				;320/2-16 = 144/176 pixel de hauteur
				;480/2-16 = 224/256 pixel de largeur
				
				move.w	#BYTE_PER_LINE*144/4-1,d6
\height_loop	clr.l	(a0)+
				dbra	d6,\height_loop
				
				move.w	#144/4,d6
\center_loop	clr.l	(a0)+
				dbra	d6,\center_loop
				
				move.l	#$ffffffff,d0
				move.w	#32,d7
\draw_loop		move.w	#BYTE_PER_LINE/4-2,d6
				move.l	d0,(a0)+
				
\enter_loop		clr.l	(a0)+
				dbra	d6,\enter_loop
				
				dbra	d7,\draw_loop
				
				movem.l	(a7)+,d0/d6/d7/a0
				rts
		
			
WhiteSquare128	movem.l	d0/d5-d7/a0,-(a7)
				lea		VIDEO_START,a0

				;320/2-64 = 98/232 pixel de hauteur
				;480/2-64 = 176/304 pixel de largeur
				
				move.w	#BYTE_PER_LINE*98/4-1,d6
\height_loop	clr.l	(a0)+
				dbra	d6,\height_loop
				
				move.w	#98/4-4,d6
\center_loop	clr.l	(a0)+
				dbra	d6,\center_loop
				
				move.l	#$ffffffff,d0
				move.w	#128,d7
\draw_loop		move.w	#BYTE_PER_LINE/4-5,d6
				move.w	#3,d5

\loop			move.l	d0,(a0)+
				dbra	d5,\loop
				
\enter_loop		clr.l	(a0)+
				dbra	d6,\enter_loop
				
				dbra	d7,\draw_loop
				
				movem.l	(a7)+,d0/d5-d7/a0
				rts
				

WhiteSquare		movem.l	d0/d6/d7/a0,-(a7)
				lea		VIDEO_START,a0
				
				adda.l	
				
				; ==============================
				; Données
				; ==============================
				
VIDEO_END		dc.l	$ffffff			
