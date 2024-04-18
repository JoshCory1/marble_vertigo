extends Node

#Level
var current_lvl: int = 1
var current_play_through_count: int = 5
var premium: bool = true
# Save game
var save_file_path = "user://vertigo_save.save"

# Log
var current_log: String
var old_log
#Skins bools
#default
var default_skin_unlocked: bool = true
var default_0_skin_use: bool = false
#cube
var cube_skin_unlocked: bool = false
var cube_1_skin_use: bool = false
#spin
var spin_skin_unlocked: bool = false
var spin_2_skin_use: bool = false
#skins array
var skins = []

func _ready():
	load_game()
	skins = [default_0_skin_use, cube_1_skin_use, spin_2_skin_use]

func _process(_delta):
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
		
