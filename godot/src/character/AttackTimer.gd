extends Timer

@export var normal_time := 4.0
@export var mirror_time := 2.0

func _ready():
	one_shot = true
	autostart = false
	
	_start_timer()
	timeout.connect(func(): _start_timer())
	
func _start_timer():
	start(mirror_time if GameManager.mirror else normal_time)
