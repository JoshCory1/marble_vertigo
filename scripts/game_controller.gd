extends Node

var current_lvl: int = 1
var current_play_through_count: int = 5
var old_current_play_through_count: int = 0



func _process(_delta):
	if current_play_through_count != old_current_play_through_count:
		old_current_play_through_count = current_play_through_count
		log_msg("Plays left: " + str(current_play_through_count))
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()

# Debug Log

func log_msg(log_str: String):
	var console = get_tree().get_first_node_in_group("debug_console")
	if console:
		var log_lable = console.find_child("LogLabel")
		if log_lable:
			if !log_lable.text.is_empty():
				log_lable.text += "\n"
			log_lable.text += log_str
			print(log_str)



