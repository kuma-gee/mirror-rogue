extends Node2D

const ROOM = preload("res://src/props/room.tscn")

const value_increase := 1.5
const kill_increase := 1.8

var enemy_value := 5.0
var enemy_kills := 1.0

func _ready():
	_setup_first_room.call_deferred()
	
func _setup_first_room():
	var room = _create_room()
	add_child(room)
	room.start(enemy_value, enemy_kills)

func _setup_next_room(current_room: Room):
	var room = _create_room()
	enemy_value *= value_increase
	enemy_kills *= kill_increase
	var dir = [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN].pick_random()
	print("Creating room in dir %s" % dir)
	current_room.rooms[dir] = room
	current_room.open_door(dir)
	add_child.call_deferred(room)

func _create_room() -> Room:
	var room = ROOM.instantiate()
	room.finished.connect(func(): _setup_next_room(room))
	room.entered.connect(func(dir):
		# TODO: move camera
		room.rooms[dir].start(enemy_value, enemy_kills, dir)
	)
	return room

func _on_player_died():
	GameManager.gameover()

func _on_player_reflected():
	GameManager.reflected()
