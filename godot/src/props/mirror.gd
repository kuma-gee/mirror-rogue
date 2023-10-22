class_name Mirror
extends Area2D

func get_normal():
	return Vector2.DOWN.rotated(global_rotation)
