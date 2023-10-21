extends CharacterBody2D

signal died()

@export var speed := 50
@export var health := 10

@onready var navigation_agent := $NavigationAgent2D

func _ready():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

func _process(delta):
	navigation_agent.target_position = get_tree().get_first_node_in_group("Player").global_position

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * speed

	velocity = new_velocity
	move_and_slide()


func _on_hitbox_hit(dmg):
	health -= dmg
	if health <= 0:
		died.emit()
		queue_free()
