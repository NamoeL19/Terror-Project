extends Area3D

@export var rotation_speed: float = 1.0
@export var hud_text: Control

func _physics_process(delta: float) -> void:
	global_rotation.y += rotation_speed * delta
