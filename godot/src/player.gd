extends CharacterBody2D

signal died()
signal reflected()

@export var speed := 100
@export var accel := 800

@export var dash_force := 500
@export var dash_deaccel := 1500
@export var attack_rate := 0.5

@export var projectile_scene: PackedScene

@onready var input: PlayerInput = $Input
@onready var hand: Node2D = $Hand
@onready var shot_point = $Hand/ShotPoint
@onready var mirror_detect = $MirrorDetect
@onready var anim = $AnimationPlayer

@onready var body = $Body
@onready var normal_body = $Body/Normal
@onready var trident_body = $Body/Trident
@onready var hp_bar = $HpBar
@onready var frame_freeze = $FrameFreeze

var dashing := false
var attacking := false
var trident: Projectile

func _ready():
	hp_bar.zero_health.connect(func(): died.emit())
	
	input.just_pressed.connect(_on_just_pressed)
	anim.play("RESET")
	_update_throw()
	
	GameManager.mirrored.connect(func(mirror):
		modulate = Color.RED if mirror else Color.WHITE
	)

func _update_throw():
	if _is_thrown():
		normal_body.visible = true
		trident_body.visible = false
	else:
		normal_body.visible = false
		trident_body.visible = true

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
			trident = projectile_scene.instantiate()
			trident.player = self
			trident.global_position = shot_point.global_position
			trident.global_rotation = shot_point.global_rotation
			get_tree().current_scene.add_child(trident)
			trident.freed.connect(func():
				trident = null
				_update_throw()
			)
			_update_throw()
		else:
			trident.return_to()
			
	elif ev.is_action_pressed("attack") and not _is_thrown() and not attacking:
		attacking = true
		anim.play("Attack")
		get_tree().create_timer(attack_rate).timeout.connect(func(): attacking = false)

func _is_thrown():
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
		var motion = _get_motion()
		velocity = velocity.move_toward(motion * speed, accel * delta)
		if not attacking:
			anim.play("Move" if velocity.length() > 0 else "Idle")
	
	move_and_slide()

func _get_motion():
	var motion_x = input.get_action_strength("move_right") - input.get_action_strength("move_left")
	var motion_y = input.get_action_strength("move_down") - input.get_action_strength("move_up")
	return Vector2(motion_x, motion_y).normalized()

func _on_hurtbox_hit(dmg):
	hp_bar.hurt(dmg)
	_set_hit_flash(true)
	await frame_freeze.freeze(0.05, 0.5)
	_set_hit_flash(false)

func _on_hurtbox_knockback(dir):
	velocity += dir


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

func _set_hit_flash(enable: bool):
	normal_body.material.set_shader_parameter("enabled", enable)
	trident_body.material.set_shader_parameter("enabled", enable)
	
