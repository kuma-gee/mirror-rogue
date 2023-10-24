extends Projectile

@export var bullet_count := 5
@export var normal_bullet: PackedScene
@export var bullet_spawn_offset := 10

@onready var hurtbox = $Hurtbox

func _ready():
	ignored.append(hurtbox)
	super._ready()

func _remove(explode_dir = dir):
	var spread = PI/2
	for i in bullet_count:
		var start = explode_dir.rotated(-spread/2)
		var d = start.rotated(i * spread/bullet_count)
		_create_bullet(d)
	
	freed.emit()
	queue_free()


func _create_bullet(d):
	var bullet = normal_bullet.instantiate()
	d = d * bullet_spawn_offset
	bullet.global_position = global_position + d
	bullet.dir = d.normalized()
	get_tree().current_scene.call_deferred("add_child", bullet)
	return bullet


func _on_explode_timer_timeout():
	_remove()


func _on_hurtbox_hit_with(area: Node2D):
	_remove(area.global_position.direction_to(global_position))
