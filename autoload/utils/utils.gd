extends Node

#region GAME
func exit_game() -> void:
	# Here you can show a confirmation or a message: demo, playtest, etc..
	get_tree().quit()

func has_autoload(autoload: String) -> bool:
	return is_inside_tree() and get_tree() != null and get_tree().root.has_node(autoload)
		
func has_autoload_signal(autoload: String, signal_name: String) -> bool:
	return is_inside_tree() and get_tree() != null and get_tree().root.has_node(autoload) and SignalBus.has_signal(signal_name)

func kill_and_create_tween(tween: Tween = null) -> Tween:
	if tween and tween.is_running():
		tween.kill()
	return create_tween()

#endregion

#region TRANSFORMS, POINTS, AREAS, ETC..
func get_random_rotation(start_rot: float, deviation: float = 10.0) -> float:
	return start_rot + (randf_range(0.0, deviation) * [-1.0, 1.0].pick_random())
	
func get_random_rotation_deg(start_rot: float, deviation: float = 10.0) -> float:
	return rad_to_deg(get_random_rotation(start_rot, deviation))

func get_random_point(object: Node2D, min_dist: float = 0.0, max_dist: float = 450.0, max_angle: float = 360.0) -> Vector2:
	return object.global_position + (Vector2.RIGHT * randf_range(min_dist, max_dist)).rotated(randf_range(0.0, deg_to_rad(max_angle)))

#endregion

#region POLYGONS
func is_point_inside_polygon(point: Vector2, polygon: Polygon2D) -> void:
	pass

func get_closest_safe_point_in_polygon(polygon: Polygon2D, p: Vector2, safe_offset: float = -80.0, max_loop: int = 1024) -> Vector2:
	var loop_count: int = 0
	var safe_point: Vector2
	
	# Duplicate polygon with same value but correct scale otherwise its broken
	var level_polygon: Polygon2D = Polygon2D.new()
	level_polygon.polygon = polygon.polygon
	level_polygon.modulate.a = 0.0
	add_child(level_polygon)
	level_polygon.rotation = polygon.rotation
	level_polygon.scale = Vector2.ONE
	
	# Offset polygon inside to have safe area to work with
	var safe_poly: PackedVector2Array = Geometry2D.offset_polygon(level_polygon.polygon, safe_offset)[0]
	
	# Check if point is already inside this safe polygon
	var local_p: Vector2 = level_polygon.to_local(p)
	if Geometry2D.is_point_in_polygon(local_p, safe_poly):
		level_polygon.queue_free()
		return level_polygon.to_global(local_p)
	
	# If not, move the point towards the center
	var dir: Vector2 = (compute_polygon_center(polygon.polygon) - local_p).normalized()
	
	# Move towards the center in 10 increments until point is safe again
	local_p += dir * 10
	while not Geometry2D.is_point_in_polygon(local_p, safe_poly):
		if loop_count >= max_loop: 
			print("MAX loop reached, safe point not necesarily reached: ", level_polygon.to_global(local_p))
			break
		local_p += dir * 10
		loop_count += 1
		
	safe_point = level_polygon.to_global(local_p)
	level_polygon.queue_free()
	
	return safe_point

func compute_bounding_box(points: PackedVector2Array) -> Array:
	var min_x: float = 1000000
	var min_y: float = 1000000
	var max_x: float = -100000
	var max_y: float = -100000
	
	var bbox: Array = []
	
	# Calculate max and min point to get the bounding box
	for p in points:
		if p.x < min_x:
			min_x = p.x
		if p.x > max_x:
			max_x = p.x
		
		if p.y < min_y:
			min_y = p.y
		if p.y > max_y:
			max_y = p.y
			
	bbox = [min_x, min_y, max_x, max_y]
	
	return bbox

func compute_polygon(radius: float, nb_points: int = 64) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(nb_points+1):
		var point = deg_to_rad(i * 360.0 / nb_points - 90)
		points.push_back(Vector2.ZERO + Vector2(cos(point), sin(point)) * radius)
	
	return points
	
func set_uv_from_polygon(polygon_node: Polygon2D = null):
	var texture = polygon_node.texture
	if not texture:
		return

	# Get polygon points
	var points = polygon_node.polygon
	if points.size() == 0:
		return
	
	# Find the polygon bounds
	var min_point = points[0]
	var max_point = points[0]
	
	for p in points:
		min_point = Vector2(min(min_point.x, p.x), min(min_point.y, p.y))
		max_point = Vector2(max(max_point.x, p.x), max(max_point.y, p.y))
	
	# Polygon size
	var poly_size = max_point - min_point
	
	# Set up UV coordinates
	var uv: PackedVector2Array = []
	for p in points:
		# Normalize point within polygon bounds
		var normalized = (p - min_point) / poly_size
		
		# Scale to texture size
		uv.append(Vector2(
			normalized.x * texture.get_width(),
			normalized.y * texture.get_height()
		))
	polygon_node.uv = uv
	
func compute_polygon_center(polygon_points: PackedVector2Array) -> Vector2:
	var center: Vector2 = Vector2.ZERO
	for p in polygon_points:
		center += p
	
	center /= polygon_points.size()
	return center

# TODO: finish
func get_random_points_inside_polygon(polygon_points: PackedVector2Array) -> Vector2:
	var new_point: Vector2
	return new_point

# TODO: finish
func get_distributed_points_inside_polygon(polygon_points: PackedVector2Array) -> Array[Vector2]:
	var new_points: Array[Vector2]
	
	return new_points

#endregion

#region CALLING FUNCTIONS
# TODO: finish
func call_function_in_frames(function: Callable, frames: int) -> void:
	pass

func call_function_later(function: Callable, time: float) -> void:
	await get_tree().create_timer(time, false).timeout
	function.call()
	
#endregion

#region EDITOR FUNCTIONS
func add_child_editor(parent, child, new_owner) -> void:
	parent.call_deferred("add_child", child)
	child.owner = new_owner

#endregion

#region ARRAY MANIPULATION
func shuffle_copy(array: Array) -> Array:
	var copy: Array = array.duplicate()
	copy.shuffle()
	return copy

#endregion

#region STRING FORMATTING
func seconds_to_text(time: float) -> String:
	var minutes: int = int(time / 60.0) % 60
	var seconds: float = snapped(fmod(time, 60.0), 0.01)
	var milliseconds: float = snapped(fmod(time, 1) * 1000.0, 0.001)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
	
func milliseconds_to_text(time: int) -> String:
	var time_seconds: float = time / 1000.0
	return seconds_to_text(time_seconds)
	
func format_number_with_spaces(n: int) -> String:
	var string: String = str(n)
	var formatted: String = ""
	var count: int = 0

	for i: int in range(string.length() - 1, -1, -1):
		formatted = string[i] + formatted
		count += 1
		if count % 3 == 0 and i > 0:  # Add space every 3 digits, except at the start
			formatted = " " + formatted

	return formatted

#endregion

#region FILES
# TODO: Add optional arg to filter specific extensions
func load_files_from_path(path: String) -> Array:
	var arr: Array = []
	
	print("loading resources from: ", path)
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir():
				if file.get_extension() == "remap":
					file = file.replace(".remap", "")
				var res = load(path+file)
				if res:
					arr.append(res)
	
			file = dir.get_next()
	else:
		printerr("An error occurred when trying to access the path.")
	
	print("Loaded: ", arr)
	
	return arr
	
func read_lines_from_file(path: String) -> Array[String]:
	var lines: Array[String] = []
	var file = FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached():
		var line: String = file.get_line().to_lower()
	
	return lines

#endregion
