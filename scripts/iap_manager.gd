extends Node

var google_payment = null
var premium_version_sku = "premium_version"

func _ready():
	if Engine.has_singleton("AndroidIAPP"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		GameController.my_log("Andriod IAP support is enabled")
		
		google_payment.connected.connect(_on_connected)
		google_payment.connect_error.connect(_on_connect_error)
		google_payment.disconnected.connect(_on_disconnected)
		
		google_payment.sku_details_query_completed.connected(_on_sku_details_query_completed)
		google_payment.sku_details_query_error.connected(_on_sku_details_query_error)
		
		google_payment.startConnection()
		
	else:
		GameController.my_log("Andriod IAP support is not availbale")

func purchase_premium():
	GameController.premium = true


func _on_connected():
	GameController.my_log("Connected!")
	
	google_payment.querySkuDetails([premium_version_sku], "inapp")

func _on_connect_error(response_id, debug_msg):
	GameController.my_log("Conenection error, Rsponse id: " + str(response_id) + " " + "Debug msg: " +  str(debug_msg))
	
func _on_disconnected():
	GameController.my_log("Disconnected!")
	
func _on_sku_details_query_completed(skus):
	GameController.my_log("sku details query commleted")
	for sku in skus:
		GameController.my_log("skus:" )
		GameController.my_log(str(sku))
	
func _on_sku_details_query_error(response_id, error_message, skus):
	GameController.my_log("sku query error, response id: " + str(response_id) + ", message: " + str(error_message) + "' skus: " + str(skus))
