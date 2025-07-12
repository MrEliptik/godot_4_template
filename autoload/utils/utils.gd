extends Node

func get_random_rotation(start_rot: float, deviation: float = 10.0) -> float:
	return start_rot + (randf_range(0.0, deviation) * [-1.0, 1.0].pick_random())
	
func get_random_rotation_deg(start_rot: float, deviation: float = 10.0) -> float:
	return rad_to_deg(get_random_rotation(start_rot, deviation))

# TODO: finish
func get_random_points_inside_polygon(polygon: PackedVector2Array) -> Vector2:
	var new_point: Vector2
	return new_point

# TODO: finish
func get_distributed_points_inside_polygon(polygon: PackedVector2Array) -> Array[Vector2]:
	var new_points: Array[Vector2]
	
	return new_points

# TODO: finish
func call_function_in_frames(function: Callable, frames: int) -> void:
	pass

# TODO: finish
func call_function_later(function: Callable, time: float) -> void:
	await get_tree().create_timer(time, false).timeout
	function.call()
