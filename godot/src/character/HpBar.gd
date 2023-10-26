class_name HpBar
extends ProgressBar

signal zero_health()

@export var max_health := 50
@onready var health := max_health

var tw := TweenCreator.new(self)

func _ready():
	tw.block = false
	modulate = Color.TRANSPARENT

func _is_full_hp():
	return health == max_health

func heal(amount: int):
	health = clamp(health + amount, 0, max_health)
	_update_hp_bar()

func hurt(dmg: int):
	health -= dmg
	_update_hp_bar()
	if health <= 0:
		zero_health.emit()

func _update_hp_bar():
	max_value = max_health
	value = health
	if _is_full_hp():
		get_tree().create_timer(1.0).timeout.connect(func():
			if _is_full_hp() and tw.new_tween():
				tw.fade_out(self)
		)
	elif modulate != Color.WHITE and tw.new_tween():
		tw.fade_in(self)
