class_name HurtBox
extends Area2D

@export var invincible_time := 0.0
@export var remove_on_hit := true

signal hit(dmg)
signal hit_with(area)
signal knockback(dir)
signal by_player()

var invincible := false

func damage(dmg: int, hitbox: Node2D, knockback_force := 0, from_player = false):
	if invincible:
		return false
	
	invincible = true
	hit.emit(dmg)
	hit_with.emit(hitbox)
	knockback.emit(hitbox.global_position.direction_to(global_position) * knockback_force)
	get_tree().create_timer(invincible_time).timeout.connect(func(): invincible = false)
	if from_player:
		by_player.emit()
	return remove_on_hit
