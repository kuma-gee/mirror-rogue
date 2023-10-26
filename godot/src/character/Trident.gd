extends Projectile

@export var normal_tex: Texture2D
@export var mirror_tex: Texture2D

@onready var player_detect = $PlayerDetect
@onready var sprite_2d = $Sprite2D

var player: Node2D

func _ready():
	super._ready()
	
	player_detect.body_entered.connect(func(body):
		freed.emit()
		queue_free()
	)
	
	_update_for_mirror()
	GameManager.mirrored.connect(func(_m): _update_for_mirror())

func _update_for_mirror():
	sprite_2d.texture = mirror_tex if GameManager.mirror else normal_tex

func _remove():
	return_to()

func return_to(p = player):
	#_disable_hit()
	target = p
