extends Enemy

@export var bullet_count := 8

func _fire():
	for i in bullet_count:
		var dir = Vector2.RIGHT.rotated(i * TAU/bullet_count)
		_create_bullet(dir)
