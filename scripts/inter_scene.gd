extends Node2D
@onready var inter_scene_loader: Control = $InterSceneLoader
@onready var portal_wheel_of: Sprite2D = $InterSceneLoader/PortalWheelOf

var new_path: String

func _ready() -> void:
	portal_wheel_of.animation_start()
	inter_scene_loader.scene_loaded.connect(_on_scene_loaded)
	inter_scene_loader.load("res://scenes/main_menu.tscn")


func _on_scene_loaded(path: String):
	new_path = path
	call_deferred_thread_group("load_level")

func load_level():
	get_tree().change_scene_to_file(new_path)
