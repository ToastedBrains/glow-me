extends Node

# Game state
# 0 - opening credits
# 1 - main menu
# 2 - game cinematic
# 3 - game play
# 4 - game over
# 5 - pause menu
# 6 - ending credits
enum GameState {INIT, OPENING, MAIN_MENU, CINEMATIC, GAME, GAME_OVER, PAUSE, ENDING}

# current game state
var CurrentGameState: GameState

# Game state to string
func game_state_to_string(state: GameState) -> String:
	return GameState.keys()[state]

# Options settings
class Settings:
	var Sound_volume: int = 80
	var Key_right: String = "d"
	var Key_left: String = "a"
	var Key_jump: String = "w"
	var Key_action: String = "e"

# Settings instance
var settings: Settings = Settings.new()

func _init() -> void:
	# init game state
	CurrentGameState = GameState.INIT

	# init settings
	if OS.get_locale_language() == "fr":
		settings.Key_left = "q"
		settings.Key_jump = "z"
