extends Control

@export var camera: Camera2D

@onready var scrHeight = ProjectSettings.get_setting("display/window/size/viewport_height")

var calculatedOffset: float

func _process(delta):
	var camZoom = camera.zoom.y;
	calculatedOffset = (-camera.position.y/(scrHeight) + self.position.y/scrHeight) * 2 / camZoom;
	self.material.set_shader_parameter("calculatedOffset", calculatedOffset);
	
	global_position.x = camera.global_position.x - 500
