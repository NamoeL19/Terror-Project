extends Control

#PLAY
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mapa_testes.tscn")


func _on_creditos_pressed() -> void:
	pass # Replace with function body.


func _on_sair_pressed() -> void:
	get_tree().quit()
