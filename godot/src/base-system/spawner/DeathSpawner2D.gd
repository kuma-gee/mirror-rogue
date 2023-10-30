class_name DeathSpawner2D
extends Node2D

@export var health: Health
@export var scene: PackedScene

func _ready():
	if health:
		health.zero_health.connect(func(): _create())

func _create():
	var x = scene.instantiate()
	x.global_position = global_position
	x.global_rotation = global_rotation
	get_tree().current_scene.add_child(x)
