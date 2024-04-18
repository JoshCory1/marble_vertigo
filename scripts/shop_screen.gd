extends Control


signal close_shop

func _on_close_button_pressed():
	close_shop.emit()

func _on_default_button_pressed():
	if GameController.default_0_skin_unlocked == false:
		GameController.default_0_skin_unlocked = true
	GameController.use_skin(0)
	

func _on_cube_button_pressed():
	if GameController.cube_1_skin_unlocked == false:
		GameController.cube_1_skin_unlocked = true
	GameController.use_skin(1)
	

func _on_spin_button_pressed():
	if GameController.spin_2_skin_unlocked == false:
		GameController.spin_2_skin_unlocked = true
	GameController.use_skin(2)
