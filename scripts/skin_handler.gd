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
	elif GameController.skins[2] && GameController.skins_unlocked[2] == true:
		player.use_spin_skin()
	else:
		player.use_default_skin()
