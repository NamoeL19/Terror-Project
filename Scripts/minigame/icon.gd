extends TextureRect

@export_enum("Primeiro", "Segundo", "Terceiro", "Quarto") var powerup = 0
var locked := false

func _get_drag_data(at_position: Vector2) -> Variant:
	if locked:
		return null
	visible = false
	var preview = TextureRect.new()
	preview.texture = texture
	set_drag_preview(preview)
	return [self, powerup]

#func _notification(notification_type) -> void:
	#match notification_type:
		#NOTIFICATION_DRAG_END:
			#visible = true
