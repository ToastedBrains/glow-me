extends RigidBody2D

@onready var power_up = false

func charge_up():
	power_up = true

func charge_down():
	power_up = false
	
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
