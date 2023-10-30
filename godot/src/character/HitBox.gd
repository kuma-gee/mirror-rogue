class_name HitBox
extends Area2D

@export var from_player := false
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
	var knockback_dir = global_position.direction_to(area.global_position)
	return area.damage(dmg, knockback_dir * knockback_force)
