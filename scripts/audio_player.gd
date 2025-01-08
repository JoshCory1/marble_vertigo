extends Node
## bounce_sfx_1
@export var bounce_sfx_1: AudioStream = null
## bounce_sfx_2
@export var bounce_sfx_2: AudioStream = null
## shatter_sfx
@export var shatter_sfx: AudioStream = null
## pillar_move_sfx
@export var pillar_move_sfx: AudioStream = null
## portal_sfx
@export var portal_sfx: AudioStream = null
## coin_sfx
@export var coin_sfx: AudioStream = null
## boost_charge
@export var boost_charge: AudioStream = null
## boost_shoot
@export var boost_shoot: AudioStream = null
## bullet_sfx
@export var bullet_sfx: AudioStream = null
## grav_switch_sfx
@export var grav_switch_sfx: AudioStream = null
## stop_now 
#@export var stop_now: bool = false
## voume of sound fx
@export var volume_sfx: float = 0.5
# m_player refrence to background music player
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
	elif sfx_name == "coin_sfx":
		stream = coin_sfx
	elif sfx_name == "boost_charge":
		stream = boost_charge
	elif sfx_name == "boost_shoot":
		stream = boost_shoot
	elif sfx_name == "bullet_sfx":
		stream = bullet_sfx
	elif sfx_name == "grav_switch_sfx":
		stream = grav_switch_sfx
	else :
		print("Invalid sfx name")
		return
	var asp = AudioStreamPlayer.new()
	
	asp.volume_db = volume_sfx
	asp.stream = stream
	asp.name = "SFX"
	
	add_child(asp)
	
	asp.play()
	await asp.finished
	asp.queue_free()
