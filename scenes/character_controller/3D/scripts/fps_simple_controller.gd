class_name FPSSimpleController extends CharacterBody3D

signal killed()

enum GUN_TYPE {GUN, ROCKET}

@export_category("Movement")
@export var speed: float = 3.5
@export var jump_force: float = 8.0
@export var mouse_sensitivity: float = 0.08
@export var accel: float = 2.0
@export var friction: float = 0.8
@export var gravity: float = 28.0
@export var coyote_time: float = 0.2
@export var input_buffer_time: float = 0.2

@export_category("Bobbing")
@export var camera_lean_accel: float = 4.0
@export var bobbing_strength: float = 1.0
@export var weapon_sway: float = 20.0
@export var side_bob_freq: float = 6.0
@export var side_bob_amplitude: float = -2.0
@export var vertical_bob_freq: float = 12.0
@export var vertical_bob_amplitude: float = 0.005

var dead: bool = false
var can_move: bool = true
var was_on_floor: bool = false
var coyote_jump: bool = false
var input_buffer_jump: bool = false
var mouse_move: Vector2 = Vector2.ZERO
var last_collider: Node3D
var last_collider_rot: Vector3

var tween_footsteps: Tween
var tween_bobbing_stop: Tween

var time: float = 0.0

@onready var rot_point: Node3D = $RotPoint
@onready var camera: Camera3D = $RotPoint/Camera3D
@onready var land: AudioStreamPlayer = $Land

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Make the player available to everyone
	# Globals.player = self

func _input(event):
	if dead or not can_move: return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_move = event.relative
		
		rot_point.rotate_x(deg_to_rad(event.relative.y * mouse_sensitivity * -1))
		rotate_y(deg_to_rad(event.relative.x * mouse_sensitivity * -1))

		var camera_rot = rot_point.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		rot_point.rotation_degrees = camera_rot
		
	# Jump 
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_jump:
			velocity.y = jump_force

func _physics_process(delta: float) -> void:
	if dead: return
	
	if not can_move: 
		reset_bobbing()
		#velocity = Vector3.ZERO
		#move_and_slide()
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	#gamepad_aim()

	if Input.is_action_just_pressed("interact"):
		pass
		
	# We hit the floor
	if not was_on_floor and is_on_floor():
		land.play()
		
	was_on_floor = is_on_floor()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, accel)
		velocity.z = move_toward(velocity.z, direction.z * speed, accel)
		footsteps_toggle(true)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		velocity.z = move_toward(velocity.z, 0, friction)
		footsteps_toggle(false)
		
	# Camera bobbing
	if Vector2(velocity.x, velocity.z).length() > 0.1:
		camera_bobbing(velocity, delta)
	else:
		reset_bobbing()

	var colliding: bool = move_and_slide()	
	if colliding:
		var collision: KinematicCollision3D = get_last_slide_collision()
		if last_collider != collision.get_collider():
			pass
		
		last_collider = collision.get_collider()
		last_collider_rot = last_collider.rotation

#func gamepad_aim() -> void:
	#var aim_dir: Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	#if aim_dir.is_zero_approx(): return
	#rot_point.rotate_x(deg_to_rad(aim_dir.y * Globals.gamepad_sensitivity * -1))
	#rotate_y(deg_to_rad(aim_dir.x * Globals.gamepad_sensitivity * -1))
#
	#var camera_rot = rot_point.rotation_degrees
	#camera_rot.x = clamp(camera_rot.x, -90, 90)
	#rot_point.rotation_degrees = camera_rot

func camera_bobbing(velocity: Vector3, delta: float) -> void:
	if tween_bobbing_stop and tween_bobbing_stop.is_running():
		tween_bobbing_stop.kill()
	
	time += delta
	var side_sin: float = sin(time * side_bob_freq) * side_bob_amplitude * velocity.normalized().length()
	camera.rotation_degrees.z = rad_to_deg(lerp_angle(camera.rotation.z, deg_to_rad(side_sin), camera_lean_accel * delta))
	
	var vertical_sin: float = sin(time * vertical_bob_freq) * vertical_bob_amplitude * velocity.normalized().length()
	#print("Vertical sin: ", vertical_sin)
	camera.position.y = vertical_sin

func reset_bobbing() -> void:
	if tween_bobbing_stop and tween_bobbing_stop.is_running(): return
	time = 0.0
	tween_bobbing_stop = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween_bobbing_stop.tween_property(camera, "rotation_degrees:z", 0.0, 0.2)
	tween_bobbing_stop.tween_property(camera, "position:y", 0.0, 0.2)

func footsteps_toggle(walking: bool) -> void:
	if walking:
		if tween_footsteps and tween_footsteps.is_running():
			return
		tween_footsteps = create_tween()
		tween_footsteps.set_loops()
		tween_footsteps.tween_callback($Footsteps.play)
		tween_footsteps.tween_interval(randf_range(0.25, 0.45))
	else:
		if tween_footsteps and tween_footsteps.is_running():
			tween_footsteps.kill()
