extends Line2D

@export_enum("Vermelho", "Azul", "Verde", "Amarelo") var cor_linha: int = 0

const CORES := [
	Color(1.0, 0.2, 0.2, 1.0),
	Color(0.2, 0.8, 1.0, 1.0), 
	Color(0.2, 1.0, 0.3, 1.0),  
	Color(1.0, 0.85, 0.0, 1.0), 
]

func _ready() -> void:
	default_color = CORES[cor_linha]
	width = 4.0

func desenhar(origem: Vector2, destino: Vector2) -> void:
	clear_points()
	add_point(origem)
	add_point(destino)

func limpar() -> void:
	clear_points()
