extends GPUParticles2D

@export var lifetime_normal := 4.0
@export var lifetime_mirror := 8.0

@onready var start_fade = $StartFade

var tw := TweenCreator.new(self)

func _ready():
	amount = 14 if GameManager.mirror else 5
	emitting = true
	tw.default_duration = 5.0
	start_fade.start(lifetime_mirror if GameManager.mirror else lifetime_normal)

func _on_start_fade_timeout():
	if tw.new_tween(func(): queue_free()):
		tw.fade_out(self).set_ease(Tween.EASE_IN_OUT)
