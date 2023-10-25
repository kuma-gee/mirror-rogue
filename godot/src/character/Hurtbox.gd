class_name HurtBox
extends Area2D

@export var remove_on_hit = true

signal hit(dmg)
signal hit_with(area)
signal knockback(dir)

func damage(dmg: int, hitbox: Node2D, knockback_force := 0):
	hit.emit(dmg)
	hit_with.emit(hitbox)
	knockback.emit(hitbox.global_position.direction_to(global_position) * knockback_force)
	return remove_on_hit
