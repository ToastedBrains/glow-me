extends Area2D

@export var text = ""

func set_text(text: String) -> void:
	$FloatingText.text = text
	$FloatingText.set_position(Vector2(-$FloatingText.get_combined_minimum_size().x / 2, 0))
	
func _ready():
	set_text(text)
	#set_text("Use ←/→, Q/D or X/X  to move\n[Spacebar] for jump")
	#$AnimationPlayer.play("show")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is CharacterBody2D:
		$AnimationPlayer.play("show")


func _on_body_exited(body):
	if body is CharacterBody2D:
		$AnimationPlayer.play("hide")
