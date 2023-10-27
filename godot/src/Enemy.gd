class_name Enemy
extends CharacterBody2D

signal died()

@export var friction := 800
@export var value := 1.0
@export var speed := 50

@export var move_anim := "move"
@export var attack_anim := "attack"

@export var normal_tex: Texture2D
@export var mirror_tex: Texture2D

@export var bullet_scene: PackedScene
@export var bullet_spawn_offset := 10
@export var hp_drop: PackedScene
@export var blood_particles: PackedScene

@export var min_drop_chance := 0.2
@export var max_drop_chance := 0.5

@onready var sprite_2d = $Sprite2D
@onready var navigation_agent := $NavigationAgent2D
@onready var hp_bar = $HpBar
@onready var collision_shape_2d = $CollisionShape2D
@onready var soft_collision = $SoftCollision
@onready var heal_timer = $HealTimer
@onready var animation_player = $AnimationPlayer

var knockback: Vector2
var attacking := false
var last_hit_dir := Vector2.RIGHT

func _update_mirror():
	if GameManager.mirror:
		heal_timer.start()
		sprite_2d.texture = mirror_tex
	else:
		heal_timer.stop()
		sprite_2d.texture = normal_tex

func _ready():
	sprite_2d.material = sprite_2d.material.duplicate()
	collision_shape_2d.disabled = true
	
	_update_mirror()
	GameManager.mirrored.connect(func(_m): _update_mirror())
	
	hp_bar.zero_health.connect(func():
		died.emit()
		var player = get_tree().get_first_node_in_group("Player")
		var diff = max_drop_chance - min_drop_chance
		var chance = max_drop_chance - player.get_hp_percentage() * diff
		
		if randf() <= chance:
			var drop = hp_drop.instantiate()
			drop.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", drop)
		
		var blood = blood_particles.instantiate()
		blood.global_position = global_position
		blood.global_rotation = Vector2.RIGHT.angle_to(last_hit_dir)
		get_tree().current_scene.call_deferred("add_child", blood)
		GameManager.killed_enemy()
		queue_free()
	)
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

func _player_pos():
	return get_tree().get_first_node_in_group("Player").global_position

func _process(delta):
	navigation_agent.target_position = _player_pos()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() or attacking:
		return
		
	if knockback:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if velocity.length() < 0.1:
			knockback = Vector2.ZERO
	else:
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()

		var new_velocity: Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * speed
		
		new_velocity += soft_collision.get_push_vector() * delta

		velocity = new_velocity
		
	animation_player.play(move_anim)
	move_and_slide()


func _on_hitbox_hit(dmg):
	hp_bar.hurt(dmg)
	_set_hit_flash(true)
	GameManager.hit()
	get_tree().create_timer(0.1).timeout.connect(func(): _set_hit_flash(false))

func _set_hit_flash(enable: bool):
	sprite_2d.material.set_shader_parameter("mirror", GameManager.mirror)
	sprite_2d.material.set_shader_parameter("enabled", enable)

func _on_fire_rate_timer_timeout():
	attacking = true
	animation_player.play(attack_anim)
	await animation_player.animation_finished
	attacking = false

func _fire():
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


func _on_hurtbox_knockback(dir):
	knockback = dir
	velocity = dir


func _on_mirror_exit_area_exited(area):
	collision_shape_2d.set_deferred("disabled", false)


func _on_heal_timer_timeout():
	hp_bar.heal(1)


func _on_hurtbox_hit_with(area):
	last_hit_dir = area.global_position.direction_to(global_position)
