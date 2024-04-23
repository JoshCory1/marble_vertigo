extends Node

var google_payment = null

func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		GameController.my_log("Andriod IAP support is enabled")
		
		google_payment.connected.connect(_on_connected)
		google_payment.connect_error.connect(_on_connect_error)
		google_payment.disconnected.connect(_on_disconnected)
		
		google_payment.startConnection()
		
	else:
		GameController.my_log("Andriod IAP support is not availbale")

func purchase_skin():
	GameController.cube_1_skin_unlocked = true


func _on_connected():
	GameController.my_log("Connected!")

func _on_connect_error(response_id, debug_msg):
	GameController.my_log("Conenection error, Rsponse id: " + str(response_id) + "Debug msg: " +  str(debug_msg))
	
func _on_disconnected():
	GameController.my_log("Disconnected!")
