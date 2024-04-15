extends Node2D

@export var music_track: AudioStream = null
@export var music_volume: float = -10
@export var fade_duration: float = 0.5

@onready var parallax1 = $ParallaxBackground/ParallaxLayer1
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var black_canvas = $BlackCanvasLayer
@onready var black_screen = $BlackCanvasLayer/ColorRect
@onready var bg = $CanvasLayer/Sprite2D
@onready var player = $Player

var viewport_size: Vector2


func _ready():
	use_selected_skin()
	set_bg_size_scale()
	black_canvas.visible = true
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.volume_db = music_volume
		AudioPlayer.m_player.play()
	viewport_size = get_viewport_rect().size
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_screen,"modulate:a", 0.0, fade_duration)
	await get_tree().create_timer(0.2).timeout
	if get_tree().paused == true:
		get_tree().paused = false

func _process(_delta):
	use_selected_skin()

func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texure = parallax_sprite.get_texture()
	var paralax_texture_height = parallax_texure.get_height()
	var paralax_texture_width = parallax_texure.get_width()
	
	var _scale_y = viewport_size.y / paralax_texture_height
	var _scale_x = viewport_size.x / paralax_texture_width
	var result = Vector2(_scale_x,_scale_y)
	return result

func  setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
	parallax_sprite.scale.x += get_viewport_rect().size.x / 800
	var mx = parallax_sprite.scale.x * parallax_sprite.get_texture().get_width()
	parallax_layer.motion_mirroring.x = mx
func set_bg_size_scale():
	pass
	bg.position = get_viewport_rect().size / 2
	bg.scale = get_viewport_rect().size
	
func use_selected_skin():
	if GameController.skins[0] == true && GameController.default_skin_unlocked == true:
		player.use_default_skin()
	elif GameController.skins[1] == true && GameController.cube_skin_unlocked == true:
		player.use_cube_skin()
	elif GameController.skins[2] && GameController.spin_skin_unlocked == true:
		player.use_spin_skin()
	else:
		player.use_default_skin()
	
