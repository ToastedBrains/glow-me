extends StaticBody2D


func _ready():
	#$Phosphorescence.energy = 8.0
	#$Phosphorescence.energy_left = 1.0
	#$Phosphorescence.color = Color(0.943, 0.284, 0.004, 1)
	#$Phosphorescence.permanent = true
	
	$Phosphorescence.set_permanent()
