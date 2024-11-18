extends Node2D

@export var fade_duration: float = 0.5
@export var scroll_speed_paralax_2 = Vector2(0,0)
@export var scroll_speed_paralax_3 = Vector2(0,0)

#onready vars
@onready var sprite_paralax_2 = $ParallaxBG/ParallaxLayer2/Sprite2D
@onready var sprite_paralax_3 = $ParallaxBG/ParallaxLayer2/Sprite2D
@export var parallax1: ParallaxLayer
@export var parallax2: ParallaxLayer
@export var parallax3: ParallaxLayer
@onready var black_canvas = $BlackCanvasLayer
@onready var black_screen = $BlackCanvasLayer/ColorRect
@onready var bg = $CanvasLayer/Sprite2D
@onready var debug_menu = $DebugScreen
var viewport_size: Vector2


func _ready():
	set_bg_size_scale()
	if black_canvas:
		black_canvas.visible = true
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_screen,"modulate:a", 0.0, fade_duration)

func _process(delta):
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	sprite_paralax_2.region_rect.position += delta * Vector2(scroll_speed_paralax_2)
	if sprite_paralax_2.region_rect.position >= Vector2(960, 540):
		sprite_paralax_2.region_rect.position = Vector2.ZERO
	sprite_paralax_3.region_rect.position += delta * Vector2(scroll_speed_paralax_3)
	if sprite_paralax_3.region_rect.position >= Vector2(960, 540):
		sprite_paralax_3.region_rect.position = Vector2.ZERO


func set_bg_size_scale():
	if bg:
		bg.visible = true
		bg.position = get_viewport_rect().size / 2
		bg.scale = get_viewport_rect().size

func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	viewport_size = get_viewport_rect().size
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
		var my = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
		parallax_layer.motion_mirroring.x = mx
		parallax_layer.motion_mirroring.y = my
