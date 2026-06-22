extends TextureRect

@export_enum("Primeiro", "Segundo", "Terceiro", "Quarto") var powerup = 0

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data[1] == powerup:
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	data[0].get_parent().remove_child(data[0])
	add_child(data[0])
	data[0].global_position = global_position
	data[0].locked = true
	get_tree().root.get_node("MapaTestes/CanvasLayer/minigame_fusivel").icone_travado()
