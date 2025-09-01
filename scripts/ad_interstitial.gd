# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends Control

signal load_next_level

@onready var level_buttons = get_tree().get_nodes_in_group("LevelButtons")

#systum vars
var level_name: String
var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()


func _ready():
	MobileAds.initialize()
	for button in level_buttons:
		button.show_ad.connect(_on_load_pressed)
	interstitial_ad_load_callback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded
	full_screen_content_callback.on_ad_clicked = func() -> void:
		GameController.my_log("on_ad_clicked")
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		GameController.my_log("on_ad_dismissed_full_screen_content")
		destroy()
		load_level()
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(_ad_error : AdError) -> void:
		GameController.my_log("on_ad_failed_to_show_full_screen_content")
		load_level()
	full_screen_content_callback.on_ad_impression = func() -> void:
		GameController.my_log("on_ad_impression")
		load_level()
	full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		GameController.my_log("on_ad_showed_full_screen_content")
		load_level()


func _on_load_pressed(_string: String):
	if interstitial_ad:
		interstitial_ad.destroy()
	var unit_id: String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/1033173712"
	if OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/4411468910"
		
	
	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)

func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	GameController.my_log(adError.message)
	
func on_interstitial_ad_loaded(interstitial_ad : InterstitialAd) -> void:
	GameController.my_log("interstitial ad loaded" + str(interstitial_ad._uid))
	interstitial_ad = interstitial_ad
	interstitial_ad.full_screen_content_callback = full_screen_content_callback
	if interstitial_ad:
		interstitial_ad.show()
		
func _on_show_pressed():
	if interstitial_ad:
		interstitial_ad.show()

func _on_destroy_pressed():
	destroy()

func destroy():
	if interstitial_ad:
		interstitial_ad.destroy()
		interstitial_ad = null #need to load again

func load_level():
	load_next_level.emit()
