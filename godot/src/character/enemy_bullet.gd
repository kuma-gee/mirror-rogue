extends Projectile

@export var speed: ValueProvider
@onready var hurtbox = $Hurtbox
@onready var health = $Health

func _ready():
	ignored.append(hurtbox)
	super._ready()
	
	health.zero_health.connect(func(): queue_free())

func _physics_process(delta):
	translate(dir * speed.get_value() * delta)
	global_rotation = Vector2.RIGHT.angle_to(dir)
