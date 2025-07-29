extends Node3D

var closed: bool = true
var tween: Tween

@onready var rot_point: Marker3D = $RotPoint

func _on_interactable_interacted() -> void:
	tween = Utils.kill_and_create_tween(tween)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		
	if closed:
		closed = false
		
		tween.tween_property(rot_point, "rotation_degrees:y", 90.0, 0.3)
	else:
		closed = true
		tween.tween_property(rot_point, "rotation_degrees:y", 0.0, 0.3)
