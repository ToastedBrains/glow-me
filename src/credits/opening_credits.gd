extends Control

signal credits_finished
signal credits_started

func run():
	$CreditsAnimation.stop(false)
	await get_tree().create_timer(1.0).timeout
	$CreditsAnimation.play("GlobalOpeningCreditsAnimation")

func _on_credits_animation_animation_finished(anim_name):
	Debug.print("Animation finished: " + anim_name)
	emit_signal("credits_finished")

func _on_credits_animation_animation_started(anim_name):
	Debug.print("Animation started: " + anim_name)
	emit_signal("credits_started")
