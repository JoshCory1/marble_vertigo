extends Node2D

signal load_next_level

var _interstitial_ad : InterstitialAd
var _full_screen_content_callback : FullScreenContentCallback

func _ready() -> void:
	#...
	_full_screen_content_callback.on_ad_clicked = func() -> void:
		GameController.my_log("on_ad_clicked")
	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		GameController.my_log("on_ad_dismissed_full_screen_content")
	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		GameController.my_log("on_ad_failed_to_show_full_screen_content")
	_full_screen_content_callback.on_ad_impression = func() -> void:
		GameController.my_log("on_ad_impression")
	_full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		GameController.my_log("on_ad_showed_full_screen_content")

func _on_load_pressed():
	#...
	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()

	#...

	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
		print("interstitial ad loaded" + str(interstitial_ad._uid))
		_interstitial_ad = interstitial_ad
		_interstitial_ad.full_screen_content_callback = _full_screen_content_callback

	#...

func load_level():
	load_next_level.emit()
