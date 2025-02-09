extends CanvasLayer

##Time until level starts
@export var time_until_start: int = 3
##Fade duration time untill screen is clear
@export var fade_duration: float = 3.0
##bool that definds the first level and sets up first level directions
@export var first_level: bool = false 

#onready vars
@onready var coins_in_level = get_tree().get_nodes_in_group("Coins")
@onready var start_timer = $StartTimer
@onready var coin_lable = $CoinSprite/CoinLabel
@onready var start_count_label = $StartCountLabel
@onready var black_canvas = $BlackCanvas
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var direction_layer = $CanvasLayerDirections

#system vars
var coin_so_far: int = 0

func _ready():
	direction_layer.start_level.connect(_on_start_level)
	direction_layer.visible = false
	if first_level:
		direction_layer.visible = true
	if player:
		player.stop_velocity = true
	if !first_level:
		if black_canvas:
			black_canvas.visible = true
		start_count_label.text = str(time_until_start)
		if time_until_start > 0:
			if get_tree().paused == false:
				get_tree().paused = true
	else:
		start_timer.stop()
		start_count_label.visible = false
	coin_lable.text = " "
	for coin in coins_in_level:
		coin.coin_pickup.connect(_on_coin_pickup)
	
func _process(_delta):
	start_count_label.text = str(time_until_start)
	if coin_so_far == 0:
		coin_lable.text = " "
	else:
		coin_lable.text = "+" + str(coin_so_far)

func _on_coin_pickup():
	coin_so_far += 1


func _on_start_timer_timeout():
	if time_until_start > 0:
		time_until_start -= 1
	if time_until_start == 0:
		start_timer.stop()
		var tween = create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(black_canvas,"modulate:a", 0.0, fade_duration)
		start_count_label.visible = false
		if get_tree().paused == true:
			get_tree().paused = false
		await get_tree().create_timer(1.0).timeout
		if player:
			player.stop_velocity = false

func _on_start_level():
	get_tree().paused = false
	if player:
			player.stop_velocity = false
