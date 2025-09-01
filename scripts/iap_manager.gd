# AndroidIAPP is a plugin for the Godot game engine. 
# It provides an interface to work with Google Play Billing Library version 7. 
# The plugin supports all public functions of the library, passes all error codes, and can work with different subscription plans.
# https://developer.android.com/google/play/billing
#
# You can use this plugin with any node in Godot.
# But, I recommend adding this script as a singleton (autoload).
# This makes it easier to access and use its functions from anywhere in your project.
#
# An example of working with a plugin:


extends Node
signal close_window()
signal product_details_received(product_id: String, price: String)
signal product_details_received_no_ads(product_id: String, price: String)
signal premium_purchase_successful()
signal no_ads_purchase_succssful()
#signal purchase_failed(product_id: String, error: Dictionary)


# https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState
enum purchaseState {
	UNSPECIFIED_STATE = 0,
	PURCHASED = 1,
	PENDING = 2,
	}


# https://developer.android.com/reference/com/android/billingclient/api/BillingClient.BillingResponseCode
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


const ITEM_CONSUMATED: Array = ["nill_consum"]

const ITEM_ACKNOWLEDGED: Array = ["premium_version", "no_ads"]

const SUBSCRIPTIONS: Array = ["nill_subs"]


var billing = null

var new_premium = null

var new_no_ads = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	run_iapp_billing()


func run_iapp_billing():
	if Engine.has_singleton("AndroidIAPP"):
		# Get the singleton instance of AndroidIAPP
		billing = Engine.get_singleton("AndroidIAPP")
		print("AndroidIAPP singleton loaded")
		
		# Connection information
		
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
		GameController.my_log("AndroidIAPP singleton not found")


func _on_start_connection() -> void:
	GameController.my_log("Billing: start connection")


func _on_connected() -> void:
	GameController.my_log("Billing successfully connected")
	await get_tree().create_timer(0.4).timeout
	if billing.isReady():
		# billing.sayHello("Hello from Godot Google IAPP plugin :)")
		# Show products available to buy
		# https://developer.android.com/google/play/billing/integrate#show-products
		billing.queryProductDetails(ITEM_ACKNOWLEDGED, "inapp")
		#billing.queryProductDetails(ITEM_CONSUMATED, "inapp")
		#billing.queryProductDetails(SUBSCRIPTIONS, "subs")
		# Handling purchases made outside your app
		# https://developer.android.com/google/play/billing/integrate#ooap
		billing.queryPurchases("subs")
		billing.queryPurchases("inapp")


func _on_disconnected() -> void:
	GameController.my_log("Billing disconnected")


func _on_hello_response(response) -> void:
	GameController.my_log("Hello signal response: " + response)


func query_product_details(response) -> void:
	#left off here
	for product in response["product_details_list"]:
		#var product = response["product_details_list"][i]
		#print(JSON.stringify(product["product_id"], "  "))
		var product_id = product["product_id"]
		var price = product["one_time_purchase_offer_details"]["formatted_price"]
		if product_id == "premium_version":
			product_details_received.emit(product_id, price)
		if product_id == "no_ads":
			product_details_received_no_ads.emit(product_id, price)

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
		if (product in ITEM_ACKNOWLEDGED) or (product in SUBSCRIPTIONS):
			# Acknowledge the purchase
			if not purchase["is_acknowledged"]:
				if purchase.size() > 0:
					if product == ITEM_ACKNOWLEDGED [0]:
						new_premium = purchase["purchase_token"]
						billing.acknowledgePurchase(purchase["purchase_token"])
						if !new_premium.is_empty():
							if new_premium == purchase["purchase_token"]:
								premium_purchase_successful.emit()
								close_window.emit()
								GameController.my_log("Acknowledging: " + purchase["purchase_token"])
					if product == ITEM_ACKNOWLEDGED [1]:
						new_no_ads = purchase["purchase_token"]
						billing.acknowledgePurchase(purchase["purchase_token"])
						if !new_no_ads.is_empty():
							if new_no_ads == purchase["purchase_token"]:
								no_ads_purchase_succssful.emit()
								close_window.emit()
								GameController.my_log("Acknowledging: " + purchase["purchase_token"])

			else:
				if purchase.size() > 0:
					if product == ITEM_ACKNOWLEDGED [0]:
						new_premium = purchase["purchase_token"]
						GameController.my_log("Premium Already acknowledged")
						premium_purchase_successful.emit()
					if product == ITEM_ACKNOWLEDGED [1]:
						new_no_ads = purchase["purchase_token"]
						GameController.my_log("No Ads Already acknowledged")
						no_ads_purchase_succssful.emit()
		elif product in ITEM_CONSUMATED:
			# Consume the purchase
			GameController.my_log("Consuming: " + purchase["purchase_token"])
			billing.consumePurchase(purchase["purchase_token"])
			#
			# Here, process the use of the product in your game.
			#
		else:
			GameController.my_log("Product not found: " + str(product))

func reset_purchases():
	if billing:
		if !new_premium.is_empty():
			billing.consumePurchase(new_premium)
			GameController.premium = false
		if !new_no_ads.is_empty():
			billing.consumePurchase(new_no_ads)
# Purchase
func do_purchase(id: String, is_personalized: bool = false):
	billing.purchase([id], is_personalized)

# Subscriptions
func do_subsciption(subscription_id: String, base_plan_id: String , is_personalized: bool = false):
	billing.subscribe([subscription_id], [base_plan_id], is_personalized)


func print_purchases(purchases):
	for purchase in purchases:
		print(JSON.stringify(purchase, "  "))


func _on_purchase(response) -> void:
	GameController.my_log("Purchase started:")
	print(JSON.stringify(response, "  "))


func _on_purchase_cancelled(response) -> void:
	GameController.my_log("Purchase_cancelled:")
	print(JSON.stringify(response, "  "))


func _on_purchase_consumed(response) -> void:
	GameController.my_log("Purchase_consumed")
	print(JSON.stringify(response, "  "))


func _on_purchase_acknowledged(response) -> void:
	print(JSON.stringify(response, "  "))
	GameController.my_log("Purchase_acknowledged:")


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
