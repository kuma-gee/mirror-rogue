class_name Projectile
extends HitBox

signal freed()

@export var speed := 300
@export var dir := Vector2.RIGHT
@export var max_reflections := 4

@export var collision_shape: CollisionShape2D

var target: Node2D
var reflected := 0

var ignored = []

func _ready():
	#_disable_hit()
	#get_tree().create_timer(0.05).timeout.connect(func(): collision_shape.disabled = false) # prevent player from hitting himself
	
	dir = dir.rotated(global_rotation)
	area_entered.connect(func(area):
		if area in ignored: return
		
		if area is Mirror:
			dir = dir.bounce(area.get_normal())
			global_rotation = Vector2.RIGHT.angle_to(dir)
			reflected += 1
			
			if reflected > max_reflections and max_reflections >= 0:
				_remove()
		elif area is HurtBox:
			if area.damage(damage, self):
				_remove()
		else:
			_remove()
	) 

func _disable_hit():
	collision_shape.set_deferred("disabled", true)

func _remove():
	freed.emit()
	queue_free()

func _physics_process(delta):
	var d = global_position.direction_to(target.global_position) if target else dir
	
	translate(d * speed * delta)
	global_rotation = Vector2.RIGHT.angle_to(d)
