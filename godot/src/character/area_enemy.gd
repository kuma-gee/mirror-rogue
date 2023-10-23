extends Enemy

@export var bullet_count := 8

func _on_fire_rate_timer_timeout():
	for i in bullet_count:
		var dir = Vector2.RIGHT.rotated(i * TAU/bullet_count)
		_create_bullet(dir)
