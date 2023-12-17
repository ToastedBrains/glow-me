extends StaticBody2D

@onready var light = $Phosphorescence

func _ready():
	light.energy = 2.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Phosphorescence.permanent:
		$AnimatedSprite2D.animation = "loaded"
