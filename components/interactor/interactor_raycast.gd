@tool
class_name InteractorRaycast extends RayCast3D

var interactor: Interactor = null

func _ready() -> void:
	set_collision_mask_value(3, true)
	interactor = Interactor.new()
	add_child(interactor)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	if not enabled: return
	force_raycast_update()
	if is_colliding() and get_collider() is Interactable:
		var interactable: Interactable = get_collider()
		
		if interactor.interactable_active == interactable: return
		interactor.interactable_active = interactable
		
		interactor.update_text()
		interactor.interactable_active.interact_hover(true, interactor)
	
	elif is_instance_valid(interactor.interactable_active):
		interactor.interactable_active.interact_hover(false, interactor)
		interactor.interactable_active = null
		interactor.update_text()
