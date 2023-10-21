extends Area2D

@export var speed := 300
@export var dir := Vector2.RIGHT
@export var max_reflections := 4
@export var damage := 5

var reflected := 0

func _ready():
	dir = dir.rotated(global_rotation)
	area_entered.connect(func(area):
		if area is Mirror:
			dir = dir.bounce(Vector2.DOWN.rotated(area.global_rotation))
			global_rotation = Vector2.RIGHT.angle_to(dir)
			reflected += 1
			
			if reflected > max_reflections:
				queue_free()
		elif area is Hitbox:
			area.damage(damage)
			queue_free()
	) 

func _physics_process(delta):
	translate(dir * speed * delta)
