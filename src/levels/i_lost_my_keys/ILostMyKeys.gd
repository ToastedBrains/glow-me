extends Node

signal game_ended

func _on_relay_relay_activated():
	$Door.switch_activated()




func _on_relay_2_relay_activated():
	$Door.switch_activated()


func _on_relay_3_relay_activated():
	$Door.switch_activated()
