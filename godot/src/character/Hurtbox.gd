class_name HurtBox
extends Area2D

signal hit(dmg)
signal hit_with(area)

func damage(dmg: int, hitbox: Node2D):
	hit.emit(dmg)
	hit_with.emit(hitbox)
