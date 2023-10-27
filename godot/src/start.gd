extends Control

@onready var start_sound = $StartSound
@onready var bgm = $BGM

var tw := TweenCreator.new(self)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("start"):
		if tw.new_tween():
			tw.prop(bgm, "volume_db", -15, -50, 1.0)
		start_sound.play()
		await get_tree().create_timer(0.5).timeout
		SceneManager.change_scene("res://src/game.tscn")
