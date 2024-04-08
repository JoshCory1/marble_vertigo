extends TextureButton


@onready var black_screen = $"../BlackCanvasLayer/ColorRectBlack"
@onready var canvas = $"../BlackCanvasLayer"


@export var fade_duration: float = 0.5
@export var level: PackedScene = null
@export var current_level: int = 0

signal camera_scroll_off

var current_active: bool = true

func _ready():
	if GameController.current_lvl >= current_level:
		disabled = false
	if disabled:
		current_active = false

func _on_pressed():
	if level != null:
		if GameController.current_play_through_count > 0:
			GameController.current_play_through_count -= 1
			set_pressed_no_signal(true)
			camera_scroll_off.emit()
			canvas.visible = true
			get_tree().paused = true
			var tween = create_tween()
			tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
			tween.tween_property(black_screen,"modulate:a", 1.0, fade_duration,)
			tween.chain().tween_property(AudioPlayer.m_player,"volume_db", -80.0, fade_duration + 0.1)
			await(tween.finished)
			get_tree().change_scene_to_packed(level)
