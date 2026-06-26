extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var jumpscare = $"../CanvasLayer/Jumpscare"

var SPEED = 2.0
var gravity = 9.8
var player
var tocou_player := false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if tocou_player:
		return
	
	# GRAVIDADE
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# ATUALIZA DESTINO
	if player:
		nav_agent.target_position = player.global_transform.origin
	
	# MOVIMENTAÇÃO
	var next_location = nav_agent.get_next_path_position()
	var direction = (next_location - global_transform.origin)
	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	move_and_slide()
	
	# VERIFICA COLISÃO COM PLAYER
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):
			tocou_player = true
			jumpscare.ativar()
			break
