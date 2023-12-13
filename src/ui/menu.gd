extends Control

# To show the main menu
func showMenuMain():
	%MenuTitle.set_text("Glow-ME")

	if Vars.CurrentGameState == Vars.GameState.PAUSED:
		%Resume.show()
	else:
		%Resume.hide()

	%MenuMain.show()
	%MenuOptions.hide()

# To show the options menu
func showMenuOptions():
	%MenuTitle.set_text("Options")

	%MenuMain.hide()
	%MenuOptions.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Only show the main menu at the beginning
	showMenuMain()

	# if it running in web hide the quit button
	if OS.get_name() == "Web":
		%Quit.hide()
	
	# Set default values for the options
	%VolumeValue.set_value(80)
	%MoveRightValue.set_text('D')
	%MoveLeftValue.set_text('A')
	%JumpValue.set_text('W')
	%InteractingValue.set_text('E')

# MenuMain
func _on_resume_pressed():
	pass # Replace with function body.

func _on_new_game_pressed():
	pass # Replace with function body.

func _on_options_pressed():
	showMenuOptions()

func _on_quit_pressed():
	# exit the game when the quit button is pressed
	get_tree().quit(0)

func _on_volume_value_drag_ended(_value_changed):
	var volume = %VolumeValue.get_value()
	Debug.print("Volume set to " + str(volume))

func _on_move_right_value_pressed():
	pass # Replace with function body.

func _on_move_left_value_pressed():
	pass # Replace with function body.

func _on_jump_value_pressed():
	pass # Replace with function body.

func _on_interacting_value_pressed():
	pass # Replace with function body.

func _on_options_quit_pressed():
	showMenuMain()
