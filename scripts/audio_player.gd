extends Node
@export var bounce_sfx_1: AudioStream = null
@export var bounce_sfx_2: AudioStream = null
@export var shatter_sfx: AudioStream = null
@export var pillar_move_sfx: AudioStream = null
@export var portal_sfx: AudioStream = null
@export var volume_sfx = 1

@onready var m_player = $MusicPlayer

func play_sfx(sfx_name: String):
	
	var stream = null
	if sfx_name == "bounce_sfx_1":
		stream = bounce_sfx_1
	elif sfx_name == "bounce_sfx_2":
		stream = bounce_sfx_2
	elif sfx_name == "shatter_sfx":
		stream = shatter_sfx
	elif  sfx_name == "pillar_move_sfx":
		stream = pillar_move_sfx
	elif sfx_name == "portal_sfx":
		stream = portal_sfx
	else :
		print("Invalid sfx name")
		return
	var asp = AudioStreamPlayer.new()
	
	asp.stream = stream
	asp.name = "SFX"
	asp.volume_db = volume_sfx
	
	add_child(asp)
	
	asp.play()
	
	await asp.finished
	asp.queue_free()
