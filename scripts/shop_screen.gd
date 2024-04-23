extends Control


signal close_shop

func _on_close_button_pressed():
	AudioPlayer.play_sfx("shatter_sfx")
	close_shop.emit()

func _on_default_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.default_0_skin_unlocked == false:
		GameController.default_0_skin_unlocked = true
	GameController.use_skin(0)
	close_shop.emit()
	

func _on_cube_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.cube_1_skin_unlocked == false:
		GameController.cube_1_skin_unlocked = true
	GameController.use_skin(1)
	close_shop.emit()
	

func _on_spin_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.spin_2_skin_unlocked == false:
		GameController.spin_2_skin_unlocked = true
	GameController.use_skin(2)
	close_shop.emit()
