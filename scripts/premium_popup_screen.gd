extends Control
signal close_popup
signal open_shop
signal perchase_button

#onready vars
@onready var main_menu = $"../.."

#system vars
var button_gold: int = 0

func _ready():
	main_menu.popup_gold_pass.connect(_on_popup_gold_pass)
	

func _on_popup_gold_pass(gold):
	button_gold = gold

func _on_close_button_pressed() -> void:
	AudioPlayer.play_sfx("shatter_sfx")
	close_popup.emit()


func _on_no_button_pressed() -> void:
	AudioPlayer.play_sfx("shatter_sfx")
	close_popup.emit()


func _on_yes_button_pressed() -> void:
	if GameController.coins >= button_gold:
		GameController.coins -= button_gold
		perchase_button.emit()
		close_popup.emit()
		GameController.save_game()
	#open_shop.emit()
