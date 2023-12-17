extends Node

signal game_ended

func _on_relay_relay_activated():
	$Door.switch_activated()


