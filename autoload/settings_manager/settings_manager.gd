extends Node

enum {GENERAL, VIDEO, SOUND, GAMEPLAY}
enum {LANGUAGE, LANGUAGE_SET, WINDOW_TYPE, MONITOR, VSYNC, MASTER_VOLUME, MASTER_TOGGLE,
	MUSIC_VOLUME, MUSIC_TOGGLE, EFFECTS_VOLUME, EFFECTS_TOGGLE, LIVES, SCREENSHAKE, VIBRATION,
	}
enum DISPLAY {FULLSCREEN, WINDOWED}
enum STRENGTH {DISABLED, LOW, NORMAL}

const SAVE_PATH = "user://settings.cfg"
var config_file = ConfigFile.new()
var settings_default = {
	GENERAL: {
		LANGUAGE:"en",
		LANGUAGE_SET:false,
	},
	VIDEO: {
		WINDOW_TYPE: DISPLAY.WINDOWED,
		MONITOR: DisplayServer.window_get_current_screen(),
		VSYNC: DisplayServer.VSYNC_ENABLED
	},
	SOUND: {
		MASTER_VOLUME: 60,
		MASTER_TOGGLE: true,
		MUSIC_VOLUME: 100,
		MUSIC_TOGGLE: true,
		EFFECTS_VOLUME: 100,
		EFFECTS_TOGGLE: true
	},
	GAMEPLAY: {
		SCREENSHAKE: STRENGTH.NORMAL,
		VIBRATION: STRENGTH.NORMAL,
	}
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
	var file_check = FileDialog.new()
	if file_check.file_exists(SAVE_PATH):
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
			settings[section][key] = config_file.get_value(section, key, val)
#			print("%s: %s" % [key, val])
	return settings
	
func write_settings() -> void:
	for section in settings.keys():
		for key in settings[section].keys():
			config_file.set_value(section, key, settings[section][key])
			
	config_file.save(SAVE_PATH)

func grab_settings():
	## VIDEO
	settings[VIDEO][VSYNC] = DisplayServer.window_get_vsync_mode()
	
	settings[VIDEO][WINDOW_TYPE] = DISPLAY.FULLSCREEN
		
	settings[VIDEO][MONITOR] = DisplayServer.window_get_current_screen()
	
	## SOUND
	settings[SOUND][MASTER_VOLUME] = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")) * 100.0
	settings[SOUND][MASTER_TOGGLE] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
	settings[SOUND][MUSIC_VOLUME] = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music")) * 100.0
	settings[SOUND][MUSIC_TOGGLE] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
	settings[SOUND][EFFECTS_VOLUME] = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX")) * 100.0
	settings[SOUND][EFFECTS_TOGGLE] = AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))
	
func apply_settings(values: Dictionary):
	TranslationServer.set_locale(settings[GENERAL][LANGUAGE])
	
	##### Video #####
	DisplayServer.window_set_current_screen(values[VIDEO][MONITOR])

	## Window type
	DisplayServer.window_set_mode(values[VIDEO][WINDOW_TYPE])

	get_window().move_to_center()

#	## VSYNC
	DisplayServer.window_set_vsync_mode(values[VIDEO][VSYNC])
	
#	## MSAA
#	get_viewport().msaa = Globals.msaa[values["video"]["msaa"]]

#	## Antialiasing

#	##### AUDIO ####
#	## General
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), values[SOUND][MASTER_VOLUME]/100.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), values[SOUND][MASTER_TOGGLE])
#	## Music
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), values[SOUND][MUSIC_VOLUME]/100.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), values[SOUND][MUSIC_TOGGLE])
#	## SFX
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), values[SOUND][EFFECTS_VOLUME]/100.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), values[SOUND][EFFECTS_TOGGLE])
