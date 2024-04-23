extends Node2D

@export var music_track : AudioStream = null

@onready var button_array = get_tree().get_nodes_in_group("LevelButtons")
@onready var menu_camera = $UIMenuCamera
@onready var bg = $CanvasLayer/Sprite2D
@onready var shop = $CanvasLayer2/ShopScreen
@onready var terrain = $UITerrain
@onready var black_can = $BlackCanvasLayer
@onready var black_rect = $BlackCanvasLayer/ColorRectBlack
@onready var fade_duration: float = 0.5
@onready var debug_menu = $DebugScreen

var current_button_array_number = 0

signal freeze_camera
signal unfreeze_camera

func _ready():
	black_can.visible = true
	if !GameController.is_reloaded:
		GameController.is_reloaded = true
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/start.tscn")
	set_bg_size_scale()
	set_shop_size_scale()
	shop.visible = false
	shop.close_shop.connect(_on_close_shop)
	if music_track != null && GameController.is_reloaded:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.volume_db = -10.0
		AudioPlayer.m_player.play()
	for number_of_buttons in button_array:
		if number_of_buttons.current_active == true:
			current_button_array_number += 1
		if number_of_buttons.current_active == true and number_of_buttons.current_level == current_button_array_number:
			menu_camera.global_position = number_of_buttons.global_position
	GameController.my_log("Plays left: " + str(GameController.current_play_through_count))
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_rect,"modulate:a", 0.0, fade_duration)
	await get_tree().create_timer(0.2).timeout
	if get_tree().paused == true:
		get_tree().paused = false
	black_can.visible = false

func set_bg_size_scale():
	bg.position = get_viewport_rect().size / 2
	bg.scale = get_viewport_rect().size
	
	
func set_shop_size_scale():
	shop.position = get_viewport_rect().size / 2

func _on_close_shop():
	shop.visible = false
	for button in button_array:
		button.visible = true
	#terrain.visible = true
	unfreeze_camera.emit()
	$CanvasLayer3/ShopButton.visible = true
	
func _on_shop_button_pressed():
	shop.visible = true
	for button in button_array:
		button.visible = false
	#terrain.visible = false
	freeze_camera.emit()
	$CanvasLayer3/ShopButton.visible = false
	
	

