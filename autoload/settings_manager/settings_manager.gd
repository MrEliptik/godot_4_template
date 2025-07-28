extends Node

enum CATEGORY {GENERAL=1, VIDEO=2, SOUND=3, GAMEPLAY=4}
enum SETTING {LANGUAGE=11, LANGUAGE_SET=12, WINDOW_TYPE=13, MONITOR=14, VSYNC=15, MASTER_VOLUME=16, MASTER_TOGGLE=17,
	MUSIC_VOLUME=18, MUSIC_TOGGLE=19, EFFECTS_VOLUME=20, EFFECTS_TOGGLE=21, SCREENSHAKE=22, VIBRATION=23,
	}
enum DISPLAY {FULLSCREEN, FULLSCREEN_BORDERLESS, WINDOWED}
enum STRENGTH {DISABLED, LOW, NORMAL}
enum VSYNC {DISABLE, ENABLE, ADAPTIVE}

const SAVE_PATH = "user://settings.cfg"
var config_file = ConfigFile.new()

var settings_default = {
	CATEGORY.GENERAL: {
		SETTING.LANGUAGE:"en",
		SETTING.LANGUAGE_SET:false,
	},
	CATEGORY.VIDEO: {
		SETTING.WINDOW_TYPE: DISPLAY.WINDOWED,
		SETTING.MONITOR: DisplayServer.window_get_current_screen(),
		SETTING.VSYNC: DisplayServer.VSYNC_ENABLED
	},
	CATEGORY.SOUND: {
		SETTING.MASTER_VOLUME: 60,
		SETTING.MASTER_TOGGLE: true,
		SETTING.MUSIC_VOLUME: 100,
		SETTING.MUSIC_TOGGLE: true,
		SETTING.EFFECTS_VOLUME: 100,
		SETTING.EFFECTS_TOGGLE: true
	},
	CATEGORY.GAMEPLAY: {
		SETTING.SCREENSHAKE: STRENGTH.NORMAL,
		SETTING.VIBRATION: STRENGTH.NORMAL,
	}
}

var category_to_str: Dictionary = {
	CATEGORY.GENERAL: "GENERAL",
	CATEGORY.VIDEO: "VIDEO",
	CATEGORY.SOUND: "SOUND",
	CATEGORY.GAMEPLAY: "GAMEPLAY",
}
	
var setting_to_str: Dictionary = {
	SETTING.LANGUAGE: "LANGUAGE",
	SETTING.LANGUAGE_SET: "LANGUAGE_SET",
	SETTING.WINDOW_TYPE: "WINDOW_TYPE",
	SETTING.MONITOR: "MONITOR",
	SETTING.VSYNC: "VSYNC",
	SETTING.MASTER_VOLUME: "MASTER_VOLUME",
	SETTING.MASTER_TOGGLE: "MASTER_TOGGLE",
	SETTING.MUSIC_VOLUME: "MUSIC_VOLUME",
	SETTING.MUSIC_TOGGLE: "MUSIC_TOGGLE",
	SETTING.EFFECTS_VOLUME: "EFFECTS_VOLUME",
	SETTING.EFFECTS_TOGGLE: "EFFECTS_TOGGLE",
	SETTING.SCREENSHAKE: "SCREENSHAKE",
	SETTING.VIBRATION: "VIBRATION",
}
var display_to_str: Dictionary = {
	DISPLAY.FULLSCREEN: "Fullscreen",
	DISPLAY.FULLSCREEN_BORDERLESS: "Bordless fullscreen",
	DISPLAY.WINDOWED: "Windowed",
}

var strength_to_sr: Dictionary = {
	STRENGTH.DISABLED: "Disabled",
	STRENGTH.LOW: "Low",
	STRENGTH.NORMAL: "Normal",
}

var steam_lang_str_to_code = {
	"english": "en",
	"french": "fr",
#	"spanish": "es",
#	"italian": "it",
#	"german": "de",
#	"brazilian": "pt_BR",
#	"portuguese": "pt",
#	"chinese": "zh",
#	"hindi": "hi"
}

