extends Projectile

@export var bullet_count := 5
@export var normal_bullet: PackedScene
@export var bullet_spawn_offset := 40

func _ready():
	super._ready()

func _remove():
	var spread = PI/2
	for i in bullet_count:
		var start = dir.rotated(-spread/2)
		var d = start.rotated(i * spread/bullet_count)
		_create_bullet(d)
	
	freed.emit()
	queue_free()


func _create_bullet(d):
	var bullet = normal_bullet.instantiate()
	d = d * bullet_spawn_offset
	bullet.global_position = global_position + d
	bullet.dir = d.normalized()
	get_tree().current_scene.add_child(bullet)
	return bullet


func _on_explode_timer_timeout():
	_remove()
