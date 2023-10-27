class_name HitBox
extends Area2D

@export var damage := 1
@export var mirror_damage := 1
@export var knockback_force := 0

func _ready():
	area_entered.connect(func(area):
		if area is HurtBox:
			_do_damage(area)
	)

func _do_damage(area: HurtBox):
	var dmg = mirror_damage if GameManager.mirror else damage
	return area.damage(dmg, self, knockback_force)
