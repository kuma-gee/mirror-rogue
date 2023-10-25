extends GPUParticles2D

func _ready():
	emitting = true
	get_tree().create_timer(1.0).timeout.connect(func(): queue_free())
