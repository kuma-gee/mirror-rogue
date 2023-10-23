class_name HurtBox
extends Area2D

signal hit(dmg)

func damage(dmg: int):
	hit.emit(dmg)
