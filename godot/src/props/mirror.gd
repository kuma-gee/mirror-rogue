class_name Mirror
extends Area2D

@export var mirror_effect: PackedScene

@onready var collision: CollisionShape2D = $CollisionShape2D

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
	var effect = mirror_effect.instantiate() as AnimatedSprite2D
	add_child(effect)
	effect.global_position = pos
	await effect.animation_finished
	remove_child(effect)
	
