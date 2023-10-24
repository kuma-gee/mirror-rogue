class_name HurtBox
extends Area2D

@export var remove_on_hit = true

signal hit(dmg)
signal hit_with(area)

func damage(dmg: int, hitbox: Node2D):
	hit.emit(dmg)
	hit_with.emit(hitbox)
	return remove_on_hit
