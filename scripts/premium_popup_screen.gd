extends Control
signal close_popup
signal perchase_button
signal nsf

@export var product_id: String

#onready vars
@onready var main_menu = $"../.."
@onready var gold_label = $Box/Label/ColorRect/GoldLabel
@onready var premium_price_label = $Box/Label/ColorRect/PremiumBuySprite/PremiumPriceLabel

#system vars
var button_gold: int = 0
var button_name: String

func _ready():
	IapManager.product_details_received.connect(_setPrice)
	main_menu.popup_gold_pass.connect(_on_popup_gold_pass)
	

func _on_popup_gold_pass(gold: int, string: String):
	button_gold = gold
	button_name = string
	gold_label.text = str(button_gold)

func _on_close_button_pressed() -> void:
	AudioPlayer.play_sfx("shatter_sfx")
	close_popup.emit()


func _on_no_button_pressed() -> void:
	AudioPlayer.play_sfx("shatter_sfx")
	close_popup.emit()


func _on_yes_button_pressed() -> void:
	if GameController.coins >= button_gold:
		GameController.coins -= button_gold
		perchase_button.emit(button_name)
		close_popup.emit()
		GameController.save_game()
	else:
		nsf.emit()
	#open_shop.emit()

func _setPrice(_product_id: String, _price: String):
	if _product_id == product_id:
		premium_price_label.text = _price # Update the displayed price


func _on_premium_buy_button_pressed() -> void:
	IapManager.do_purchase(product_id)
