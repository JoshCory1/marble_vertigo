extends Node
#Debug
## Debug contorls if player can hit Q(debug key) to by pass game for testing purpose
@export var debug: bool = false
## Debug toglles debug menu
@export var debug_visible: bool = false

#Time
var old_time: float = 0.0
var ver_time: float = 0.0
#Level
var current_lvl: int = 1
var current_play_through_count: int = 5

# Save game
var save_file_path = "user://vertigo_save.save"

# Log
var current_log: String
var old_log
#Shop

## premium controls if game has limited levels and adds
@export var premium: bool = false

#coin
var coins: int = 0

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

#puzzle
var puzzle_3_unlocked: bool = false
var puzzle_3_skin_use: bool = false

#infinty
var infinty_4_unlocked: bool = false
var infinty_4_skin_use: bool = false

#circle
var circle_5_unlocked: bool = false
var circle_5_skin_use: bool = false

#star
var star_6_unlocked: bool = false
var star_6_skin_use: bool = false

#crystel
var crystel_7_unlocked: bool = false
var crystel_7_skin_use: bool = false

#billiards
var billiards_8_unlocked: bool = false
var billiards_8_skin_use: bool = false

#skins array
@onready var skins_unlocked = [default_0_skin_unlocked, cube_1_skin_unlocked, spin_2_skin_unlocked, puzzle_3_unlocked, infinty_4_unlocked, circle_5_unlocked,star_6_unlocked,crystel_7_unlocked,billiards_8_unlocked]
@onready var skins_unlocked_backup = [default_0_skin_unlocked, cube_1_skin_unlocked, spin_2_skin_unlocked, puzzle_3_unlocked, infinty_4_unlocked, circle_5_unlocked,star_6_unlocked,crystel_7_unlocked,billiards_8_unlocked]
@onready var skins = [default_0_skin_use, cube_1_skin_use, spin_2_skin_use, puzzle_3_skin_use,infinty_4_skin_use , circle_5_skin_use, star_6_skin_use,crystel_7_skin_use,billiards_8_skin_use]
@onready var skins_backup = [default_0_skin_use, cube_1_skin_use, spin_2_skin_use, puzzle_3_skin_use,infinty_4_skin_use , circle_5_skin_use, star_6_skin_use,crystel_7_skin_use,billiards_8_skin_use]


func _ready():
	load_game()
	for i in range(skins_unlocked_backup.size()):
		var n = i
		skins_unlocked[n] = skins_unlocked_backup[i]
	skins_unlocked_backup = skins_unlocked
	for i in range(skins_backup.size()):
		var n = i
		skins[n] = skins_backup[i]
	skins_backup = skins
	#IapManager.purchase_successful.connect(_on_purchase_successful)
	my_log("premium is: " + str(premium))

	
func _process(_delta):
	var time = Time.get_unix_time_from_system()
	if time > old_time:
		if time > old_time + 1.0 / 100.0:
			ver_time += 0.01
			old_time = time
		if ver_time >= 1.0:
			ver_time = 0.0
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
	file.store_var(coins)
	my_log("saved coins to disk")
	file.store_var(skins_backup)
	my_log("Saved skins to disk")
	file.store_var(skins_unlocked_backup)
	my_log("Saved skins_unlocked to disk")
	file.store_var(premium)
	my_log("Saved permium: " + str(premium) + ", to disk")
	file.close()
#	save_json(skins_unlocked)

func load_game():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		current_play_through_count = file.get_var()
		current_lvl = file.get_var()
		coins = file.get_var()
		skins_backup = file.get_var()
		skins_unlocked_backup = file.get_var()
		premium = file.get_var()
		my_log("Loaded current play through count: " + str(current_play_through_count) + "\n" + "Loaded current_level: " + str(current_lvl) + "\n" + "Loaded coins" + str(coins) + "\n" + "premium: " + str(premium))
		file.close()
	else:
		my_log("Save file dosen't exist, setting default values")
		current_play_through_count = 5
		current_lvl = 1
		coins = 0
		premium = false
#func _on_purchase_successful():
	#premium = true
	#my_log("premium is: " + str(premium))
	#save_game()
