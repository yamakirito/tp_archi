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
				
Main			lea		Invader_Bitmap,a0
				lea		VIDEO_START,a1
				move.w	#16-1,d7
				
\loop			move.b	(a0)+,(a1)
				move.b	(a0)+,1(a1)
				move.b	(a0)+,2(a1)
				
				adda.l	#BYTE_PER_LINE,a1
				dbra	d7,\loop
				
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

WhiteSquare32	movem.l d7/a0,-(a7)

				; Fait pointer A0 sur l'emplacement du carré.
				
				; Centrage horizontal :
				; La largeur ci-dessous est mesurée en octets.
				; Largeur totale = Largeur de la fenêtre = BYTE_PER_LINE
				; Largeur du carré = 4 octets (32 pixels)
				; Déplacement horizontal en octets
				; = (Largeur totale - Largeur du carré) / 2
				
				; Centrage vertical :
				; La hauteur ci-dessous est mesurée en pixels.
				; Hauteur totale = Hauteur de la fenêtre = VIDEO_HEIGHT
				; Hauteur du carré = 32 pixels
				; Déplacement vertical en pixels
				; = (Hauteur totale - Hauteur du carré) / 2
				; Déplacement vertical en octets
				; = Déplacement vertical en pixels x BYTE_PER_LINE
				
				; Adresse du carré
				; = VIDEO_START + (Déplacement horizontal) + (Déplacement vertical)
				
				lea		VIDEO_START+((BYTE_PER_LINE-4)/2)+(((VIDEO_HEIGHT-32)/2)*BYTE_PER_LINE),a0
				move.w	#32-1,d7
				
\loop			move.l	#$ffffffff,(a0)
				adda.l	#BYTE_PER_LINE,a0
				dbra	d7,\loop
				
				movem.l (a7)+,d7/a0
				rts

;				movem.l	d0/d6/d7/a0,-(a7)
;				lea		VIDEO_START,a0
;
;				;320/2-16 = 144/176 pixel de hauteur
;				;480/2-16 = 224/256 pixel de largeur
;				
;				move.w	#BYTE_PER_LINE*144/4-1,d6
;\height_loop	clr.l	(a0)+
;				dbra	d6,\height_loop
;				
;				move.w	#144/4,d6
;\center_loop	clr.l	(a0)+
;				dbra	d6,\center_loop
;				
;				move.l	#$ffffffff,d0
;				move.w	#32,d7
;\draw_loop		move.w	#BYTE_PER_LINE/4-2,d6
;				move.l	d0,(a0)+
;				
;\enter_loop		clr.l	(a0)+
;				dbra	d6,\enter_loop
;				
;				dbra	d7,\draw_loop
;				
;				movem.l	(a7)+,d0/d6/d7/a0
;				rts
		
			
WhiteSquare128	movem.l	d7/a0,-(a7)
				lea		VIDEO_START+((BYTE_PER_LINE-16)/2)+(((VIDEO_HEIGHT-128)/2)*BYTE_PER_LINE),a0
				move.w	#128-1,d7
				
\loop			move.l	#$ffffffff,(a0)
				move.l	#$ffffffff,4(a0)
				move.l	#$ffffffff,8(a0)
				move.l	#$ffffffff,12(a0)
				adda.l	#BYTE_PER_LINE,a0
				dbra	d7,\loop
				
				movem.l	(a7)+,d7/a0
				rts


WhiteLine       ; Sauvegarde les registres dans la pile.
				movem.l	d0/a0,-(a7)
				
				; Nombre d'itérations = Taille de la ligne en octets
				; D0.W = Nombre d'itérations - 1 (car DBRA)
				subq.w	#1,d0

\loop			; Copie 8 pixels blancs et passe à l'adresse suivante.
				move.b	#$ff,(a0)+
				dbra	d0,\loop
				
				; Restaure les registres puis sortie.
				movem.l	(a7)+,d0/a0
				rts
				
				
WhiteSquare     ; Sauvegarde les registres dans la pile.
				movem.l	d0-d2/a0,-(a7)
				
				; D2.W = Taille en pixels du carré.
				move.w	d0,d2
				lsl.w	#3,d2
				
				; Fait pointer A0 sur la mémoire vidéo.
				lea     VIDEO_START,a0
				
				; Centre horizontalement.
				; A0 + (Largeur totale - largeur carré) / 2
				move.w	#BYTE_PER_LINE,d1
				sub.w	d0,d1
				lsr.w	#1,d1
				adda.w	d1,a0
				
				; Centre verticalement.
				; A0 + ((Hauteur totale - Hauteur carré) / 2) * BYTE_PER_LINE
				move.w	#VIDEO_HEIGHT,d1
				sub.w	d2,d1
				lsr.w	#1,d1
				mulu.w	#BYTE_PER_LINE,d1
				adda.w	d1,a0
				
				; Nombre d'itérations = Taille en pixels
				; D2.W = Nombre d'itérations - 1 (car DBRA)
				subq.w	#1,d2

