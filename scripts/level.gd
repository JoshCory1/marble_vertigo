extends Node2D

@export var music_track: AudioStream = null
@export var music_volume: float = -10
@export var fade_duration: float = 0.5

@onready var parallax1 = $Environment/ParallaxBG/ParallaxLayer1
@onready var parallax2 = $Environment/ParallaxBG/ParallaxLayer2
@onready var black_canvas = $Environment/BlackCanvasLayer
@onready var black_screen = $Environment/BlackCanvasLayer/ColorRect
@onready var bg = $Environment/CanvasLayer/Sprite2D
@onready var player = $Player
@onready var debug_menu = $Environment/DebugScreen
@onready var coins_in_level = get_tree().get_nodes_in_group("Coins") 

var coins_this_level: int = 0
var viewport_size: Vector2


func _ready():
	set_bg_size_scale()
	if black_canvas:
		black_canvas.visible = true
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.volume_db = music_volume
		AudioPlayer.m_player.play()
	viewport_size = get_viewport_rect().size
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	for coin in coins_in_level:
		coin.coin_pickup.connect(_on_coin_pickup)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_screen,"modulate:a", 0.0, fade_duration)
	await get_tree().create_timer(0.2).timeout
	if get_tree().paused == true:
		get_tree().paused = false



func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texure = parallax_sprite.get_texture()
	var paralax_texture_height = parallax_texure.get_height()
	var paralax_texture_width = parallax_texure.get_width()
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

func set_bg_size_scale():
	if bg:
		bg.visible = true
		bg.position = get_viewport_rect().size / 2
		bg.scale = get_viewport_rect().size
		

func _on_coin_pickup():
	coins_this_level +=1
	

	
