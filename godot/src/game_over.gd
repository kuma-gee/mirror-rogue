extends Control

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("start"):
		SceneManager.change_scene("res://src/game.tscn")
