extends Node3D

@onready var player = $player

func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "update_target_location", player.global_transform.origin)

func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
