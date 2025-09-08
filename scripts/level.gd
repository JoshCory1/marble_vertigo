extends Node2D
##Sets the music track for the level
@export var music_track: AudioStream = null

#onready vars
@onready var coins_in_level = get_tree().get_nodes_in_group("Coins")
@onready var exit = $Exit
@onready var player: CharacterBody2D = $Player

var coins_this_level: int = 0
var viewport_size: Vector2


func _ready():
	player.change_level.connect(_on_change_level)
	log(exit.current_lvl)
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.play()
	viewport_size = get_viewport_rect().size
	for coin in coins_in_level:
		coin.coin_pickup.connect(_on_coin_pickup)

func _on_coin_pickup():
	coins_this_level += 1
	
func _on_change_level():
	get_tree().change_scene_to_file("res://scenes/inter_scene.tscn")
	#get_tree().unload_current_scene()
