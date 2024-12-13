extends Node2D
##Music trak for main level
@export var music_track : AudioStream = null
# on redy vars
@onready var button_array = get_tree().get_nodes_in_group("LevelButtons")
@onready var menu_camera = $UIMenuCamera
@onready var bg = $ParallaxBackground/ParallaxLayer/Sprite2D
@onready var shop = $CanvasLayer2/ShopScreen
@onready var black_can = $BlackCanvasLayer
@onready var black_rect = $BlackCanvasLayer/ColorRectBlack
@onready var fade_duration: float = 0.5
@onready var debug_menu = $DebugScreen
@onready  var coin_count = $CanvasLayer2/CoinSprite/Label
@onready var heart = $CanvasLayer2/HeartSprite
@onready var heart_text = $CanvasLayer2/HeartSprite/Label

# current play throue not used
var current_button_array_number = 0
# signals
signal freeze_camera
signal unfreeze_camera

func _ready():
	black_can.visible = true
	setup_parallax_layer($ParallaxBackground/ParallaxLayer)
	set_shop_size_scale()
	shop.visible = false
	shop.close_shop.connect(_on_close_shop)
	coin_count.text = str(GameController.coins)
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.volume_db = -10.0
		AudioPlayer.m_player.play()
	for number_of_buttons in button_array:
		if number_of_buttons.current_active == true:
			current_button_array_number += 1
		if number_of_buttons.current_active == true and number_of_buttons.current_level == current_button_array_number:
			menu_camera.global_position = number_of_buttons.global_position
	GameController.my_log("Plays left: " + str(GameController.current_play_through_count)+ "\n" + " coins: " + str(GameController.coins))
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_rect,"modulate:a", 0.0, fade_duration)
	await tween.finished
	if get_tree().paused == true:
		get_tree().paused = false
	black_can.visible = false
func _process(_delta):
	coin_count.text = str(GameController.coins)
#	if GameController.premium == true: # not used
#		heart.visible = false
#	else:
#		heart_text.text = str(GameController.current_play_through_count)
		

func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texure = parallax_sprite.get_texture()
	var paralax_texture_height = parallax_texure.get_height()
	var paralax_texture_width = parallax_texure.get_width()
	var viewport_size = get_viewport_rect().size
	var _scale_y = viewport_size.y / paralax_texture_height
	var _scale_x = viewport_size.x / paralax_texture_width
	var result = Vector2(_scale_x,_scale_y)
	return result

func  setup_parallax_layer(parallax_layer: ParallaxLayer):
	if parallax_layer:
		var parallax_sprite = parallax_layer.find_child("Sprite2D")
		parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
		parallax_sprite.scale.x = get_viewport_rect().size.x / 960
		parallax_sprite.scale.y = get_viewport_rect().size.y / 540
		var mx = parallax_sprite.scale.x * parallax_sprite.get_texture().get_width()
		parallax_layer.motion_mirroring.x = mx
	
	
func set_shop_size_scale():
	shop.position = get_viewport_rect().size / 2

func _on_close_shop():
	shop.visible = false
	for button in button_array:
		button.visible = true
	unfreeze_camera.emit()
	$CanvasLayer3/ShopButton.visible = true
	
func _on_shop_button_pressed():
	shop.visible = true
	for button in button_array:
		button.visible = false
	freeze_camera.emit()
	$CanvasLayer3/ShopButton.visible = false
	
	
