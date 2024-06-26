extends StaticBody2D

## minimum bounce velocity of player
@export var bounce_force_min: int = 300
## maximum bounce velocity of player
@export var bounce_force_max: int = 450


func _on_area_2_dright_body_entered(body):
	if body != null:
		body.bounce_right(bounce_force_min, bounce_force_max)
		if body.pause_y:
			body.pause_y = false
		if body.stop_contorls:
			body.stop_contorls = false


func _on_area_2d_left_body_entered(body):
	if body != null:
		body.bounce_left(bounce_force_min, bounce_force_max)
		if body.pause_y:
			body.pause_y = false
		if body.stop_contorls:
			body.stop_contorls = false


func _on_area_2dup_body_entered(body):
	if body != null:
		body.bounce_up(bounce_force_min, bounce_force_max)
		if body.pause_y:
			body.pause_y = false
		if body.stop_contorls:
			body.stop_contorls = false


func _on_area_2d_down_body_entered(body):
	if body != null:
		body.bounce_down(bounce_force_min, bounce_force_max)
		if body.pause_y:
			body.pause_y = false
		if body.stop_contorls:
			body.stop_contorls = false
