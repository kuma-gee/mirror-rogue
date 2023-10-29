class_name HpBar
extends ProgressBar

@export var health: Health

var tw := TweenCreator.new(self)

func _ready():
	tw.block = false
	modulate = Color.TRANSPARENT
	
	if health:
		health.health_changed.connect(func(_h): _update_hp_bar())

func _update_hp_bar():
	value = health.health
	max_value = health.max_health
	
	if health.is_full_health():
		get_tree().create_timer(1.0).timeout.connect(func():
			if health.is_full_health() and tw.new_tween():
				tw.fade_out(self)
		)
	elif modulate != Color.WHITE and tw.new_tween():
		tw.fade_in(self)
