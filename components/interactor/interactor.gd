class_name Interactor extends Node

@export var interaction_key: InputEventAction = preload("res://components/interactor/interact_action.tres")

var interactable_active: Interactable = null

func _ready() -> void:
	pass

func interact() -> void:
	if is_instance_valid(interactable_active):
		interactable_active.interact()

func update_text() -> void:
	var msg: String = ""
	if is_instance_valid(interactable_active):
		msg = interactable_active.message.format({"key":interaction_key.as_text()})
	print("%s" % [msg])
	if Utils.has_autoload_signal("SignalBus", "interact_text_changed"):
		SignalBus.interact_text_changed.emit(msg)
	
