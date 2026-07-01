extends TextureRect

@export_enum("Primeiro", "Segundo", "Terceiro", "Quarto") var powerup = 0
@export_enum("Vermelho", "Azul", "Verde", "Amarelo") var cor_linha: int = 0

# ativa ou desativa as linhas aqui
const LINHAS_ATIVAS := true

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data[1] == powerup:
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var icone = data[0]

	var origem = icone.global_position + icone.size / 2

	icone.locked = true
	icone.visible = false

	if LINHAS_ATIVAS:
		var destino = global_position + size / 2
		var minigame = get_tree().root.get_node("MapaTestes/CanvasLayer/minigame_fusivel")
		minigame.desenhar_linha(origem, destino, cor_linha)

	get_tree().root.get_node("MapaTestes/CanvasLayer/minigame_fusivel").icone_travado()
