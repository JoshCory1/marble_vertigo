extends AnimatableBody2D

# the end point of travel path
@export var destination: Vector2
## the amount  of time it takes to travel between beginning and end points
@export var duration: float = 1.0
## waite time at start point
@export var wait_time_1: float = 0.0
## waite time at end point
@export var wait_time_2: float = 0.0


func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_interval(wait_time_1)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(wait_time_2)
	tween.tween_property(self, "global_position", global_position, duration)
