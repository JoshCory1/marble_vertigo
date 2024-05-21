extends Node2D

@export var music_track: AudioStream = null
@export var music_volume: float = -10

@onready var coins_in_level = get_tree().get_nodes_in_group("Coins") 

var coins_this_level: int = 0
var viewport_size: Vector2


func _ready():
	
	if music_track != null:
		AudioPlayer.m_player.stream = music_track
		AudioPlayer.m_player.volume_db = music_volume
		AudioPlayer.m_player.play()
	viewport_size = get_viewport_rect().size
	for coin in coins_in_level:
		coin.coin_pickup.connect(_on_coin_pickup)

func _on_coin_pickup():
	coins_this_level +=1

