extends Node

@onready var menu = $Menu
@export var level : PackedScene

func _ready():
	await $OpeningCredits.run()
	menu.show()
	$OpeningCredits.hide()


func _on_menu_start_game():
	var l = level.instantiate()
	$Menu.hide()
	call_deferred("add_sibling", l)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not $QuitConfirm.visible:
			$QuitConfirm.show()
		else:
			$QuitConfirm.hide()
		


func _on_quit_confirm_confirmed():
	get_tree().quit()
