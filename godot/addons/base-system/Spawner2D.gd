class_name Spawner2D
extends Marker2D

@export var limiter: RateLimiter
@export var scene: PackedScene

func spawn():
	if limiter:
		if limiter.should_wait(): return
	
		limiter.run()
	
	return _create()

func _create():
	var eff = scene.instantiate()
	eff.global_position = global_position
	eff.global_rotation = global_rotation
	get_tree().current_scene.add_child(eff)
	return eff
