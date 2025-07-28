class_name CreditsUI extends Control

func _on_btn_home_pressed() -> void:
	SceneSwitcher.switch_to(SceneSwitcher.SCENE.TITLE, false)

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
