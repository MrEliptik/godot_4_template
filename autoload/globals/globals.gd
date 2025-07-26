extends Node

var is_demo: bool = false

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(0, DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(0, DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# Can use "debug" too
	if event.is_action_pressed("restart") and OS.has_feature("editor"):
		get_tree().reload_current_scene()
