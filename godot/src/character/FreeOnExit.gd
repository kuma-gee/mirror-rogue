class_name FreeOnExit
extends VisibleOnScreenNotifier2D

func _ready():
	screen_exited.connect(func(): queue_free())
