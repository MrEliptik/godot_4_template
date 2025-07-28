class_name PauseUI extends Control

@onready var scene: Control = $Scene

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause(not get_tree().paused)

func pause(pause_state: bool) -> void:
	get_tree().paused = pause_state
	visible = pause_state

func _on_btn_continue_pressed() -> void:
	pause(false)

func _on_btn_settings_pressed() -> void:
	var instance: SettingsUI = SceneSwitcher.instance_scene(SceneSwitcher.SCENE.SETTINGS, {"standalone": true})
	scene.add_child(instance)

func _on_btn_home_pressed() -> void:
	pause(false)
	SceneSwitcher.switch_to(SceneSwitcher.SCENE.TITLE)
