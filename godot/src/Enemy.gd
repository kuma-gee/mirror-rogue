class_name Enemy
extends CharacterBody2D

signal died()

@export var value := 1
@export var friction := 800
@export var mirror_speed := 50
@export var speed := 50

@export var move_anim := "move"
@export var attack_anim := "attack"

@onready var sprite_2d = $Sprite2D
@onready var navigation_agent := $NavigationAgent2D
@onready var hp_bar = $Health
@onready var collision_shape_2d = $CollisionShape2D
@onready var soft_collision = $SoftCollision
@onready var heal_timer = $HealTimer
@onready var animation_player = $AnimationPlayer

@onready var drop_chance = $DeathSpawner2D/DropChance
@onready var blood_spawner = $BloodSpawner
@onready var bullet_spawner = $BulletSpawner
@onready var mirror_hit_flash_2d = $Hurtbox/MirrorHitFlash2D

var knockback: Vector2
var attacking := false
var last_hit_dir := Vector2.RIGHT

func _update_mirror():
	if GameManager.mirror:
		heal_timer.start()
	else:
		heal_timer.stop()

func _ready():
	sprite_2d.material = sprite_2d.material.duplicate()
	mirror_hit_flash_2d.reset()
	collision_shape_2d.disabled = true
	
	_update_mirror()
	GameManager.mirrored.connect(func(_m): _update_mirror())
	
	hp_bar.health_changed.connect(func(_h):
		var player = get_tree().get_first_node_in_group("Player")
		drop_chance.value = 1 - player.get_hp_percentage()
	)
	
	hp_bar.zero_health.connect(func():
		died.emit()
		var blood = blood_spawner.spawn()
		blood.global_rotation = Vector2.RIGHT.angle_to(last_hit_dir)
		
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
		var s = mirror_speed if GameManager.mirror else speed
		new_velocity = new_velocity * s
		
		new_velocity += soft_collision.get_push_vector() * delta

		velocity = new_velocity
		
	animation_player.play(move_anim)
	move_and_slide()


func _on_hitbox_hit(dmg):
	GameManager.hit()

func _fire():
	var dir = global_position.direction_to(_player_pos())
	_create_bullet(dir)

func _create_bullet(dir):
	bullet_spawner.global_rotation = Vector2.RIGHT.angle_to(dir)
	return bullet_spawner.spawn()


func _on_hurtbox_knockback(dir):
	last_hit_dir = dir.normalized()
	knockback = dir
	velocity = dir


func _on_mirror_exit_area_exited(area):
	collision_shape_2d.set_deferred("disabled", false)


func _on_heal_timer_timeout():
	hp_bar.heal(1)


func _on_timer_timeout():
	attacking = true
	animation_player.play(attack_anim)
	await animation_player.animation_finished
	attacking = false
