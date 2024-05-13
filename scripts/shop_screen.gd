extends Control


signal close_shop

func _on_close_button_pressed():
	AudioPlayer.play_sfx("shatter_sfx")
	close_shop.emit()

func _on_default_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[0] == false:
		GameController.default_0_skin_unlocked = true
	GameController.use_skin(0)
	GameController.save_game()
	await get_tree().create_timer(.5).timeout
	close_shop.emit()
	

func _on_cube_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[1] == false && GameController.coins >= 2:
		GameController.cube_1_skin_unlocked = true
		GameController.coins -= 2
	if GameController.cube_1_skin_unlocked == true:
		GameController.use_skin(1)
	else:
		GameController.use_skin(0)
	GameController.save_game()
	await get_tree().create_timer(.5).timeout
	close_shop.emit()
	

func _on_spin_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[2] == false && GameController.coins >= 10:
		GameController.spin_2_skin_unlocked = true
		GameController.coins -= 10
	if GameController.spin_2_skin_unlocked == true:
		GameController.use_skin(2)
	else:
		GameController.use_skin(0)
	GameController.save_game()
	await get_tree().create_timer(.5).timeout
	close_shop.emit()
