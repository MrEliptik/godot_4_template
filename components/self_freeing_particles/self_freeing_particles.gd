
class_name SelfFreeingParticles extends GPUParticles3D

func _ready() -> void:
	one_shot = true
	emitting = true
	
	var to_wait_for: GPUParticles3D = self
	var shortest_lifetime: float = lifetime / speed_scale
	
	for c in get_children():
		if c is not GPUParticles3D: continue
		c.one_shot = true
		c.emitting = true
		if c.lifetime / c.speed_scale < shortest_lifetime:
			shortest_lifetime = c.lifetime / c.speed_scale
			to_wait_for = c
	
	await to_wait_for.finished
	await get_tree().create_timer(1.0, false).timeout
	queue_free() 
