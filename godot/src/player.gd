class_name Player
extends CharacterBody2D

signal died()
signal reflected()
signal thrown()

@export var dash_force := 500
@export var dash_deaccel := 1500

@onready var input: PlayerInput = $PlayerController/Input
@onready var hand: Node2D = $Hand
@onready var mirror_detect = $MirrorDetect
@onready var anim = $AnimationPlayer

@onready var attack_spawner = $Hand/AttackSpawner
@onready var trident_spawner = $Hand/TridentSpawner

@onready var body = $Body
@onready var sprite = $Body/Sprite2D

@onready var hp_bar = $Health
@onready var heal_sound = $HealSound

@onready var top_down_move_2d = $States/TopDownMove2D

var dashing := false
var trident: Projectile

func _ready():
	hp_bar.zero_health.connect(func(): died.emit())
	
	input.just_pressed.connect(_on_just_pressed)
	anim.play("RESET")

func get_hp_percentage():
	return hp_bar.get_health_percent()

func _update_throw():
	thrown.emit()

func _on_just_pressed(ev: InputEvent):
	if ev.is_action_pressed("dash") and not dashing:
		var dir = _get_motion()
		if dir.length() == 0:
			dir = _aim_dir()
		
		velocity = dir * dash_force
		dashing = true
		anim.play("Dash")
		
		if mirror_detect.get_overlapping_areas().size() > 0:
			var mirror = mirror_detect.get_overlapping_areas()[0]
			var mirror_dir = global_position.direction_to(mirror.global_position)
			if mirror_dir.dot(dir) > 0:
				_on_mirror_detect_area_entered(mirror)
	elif ev.is_action_pressed("throw"):
		if not trident:
			trident = trident_spawner.spawn()
			trident.player = self
			trident.tree_exited.connect(func():
				trident = null
				_update_throw()
			)
			_update_throw()
		else:
			trident.return_to()
			
	elif ev.is_action_pressed("attack") and not is_thrown() and not get_tree().paused:
		attack_spawner.spawn()

func is_thrown():
	return trident != null

func _process(delta):
	var aim = _aim_dir()
	hand.global_rotation = Vector2.RIGHT.angle_to(aim)
	
	# body is rotated, so we scale y-axis
	body.scale.y = 1 if aim.x > 0 else -1

func _aim_dir():
	return global_position.direction_to(get_global_mouse_position())

func _physics_process(delta):
	if dashing:
		velocity = velocity.move_toward(Vector2.ZERO, dash_deaccel * delta)
		if velocity.length() < 0.5:
			dashing = false
	else:
		velocity = top_down_move_2d.move(velocity, delta)
		anim.play("Move" if velocity.length() > 0 else "Idle")
	
	move_and_slide()

func _get_motion():
	var motion_x = input.get_action_strength("move_right") - input.get_action_strength("move_left")
	var motion_y = input.get_action_strength("move_down") - input.get_action_strength("move_up")
	return Vector2(motion_x, motion_y).normalized()

func _on_hurtbox_knockback(dir):
	velocity += dir

func heal(amount: int):
	hp_bar.heal(amount)
	heal_sound.play()

func _on_mirror_detect_area_entered(area):
	if dashing and velocity.length() > 400:
		var n = area.get_normal()
		if abs(velocity.dot(n)) < 0.1: # ignore steep collisions
			return
		
		velocity = velocity.bounce(n) / 2
		reflected.emit()

func immediate_return_trident():
	if trident:
		trident.queue_free()
		trident = null
		_update_throw()
	
