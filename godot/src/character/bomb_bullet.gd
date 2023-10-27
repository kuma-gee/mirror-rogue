extends Projectile

@export var bubble_effect: PackedScene
@export var bullet_count := 5
@export var normal_bullet: PackedScene
@export var bullet_spawn_offset := 10

@onready var hurtbox = $Hurtbox
@onready var animation_player = $AnimationPlayer

var removing = false

func _ready():
	ignored.append(hurtbox)
	animation_player.play("idle")
	super._ready()

func _remove(explode_dir = dir):
	if removing: return
	
	removing = true
	var spread = PI
	for i in bullet_count:
		var start = explode_dir.rotated(-spread/2)
		var d = start.rotated(i * spread/bullet_count)
		_create_bullet(d)
	
	
	var eff = bubble_effect.instantiate()
	eff.global_position = global_position
	get_tree().current_scene.add_child(eff)
	
	_stop()
	animation_player.play("pop")
	await animation_player.animation_finished
	
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


func _on_hurtbox_by_player():
	GameManager.bubble_popped()
