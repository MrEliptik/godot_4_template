extends HBoxContainer

enum BUS {MASTER, MUSIC, EFFECTS}

@export var bus: BUS = BUS.MASTER

@onready var h_slider: HSlider = $HSlider
@onready var value_lbl: Label = $Value
@onready var mute_btn: CheckButton = $MuteBtn

@onready var bus_enum_to_bus_idx: Dictionary = {
	BUS.MASTER: AudioServer.get_bus_index("Master"),
	BUS.MUSIC: AudioServer.get_bus_index("Music"),
	BUS.EFFECTS: AudioServer.get_bus_index("SFX"),
}

func _ready() -> void:
	reflect_settings()

func reflect_settings() -> void:
	var value: float = AudioServer.get_bus_volume_linear(bus_enum_to_bus_idx[bus])
	h_slider.value = value * 100.0
	value_lbl.text = "%.0f" % [value * 100.0]
	mute_btn.set_pressed_no_signal(not AudioServer.is_bus_mute(bus_enum_to_bus_idx[bus]))
	h_slider.editable = not AudioServer.is_bus_mute(bus_enum_to_bus_idx[bus])

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(bus_enum_to_bus_idx[bus], value / 100.0)
	value_lbl.text = "%.0f" % value
	
	match bus:
		BUS.MASTER:
			SettingsManager.settings[SettingsManager.CATEGORY.SOUND][SettingsManager.SETTING.MASTER_VOLUME] = value
		BUS.MUSIC:
			SettingsManager.settings[SettingsManager.CATEGORY.SOUND][SettingsManager.SETTING.MUSIC_VOLUME] = value
		BUS.EFFECTS:
			SettingsManager.settings[SettingsManager.CATEGORY.SOUND][SettingsManager.SETTING.EFFECTS_VOLUME] = value

func _on_mute_btn_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(bus_enum_to_bus_idx[bus], not toggled_on)
	h_slider.editable = toggled_on
	match bus:
		BUS.MASTER:
			SettingsManager.settings[SettingsManager.CATEGORY.SOUND][SettingsManager.SETTING.MASTER_TOGGLE] = toggled_on
		BUS.MUSIC:
			SettingsManager.settings[SettingsManager.CATEGORY.SOUND][SettingsManager.SETTING.MUSIC_TOGGLE] = toggled_on
		BUS.EFFECTS:
			SettingsManager.settings[SettingsManager.CATEGORY.SOUND][SettingsManager.SETTING.EFFECTS_TOGGLE] = toggled_on
	SettingsManager.write_settings()

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	SettingsManager.write_settings()
