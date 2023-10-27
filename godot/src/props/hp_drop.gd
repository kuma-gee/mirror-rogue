extends Area2D

@export var amount := 5

func _ready():
	GameManager.mirrored.connect(func(mirror): _visible(mirror))
	body_entered.connect(func(player):
		player.heal(amount)
		queue_free()
	)

func _visible(v: bool):
	visible = v
	$CollisionShape2D.disabled = not v
