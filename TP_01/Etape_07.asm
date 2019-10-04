			org		$4

Vector_001	dc.l	Main

			org 	$500

Main		move.l	BASE,d1
			ror.l	#4,d1
			ror.b	#4,d1
			rol.l	#4,d1
			
			move.l	BASE,d1
			ror.w	#4,d1
			ror.b	#4,d1
			rol.w	#4,d1
			swap	d1
			
			ror.w	#4,d1
			ror.b	#4,d1
			rol.w	#4,d1
			swap	d1

			move.l	BASE,d1
			swap	d1
			ror.l	#8,d1
			ror.b	#4,d1

			move.l	BASE,d1
			ror.l	#4,d1
			ror.b	#4,d1
			rol.l	#8,d1
			ror.b	#4,d1
			ror.l	#4,d1
			swap	d1

			ror.l	#4,d1
			ror.b	#4,d1
			rol.l	#8,d1
			ror.b	#4,d1
			ror.l	#4,d1
			swap	d1

			illegal

			org		$550

BASE		dc.l	$76543210