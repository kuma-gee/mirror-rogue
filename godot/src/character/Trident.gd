extends Projectile

@onready var player_detect = $PlayerDetect

var player: Node2D

func _ready():
	super._ready()
	
	player_detect.body_entered.connect(func(body):
		freed.emit()
		queue_free()
	)

func _remove():
	return_to()

func return_to(p = player):
	#_disable_hit()
	target = p
