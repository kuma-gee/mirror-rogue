extends Area2D

signal freed()

@export var speed := 300
@export var dir := Vector2.RIGHT
@export var max_reflections := 4
@export var damage := 5

@onready var collision_shape_2d = $CollisionShape2D

var reflected := 0

func _ready():
	collision_shape_2d.disabled = true
	get_tree().create_timer(0.05).timeout.connect(func(): collision_shape_2d.disabled = false) # prevent player from hitting himself
	
	dir = dir.rotated(global_rotation)
	area_entered.connect(func(area):
		if area is Mirror:
			dir = dir.bounce(area.get_normal())
			global_rotation = Vector2.RIGHT.angle_to(dir)
			reflected += 1
			
			if reflected > max_reflections:
				_remove()
		elif area is Hitbox:
			area.damage(damage)
			_remove()
	) 

func _remove():
	freed.emit()
	queue_free()

func _physics_process(delta):
	translate(dir * speed * delta)
