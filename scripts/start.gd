extends Node2D

@onready var black_can = $CanvasLayer

func _ready():
	if !GameController.reload:
		black_can.visible = true
		ResourceLoader.load_threaded_request("res://scenes/main_menu.tscn")
		ResourceLoader.load_threaded_request("res://scenes/ui_terrain.tscn")
		await get_tree().create_timer(.8).timeout
		GameController.reload = true
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
