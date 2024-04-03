extends Node

var current_lvl: int = 1
var current_play_through_count: int = 5




func _process(_delta):
	print("pay through count is: " + str(current_play_through_count))
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
