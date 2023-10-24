class_name Door
extends StaticBody2D

signal entered()

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("RESET")

func open():
	animation_player.play("open")
	
func close():
	animation_player.play("close")


func _on_enter_area_body_entered(body):
	entered.emit()
