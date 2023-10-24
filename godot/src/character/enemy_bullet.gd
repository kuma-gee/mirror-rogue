extends Projectile

@onready var hurtbox = $Hurtbox

func _ready():
	ignored.append(hurtbox)
	super._ready()

func _on_hurtbox_hit(dmg):
	_remove()
