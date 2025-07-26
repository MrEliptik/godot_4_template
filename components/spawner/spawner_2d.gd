class_name Spawner2D extends Node2D

@export var to_spawn: PackedScene

func _ready() -> void:
	pass # Replace with function body.

func spawn_local(data: Dictionary = {}) -> void:
	var instance = to_spawn.instantiate()
	instance.set_meta("data", data)
	add_child(instance)

func spawn_global(data: Dictionary = {}) -> void:
	var instance = to_spawn.instantiate()
	instance.set_meta("data", data)
	get_tree().get_current_scene().add_child(instance)
	instance.global_position = global_position
