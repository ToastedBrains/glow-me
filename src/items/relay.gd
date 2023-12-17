extends StaticBody2D

signal relay_activated

@onready var light = $Phosphorescence

var activated = false

func _ready():
	light.energy = 1.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not activated:
		if $Phosphorescence.permanent:
			$AnimatedSprite2D.animation = "loaded"
			emit_signal("relay_activated")
			activated = true
