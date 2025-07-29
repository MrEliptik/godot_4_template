@tool
class_name InteractorArea extends Area3D

@export var enabled: bool = true

var interactor: Interactor = null

func _ready() -> void:
	if enabled:
		monitoring = true
		monitorable = false
		set_collision_layer_value(3, true)
		set_collision_mask_value(3, true)
	else:
		monitoring = false
		monitorable = false
		for i in range(1, 33, 1):
			set_collision_layer_value(i, false)
			set_collision_mask_value(i, false)
	
	interactor = Interactor.new()
	add_child(interactor)
	
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)

func _input(event: InputEvent) -> void:
	if not enabled: return
	if event.is_action_pressed("interact"):
		interactor.interact()

func on_area_entered(area: Area3D) -> void:
	if not enabled: return
	if area is not Interactable: return
	
	if interactor.interactable_active == area: return
	# Remove the old one
	if is_instance_valid(interactor.interactable_active):
			interactor.interactable_active.interact_hover(false, interactor)
	
	interactor.interactable_active = area
	
	interactor.update_text()
	interactor.interactable_active.interact_hover(true, interactor)
	
func on_area_exited(area: Area3D) -> void:
	if not enabled: return
	if area is not Interactable: return
	if not is_instance_valid(interactor.interactable_active): return
	# We're leaving a different interactable than the current one
	# Happens when overlapping
	if is_instance_valid(interactor.interactable_active) and interactor.interactable_active != area: return
	interactor.interactable_active.interact_hover(false, interactor)
	interactor.interactable_active = null
	interactor.update_text()
