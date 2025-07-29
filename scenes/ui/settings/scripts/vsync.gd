extends HBoxContainer

@onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	reflect_settings()

func reflect_settings() -> void:
	for v in SettingsManager.vsync_to_str.values():
		option_button.add_item(v)
	
	var value: int = SettingsManager.settings[SettingsManager.CATEGORY.VIDEO][SettingsManager.SETTING.VSYNC]
	var idx: int = SettingsManager.vsync_to_str.keys().find(value)
	option_button.select(idx)

func _on_option_button_item_selected(index: int) -> void:
	SettingsManager.settings[SettingsManager.CATEGORY.VIDEO][SettingsManager.SETTING.VSYNC] = SettingsManager.vsync_to_str.keys()[index]
	DisplayServer.window_set_vsync_mode(SettingsManager.vsync_to_str.keys()[index])
	SettingsManager.write_settings() 
