extends GPUParticles2D

var tw := TweenCreator.new(self)

func _ready():
	emitting = true
	tw.default_duration = 5.0

func _on_start_fade_timeout():
	if tw.new_tween(func(): queue_free()):
		tw.fade_out(self).set_ease(Tween.EASE_IN_OUT)
