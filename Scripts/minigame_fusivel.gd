extends Control

var icones_travados := 0
var fusivel_atual = null
var fusiveis_resolvidos := 0

@onready var status_label = $"../Label"

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	status_label.text = "Fusíveis: 0/4"

func icone_travado() -> void:
	icones_travados += 1
	if icones_travados >= 4:
		fechar_minigame()

func fechar_minigame() -> void:
	if fusivel_atual != null:
		fusivel_atual.resolvido = true
		fusiveis_resolvidos += 1
		print("Fusível ", fusivel_atual.fusivel_id + 1, " finalizado!")
		status_label.text = "Fusíveis: " + str(fusiveis_resolvidos) + "/4"

	visible = false
	icones_travados = 0
	fusivel_atual = null
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	status_label.visible = true
