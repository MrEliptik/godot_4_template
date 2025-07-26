extends Node

signal transition_in_finished() 
signal transition_out_finished()

@onready var circle: ColorRect = $CanvasLayer/Circle
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var shown: bool = false

func _ready() -> void:
	pass # Replace with function body.

func show_transition() -> void:
	if shown: return
	circle.material.set_shader_param("screen_width", circle.size.x)
	circle.material.set_shader_param("screen_height", circle.size.y)
	shown = true
	animation_player.play("show")
	
func hide_transition() -> void:
	if not shown: return
	circle.material.set_shader_param("screen_width", circle.size.x)
	circle.material.set_shader_param("screen_height", circle.size.y)
	shown = false
	animation_player.play("hide")
