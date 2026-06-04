extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 2.0
var gravity = 9.8
var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Atualiza destino
	if player:
		nav_agent.target_position = player.global_transform.origin

	# Movimentação
	var next_location = nav_agent.get_next_path_position()
	var direction = (next_location - global_transform.origin)
	direction.y = 0
	direction = direction.normalized()

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
