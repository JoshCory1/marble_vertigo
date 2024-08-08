extends AnimatableBody2D

## controles gravity speed
@export var grav_speed: float = 35

var bounce_force_min: float = 300
var bounce_force_max: float = 450

func  _physics_process(delta):
	position.y += grav_speed * delta


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body != null:
		body.bounce_up(bounce_force_min, bounce_force_max)
		if body.pause_y:
			body.pause_y = false
		if body.stop_contorls:
			body.stop_contorls = false
