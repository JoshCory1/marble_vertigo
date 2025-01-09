extends AnimatableBody2D

# refrence to player
@onready var player = get_tree().get_first_node_in_group("Player")
# refrences to area2D's
@onready var area_bounce_up = $AreaBounceUp
@onready var area_bounce_down = $AreaBounceUp/AreaBounceDown
@onready var area_bounce_left = $AreaBounceLeft
@onready var area_bounce_right = $AreaBounceRight

##the end point of travel path
@export var destination: Vector2
##the amount  of time it takes to travel between beginning and end points
@export var duration: float = 1.0
##waite time at start point
@export var wait_time_1: float = 0.0
##waite time at end point
@export var wait_time_2: float = 0.0
##minimum bounce velocity of player
@export var bounce_force_min: float = 300
##maximum bounce velocity of player
@export var bounce_force_max: float = 450


func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_interval(wait_time_1)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(wait_time_2)
	tween.tween_property(self, "global_position", global_position, duration)

func _on_area_bounce_up_body_entered(body):
	if body != null:
		body.stop_velocity = true
		if destination.y < 0:
			bounce_force_min = bounce_force_min / 1.5
			bounce_force_max = bounce_force_max / 1.5
		body.bounce_up(bounce_force_min, bounce_force_max)
		body.stop_velocity = false
		


func _on_area_bounce_down_body_entered(body):
	if body != null:
		body.stop_velocity = true
		body.bounce_down(bounce_force_min, bounce_force_max)
		body.stop_velocity = false


func _on_area_bounce_left_body_entered(body):
	if body != null:
		body.stop_velocity = true
		body.bounce_left(bounce_force_min, bounce_force_max)
		body.stop_velocity = false


func _on_area_bounce_right_body_entered(body):
	if body != null:
		body.stop_velocity = true
		body.bounce_right(bounce_force_min, bounce_force_max)
		body.stop_velocity = false
