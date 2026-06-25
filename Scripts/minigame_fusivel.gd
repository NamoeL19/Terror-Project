extends Control

var icones_travados := 0
var fusivel_atual = null
var fusiveis_resolvidos := 0

@onready var status_label = $"../Label"
@onready var linhas := [
	$Linhas/LinhaFusiveis,   # Vermelho
	$Linhas/LinhaFusiveis2,  # Azul
	$Linhas/LinhaFusiveis3,  # Verde
	$Linhas/LinhaFusiveis4,  # Amarelo
]

var icones := []
var posicoes_iniciais := []

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	status_label.visible = true
	status_label.text = "Fusíveis: 0/4"
	
	for icone in get_tree().get_nodes_in_group("icone"):
		icones.append(icone)
		posicoes_iniciais.append(icone.position)

func abrir_minigame() -> void:
	resetar_minigame()
	visible = true

func icone_travado() -> void:
	icones_travados += 1
	if icones_travados >= 4:
		fechar_minigame(true) # concluiu

func fechar_minigame(concluido: bool) -> void:
	if concluido and fusivel_atual != null:
		fusivel_atual.resolvido = true
		fusiveis_resolvidos += 1
		print("Fusível ", fusivel_atual.fusivel_id + 1, " finalizado!")
		status_label.text = "Fusíveis: " + str(fusiveis_resolvidos) + "/4"
	
	for l in linhas:
		l.limpar()
	
	visible = false
	icones_travados = 0
	fusivel_atual = null
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	status_label.visible = true

func resetar_minigame() -> void:
	# limpa linhas ao resetar também
	for l in linhas:
		l.limpar()
	
	for icone in icones:
		if icone.get_parent() != self:
			icone.get_parent().remove_child(icone)
			add_child(icone)
		icone.locked = false
	
	var posicoes_embaralhadas = posicoes_iniciais.duplicate()
	posicoes_embaralhadas.shuffle()
	
	for i in range(icones.size()):
		icones[i].position = posicoes_embaralhadas[i]

func desenhar_linha(origem: Vector2, destino: Vector2, indice: int) -> void:
	linhas[indice].desenhar(origem, destino)

func _on_button_pressed() -> void:
	fechar_minigame(false) # saiu sem concluir
	
