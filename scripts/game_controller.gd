extends Node
#Debug
## Debug contorls if player can hit Q(debug key) to by pass game for testing purpose
@export var debug: bool = false
## Debug toglles debug menu
@export var debug_visible: bool = false

# Start
var is_reloaded: bool = false

#Time
var old_time: float = 0.0
var ver_time: float = 0.0
#Level
var current_lvl: int = 1
var current_play_through_count: int = 5
## premium controls if game has limited plays before needing to watch adds
@export var premium: bool = false

# Save game
var save_file_path = "user://vertigo_save.save"

# Log
var current_log: String
var old_log

#Skins bools

#default
var default_0_skin_unlocked: bool = true
var default_0_skin_use: bool = false

#cube
var cube_1_skin_unlocked: bool = false
var cube_1_skin_use: bool = false

#spin
var spin_2_skin_unlocked: bool = false
var spin_2_skin_use: bool = false

#skins array
var skins = []

func _ready():
	load_game()
	skins = [default_0_skin_use, cube_1_skin_use, spin_2_skin_use]

func _process(_delta):
	var time = Time.get_unix_time_from_system()
	if time > old_time:
		if time > old_time + 10:
			ver_time += 1
			print("my time is: " + str(ver_time))
			old_time = time
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()

# Debug Log

func my_log(log_str: String):
	var console = get_tree().get_first_node_in_group("debug_console")
	if console:
		var log_lable = console.find_child("LogLabel")
		if log_lable:
			if !log_lable.text.is_empty():
				log_lable.text += "\n"
			log_lable.text += log_str
			print(log_str)

func use_skin(val: int):
	for i in range(skins.size()):
		skins[i] = false
	skins[val] = true
	

# Save game

func save_game():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(current_play_through_count)
	my_log("Saved current play through count to disk")
	file.store_var(current_lvl)
	my_log("Saved current level to disk")
	file.close()
	

func load_game():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		current_play_through_count = file.get_var()
		current_lvl = file.get_var()
		my_log("Loaded current play through count: " + str(current_play_through_count) + "\n" + "Loaded current level: " + str(current_lvl))
		file.close()
	else:
		my_log("Save file dosen't exist, setting default values")
		current_play_through_count = 5
		current_lvl = 1
		
