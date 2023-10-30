class_name Mirror
extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var spawner_2d = $Spawner2D

func get_normal():
	return Vector2.DOWN.rotated(global_rotation)

func get_shape() -> Shape2D:
	return collision.shape

func create_mirror_effect(collision_point: Vector2, dir: Vector2):
	var shape_size = get_shape().get_rect().size
	var size = min(shape_size.x, shape_size.y)
	
	var actual_pos = collision_point + dir.rotated(-global_rotation) * size / 3
	await create_effect(actual_pos)
	return actual_pos
	
func create_effect(pos):
	var effect = spawner_2d.spawn() as AnimatedSprite2D
	effect.global_position = pos
	await effect.animation_finished
	
