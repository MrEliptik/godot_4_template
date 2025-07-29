extends HBoxContainer

@onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	reflect_settings()

func reflect_settings() -> void:
	for lang in SettingsManager.display_to_str.values():
		option_button.add_item(lang)
	
	var value: int = SettingsManager.settings[SettingsManager.CATEGORY.VIDEO][SettingsManager.SETTING.WINDOW_TYPE]

	var idx: int = SettingsManager.display_to_str.keys().find(value)
	option_button.select(idx)

func _on_option_button_item_selected(index: int) -> void:
	SettingsManager.settings[SettingsManager.CATEGORY.VIDEO][SettingsManager.SETTING.WINDOW_TYPE] = SettingsManager.display_to_str.keys()[index]
	DisplayServer.window_set_mode(SettingsManager.display_to_str.keys()[index])
	SettingsManager.write_settings()
