class_name InteractLabel extends Label

func _ready() -> void:
	text = ""
	
	if Utils.has_autoload_signal("SignalBus", "interact_text_changed"):
		SignalBus.interact_text_changed.connect(on_interact_text_changed)

func on_interact_text_changed(new_text: String) -> void:
	text = new_text
