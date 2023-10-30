extends Projectile

@export var speed: ValueProvider

@onready var player_detect = $PlayerDetect

var target: Node2D
var velocity := Vector2.ZERO
var player: Node2D

func _physics_process(delta):
	var d = global_position.direction_to(target.global_position) if target else dir
	translate(d * speed.get_value() * delta)
	global_rotation = Vector2.RIGHT.angle_to(d)

func _remove():
	return_to()

func return_to(p = player):
	target = p
