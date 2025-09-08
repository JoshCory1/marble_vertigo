extends Node2D


func _ready() -> void:
	preload("res://scenes/main_menu.tscn")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/inter_scene.tscn")
