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
	
	var actual_pos = to_local(collision_point) + dir.rotated(-global_rotation) * size / 2
	var effect = mirror_effect.instantiate() as AnimatedSprite2D
	effect.position = actual_pos
	add_child(effect)
	await effect.animation_finished
	remove_child(effect)
	return to_global(effect.position)
