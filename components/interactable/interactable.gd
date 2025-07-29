@tool
class_name Interactable extends Area3D

signal interacted()

@export var message: String = "Press {key} to do something"
@export var target_mesh: GeometryInstance3D
@export var interact_overlay_color: Color = Color.WHITE
@export var interact_overlay: ShaderMaterial = preload("res://components/interactable/interact_overlay.tres")

var tween: Tween

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not target_mesh:
		warnings.append("Target mesh not set")
		
	return warnings

func _ready() -> void:
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)
	
	if is_instance_valid(target_mesh):
		target_mesh.material_overlay = interact_overlay
		target_mesh.set_instance_shader_parameter("hit_color", interact_overlay_color)

func interact() -> void:
	interacted.emit()
	
func interact_hover(state: bool, interactor: Interactor) -> void:
	if not is_instance_valid(target_mesh): return
	
	tween = Utils.kill_and_create_tween(tween)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	if state:
		tween.tween_property(target_mesh, "instance_shader_parameters/amount", 1.0, 0.1)
	else:
		tween.tween_property(target_mesh, "instance_shader_parameters/amount", 0.0, 0.3)

func disable() -> void:
	monitorable = false
	monitoring = false
		
func enable() -> void:
	monitorable = true
	monitoring = true
