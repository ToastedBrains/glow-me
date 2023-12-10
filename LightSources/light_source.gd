extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_body_entered(body):
	if body is CharacterBody2D:
#		print(body)
		var props = body.get_property_list()
		for p in props:
			print(p)
		body.charging = true
#	queue_free()
#	body.power_up = true
#	body.queue_free()
#	body.charge_up()
		


func _on_body_exited(body):
	if body is CharacterBody2D:
#		print(body)
		var props = body.get_property_list()
		for p in props:
			print(p)
		body.charging = false
