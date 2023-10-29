class_name MirrorValue
extends ValueProvider

@export var normal_value := 1.0
@export var mirror_value := 1.0

func get_value():
	return mirror_value if GameManager.mirror else normal_value
