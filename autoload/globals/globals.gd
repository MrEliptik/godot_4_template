extends Node

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(0, DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(0, DisplayServer.WINDOW_MODE_FULLSCREEN)

	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