var languages = {
	"english": "en",
	"francais": "fr",
#	"espanol": "es",
#	"italian": "it",
#	"german": "de",
#	"português": "pt_PT",
#	"português do Brasil": "pt_BR",
#	"chinese": "zh",
#	"hindi": "hi"
}
## Values
var strength_to_val = {
	STRENGTH.DISABLED: 0.0,
	STRENGTH.LOW: 0.5,
	STRENGTH.NORMAL: 1.0,
}
var should_apply_values: bool = true

@onready var settings = settings_default.duplicate()

func _ready() -> void:
	## Create save file if not existing
	## otherwise, load values
	print(ProjectSettings.globalize_path(SAVE_PATH))
	if FileAccess.file_exists(SAVE_PATH):
		settings = load_settings()
		apply_settings(settings)
		# Write again to make sure to save new values if I added it after the file was created
		write_settings() 
	else:
		write_settings()
		apply_settings(settings)

func load_settings() -> Dictionary:
	var err = config_file.load(SAVE_PATH)
	if err != OK:
		print("Error loading the save file. Error code: %s" % err)
		return {}
	
	for section in settings.keys():
		for key in settings[section].keys():
			# Default value
			var val = settings[section][key]
			settings[section][key] = config_file.get_value(category_to_str[section], setting_to_str[key], val)
#			print("%s: %s" % [key, val])
	return settings
	
func write_settings() -> void:
	for section in settings.keys():
		for key in settings[section].keys():
			config_file.set_value(category_to_str[section], setting_to_str[key], settings[section][key])
			
	config_file.save(SAVE_PATH)

func grab_settings():
	## VIDEO
	settings[CATEGORY.VIDEO][SETTING.VSYNC] = DisplayServer.window_get_vsync_mode()
	
	settings[CATEGORY.VIDEO][SETTING.WINDOW_TYPE] = DISPLAY.FULLSCREEN
		
	settings[CATEGORY.VIDEO][SETTING.MONITOR] = DisplayServer.window_get_current_screen()
	
	## SOUND
	settings[CATEGORY.SOUND][SETTING.MASTER_VOLUME] = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")) * 100.0
	settings[CATEGORY.SOUND][SETTING.MASTER_TOGGLE] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	settings[CATEGORY.SOUND][SETTING.MUSIC_VOLUME] = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music")) * 100.0
	settings[CATEGORY.SOUND][SETTING.MUSIC_TOGGLE] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
	settings[CATEGORY.SOUND][SETTING.EFFECTS_VOLUME] = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX")) * 100.0
	settings[CATEGORY.SOUND][SETTING.EFFECTS_TOGGLE] = AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))
	
func apply_settings(values: Dictionary):
	TranslationServer.set_locale(settings[CATEGORY.GENERAL][SETTING.LANGUAGE])
	
	##### Video #####
	DisplayServer.window_set_current_screen(values[CATEGORY.VIDEO][SETTING.MONITOR])

	## Window type
	DisplayServer.window_set_mode(values[CATEGORY.VIDEO][SETTING.WINDOW_TYPE])

	get_window().move_to_center()

#	## VSYNC
	DisplayServer.window_set_vsync_mode(values[CATEGORY.VIDEO][SETTING.VSYNC])
	
#	## MSAA
#	get_viewport().msaa = Globals.msaa[values["video"]["msaa"]]

#	## Antialiasing

#	##### AUDIO ####
#	## General
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), values[CATEGORY.SOUND][SETTING.MASTER_VOLUME]/100.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), values[CATEGORY.SOUND][SETTING.MASTER_TOGGLE])
#	## Music
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), values[CATEGORY.SOUND][SETTING.MUSIC_VOLUME]/100.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), values[CATEGORY.SOUND][SETTING.MUSIC_TOGGLE])
#	## SFX
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), values[CATEGORY.SOUND][SETTING.EFFECTS_VOLUME]/100.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), values[CATEGORY.SOUND][SETTING.EFFECTS_TOGGLE])
