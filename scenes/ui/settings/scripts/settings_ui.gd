class_name SettingsUI extends Control

func _on_btn_home_pressed() -> void:
	SceneSwitcher.switch_to(SceneSwitcher.SCENE.TITLE, false)
