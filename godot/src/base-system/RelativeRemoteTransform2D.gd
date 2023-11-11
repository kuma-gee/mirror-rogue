class_name RelativeRemoteTransform2D
extends Node2D

@export var remote_node: Node2D
@export var relative_to_origin := 1.1

func _process(delta):
	remote_node.global_position = global_position * relative_to_origin
