extends AnimatableBody2D


# player reference
@onready var player = get_tree().get_first_node_in_group("Player")
## the end point of travel path
@export var destination: Vector2
## the amount  of time it takes to travel between beginning and end points
@export var duration: float = 3.0
## waite time at start point
@export var wait_time_1: float = 0.0
## waite time at end point
@export var wait_time_2: float = 0.0
## minimum bounce velocity of player
@export var bounce_force_min: float = 300.0
## maximum bounce velocity of player
@export var bounce_force_max: float = 450.0
# bool that contorls player stuck
var stuck: bool = false
# controles up or down
var player_up: bool = false
var player_down: bool = false
var in_transition: bool = false

func _ready() -> void:
	$Timer.wait_time = (duration + wait_time_1 + wait_time_2)
	$Timer.start()
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_interval(wait_time_1)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(wait_time_2)
	tween.tween_property(self, "global_position", global_position, duration)


func _physics_process(_delta):
	if stuck:
		player.velocity = Vector2.ZERO
		if player_up:
			player.position = self.position + Vector2(0,-30)
		elif player_down:
			player.position = self.position + Vector2(0,30)
	if !stuck && player_up:
		player.bounce_up(bounce_force_min,bounce_force_max)
		_on_reset()
	if !stuck && player_down:
		player.bounce_down(bounce_force_min,bounce_force_max)
		_on_reset()

	
func _on_reset():
	if in_transition:
		in_transition = false
	if player_up:
		player_up = false
	if player_down:
		player_down = false
	if stuck:
		stuck = false
		
func _on_area_2dup_body_entered(body):
	if body != null:
		if !in_transition:
			in_transition = true
			stuck = true
			player_up = true


func _on_area_2d_down_body_entered(body):
	if body != null:
		if !in_transition:
			in_transition = true
			stuck = true
			player_down = true



func _on_timer_timeout():
	if stuck:
		stuck = false
