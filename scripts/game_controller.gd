extends Node
const SAVE_VERSION = 1
signal purchased_premium

#Debug
##Debug contorls if player can hit Q(debug key) to by pass game for testing purpose
@export var debug: bool = false

##Debug toglles debug menu
@export var debug_visible: bool = false

##premium controls if game has limited levels and adds
@export var premium: bool = false

##controles the ad responce for if ad is played or not
@export var master_no_ads: bool = false

#Time
var old_time: float = 0.0
var ver_time: float = 0.0

#Level
var current_lvl: int = 1
var current_play_through_count: int = 5

# Save game
var node_name: String
var save_file_path = "user://GameController.save"

# Log
var current_log: String
var old_log
#Shop


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
var skins_unlocked =[]
var skins_unlocked_backup = []
var skins = []
var skins_backup = []

func _enter_tree() -> void:
	skins_unlocked = [default_0_skin_unlocked, cube_1_skin_unlocked, spin_2_skin_unlocked, puzzle_3_unlocked, infinty_4_unlocked, circle_5_unlocked,  star_6_unlocked, crystel_7_unlocked, billiards_8_unlocked]
	skins_unlocked_backup = [default_0_skin_unlocked, cube_1_skin_unlocked, spin_2_skin_unlocked, puzzle_3_unlocked, infinty_4_unlocked, circle_5_unlocked, star_6_unlocked, crystel_7_unlocked, billiards_8_unlocked]
	skins = [default_0_skin_use, cube_1_skin_use, spin_2_skin_use, puzzle_3_skin_use, infinty_4_skin_use, circle_5_skin_use, star_6_skin_use, crystel_7_skin_use, billiards_8_skin_use]
	skins_backup = [default_0_skin_use, cube_1_skin_use, spin_2_skin_use, puzzle_3_skin_use, infinty_4_skin_use, circle_5_skin_use, star_6_skin_use, crystel_7_skin_use, billiards_8_skin_use]


func _ready():
	IapManager.premium_purchase_successful.connect(_on_premium_purchase_successful)
	if premium:
		my_log("premium is: " + str(premium))
		purchased_premium.emit()
	node_name = self.name
	load_game()
	for i in range(skins_unlocked_backup.size()):
		var n = i
		skins_unlocked[n] = skins_unlocked_backup[i]
	skins_unlocked_backup = skins_unlocked
	for i in range(skins_backup.size()):
		var n = i
		skins[n] = skins_backup[i]
	
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
	if coins >= 999999:
		coins = 999999

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
	
	if file:
		# ---- Write version ----
		file.store_var(SAVE_VERSION)

		# ---- Simple values ----
		file.store_var(current_play_through_count)
		file.store_var(current_lvl)
		file.store_var(coins)

		# ---- Arrays ----
		file.store_var(skins_backup)
		file.store_var(skins_unlocked_backup)

		# ---- Audio ----
		file.store_var(AudioPlayer.volume_sfx)
		file.store_var(AudioPlayer.m_player_vol)

		file.close()
		print("Game saved.")

func load_game():
	if not FileAccess.file_exists(save_file_path):
		# No save? Initialize defaults.
		skins_backup = skins.duplicate()
		skins_unlocked_backup = skins_unlocked.duplicate()
		return

	var file = FileAccess.open(save_file_path, FileAccess.READ)

	# ---- Read version ----
	var version = file.get_var()

	# ---- Read simple values ----
	current_play_through_count = file.get_var()
	current_lvl = file.get_var()
	coins = file.get_var()

	# ---- Load arrays safely ----
	var loaded_skins = file.get_var()
	var loaded_skins_unlocked = file.get_var()

	# Validate arrays
	if typeof(loaded_skins) == TYPE_ARRAY:
		skins_backup = loaded_skins
	else:
		skins_backup = skins.duplicate()  # fallback to defaults

	if typeof(loaded_skins_unlocked) == TYPE_ARRAY:
		skins_unlocked_backup = loaded_skins_unlocked
	else:
		skins_unlocked_backup = skins_unlocked.duplicate()

	# ---- Audio ----
	AudioPlayer.volume_sfx = file.get_var()
	AudioPlayer.m_player_vol = file.get_var()

	file.close()

	# ---- Ensure arrays are correct length ----
	_fix_skin_array_size()
	
func _fix_skin_array_size():
	# Fix skins_backup
	if skins_backup.size() < skins.size():
		for i in range(skins.size()):
			if i >= skins_backup.size():
				skins_backup.append(skins[i])

	# Fix skins_unlocked_backup
	if skins_unlocked_backup.size() < skins_unlocked.size():
		for i in range(skins_unlocked.size()):
			if i >= skins_unlocked_backup.size():
				skins_unlocked_backup.append(skins_unlocked[i])
				
func _on_premium_purchase_successful():
	if !premium:
		premium = true
	if premium:
		purchased_premium.emit()
	my_log("premium is now: " + str(premium))
