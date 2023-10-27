extends Control

@export var kills_label: Label
@export var mirror_kills_label: Label
@export var bubbles_label: Label
@export var mirror_time_label: Label
@export var playtime_label: Label

func _ready():
	kills_label.text = str(GameManager.kills)
	mirror_kills_label.text = str(GameManager.mirror_kills)
	bubbles_label.text = str(GameManager.bubbles)
	mirror_time_label.text = _format_sec(GameManager.mirror_time)
	playtime_label.text = _format_sec(GameManager.playtime)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("start"):
		GameManager.reset()
		SceneManager.change_scene("res://src/game.tscn")

func _format_sec(sec: float):
	var total_sec = int(round(sec))
	var min = total_sec / 60
	var actual_sec = total_sec % 60
	return "%s:%s" % [_prefix_zero(min), _prefix_zero(actual_sec)]

func _prefix_zero(num: int):
	if num > 9:
		return str(num)
	return "0" + str(num)
