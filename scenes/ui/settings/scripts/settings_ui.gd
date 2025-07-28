class_name SettingsUI extends Control

signal done()

@export var standalone: bool = true

func _ready() -> void:
	if has_meta("data") and get_meta("data").has("standalone"):
		standalone = get_meta("data")["standalone"]

func disappear() -> void:
	queue_free()

func _on_btn_home_pressed() -> void:
	if standalone:
		SceneSwitcher.switch_to(SceneSwitcher.SCENE.TITLE, false)
	else:
		done.emit()
		disappear()
