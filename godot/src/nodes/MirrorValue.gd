class_name MirrorValue
extends NumberValue

@export var mirror_value := 1.0

func get_value():
	return mirror_value if GameManager.mirror else value
