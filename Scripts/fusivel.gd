extends Node3D

@export var fusivel_id: int = 0 # define qual fusível é (0,1,2,3)

var player_nearby := false
var resolvido := false

@onready var minigame = $"../../CanvasLayer/minigame_fusivel"
@onready var text = $"../../CanvasLayer/Label"
@onready var player = $"../../player"

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false

func _process(delta: float) -> void:
	if player_nearby and not resolvido and Input.is_action_just_pressed("interact"):
		abrir_minigame()

func abrir_minigame() -> void:
	minigame.fusivel_atual = self
	minigame.abrir_minigame()  # agora chama a função que já reseta e abre
	player.bloqueado = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
