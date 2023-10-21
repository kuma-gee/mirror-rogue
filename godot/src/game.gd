extends Node2D

const SHARD_EMITTER = preload("res://src/props/shard_emitter.tscn")

@onready var main = $Main
@onready var death_screen = $DeathScreen

func _ready():
	death_screen.hide()

func _on_player_died():
	main.process_mode = Node.PROCESS_MODE_DISABLED
	
	var window_scale = get_viewport_rect().size / Vector2(get_window().size)
	var tex_scale = max(window_scale.x, window_scale.y)
	
	var img = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(img)
	death_screen.texture = tex
	death_screen.scale = Vector2(tex_scale, tex_scale)
	death_screen.show()
	main.hide()
	
	var shard = SHARD_EMITTER.instantiate()
	death_screen.add_child(shard)
	get_tree().create_timer(1.0).timeout.connect(func(): shard.shatter())
