class_name Spawner2D
extends Node2D

@export var autostart := false
@export var scene: PackedScene

func _ready():
	if autostart:
		spawn()

func spawn():
	return _create()

func _create(offset := Vector2.ZERO):
	var eff = scene.instantiate()
	eff.global_position = global_position + offset
	eff.global_rotation = global_rotation
	get_tree().current_scene.add_child(eff)
	return eff
