extends Control

@onready var audio_grito = $grito
@onready var fade = $ColorRect
@onready var imagem = $TextureRect

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	fade.modulate.a = 0.0
	imagem.visible = false  # esconde a imagem no início

func ativar() -> void:
	visible = true
	imagem.visible = true  # mostra a imagem só no jumpscare
	audio_grito.play()
	await audio_grito.finished
	
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1.5)
	await tween.finished
	
	get_tree().reload_current_scene()
