extends HBoxContainer

@onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	reflect_settings()

func reflect_settings() -> void:
	for lang in SettingsManager.languages.keys():
		option_button.add_item(lang)
	
	var value: String = SettingsManager.settings[SettingsManager.CATEGORY.GENERAL][SettingsManager.SETTING.LANGUAGE]

func _on_option_button_item_focused(index: int) -> void:
	TranslationServer.set_locale(SettingsManager.languages[option_button.get_item_text(index)])

func _on_option_button_item_selected(index: int) -> void:
	TranslationServer.set_locale(SettingsManager.languages[option_button.get_item_text(index)])
	SettingsManager.settings[SettingsManager.CATEGORY.GENERAL][SettingsManager.SETTING.LANGUAGE] = SettingsManager.languages[option_button.get_item_text(index)]
	SettingsManager.write_settings()
