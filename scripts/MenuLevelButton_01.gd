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
##level unlock bool if player has used gold to purchase level
@export var level_for_gold_unlock: bool = false
##cost of level in gold
@export var gold_cost: int = 0

#onready vars
@onready var black_screen = $"../../BlackCanvasLayer/ColorRectBlack"
@onready var canvas = $"../../BlackCanvasLayer"
@onready var lock = $Lock
@onready var premium_button_sprite = $"Premium Button Sprite"
@onready var popup_screen = $"../../CanvasLayer2/PremiumPopupScreen"

signal camera_scroll_off

#system vars
var name_of_level
var unlock: bool = false
var current_active: bool = true
var save_file_path


func _ready():
	name_of_level = self.name
	save_file_path = "user://" + name_of_level + ".save"
	load_button()
	popup_screen.perchase_button.connect(_on_perchase_button)
	disabled = true
	IapManager.purchase_successful.connect(_on_purchase_successful)
	if free_level:
		button_ready_up(true)
	elif level_for_gold_unlock:
		button_ready_up(true)
	else:
		button_ready_up(false)



func button_ready_up(flag: bool):
	if flag:
		if GameController.current_lvl >= current_level:
			if disabled:
				disabled = false
			if premium_button_sprite.visible:
				premium_button_sprite.visible = false
			if !unlock:
				unlock = true
			if lock.visible:
				lock.visible = false
		else:
			disabled = true
			if !unlock:
				unlock = true
			if lock.visible:
				lock.visible = false
			if premium_button_sprite.visible:
				premium_button_sprite.visible = false
		#if GameController.current_lvl:
			#if lock.visible == true:
				#lock.visible = false
			#if premium_button_sprite.visible == true:
				#premium_button_sprite.visible = false
			#if !disabled:
				#disabled = true
	else:
		if GameController.current_lvl >= current_level:
			if !premium_button_sprite.visible:
				premium_button_sprite.visible = true
			if disabled:
				disabled = false
			if !lock.visible:
				lock.visible = true
			if !premium_button_sprite.visible:
				premium_button_sprite.visible = true
			if unlock:
				unlock = false
		else:
			if lock.visible:
				lock.visible = false
			if premium_button_sprite.visible:
				premium_button_sprite.visible = false
			disabled = true
	if disabled:
		current_active = false


func _on_pressed():
	if unlock:
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
		show_popup.emit(gold_cost)
		
func _on_purchase_successful():
	button_ready_up(true)

func _on_perchase_button():
	button_ready_up(true)
	if !level_for_gold_unlock:
		level_for_gold_unlock = true
	save_button()

func save_button():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(level_for_gold_unlock)

func load_button():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		level_for_gold_unlock = file.get_var()
	else:
		level_for_gold_unlock = false
