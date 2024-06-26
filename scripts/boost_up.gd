extends Area2D

signal y_lock_releasing
signal stop_other_timers

# player reference
@onready var player = get_tree().get_first_node_in_group("Player")

## time until activation
@export var time_till_boost: float = 2.0
## cotroles bounce min
@export var min_bounce: float = 900
## cotroles bounce max
@export var max_bounce: float = 900
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
# target position set to curent moveing posititon of object
var stuck: bool = false

func _ready():
	if no_charge_up:
		time_till_boost = 0.0
		use_red_animation()
	else:
		use_default_animation()
	for stop_timer in stop_timers:
		stop_timer.stop_other_timers.connect(_on_stop_other_timers)

func _physics_process(_delta):
	if stuck:
		player.velocity = Vector2.ZERO
		player.global_position = global_position

func _on_body_entered(body):
	stop_other_timers.emit()
	stuck = true
	body.global_position = global_position
	if !no_charge_up:
		AudioPlayer.play_sfx("boost_charge")
	await get_tree().create_timer(time_till_boost).timeout
	body.pause_y = true
	body.velocity.x = 0
	stuck = false
	body.stop_contorls = true
	#AudioPlayer.stop_now = true
	AudioPlayer.play_sfx("boost_shoot")
	body.bounce_up(min_bounce,max_bounce)
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




func _on_body_exited(body):
	body.no_bounce_y = 0
