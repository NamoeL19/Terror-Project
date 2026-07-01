extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var jumpscare = $"../CanvasLayer/Jumpscare"
@onready var raycast = $RayCast3D
@onready var normal_music = $"../songs_audios/normal_music"
@onready var chase_music = $"../songs_audios/chase_music"

const SPEED_NORMAL = 2.5
const SPEED_PERSEGUICAO = 5.0
const ANGULO_VISAO = 90.0
const DISTANCIA_VISAO = 15.0

var SPEED = SPEED_NORMAL
var gravity = 9.8
var player
var tocou_player := false
var em_perseguicao := false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if tocou_player:
		return

	# GRAVIDADE
	if not is_on_floor():
		velocity.y -= gravity * delta

	# VERIFICA CAMPO DE VISÃO
	if player:
		
		# ROTACIONA O INIMIGO PARA O PLAYER
		var direcao_look = player.global_transform.origin - global_transform.origin
		direcao_look.y = 0
		if direcao_look.length() > 0.1:
			var target = global_transform.origin + direcao_look
			look_at(target, Vector3.UP)
			
		verificar_visao()
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

func verificar_visao() -> void:
	var direcao_player = (player.global_transform.origin - global_transform.origin)
	var distancia = direcao_player.length()

	# verifica distância
	if distancia > DISTANCIA_VISAO:
		sair_perseguicao()
		return

	# verifica ângulo de visão
	direcao_player = direcao_player.normalized()
	var direcao_frente = -global_transform.basis.z
	var angulo = rad_to_deg(direcao_frente.angle_to(direcao_player))

	if angulo > ANGULO_VISAO:
		sair_perseguicao()
		return

	# verifica linha de visão com raycast
	raycast.target_position = to_local(player.global_transform.origin)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var colidiu = raycast.get_collider()
		if colidiu.is_in_group("player"):
			entrar_perseguicao()
		else:
			sair_perseguicao()
	else:
		sair_perseguicao()

func entrar_perseguicao() -> void:
	if em_perseguicao:
		return
	em_perseguicao = true
	SPEED = SPEED_PERSEGUICAO
	normal_music.stop()
	chase_music.play()
	print("TO TE VENDO")

func sair_perseguicao() -> void:
	if not em_perseguicao:
		return
	em_perseguicao = false
	SPEED = SPEED_NORMAL
	chase_music.stop()
	normal_music.play()
	print("SUMIU")
