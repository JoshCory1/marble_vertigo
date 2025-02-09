extends Control
signal close_popup
signal open_shop

func _on_close_button_pressed() -> void:
	AudioPlayer.play_sfx("shatter_sfx")
	close_popup.emit()


func _on_no_button_pressed() -> void:
	AudioPlayer.play_sfx("shatter_sfx")
	close_popup.emit()


func _on_yes_button_pressed() -> void:
	open_shop.emit()
