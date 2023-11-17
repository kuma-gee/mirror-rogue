class_name RelativeRemoteTransform2D
extends Node2D

@export var remote_node: Node2D
@export var relative_to_origin := 1.1
@export var center := Vector2.ZERO

func _process(delta):
	if remote_node:
		var dir = global_position - center
		remote_node.global_position = dir * relative_to_origin
