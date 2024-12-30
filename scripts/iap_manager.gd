extends Node

signal product_details_received(product_id: String, price: String)
signal purchase_successful(product_id: String)
#signal purchase_failed(product_id: String, error: Dictionary)

#premium var
var new_premium

enum purchaseState {
	UNSPECIFIED_STATE = 0,
	PURCHASED = 1,
	PENDING = 2,
	}

enum billingResponseCode {
	SERVICE_TIMEOUT = -3,
	FEATURE_NOT_SUPPORTED = -2,
	SERVICE_DISCONNECTED = -1,
	OK = 0,
	USER_CANCELED = 1,
	SERVICE_UNAVAILABLE = 2, 	
	BILLING_UNAVAILABLE = 3,
	ITEM_UNAVAILABLE = 4,
	DEVELOPER_ERROR = 5,
	ERROR = 6,	
	ITEM_ALREADY_OWNED = 7,
	ITEM_NOT_OWNED = 8,
	NETWORK_ERROR = 12
	}
	
const ITEM_ACKNOWLEDGED = ["premium_version"]

var billing = null

func _ready() -> void:
	
	run_iapp_billing()
	#billing.purchase_successful.connect(_on_purchase_successful)
	#billing.purchase_failed.connect(_on_purchase_failed)
	
func run_iapp_billing():
	await get_tree().create_timer(1).timeout
	if Engine.has_singleton("AndroidIAPP"):
		# Get the singleton instance of AndroidIAPP
		billing = Engine.get_singleton("AndroidIAPP")
		# Handle the response from the helloResponse signal
		billing.helloResponse.connect(_on_hello_response)
		# Handle the startConnection signal
		billing.startConnection.connect(_on_start_connection)
		# Handle the connected signal
		billing.connected.connect(_on_connected)
		# Handle the disconnected signal
		billing.disconnected.connect(_on_disconnected)
		
		# Querying purchases
		
		# Handle the response from the query_purchases signal
		billing.query_purchases.connect(_on_query_purchases)
		# Handle the query_purchases_error signal
		billing.query_purchases_error.connect(_on_query_purchases_error)
		
		# Querying products details
		
		# Handle the response from the query_product_details signal
		billing.query_product_details.connect(query_product_details)
		# Handle the query_product_details_error signal
		billing.query_product_details_error.connect(_on_query_product_details_error)
		
		# Purchase processing
		
		# Handle the purchase signal
		billing.purchase.connect(_on_purchase)
		# Handle the purchase_error signal
		billing.purchase_error.connect(_on_purchase_error)
		
		# Purchase updating
		
		# Handle the purchase_updated signal
		billing.purchase_updated.connect(_on_purchase_updated)
		# Handle the purchase_cancelled signal
		billing.purchase_cancelled.connect(_on_purchase_cancelled)
		# Handle the purchase_update_error signal
		billing.purchase_update_error.connect(_on_purchase_update_error)
		
		# Purchase consuming
		
		# Handle the purchase_consumed signal
		billing.purchase_consumed.connect(_on_purchase_consumed)
		# Handle the purchase_consumed_error signal
		billing.purchase_consumed_error.connect(_on_purchase_consumed_error)
		
		# Purchase acknowledging
		
		# Handle the purchase_acknowledged signal
		billing.purchase_acknowledged.connect(_on_purchase_acknowledged)
		# Handle the purchase_acknowledged_error signal
		billing.purchase_acknowledged_error.connect(_on_purchase_acknowledged_error)
		
		# Connection
		billing.startConnection()
	else:
		GameController.my_log("AIAPP singleton not found")



func _on_start_connection() -> void:
	GameController.my_log("Billing: start connection")


func _on_connected() -> void:
	GameController.my_log("Billing successfully connected")
	await get_tree().create_timer(1).timeout
	if billing.isReady():
		billing.queryProductDetails(ITEM_ACKNOWLEDGED, "inapp")
		billing.queryPurchases("inapp")


func _on_disconnected() -> void:
	GameController.my_log("Billing disconnected")


func _on_hello_response(response) -> void:
	GameController.my_log("Hello signal response: " + response)


func query_product_details(response) -> void:
	for product in response["product_details_list"]:
		#var product = response["product_details_list"][i]
		#GameController.my_log(JSON.stringify(product["product_id"], "  "))
		var product_id = product["product_id"]
		var price = product["one_time_purchase_offer_details"]["formatted_price"]
		product_details_received.emit(product_id, price)
		#
		# Handle avaible for purchase product details here
		#


func _on_query_purchases(response) -> void:
	GameController.my_log("on_query_Purchases_response: ")
	for purchase in response["purchases_list"]:
		process_purchase(purchase)


func _on_purchase_updated(response):
	for purchase in response["purchases_list"]:
		process_purchase(purchase)
	

# Processing incoming purchase
func process_purchase(purchase):
	for product in purchase["products"]:
		if product in ITEM_ACKNOWLEDGED:
			# Consume the purchase
			#GameController.my_log("Consuming: " + purchase["purchase_token"])
			#billing.consumePurchase(purchase["purchase_token"])
			if not purchase["is_acknowledged"]:
				GameController.my_log("Acknowledging: " + purchase["purchase_token"])
				billing.acknowledgePurchase(purchase["purchase_token"])
				new_premium = purchase.purchase_token
			#
		else:
			GameController.my_log("Product not found: " + str(product))


# Purchase
func do_purchase(id: String, is_personalized: bool = false):
	billing.purchase([id], is_personalized)

# Subscriptions

func print_purchases(purchases):
	for purchase in purchases:
		GameController.my_log(JSON.stringify(purchase, "  "))


func _on_purchase(response) -> void:
	GameController.my_log("Purchase started:")
	GameController.my_log(JSON.stringify(response, "  "))


func _on_purchase_cancelled(response) -> void:
	GameController.my_log("Purchase_cancelled:")
	GameController.my_log(JSON.stringify(response, "  "))


func _on_purchase_consumed(response) -> void:
	GameController.my_log("Purchase_consumed:")
	GameController.my_log(JSON.stringify(response, "  "))


func _on_purchase_acknowledged(response) -> void:
	GameController.my_log("Purchase_acknowledged:")
	GameController.my_log(JSON.stringify(response, "  "))
	if new_premium != null:
		if new_premium == response:
			purchase_successful.emit()


func _on_purchase_update_error(error) -> void:
	GameController.my_log(JSON.stringify(error, "  "))


func _on_purchase_error(error) -> void:
	GameController.my_log(JSON.stringify(error, "  "))


func _on_purchase_consumed_error(error) -> void:
	GameController.my_log(JSON.stringify(error, "  "))


func _on_purchase_acknowledged_error(error) -> void:
	GameController.my_log(JSON.stringify(error, "  "))


func _on_query_purchases_error(error) -> void:
	GameController.my_log(JSON.stringify(error, "  "))


func _on_query_product_details_error(error) -> void:
	GameController.my_log(JSON.stringify(error, "  "))

#func _on_purchase_successful(purchase_id):
	#pass
#func _on_purchase_failed(response_id, error_message):
	#GameController.my_log("Purchase error, rspones id: " + str(response_id) + " error msg: " + error_message)
