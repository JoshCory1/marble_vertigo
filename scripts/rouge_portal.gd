extends AnimatableBody2D



# refrence to player
@onready var player = get_tree().get_first_node_in_group("Player")
# refrence to portal
@onready var potal = $Portal

## portal exit
@export var portal_exit: Node = null
## the end point of travel path
@export var destination: Vector2
## the amount  of time it takes to travel between beginning and end points
@export var duration: float = 1.0
## waite time at start point
@export var wait_time_1: float = 0.0
## waite time at end point
@export var wait_time_2: float = 0.0

func _ready() -> void:
	potal.exit_point = portal_exit
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_interval(wait_time_1)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(wait_time_2)
	tween.tween_property(self, "global_position", global_position, duration)
