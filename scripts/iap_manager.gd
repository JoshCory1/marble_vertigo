extends Node

var google_payment = null

func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		GameController.my_log("Andriod IAP support is enabled")
	else:
		GameController.my_log("Andriod IAP support is not availbale")

func purchase_skin():
	GameController.cube_1_skin_unlocked = true
