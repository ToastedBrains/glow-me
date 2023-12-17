extends Node

@onready var menu = $Menu
@export var level : PackedScene
@export var end_scene : PackedScene
var lvl

func _ready():
	await $OpeningCredits.run()
	menu.show()
	$OpeningCredits.hide()


func _on_menu_start_game():
	lvl = level.instantiate()
	$Menu.hide()
	call_deferred("add_sibling", lvl)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if not $QuitConfirm.visible:
			$QuitConfirm.show()
		else:
			$QuitConfirm.hide()
		

func quand_ce_gros_con_d_adrien_aura_fini_ce_putain_de_niveau():
	var e = end_scene.instantiate()
	lvl.queue_free()
	call_deferred("add_sibling", e)

func _on_quit_confirm_confirmed():
	get_tree().quit()
