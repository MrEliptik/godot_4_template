@tool
class_name InteractorArea extends Area3D

var interactor: Interactor = null

func _ready() -> void:
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)
	
	interactor = Interactor.new()
	add_child(interactor)
	
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)

func on_area_entered(area: Area3D) -> void:
	if area is not Interactable: return
	
	if interactor.interactable_active == area: return
	interactor.interactable_active = area
	
	interactor.update_text()
	interactor.interactable_active.interact_hover(true, interactor)
	
func on_area_exited(area: Area3D) -> void:
	if area is not Interactable: return
	
	interactor.interactable_active.interact_hover(false, interactor)
	interactor.interactable_active = null
	interactor.update_text()
