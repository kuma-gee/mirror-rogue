extends CharacterBody2D

signal died()
signal reflected()

@export var mirror_speed := 120
@export var speed := 80
@export var accel := 900

@export var dash_force := 500
@export var dash_deaccel := 1500

@export var mirror_attack_rate := 0.3
@export var attack_rate := 0.5

@export var projectile_scene: PackedScene
@export var attack_effect: PackedScene

@export var normal_tex: Texture2D
@export var normal_mirror_tex: Texture2D
@export var trident_tex: Texture2D
@export var trident_mirror_tex: Texture2D

@onready var input: PlayerInput = $Input
@onready var hand: Node2D = $Hand
@onready var shot_point = $Hand/ShotPoint
@onready var mirror_detect = $MirrorDetect
@onready var anim = $AnimationPlayer

@onready var body = $Body
@onready var sprite = $Body/Normal

@onready var hp_bar = $HpBar
@onready var frame_freeze = $FrameFreeze
@onready var heal_sound = $HealSound
@onready var hit_sound = $HitSound

var dashing := false
var attacking := false
var trident: Projectile

func _ready():
	hp_bar.zero_health.connect(func(): died.emit())
	
	input.just_pressed.connect(_on_just_pressed)
	anim.play("RESET")
	_update_throw()
	
	GameManager.mirrored.connect(func(mirror):
		_update_throw()
	)

func get_hp_percentage():
	return hp_bar.value / hp_bar.max_value

func _update_throw():
	sprite.texture = _get_body_tex()

func _get_body_tex() -> Texture2D:
	var mirror = GameManager.mirror
	if _is_thrown():
		return normal_mirror_tex if mirror else normal_tex
	return trident_mirror_tex if mirror else trident_tex

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
			
	elif ev.is_action_pressed("attack") and not _is_thrown() and not attacking and not get_tree().paused:
		attacking = true
		var eff = attack_effect.instantiate()
		get_tree().current_scene.add_child(eff)
		eff.global_position = shot_point.global_position
		eff.global_rotation = shot_point.global_rotation
		_start_attack_rate_timer()

func _start_attack_rate_timer():
	var time = mirror_attack_rate if GameManager.mirror else attack_rate
	get_tree().create_timer(time).timeout.connect(func(): attacking = false)

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
		var s = mirror_speed if GameManager.mirror else speed
		velocity = velocity.move_toward(motion * s, accel * delta)
		if not attacking:
			anim.play("Move" if velocity.length() > 0 else "Idle")
	
	move_and_slide()

func _get_motion():
	var motion_x = input.get_action_strength("move_right") - input.get_action_strength("move_left")
	var motion_y = input.get_action_strength("move_down") - input.get_action_strength("move_up")
	return Vector2(motion_x, motion_y).normalized()

func _on_hurtbox_hit(dmg):
	hit_sound.play()
	hp_bar.hurt(dmg)
	if hp_bar.value > 0:
		_set_hit_flash(true)
		await frame_freeze.freeze(0.05, 0.5)
		_set_hit_flash(false)

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

func _set_hit_flash(enable: bool):
	sprite.material.set_shader_parameter("mirror", GameManager.mirror)
	sprite.material.set_shader_parameter("enabled", enable)
	
