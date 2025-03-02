extends TextureButton

signal show_popup

##duration of screen fade effect
@export var fade_duration: float = 0.5
##level toat button loads
@export var level: PackedScene = null
##current level required to load level
@export var current_level: int = 0
##free lavel bool allows access to level
@export var free_level: bool = false

#onready vars
@onready var black_screen = $"../../BlackCanvasLayer/ColorRectBlack"
@onready var canvas = $"../../BlackCanvasLayer"
@onready var lock = $Lock
@onready var premium_button_sprite = $"Premium Button Sprite"

signal camera_scroll_off

var current_active: bool = true


func _ready():
	if GameController.premium:
		free_level = true
	if free_level:
		if lock.visible == true:
			lock.visible = false
		if premium_button_sprite.visible == true:
			premium_button_sprite.visible = false
		if !disabled:
			disabled = true
	elif !free_level && current_level > GameController.current_lvl:
		if lock.visible == true:
			lock.visible = false
		if premium_button_sprite.visible == true:
			premium_button_sprite.visible = false
		if !disabled:
			disabled = true
	if GameController.current_lvl >= current_level:
		disabled = false
	if disabled:
		current_active = false

func _on_pressed():
	if free_level:
		if level != null:
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
	else:
		show_popup.emit()
