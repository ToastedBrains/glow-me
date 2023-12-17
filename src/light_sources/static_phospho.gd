extends StaticBody2D

@export var energy = 2.0
@export var permanent = false

func _ready():
	$Phosphorescence.energy = energy
	if permanent:
		$Phosphorescence.set_permanent()
