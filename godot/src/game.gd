extends Node2D

const ROOM = preload("res://src/props/room.tscn")

@onready var cam = $Camera2D
@onready var player = $Player
@onready var music_player = $MusicPlayer
@onready var mirror_viewport = $MirrorViewport
@onready var relative_remote_transform_2d = $Player/RelativeRemoteTransform2D
@onready var grid_room_map = $GridRoomMap

@export var enemy_value := 5.0
@export var enemy_kills := 5.0

@export var value_increase := 1.5
@export var kill_increase := 1.8

var room_dirs := [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]
var rooms = {}

var _logger = Logger.new("Game")

func _ready():
	GameManager.game_start()
	music_player.play("RESET")
	GameManager.mirrored.connect(func(mirror): music_player.play("mirror" if mirror else "normal"))
	
	grid_room_map.generated.connect(func():
		for coord in grid_room_map.rooms:
			_create_room(coord)
		
		print("Created rooms")
		var room = rooms[grid_room_map.coord]
		var pos = room.global_position
		player.global_position = pos
		cam.global_position = pos
		relative_remote_transform_2d.center = pos
		room.open_doors()
		
		await get_tree().create_timer(0.5).timeout
		cam.position_smoothing_enabled = true
	)
	grid_room_map.generate()
	
#func _setup_first_room():
	#var room = _create_room()
	#add_child(room)
	#room.start(enemy_value, enemy_kills)
#
#func _setup_next_room(current_room: Room):
	#var room = _create_room()
	#var dir = room_dirs.filter(func(d): return d != previous_dir).pick_random()
	#_logger.debug("Creating room in dir %s" % dir)
	#current_room.rooms[dir] = room
	#current_room.open_doors()
	#
	#room.global_position = current_room.global_position + dir * room.get_size()
	#add_child.call_deferred(room)

func _create_room(coord: Vector2i) -> Room:
	var room = ROOM.instantiate()
	var mat = room.material as ShaderMaterial
	mat.set_shader_parameter("reflection_viewport", mirror_viewport.get_viewport().get_texture())
	
	add_child(room)
	rooms[coord] = room
	room.global_position = coord * room.get_size()
	room.setup_doors(grid_room_map.get_linked_dirs(coord))
	
	room.finished.connect(func():
		grid_room_map.set_room_cleared(coord)
		room.open_doors()
		enemy_value *= value_increase
		enemy_kills *= kill_increase
	)
	room.entered.connect(func(dir):
		_logger.debug("Player entered in direction %s" % dir)
		var next_coord = coord + dir
		if not next_coord in rooms:
			print("Room not available in %s" % next_coord)
			return
		
		var next_room = rooms[next_coord]
		cam.global_position = next_room.global_position
		relative_remote_transform_2d.center = cam.global_position
		
		player.velocity = Vector2.ZERO
		player.global_position = next_room.get_door(-dir).global_position + Vector2(dir) * 10
		player.immediate_return_trident()
		
		grid_room_map.coord = next_coord
		if not grid_room_map.is_room_cleared(next_coord):
			next_room.start(enemy_value, enemy_kills, dir)
	)
	return room

func _on_player_died():
	GameManager.gameover()

func _on_player_reflected():
	_logger.debug("Player reflected in mirror")
	GameManager.reflected()
