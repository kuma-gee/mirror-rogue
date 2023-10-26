extends Area2D

@export var amount := 4

func _ready():
	body_entered.connect(func(player):
		player.heal(amount)
		queue_free()
	)
