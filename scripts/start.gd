extends Node2D

@onready var black_can = $CanvasLayer

func _ready():
	black_can.visible = true
	ResourceLoader.load_threaded_request("res://scenes/main_menu.tscn")
	ResourceLoader.load_threaded_request("res://scenes/ui_terrain.tscn")
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
