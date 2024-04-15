extends Control


signal close_shop

func _on_close_button_pressed():
	close_shop.emit()

func _on_default_button_pressed():
	if GameController.default_skin_unlocked == false:
		GameController.default_skin_unlocked = true
	GameController.use_skin(0)
	

func _on_cube_button_pressed():
	if GameController.cube_skin_unlocked == false:
		GameController.cube_skin_unlocked = true
	GameController.use_skin(1)
	

func _on_spin_button_pressed():
	if GameController.spin_skin_unlocked == false:
		GameController.spin_skin_unlocked = true
	GameController.use_skin(2)
