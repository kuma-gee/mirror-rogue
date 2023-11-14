class_name Projectile
extends Area2D

signal reflect(dir)

@export var dir := Vector2.RIGHT
@export var max_reflections := 4
@export var disable_initial_hit := true

@export var collision_shape: CollisionShape2D
@export var hurt_collision: CollisionShape2D
@export var raycast: RayCast2D

@export var death_spawner: DeathSpawner2D
@export var hit_box: HitBox
@export var health: Health

var reflected := 0
var ignored = []

func _ready():
#	if disable_initial_hit:
#		_temp_disable_collision()
	
	if hit_box:
		hit_box.hit.connect(_remove)
	if health:
		health.zero_health.connect(_remove)
	
	dir = dir.rotated(global_rotation)
	area_entered.connect(func(area):
		if area in ignored: return
		
		if reflected > max_reflections and max_reflections >= 0:
			_remove()
		elif area is Mirror:
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
			reflect.emit(dir)
		else:
			_remove()
	)
	body_entered.connect(func(_x): _remove())

#func _temp_disable_collision():
#	_disable_hit()
#	get_tree().create_timer(0.1).timeout.connect(func(): collision_shape.disabled = false) # prevent player from hitting himself

#func _disable_hit():
#	collision_shape.set_deferred("disabled", true)

func _remove():
	if death_spawner:
		death_spawner.spawn()
	queue_free()
