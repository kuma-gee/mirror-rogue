extends Projectile

@export var speed: ValueProvider

@onready var hurtbox = $Hurtbox

func _ready():
	ignored.append(hurtbox)
	super._ready()

func _physics_process(delta):
	translate(dir * speed.get_value() * delta)
	global_rotation = Vector2.RIGHT.angle_to(dir)

func _on_hurtbox_knockback(dir):
	death_spawner.global_rotation = Vector2.RIGHT.angle_to(dir)
