extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

#CABEÇA MEXENDO
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#FOV
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var gravity = 9.8

#FADE-IN E FADE-OUT DOS AUDIOS
const FADE_SPEED := 5.0
const VOLUME_MAX := 0.0
const VOLUME_MIN := -60.0

# BLOQUEIO DO PLAYER
var bloqueado := false

@onready var audio_walk = $Audios/walk
@onready var audio_sprint = $Audios/sprint
@onready var head = $"cabeça"
@onready var camera = $"cabeça/Camera3D"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	audio_walk.volume_db = VOLUME_MIN
	audio_sprint.volume_db = VOLUME_MIN
	audio_walk.play()
	audio_sprint.play()

func _unhandled_input(event):
	if bloqueado:
		return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	# GRAVIDADE
	if not is_on_floor():
		velocity.y -= gravity * delta

	# PULO
	if Input.is_action_just_pressed("jump") and is_on_floor() and not bloqueado:
		velocity.y = JUMP_VELOCITY

	# VELOCIDADE
	if not bloqueado:
		if Input.is_action_pressed("sprint"):
			speed = SPRINT_SPEED
		else:
			speed = WALK_SPEED

	# DIREÇÃO
	var input_dir := Vector2.ZERO
	if not bloqueado:
		input_dir = Input.get_vector("MovLeft", "MovRight", "MovUp", "MovDown")

	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.5)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.5)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)

	# HEAD BOB
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	# AUDIO DE PASSOS COM FADE
	var moving = direction.length() > 0 and is_on_floor() and not bloqueado
	var sprinting = Input.is_action_pressed("sprint")

	if moving and sprinting:
		audio_sprint.volume_db = lerp(audio_sprint.volume_db, VOLUME_MAX, delta * FADE_SPEED)
		audio_walk.volume_db = lerp(audio_walk.volume_db, VOLUME_MIN, delta * FADE_SPEED)
	elif moving and not sprinting:
		audio_walk.volume_db = lerp(audio_walk.volume_db, VOLUME_MAX, delta * FADE_SPEED)
		audio_sprint.volume_db = lerp(audio_sprint.volume_db, VOLUME_MIN, delta * FADE_SPEED)
	else:
		audio_walk.volume_db = lerp(audio_walk.volume_db, VOLUME_MIN, delta * FADE_SPEED)
		audio_sprint.volume_db = lerp(audio_sprint.volume_db, VOLUME_MIN, delta * FADE_SPEED)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
