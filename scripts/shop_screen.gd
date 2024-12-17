extends Control


signal close_shop

##Flash duration
@export var flash_duration: float = 0.05
##Wait time for screen flash
@export var wait_time:float = 0.1
#IAP vars
@export var item_value: int
@export var product_id: String
@export var price: String = "Loading..."
@onready var premium_butten_val = $Box/Label/ColorRect/ScrollContainer/VBoxContainer/Premium/Label


func _ready():
	premium_butten_val.text = price
	IapManager.product_details_received.connect(_setPrice)
	if GameController.skins_unlocked[1] == true:
		show_owned($Box/Label/ColorRect/ScrollContainer/VBoxContainer/CubeButton/CoinSprite,$Box/Label/ColorRect/ScrollContainer/VBoxContainer/CubeButton/LabelOwned)
	if GameController.skins_unlocked[2] == true:
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/SpinButton/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/SpinButton/LabelOwned)
	if GameController.skins_unlocked[3] == true:
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Puzzle/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Puzzle/LabelOwned)
	if GameController.skins_unlocked[4] == true:
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Infinty/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Infinty/LabelOwned)
	if GameController.skins_unlocked[5] == true:
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Circle/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Circle/LabelOwned)
	if GameController.skins_unlocked[6] == true:
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Star/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Star/LabelOwned)
	if GameController.skins_unlocked[7] == true:
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Crystel/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Crystel/LabelOwned)
	if GameController.skins_unlocked[8] == true:
		show_owned($Box/Label/ColorRect/ScrollContainer/VBoxContainer/Billiards/CoinSprite,$Box/Label/ColorRect/ScrollContainer/VBoxContainer/Billiards/LabelOwned)

func _setPrice(_product_id: String, _price: String):
	if _product_id == product_id:
		premium_butten_val.text = _price # Update the displayed price

func screen_flash():
	var flash_rect = $Box/RedFlash
	flash_rect.visible = true
	var tween = create_tween()
	tween.tween_property(flash_rect,"modulate:a",0.5,flash_duration)
	tween.tween_interval(wait_time)
	tween.tween_property(flash_rect,"modulate:a",0.0,flash_duration)
	tween.tween_interval(wait_time)
	tween.tween_property(flash_rect,"modulate:a",0.5,flash_duration)
	tween.tween_interval(wait_time)
	tween.tween_property(flash_rect,"modulate:a",0.0,flash_duration)
	await tween.finished
	flash_rect.visible = false

func show_owned(str_1, str_2):
	str_1.visible = false
	str_2.visible = true

func _on_close_button_pressed():
	AudioPlayer.play_sfx("shatter_sfx")
	close_shop.emit()

func _on_premium_pressed():
	IapManager.do_purchase(product_id)
	#GameController.my_log("perchase attempted, response " + str(response.status))
	#if response.status != OK:
		#GameController.my_log("error purchsing item")
	
func _on_default_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[0] == false:
		GameController.skins_unlocked[0] = true
	GameController.use_skin(0)
	GameController.save_game()
	await get_tree().create_timer(.5).timeout
	close_shop.emit()
	

func _on_cube_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[1] == false && GameController.coins >= 100:
		GameController.skins_unlocked[1] = true
		GameController.coins -= 100
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/CubeButton/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/CubeButton/LabelOwned)
	if GameController.skins_unlocked[1] == true:
		GameController.use_skin(1)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()
	
	

func _on_spin_button_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[2] == false && GameController.coins >= 100:
		GameController.skins_unlocked[2] = true
		GameController.coins -= 100
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Billiards/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Billiards/LabelOwned)
	if GameController.skins_unlocked[2] == true:
		GameController.use_skin(2)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()

func _on_puzzle_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[3] == false && GameController.coins >= 100:
		GameController.skins_unlocked[3] = true
		GameController.coins -= 100
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Puzzle/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Puzzle/LabelOwned)
	if GameController.skins_unlocked[3] == true:
		GameController.use_skin(3)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()


func _on_infinty_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[4] == false && GameController.coins >= 100:
		GameController.skins_unlocked[4] = true
		GameController.coins -= 100
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Infinty/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Infinty/LabelOwned)
	if GameController.skins_unlocked[4] == true:
		GameController.use_skin(4)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()


func _on_circle_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[5] == null:
		GameController.skins_unlocked[5] = GameController.skins_unlocked_backup[5]
	if GameController.skins_unlocked[5] == false && GameController.coins >= 500:
		GameController.skins_unlocked[5] = true
		GameController.coins -= 500
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Circle/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Circle/LabelOwned)
	if GameController.skins_unlocked[5] == true:
		GameController.use_skin(5)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()


func _on_star_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[6] == null:
		GameController.skins_unlocked[6] = GameController.skins_unlocked_backup[5]
	if GameController.skins_unlocked[6] == false && GameController.coins >= 500:
		GameController.skins_unlocked[6] = true
		GameController.coins -= 500
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Star/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Star/LabelOwned)
	if GameController.skins_unlocked[6] == true:
		GameController.use_skin(6)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()


func _on_crystel_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[7] == null:
		GameController.skins_unlocked[7] = GameController.skins_unlocked_backup[5]
	if GameController.skins_unlocked[7] == false && GameController.coins >= 500:
		GameController.skins_unlocked[7] = true
		GameController.coins -= 500
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Crystel/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Crystel/LabelOwned)
	if GameController.skins_unlocked[7] == true:
		GameController.use_skin(7)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()


func _on_billiards_pressed():
	AudioPlayer.play_sfx("bounce_sfx_1")
	if GameController.skins_unlocked[8] == null:
		GameController.skins_unlocked[8] = GameController.skins_unlocked_backup[5]
	if GameController.skins_unlocked[8] == false && GameController.coins >= 500:
		GameController.skins_unlocked[8] = true
		GameController.coins -= 500
		show_owned($Box/ColorRect/ScrollContainer/VBoxContainer/Billiards/CoinSprite,$Box/ColorRect/ScrollContainer/VBoxContainer/Billiards/LabelOwned)
	if GameController.skins_unlocked[8] == true:
		GameController.use_skin(8)
		close_shop.emit()
	else:
		screen_flash()
		GameController.use_skin(0)
	await get_tree().create_timer(.5).timeout
	GameController.save_game()
