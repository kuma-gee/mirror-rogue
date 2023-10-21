extends CharacterBody2D

@export var speed := 100
@export var accel := 800

@onready var input: PlayerInput = $Input

func _physics_process(delta):
	var motion_x = input.get_action_strength("move_right") - input.get_action_strength("move_left")
	var motion_y = input.get_action_strength("move_down") - input.get_action_strength("move_up")
	
	velocity = velocity.move_toward(Vector2(motion_x, motion_y) * speed, accel * delta)
	move_and_slide()
