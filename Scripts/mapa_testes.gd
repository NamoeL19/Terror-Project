extends Node3D

@onready var player = $player
@onready var minigame = $CanvasLayer/minigame_fusivel

func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "update_target_location", player.global_transform.origin)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if minigame.fusiveis_resolvidos >= 4:
			get_tree().change_scene_to_file("res://Scenes/final_mega_provisorio.tscn")
		else:
			print("não finalizou o jogo ainda amigão, termina isso de uma vez.")
