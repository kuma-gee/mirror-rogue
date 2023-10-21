class_name Hitbox
extends Area2D

signal hit(dmg)

func damage(dmg: int):
	hit.emit(dmg)
