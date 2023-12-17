extends Area2D

signal player_won

var switches_activated = 0
var door_open = false


func switch_activated():
	switches_activated += 1
	Debug.print(["switches_activated:", switches_activated])
	if switches_activated >= 3:
		door_can_open()


func door_can_open():
	door_open = true
	Debug.print(["door_can_open:", door_open])


func _on_detect_zone_body_entered(body):
	if door_open:
		$AnimatedSprite2D.play("opening")
		await get_tree().create_timer(7).timeout
		$EndZone.disabled = false


func _on_body_entered(body):
	if body is CharacterBody2D and door_open:
		emit_signal("player_won")
		Debug.print(["VICTORY"])
