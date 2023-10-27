extends Area2D

@export var amount := 5

func _ready():
	GameManager.mirrored.connect(func(mirror):
		visible = mirror
		$CollisionShape2D.disabled = not mirror
	)
	body_entered.connect(func(player):
		player.heal(amount)
		queue_free()
	)
