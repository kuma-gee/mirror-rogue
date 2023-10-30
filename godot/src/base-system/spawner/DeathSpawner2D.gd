class_name DeathSpawner2D
extends Node2D

@export var spawn_chance: ValueProvider
@export var health: Health
@export var scene: PackedScene

func _ready():
	if health:
		health.zero_health.connect(func(): _create())

func _should_spawn():
	return spawn_chance == null or randf() <= spawn_chance.get_value()

func _create():
	if not _should_spawn():
		return
	
	var x = scene.instantiate()
	x.global_position = global_position
	x.global_rotation = global_rotation
	get_tree().current_scene.call_deferred("add_child", x)
