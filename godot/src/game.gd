extends Node2D

const ENEMY = preload("res://src/character/enemy.tscn")
const AREA_ENEMY = preload("res://src/character/area_enemy.tscn")
const BOMB_ENEMY = preload("res://src/character/bomb_enemy.tscn")

@onready var mirror_n = $TileMap/MirrorN
@onready var mirror_s = $TileMap/MirrorS
@onready var mirror_w = $TileMap/MirrorW
@onready var mirror_e = $TileMap/MirrorE

func _on_player_died():
	GameManager.gameover()

func _on_player_reflected():
	GameManager.reflected()

func _on_enemy_spawner_timeout():
	var enemy = BOMB_ENEMY.instantiate()
	var mirror = [mirror_n, mirror_s, mirror_w, mirror_e].pick_random()
	var collision = mirror.get_node("CollisionShape2D2") as CollisionShape2D
	var shape = collision.shape as RectangleShape2D
	var offset = shape.size.x / 2.0
	
	var pos = mirror.global_position + Vector2(randi_range(-offset, offset), 0).rotated(mirror.global_rotation)
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = pos
