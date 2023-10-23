extends Projectile

@onready var player_detect = $PlayerDetect

func _ready():
	super._ready()
	
	player_detect.body_entered.connect(func(body):
		freed.emit()
		queue_free()
	)

func _remove():
	_disable_hit()
	target = get_tree().get_first_node_in_group("Player")
