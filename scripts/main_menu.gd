extends Node2D

# signals
signal freeze_camera
signal unfreeze_camera
signal popup_gold_pass
signal next_level

##Music trak for main level
@export var music_track : AudioStream = null

##Background scroll speed
@export var scroll_speed_paralax_bg: Vector2
##duration of fade in and out effect
@export var fade_duration: float = 0.5

#onready vars
@onready var button_array = get_tree().get_nodes_in_group("LevelButtons")
@onready var menu_camera = $UIMenuCamera
@onready var bg = $ParallaxBackground/ParallaxLayer/Sprite2D
@onready var shop = $CanvasLayer2/ShopScreen
@onready var black_can = $BlackCanvasLayer
@onready var black_rect = $BlackCanvasLayer/ColorRectBlack
@onready var wheel = $BlackCanvasLayer/PortalWheelOf
@onready var debug_menu = $DebugScreen
@onready  var coin_count = $CanvasLayer2/CoinSprite/Label
@onready var heart = $CanvasLayer2/HeartSprite
@onready var heart_text = $CanvasLayer2/HeartSprite/Label
@onready var premium_popup_screen = $CanvasLayer2/PremiumPopupScreen
@onready var close_shop_button = $CanvasLayer3/ShopButton
@onready var settings_button = $CanvasLayer3/SettingsButton
@onready var settings = $CanvasLayer2/Settings
@onready var interstitial = $AdInterstitial

#current play throue not used
var current_button_array_number = 0
var name_of_next_level

func _ready():
	black_can.visible = true
	wheel.animation_start()
	setup_parallax_layer($ParallaxBackground/ParallaxLayer)
	set_shop_size_scale()
	settings.visible = false
	shop.visible = false
	premium_popup_screen.visible = false
	for button in button_array:
		button.show_popup.connect(_on_show_popup)
		button.show_ad.connect(_on_show_ad)
	interstitial.load_next_level.connect(_on_end_of_ad)
	shop.close_shop.connect(_on_close_shop)
	settings.close_settings.connect(_on_close_settings)
	premium_popup_screen.close_popup.connect(_on_close_popup)
	coin_count.text = str(GameController.coins)
	for number_of_buttons in button_array:
		if number_of_buttons.current_active == true:
			current_button_array_number += 1
		if number_of_buttons.current_active == true and number_of_buttons.current_level == current_button_array_number:
			menu_camera.global_position = number_of_buttons.global_position
	GameController.my_log("Plays left: " + str(GameController.current_play_through_count)+ "\n" + " coins: " + str(GameController.coins))
	await get_tree().create_timer(2.0).timeout
	wheel.visible = false
	wheel.animation_stop()
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.play()
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_rect,"modulate:a", 0.0, fade_duration)
	await tween.finished
	if get_tree().paused == true:
		get_tree().paused = false
	black_can.visible = false

func _process(delta):
	coin_count.text = str(GameController.coins)
	bg.region_rect.position += delta * Vector2(scroll_speed_paralax_bg)
	if bg.region_rect.position >= Vector2(960, 540):
		bg.region_rect.position = Vector2.ZERO

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
	close_shop_button.visible = true
	settings_button.visible = true
	
func _on_shop_button_pressed():
	shop.visible = true
	for button in button_array:
		button.visible = false
	freeze_camera.emit()
	close_shop_button.visible = false
	premium_popup_screen.visible = false
	settings_button.visible = false

func _on_show_popup(gold: int, string: String):
	premium_popup_screen.visible = true
	for button in button_array:
		button.visible = false
	freeze_camera.emit()
	close_shop_button.visible = false
	settings_button.visible = false
	popup_gold_pass.emit(gold, string)

func  _on_close_popup():
	premium_popup_screen.visible = false
	for button in button_array:
		button.visible = true
	unfreeze_camera.emit()
	close_shop_button.visible = true
	settings_button.visible = true
#work on this
func _on_button_pressed() -> void:
	settings.visible = true
	for button in button_array:
		button.visible = false
	freeze_camera.emit()
	close_shop_button.visible = false
	settings_button.visible = false

func _on_close_settings():
	settings.visible = false
	for button in button_array:
		button.visible = true
	unfreeze_camera.emit()
	close_shop_button.visible = true
	settings_button.visible = true

func _on_show_ad(string: String):
	AudioPlayer.m_player.stop()
	name_of_next_level = string
	black_can.visible = true
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_rect,"modulate:a", 1.0, fade_duration)
	await tween.finished
	wheel.visible = true
	wheel.animation_start()
	await get_tree().create_timer(8.0).timeout
	_on_end_of_ad()

func _on_end_of_ad():
	black_can.visible = false
	wheel.animation_stop()
	next_level.emit(name_of_next_level)
