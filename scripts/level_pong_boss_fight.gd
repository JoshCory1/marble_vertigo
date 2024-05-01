extends Node2D

# Player
@onready var player = $Player

#sfx
@export var music_track: AudioStream = null
@export var music_volume: float = -10

# Canvas
@onready var bg = $CanvasLayer/Sprite2D
@onready var black_canvas = $BlackCanvas
@onready var black_screen = $BlackCanvas/ColorRect
## Sets the fade in duration
@export var fade_duration: float = 0.5

# Side Bars
@onready var rigt_bar = $RightBar
@onready var left_bar = $LeftBar
# Exit and Deathzone
@onready var exit = $Exit
@onready var deathzone = $Deathzone
# Pillars
@onready var player_pillar = $PlayerPillar
@onready var enamy_pillar = $EnemyPillar

func _ready():
	set_up_bars()
	set_up_new_game()
	

func set_up_new_game():
	if black_canvas:
		black_canvas.visible = true
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.volume_db = music_volume
		AudioPlayer.m_player.play()
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black_screen,"modulate:a", 0.0, fade_duration)
	await get_tree().create_timer(0.2).timeout
	if get_tree().paused == true:
		get_tree().paused = false

func set_up_bars():
	var screen_size = get_viewport_rect().size
	var side_bars = [rigt_bar, left_bar]
	for bar in side_bars:
		bar.scale.y = screen_size.y
	rigt_bar.position.x = screen_size.x - 10
	left_bar.position.x = 10
	exit.scale.x = screen_size.x
	exit.position.x = screen_size.x / 2
	exit.position.y = 0
	deathzone.scale.x = screen_size.x
	deathzone.scale.x = screen_size.x
	deathzone.position.x = screen_size.x / 2
	deathzone.position.y = screen_size.y
	player_pillar.position.y = screen_size.y - 30
	player_pillar.position.x = screen_size.x / 2
	enamy_pillar.position.y = 30
	enamy_pillar.position.x = screen_size.x /2
	player.position = screen_size / 2
	bg.position = screen_size / 2
	bg.scale.x = screen_size.x / 960
	bg.scale.y = screen_size.y / 540
