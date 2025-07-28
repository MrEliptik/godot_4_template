class_name Titlescreen extends Control

@onready var buttons: VBoxContainer = $Buttons

func _on_btn_start_pressed() -> void:
	SceneSwitcher.switch_to(SceneSwitcher.SCENE.GAME, true)

func _on_btn_settings_pressed() -> void:
	SceneSwitcher.switch_to(SceneSwitcher.SCENE.SETTINGS, false)

func _on_btn_credits_pressed() -> void:
	SceneSwitcher.switch_to(SceneSwitcher.SCENE.CREDITS, false)

func _on_btn_quit_pressed() -> void:
	# Can add a confirmation or 
	Utils.exit_game()
