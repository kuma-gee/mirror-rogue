class_name Projectile
extends HitBox

signal freed()
signal reflect()

@export var speed := 300
@export var dir := Vector2.RIGHT
@export var max_reflections := 4
@export var disable_initial_hit := true

@export var collision_shape: CollisionShape2D
@export var raycast: RayCast2D

@onready var current_speed := speed
@onready var mirror := GameManager.mirror

const MIRROR_LAYER = 1 << 5

var target: Node2D
var reflected := 0

var ignored = []

func _ready():
	if disable_initial_hit:
		_temp_disable_collision()
	
	dir = dir.rotated(global_rotation)
	area_entered.connect(func(area):
		if area in ignored: return
		
		if area is Mirror:
			if reflected > max_reflections and max_reflections >= 0:
				_remove()
			else:
				if raycast and raycast.is_colliding():
					set_physics_process(false)
					hide()
					var effect_pos = await area.create_mirror_effect(raycast.get_collision_point(), dir)
					global_position = effect_pos
					set_physics_process(true)
					show()
				
				dir = dir.bounce(area.get_normal())
				global_rotation = Vector2.RIGHT.angle_to(dir)
				reflected += 1
				mirror = not mirror
				reflect.emit()
		elif area is HurtBox:
			if _do_damage(area):
				_remove()
		else:
			_remove()
	) 

func _temp_disable_collision():
	_disable_hit()
	get_tree().create_timer(0.1).timeout.connect(func(): collision_shape.disabled = false) # prevent player from hitting himself

func _disable_hit():
	collision_shape.set_deferred("disabled", true)

func _remove():
	freed.emit()
	queue_free()

func _physics_process(delta):
	var d = global_position.direction_to(target.global_position) if target else dir
	
	translate(d * current_speed * delta)
	global_rotation = Vector2.RIGHT.angle_to(d)

func _stop():
	_disable_hit()
	set_physics_process(false)
