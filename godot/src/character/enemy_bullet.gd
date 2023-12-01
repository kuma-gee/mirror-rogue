extends Projectile

@export var speed: ValueProvider

@onready var hurtbox = $Hurtbox
@onready var death_spawner_2d = $DeathSpawner2D

func _ready():
	ignored.append(hurtbox)
	super._ready()

func _physics_process(delta):
	translate(dir * speed.get_value() * delta)
	global_rotation = Vector2.RIGHT.angle_to(dir)


func _on_player_hurtbox_hit(dmg):
	GameManager.bubble_popped()
