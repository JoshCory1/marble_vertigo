extends Node2D

@export var music_track : AudioStream = null

@onready var button_array = get_tree().get_nodes_in_group("LevelButtons")
@onready var menu_camera = $UIMenuCamera


var current_button_array_number = 0


func _ready():
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.volume_db = -10.0
		AudioPlayer.m_player.play()
	for number_of_buttons in button_array:
		if number_of_buttons.current_active == true:
			current_button_array_number += 1
		if number_of_buttons.current_active == true and number_of_buttons.current_level == current_button_array_number:
			menu_camera.global_position = number_of_buttons.global_position
