extends Node

@onready var player = $"../Player"

func _ready():
	use_selected_skin()

func _process(_delta):
	use_selected_skin()

func use_selected_skin():
	if GameController.skins[0] == true && GameController.skins_unlocked[0] == true:
		player.use_default_skin()
	elif GameController.skins[1] == true && GameController.skins[1] == true:
		player.use_cube_skin()
	elif GameController.skins[2] == true && GameController.skins_unlocked[2] == true:
		player.use_spin_skin()
	elif GameController.skins[3] == true && GameController.skins_unlocked[3] == true:
		player.use_puzzle_skin()
	elif GameController.skins[4] == true && GameController.skins_unlocked[4] == true:
		player.use_infinty_skin()
	elif  GameController.skins[5] == true && GameController.skins_unlocked[5] == true:
		player.use_circle_skin() 
	elif GameController.skins[6] == true && GameController.skins_unlocked[6] == true:
		player.use_star_skin()
	elif GameController.skins[7] == true && GameController.skins_unlocked[7] == true:
		player.use_crystel_skin()
	elif  GameController.skins[8] == true && GameController.skins_unlocked[8] == true:
		player.use_billiards_skin()
	else:
		player.use_default_skin()