\loop			; Affiche la ligne en cours et passe à la ligne suivante.
				jsr 	WhiteLine
				adda.l	#BYTE_PER_LINE,a0
				dbra	d2,\loop
				
				; Restaure les registres puis sortie.
				movem.l	(a7)+,d0-d2/a0
				rts


PixelToByte		addq.w	#7,d3
				lsr.w	#3,d3
				
				rts
				
;PixelToByte		move.l	d0,-(a7)
;				
;				move.w	d3,d0
;				andi.w	#7,d0
;				tst.w	d0
;				beq		\quit
;				
;				addq.w	#8,d3
;				
;\quit			divu.w	#8,d3
;
;				move.l	(a7)+,d0
;				rts


CopyLine		movem.l	d3/a1,-(a7)
				subq.w	#1,d3
				
\loop			move.b	(a0)+,(a1)+
				dbra	d3,\loop
				
				movem.l	(a7)+,d3/a1
				rts
				
				
CopyBitmap		movem.l	d3/d4/a0/a1,-(a7)
				move.w	WIDTH(a0),d3
				jsr		PixelToByte
				
				move.w	HEIGHT(a0),d4
				subq.w	#1,d4
				
				lea		MATRIX(a0),a0
				
\loop			jsr		CopyLine
				adda.l	#BYTE_PER_LINE,a1
				dbra	d4,\loop
				
				movem.l	(a7)+,d3/d4/a0/a1
				rts
				

				; ==============================
				; Données
				; ==============================
				
WIDTH			equ		0
HEIGHT			equ		2
MATRIX			equ		4

InvaderA_Bitmap dc.w	24,16
				dc.b    %00000000,%11111111,%00000000
				dc.b    %00000000,%11111111,%00000000
				dc.b    %00111111,%11111111,%11111100
				dc.b    %00111111,%11111111,%11111100
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111100,%00111100,%00111111
				dc.b    %11111100,%00111100,%00111111
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111111,%11111111,%11111111
				dc.b    %00000011,%11000011,%11000000
				dc.b    %00000011,%11000011,%11000000
				dc.b    %00001111,%00111100,%11110000
				dc.b    %00001111,%00111100,%11110000
				dc.b    %11110000,%00000000,%00001111
				dc.b    %11110000,%00000000,%00001111				


Invader_Bitmap dc.w	22,16
				dc.b    %00001100,%00000000,%11000000
				dc.b    %00001100,%00000000,%11000000
				dc.b    %00000011,%00000011,%00000000
				dc.b    %00000011,%00000011,%00000000
				dc.b    %00001111,%11111111,%11000000
				dc.b    %00001111,%11111111,%11000000
				dc.b    %00001100,%11111100,%11000000
				dc.b    %00001100,%11111100,%11000000
				dc.b    %00111111,%11111111,%11110000
				dc.b    %00111111,%11111111,%11110000
				dc.b    %11001111,%11111111,%11001100
				dc.b    %11001111,%11111111,%11001100
				dc.b    %11001100,%00000000,%11001100
				dc.b    %11001100,%00000000,%11001100
				dc.b    %00000011,%11001111,%00000000
				dc.b    %00000011,%11001111,%00000000
				
				
InvaderC_Bitmap dc.w	16,16
				dc.b    %00000011,%11000000
				dc.b    %00000011,%11000000
				dc.b    %00001111,%11110000
				dc.b    %00001111,%11110000
				dc.b    %00111111,%11111100
				dc.b    %00111111,%11111100
				dc.b    %11110011,%11001111
				dc.b    %11110011,%11001111
				dc.b    %11111111,%11111111
				dc.b    %11111111,%11111111
				dc.b    %00110011,%11001100
				dc.b    %00110011,%11001100
				dc.b    %11000000,%00000011
				dc.b    %11000000,%00000011
				dc.b    %00110000,%00001100
				dc.b    %00110000,%00001100
				
				
Ship_Bitmap     dc.w	24,14
				dc.b    %00000000,%00011000,%00000000
				dc.b    %00000000,%00011000,%00000000
				dc.b    %00000000,%01111110,%00000000
				dc.b    %00000000,%01111110,%00000000
				dc.b    %00000000,%01111110,%00000000
				dc.b    %00000000,%01111110,%00000000
				dc.b    %00111111,%11111111,%11111100
				dc.b    %00111111,%11111111,%11111100
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111111,%11111111,%11111111
				dc.b    %11111111,%11111111,%11111111
