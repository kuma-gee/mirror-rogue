extends Node

@export var ctrl: CharacterController
@export var speed: ValueProvider
@export var accel := 900

@export var debug := false

var _logger := Logger.new("TopDownMove2D")

func move(velocity: Vector2, delta: float):
	var motion = Vector2.ZERO
	if ctrl:
		motion = ctrl.get_motion()
	
	if debug:
		_logger.debug("Moving to %s" % motion)
		
	var s = speed.get_value()
	return velocity.move_toward(motion * s, accel * delta)
