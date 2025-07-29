extends Node

func _ready() -> void:
	# Lowering the resolution affects the mouse sensitivity. Compensate to keep the normal value
	$LowRes/SubViewportContainer/SubViewport/FPSSimpleDemo/FPSSimpleController.mouse_sensitivity *= $LowRes/SubViewportContainer.stretch_shrink
