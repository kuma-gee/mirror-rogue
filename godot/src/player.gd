extends CharacterBody2D

signal died()

@export var speed := 100
@export var accel := 800
@export var health := 50

@export var dash_force := 600
@export var dash_deaccel := 2000

@export var projectile_scene: PackedScene

@onready var input: PlayerInput = $Input
@onready var hand: Node2D = $Hand
@onready var shot_point = $Hand/ShotPoint

var thrown = false
var dashing = false

func _ready():
	input.just_pressed.connect(_on_just_pressed)

func _on_just_pressed(ev: InputEvent):
	if ev.is_action_pressed("dash") and not dashing:
		velocity = velocity.normalized() * dash_force
		dashing = true
	elif ev.is_action_pressed("throw") and not thrown:
		thrown = true
		var projectile = projectile_scene.instantiate()
		projectile.global_position = shot_point.global_position
		projectile.global_rotation = shot_point.global_rotation
		get_tree().current_scene.add_child(projectile)
		projectile.freed.connect(func(): thrown = false)

func _process(delta):
	hand.global_rotation = Vector2.RIGHT.angle_to(global_position.direction_to(get_global_mouse_position()))

func _physics_process(delta):
	if dashing:
		velocity = velocity.move_toward(Vector2.ZERO, dash_deaccel * delta)
		if velocity.length() < 0.5:
			dashing = false
	else:
		var motion_x = input.get_action_strength("move_right") - input.get_action_strength("move_left")
		var motion_y = input.get_action_strength("move_down") - input.get_action_strength("move_up")
		velocity = velocity.move_toward(Vector2(motion_x, motion_y) * speed, accel * delta)
	
	move_and_slide()


func _on_hitbox_hit(dmg):
	health -= dmg
	if health <= 0:
		died.emit()
