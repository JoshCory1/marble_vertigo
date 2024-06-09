extends Area2D

signal y_lock_releasing
signal stop_other_timers

## time until activation
@export var time_till_boost: float = 2.0
## cotroles bounce min
@export var min_bounce: float = 2000
## cotroles bounce max
@export var max_bounce: float = 2000
## activats immediately
@export var no_charge_up:bool = false
# times how long y is locked
@export var pause_y_time: float = 3.0

# sprite reference
@onready var sprite = $AnimatedSprite2D
# animation player reference
@onready var animation_player = $AnimatedSprite2D
# y_timer is for releasing lock on y velocity
@onready var y_timer = $YTimer
# connect array for stop timers
@onready var stop_timers = get_tree().get_nodes_in_group("boost_x")

func _ready():
	if no_charge_up:
		time_till_boost = 0.0
		use_red_animation()
	else:
		use_default_animation()
	y_timer.wait_time = pause_y_time
	for stop_timer in stop_timers:
		stop_timer.stop_other_timers.connect(_on_stop_other_timers)

func _on_body_entered(body):
	stop_other_timers.emit()
	body.stop_velocity = true
	body.global_position = global_position
	if !no_charge_up:
		AudioPlayer.play_sfx("boost_charge")
	await get_tree().create_timer(time_till_boost).timeout
	body.pause_y = true
	body.velocity.y = 0
	body.stop_velocity = false
	body.stop_contorls = true
	AudioPlayer.stop_now = true
	AudioPlayer.play_sfx("boost_shoot")
	body.bounce_right(min_bounce,max_bounce)
	if body.pause_y:
		y_timer.start()
	
	
# animations

func use_default_animation():
	animation_player.play("default")


func  use_red_animation():
	animation_player.play("red")


func _on_y_timer_timeout():
	y_lock_releasing.emit()
	stop_other_timers.emit()
	
func _on_stop_other_timers():
	y_timer.stop()
