extends Control

@onready var start_sound = $StartSound

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("start"):
		start_sound.play()
		await get_tree().create_timer(0.5).timeout
		SceneManager.change_scene("res://src/game.tscn")
