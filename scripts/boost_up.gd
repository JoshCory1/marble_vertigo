extends Area2D

@export var time_till_boost: float = 5.0
@export var min_bounce: float = 600
@export var max_bounce: float = 650
@export var no_charge_up:bool = false

@onready var sprite = $AnimatedSprite2D

func _ready():
	if no_charge_up:
		time_till_boost = 0.0
		sprite.modulate = Color(1,0,0,1)

func _on_body_entered(body):
	body.stop_velocity = true
	body.global_position = global_position
	if !no_charge_up:
		AudioPlayer.play_sfx("boost_charge")
	await get_tree().create_timer(time_till_boost).timeout
	body.stop_velocity = false
	body.velocity.x = 0
	AudioPlayer.stop_now = true
	AudioPlayer.play_sfx("boost_shoot")
	body.bounce_up(min_bounce,max_bounce)
