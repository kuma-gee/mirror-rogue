class_name HitBox
extends Area2D

signal hit()

@export var damage := 1
@export var damage_value: NumberValue
@export var knockback_force := 0

func _ready():
	area_entered.connect(func(area):
		if area is HurtBox:
			_do_damage(area)
	)

func _do_damage(area: HurtBox):
	var dmg = damage_value.get_value() if damage_value else damage
	var knockback_dir = global_position.direction_to(area.global_position)
	
	var did_hit = area.damage(dmg, knockback_dir * knockback_force)
	if did_hit:
		hit.emit()
	return did_hit
