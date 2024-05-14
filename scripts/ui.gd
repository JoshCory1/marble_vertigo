extends CanvasLayer


@onready var coins_in_level = get_tree().get_nodes_in_group("Coins")
@onready var coin_lable = $CoinSprite/CoinLabel
var coin_so_far: int = 0

func _ready():
	coin_lable.text = " "
	for coin in coins_in_level:
		coin.coin_pickup.connect(_on_coin_pickup)
		
		
func _process(_delta):
	if coin_so_far == 0:
		coin_lable.text = " "
	else:
		coin_lable.text = "+" + str(coin_so_far)

func _on_coin_pickup():
	coin_so_far += 1
