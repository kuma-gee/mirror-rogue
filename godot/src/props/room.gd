class_name Room
extends TileMap

signal finished()
signal entered(dir)

const ENEMY = preload("res://src/character/enemy.tscn")
const AREA_ENEMY = preload("res://src/character/area_enemy.tscn")
const BOMB_ENEMY = preload("res://src/character/bomb_enemy.tscn")

@onready var mirror_n = $MirrorN
@onready var mirror_s = $MirrorS
@onready var mirror_w = $MirrorW
@onready var mirror_e = $MirrorE

@onready var door_n = $DoorN
@onready var door_s = $DoorS
@onready var door_w = $DoorW
@onready var door_e = $DoorE

@onready var enemy_spawner = $EnemySpawner

@onready var doors = {
	Vector2.UP: door_n,
	Vector2.DOWN: door_s,
	Vector2.LEFT: door_w,
	Vector2.RIGHT: door_e,
}

var max_enemy_value := 5.0
var max_enemies_killed := 10.0

var available_enemies := [ENEMY]
var spawned_enemies: Array[Enemy] = []
var enemies_killed := 0

var rooms = {}

func _ready():
	door_n.entered.connect(func(): entered.emit(Vector2.UP))
	door_s.entered.connect(func(): entered.emit(Vector2.DOWN))
	door_w.entered.connect(func(): entered.emit(Vector2.LEFT))
	door_e.entered.connect(func(): entered.emit(Vector2.RIGHT))

func get_size():
	var size = get_used_rect().size + Vector2i(2, 0)
	return Vector2(size * tile_set.tile_size)

func open_door(dir: Vector2):
	doors[dir].open()

func get_door(dir: Vector2):
	return doors[dir]

func start(max_value: int, max_killed: int, from: Vector2 = Vector2.ZERO):
	max_enemy_value = max_value
	max_enemies_killed = max_killed
	enemy_spawner.start()
	
	if max_enemy_value > 8:
		available_enemies.append(AREA_ENEMY)
	
	if max_enemy_value > 10:
		available_enemies.append(BOMB_ENEMY)
		
	if from:
		doors[-from].close()

func _on_enemy_spawner_timeout():
	var enemy = available_enemies.pick_random().instantiate()
	var mirror = [mirror_n, mirror_s, mirror_w, mirror_e].pick_random()
	var collision = mirror.get_node("CollisionShape2D2") as CollisionShape2D
	var shape = collision.shape as RectangleShape2D
	var offset = shape.size.x / 2.0
	
	var pos = mirror.global_position + Vector2(randi_range(-offset, offset), 0).rotated(mirror.global_rotation)
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = pos
	
	spawned_enemies.append(enemy)
	enemy.died.connect(func():
		spawned_enemies.erase(enemy)
		enemies_killed += 1
		if _check_current_enemy_values() and spawned_enemies.is_empty():
			finished.emit()
	)
	
	_check_current_enemy_values()

func _check_current_enemy_values():
	if enemies_killed >= max_enemies_killed:
		enemy_spawner.stop()
		return true
	
	var value = 0
	for enemy in spawned_enemies:
		value += enemy.value
	
	if value >= max_enemy_value:
		enemy_spawner.stop()
	elif enemy_spawner.is_stopped():
		enemy_spawner.start()
	return false
