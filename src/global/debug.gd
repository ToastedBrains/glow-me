extends Node

func print(msg: String) -> void:
	if not OS.is_debug_build():
		return

	print("[DEBUG] " + msg)
