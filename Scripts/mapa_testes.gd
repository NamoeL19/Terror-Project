extends Node3D

@onready var player = $player
@onready var minigame = $CanvasLayer/minigame_fusivel
@onready var pause_menu = $Control/PauseMenu
@onready var fade = $CanvasLayer/Jumpscare/ColorRect

func _ready() -> void:
	pause_menu.visible = false
	
	#FADEIN
	$CanvasLayer/Jumpscare.visible = true
	fade.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, 1.0) # 1.5 = duração em segundos
	await tween.finished
	$CanvasLayer/Jumpscare.visible = false
	
	
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "update_target_location", player.global_transform.origin)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_paused()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if minigame.fusiveis_resolvidos >= 4:
			get_tree().change_scene_to_file("res://Scenes/final_mega_provisorio.tscn")
		else:
			print("não finalizou o jogo ainda amigão, termina isso de uma vez.")

func toggle_paused():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
