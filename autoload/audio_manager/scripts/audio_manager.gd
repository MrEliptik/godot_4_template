extends Node

signal track_changed(new_track)

@export var crossfade_time: float = 4.0

var tween_music: Tween
var tween_muffle: Tween
var tween_damage: Tween
var tween_volume: Tween
var music_idx: int = 0
var curr_music: Dictionary
var active_player: AudioStreamPlayer
var previous_stream: AudioStream
var gameplay_music_playing: bool = false
var gameplay_music_offset: float = 0.0
var gameplay_music: Dictionary

@onready var music_player: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	pass

## MUSIC
func play_music() -> void:
	music_player.play()
	active_player = music_player

func stop_music() -> void:
	music_player.stop()
	active_player = null

func damage_music_effect() -> void:
	if not active_player: return
	var prev_db: float = active_player.volume_db
	if tween_damage and tween_damage.is_running():
		tween_damage.kill()
	tween_damage = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween_damage.tween_property(active_player, "pitch_scale", 0.7, 0.3)
	tween_damage.tween_property(active_player, "volume_db", prev_db-13.0, 0.3)
	tween_damage.chain().tween_interval(0.35)
	tween_damage.tween_property(active_player, "pitch_scale", 1.0, 0.5)
	tween_damage.tween_property(active_player, "volume_db", prev_db, 0.5)

func death_music_effect() -> void:
	if not active_player: return
	var prev_db: float = active_player.volume_db
	if tween_damage and tween_damage.is_running():
		tween_damage.kill()
	tween_damage = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween_damage.tween_property(active_player, "pitch_scale", 0.7, 0.3)
	tween_damage.tween_property(active_player, "volume_db", prev_db-13.0, 0.3)
	tween_damage.chain().tween_interval(0.35)
	tween_damage.tween_property(active_player, "pitch_scale", 1.0, 0.5)
	tween_damage.tween_property(active_player, "volume_db", prev_db, 0.5)
	tween_damage.tween_callback(AudioManager.set_muffle_music.bind(true))

func tween_music_volume(volume_db: float) -> void:
	if not active_player: return
	if tween_volume and tween_volume.is_running():
		tween_volume.kill()
	tween_volume = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_volume.tween_property(active_player, "volume_db", volume_db, 0.3)

func set_muffle_music(state: bool) -> void:
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 1, state)
	
func is_music_muffled() -> bool:
	return AudioServer.is_bus_effect_enabled(AudioServer.get_bus_index("Music"), 1)

func spawn_and_play_2D_SFX(stream: AudioStream, pos: Vector2, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	var player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	player.bus = "SFX"
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.stream = stream
	
	add_child(player)
	player.global_position = pos
	player.play()
	await player.finished
	player.queue_free()
