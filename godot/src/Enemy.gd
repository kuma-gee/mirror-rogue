class_name Enemy
extends CharacterBody2D

signal died()

@export var value := 1.0
@export var speed := 50
@export var bullet_scene: PackedScene
@export var bullet_spawn_offset := 10

@onready var navigation_agent := $NavigationAgent2D
@onready var hp_bar = $HpBar

func _ready():
	hp_bar.zero_health.connect(func():
		died.emit()
		queue_free()
	)
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

func _player_pos():
	return get_tree().get_first_node_in_group("Player").global_position

func _process(delta):
	navigation_agent.target_position = _player_pos()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * speed

	velocity = new_velocity
	move_and_slide()


func _on_hitbox_hit(dmg):
	hp_bar.hurt(dmg)


func _on_fire_rate_timer_timeout():
	var bullet = bullet_scene.instantiate()
	var dir = global_position.direction_to(_player_pos())
	_create_bullet(dir)

func _create_bullet(dir):
	var bullet = bullet_scene.instantiate()
	dir = dir * bullet_spawn_offset
	bullet.global_position = global_position + dir
	bullet.dir = dir.normalized()
	get_tree().current_scene.add_child(bullet)
	return bullet
