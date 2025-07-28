extends Node

enum SCENE {TITLE, CREDITS, SETTINGS, GAME}

@export var game: PackedScene = preload("res://scenes/game/game.tscn")
@export var titlescreen: PackedScene = preload("res://scenes/ui/titlescreen/titlescreen.tscn")
@export var credits: PackedScene = preload("res://scenes/ui/credits/credits_ui.tscn")
@export var settings: PackedScene = preload("res://scenes/ui/settings/settings_ui.tscn")

var _params = null

func switch_to(scene: int, use_transition: bool = true, params=null) -> void:
	if use_transition:
		Transition.show_transition()
		await Transition.transition_in_finished
		
	_params = params
		
	var to_load
	match scene:
		SCENE.TITLE:
			to_load = titlescreen
		SCENE.CREDITS:
			to_load = credits
		SCENE.SETTINGS:
			to_load = settings
		SCENE.GAME:
			to_load = game
			
	get_tree().change_scene_to_packed(to_load)
	
	if use_transition:
		Transition.hide_transition()

func instance_scene(scene: int) -> Node:
	var instance = null
	match scene:
		SCENE.TITLE:
			instance = titlescreen.instance()
		SCENE.CREDITS:
			instance = credits.instance()
		SCENE.SETTINGS:
			instance = settings.instance()
		SCENE.GAME:
			instance = game.instance()
	
	return instance

# In the newly opened scene, you can get the parameters by name
func get_param(name):
	if _params != null and _params.has(name):
		return _params[name]
	return null
