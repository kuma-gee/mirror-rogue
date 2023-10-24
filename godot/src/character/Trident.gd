extends Projectile

@export var mirror_speed := 400

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
	reflect.connect(func(): _update_for_mirror())

func _update_for_mirror():
	sprite_2d.modulate = Color.RED if mirror else Color.WHITE
	current_speed = mirror_speed if mirror else speed

func _remove():
	return_to()

func return_to(p = player):
	#_disable_hit()
	target = p
