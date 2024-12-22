extends HurtBox

var open := false

func _ready() -> void:
	hit.connect(_on_hit)

func _on_hit():
	if open: return
	open = true
	
	
