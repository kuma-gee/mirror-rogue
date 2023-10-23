extends Node2D

signal mirrored(mirror)

const SHARD_EMITTER = preload("res://src/props/shard_emitter.tscn")
const GAMEOVER = preload("res://src/game_over.tscn")

@onready var canvas_modulate = $CanvasModulate

var mirror := false
var mirror_tw = TweenCreator.new(self)

func _ready():
	canvas_modulate.color = Color.WHITE
	
func _play_shatter(restore = false):
	get_tree().paused = true
	
	var window_scale = get_viewport_rect().size / Vector2(get_window().size)
	var tex_scale = max(window_scale.x, window_scale.y)
	
	var img = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	var death_screen = Sprite2D.new()
	death_screen.texture = tex
	death_screen.z_index = 10
	death_screen.scale = Vector2(tex_scale, tex_scale)
	death_screen.show()
	
	var shard = SHARD_EMITTER.instantiate()
	add_child(death_screen)
	death_screen.add_child(shard)
	get_tree().create_timer(1.0).timeout.connect(func():
		shard.shatter()
		if restore:
			get_tree().create_timer(0.5).timeout.connect(func(): get_tree().paused = false)
		get_tree().create_timer(1.0).timeout.connect(func(): remove_child(death_screen))
	)

func gameover():
	_play_shatter()
	get_tree().change_scene_to_packed(GAMEOVER)

func reflected():
	if mirror_tw.new_tween():
		_play_shatter(true)
		
		mirror = not mirror
		var new_color = Color("ff9c9c") if mirror else Color.WHITE
		mirror_tw.prop(canvas_modulate, "color", canvas_modulate.color, new_color, 1.0).set_delay(0.5)
		mirrored.emit(mirror)
