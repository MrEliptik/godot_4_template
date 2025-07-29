extends HBoxContainer

@onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	reflect_settings()

func reflect_settings() -> void:
	for i in range(DisplayServer.get_screen_count()):
		option_button.add_item(str(i))
	
	var value: int = SettingsManager.settings[SettingsManager.CATEGORY.VIDEO][SettingsManager.SETTING.MONITOR]

func _on_option_button_item_selected(index: int) -> void:
	SettingsManager.settings[SettingsManager.CATEGORY.VIDEO][SettingsManager.SETTING.MONITOR] = int(option_button.get_item_text(index))
	DisplayServer.window_set_current_screen(int(option_button.get_item_text(index)))
	SettingsManager.write_settings()
