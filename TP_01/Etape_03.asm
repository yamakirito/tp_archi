			org		$4

Vector_001	dc.l	Main

			org		$500
			
Main		move.w	NUMBER1,d0	; (NUMBER1) -> D0.W
			add.w	NUMBER2,d0	; (NUMBER2) + D0.W -> D0.W
			move.w	d0,SUM		;D0.W -> (SUM)
			
			illegal
			
			org		$550
			
NUMBER1		dc.w	$2222		; Le nombre $2222 est stock� � l'adresse NUMBER1.
NUMBER2		dc.w	$5555		; Le nombre $5555 est stock� � l'adresse NUMBER2.
SUM 		ds.w	1			; On r�serve 16 bits pour stocker la somme