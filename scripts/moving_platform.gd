extends Area2D
##min bounce force amount of player bounce
@export var bounce_force_min: int = 750
##max bounce force amount of player bounce
@export var bounce_force_max: int = 850
##the end point of travel path
@export var destination: Vector2
##the amount  of time it takes to travel between beginning and end points
@export var duration: float = 1.0
##waite time at start point
@export var wait_time_1: float = 0.0
##waite time at end point
@export var wait_time_2: float = 0.0


func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_interval(wait_time_1)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(wait_time_2)
	tween.tween_property(self, "global_position", global_position, duration)

func _on_body_entered(body):
	if body != null:
		if body.gravity > 0:
			body.bounce_up(round(bounce_force_min / 2),round(bounce_force_max / 2))
			if body.pause_y:
				body.pause_y = false
			if body.stop_contorls:
				body.stop_contorls = false
		elif body.gravity < 0:
			body.bounce_down(bounce_force_min, bounce_force_max)
			if body.pause_y:
				body.pause_y = false
			if body.stop_contorls:
				body.stop_contorls = false
