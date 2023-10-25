class_name HitBox
extends Area2D

@export var damage := 1
@export var knockback_force := 0

func _ready():
	area_entered.connect(func(area):
		if area is HurtBox:
			_do_damage(area)
	)

func _do_damage(area: HurtBox):
	return area.damage(damage, self, knockback_force)
