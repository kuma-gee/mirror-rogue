class_name MirrorSprite2D
extends Sprite2D

@export var mirror_texture: Texture2D
@onready var normal_texture: Texture2D = texture

func _ready():
	update()
	GameManager.mirrored.connect(func(_m): update())

func update():
	texture = mirror_texture if GameManager.mirror else normal_texture
