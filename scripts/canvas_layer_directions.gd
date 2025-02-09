extends CanvasLayer

signal start_level

func _on_button_pressed() -> void:
	visible = false
	start_level.emit()
