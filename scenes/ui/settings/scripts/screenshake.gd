extends HBoxContainer

@onready var h_slider: HSlider = $HSlider
@onready var value_lbl: Label = $Value

func _ready() -> void:
	reflect_settings()

func reflect_settings() -> void:
	var value: int = SettingsManager.settings[SettingsManager.CATEGORY.GAMEPLAY][SettingsManager.SETTING.SCREENSHAKE]
	value_lbl.text = SettingsManager.strength_to_str[value]
	h_slider.value = value

func _on_h_slider_value_changed(value: float) -> void:
	SettingsManager.settings[SettingsManager.CATEGORY.GAMEPLAY][SettingsManager.SETTING.SCREENSHAKE] = int(value)
	value_lbl.text = SettingsManager.strength_to_str[int(value)]
	SettingsManager.write_settings()
