extends Projectile

@export var bubble_effect: PackedScene

@onready var hurtbox = $Hurtbox
@onready var animation_player = $AnimationPlayer

var removing = false

func _ready():
	ignored.append(hurtbox)
	animation_player.play("idle")
	super._ready()

func _on_hurtbox_hit(dmg):
	_remove()

func _remove():
	if not removing:
		removing = true
		var eff = bubble_effect.instantiate()
		eff.global_position = global_position
		get_tree().current_scene.add_child(eff)
		_stop()
		
		animation_player.play("pop")
		await animation_player.animation_finished
		super._remove()
