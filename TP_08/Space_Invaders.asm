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
				
Main			move.l	#$ffffffff,d0
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
				
FillScreen		movea.l	#$ffb500,a0

\loop			move.l	d0,(a0)+
				cmpa.l	VIDEO_END,a0
				bls		\loop
				
\quit			rts


HLines			movea.l	#$ffb500,a0
				move.l	#$ffffffff,d0
				clr.l	d1
				
\loop			move.l	d0,(a0)+
				addq.l	#1,d1
				
				cmpi.l	#$78,d1
				blo		\loop
				
				cmpa.l	VIDEO_END,a0
				bhi		\quit
				
				clr.l	d1
				adda.l	#$1E0,a0
				
				cmpa.l	VIDEO_END,a0
				bls		\loop

\quit			rts
				
				; ==============================
				; Données
				; ==============================
				
VIDEO_END		dc.l	$ffffff			
