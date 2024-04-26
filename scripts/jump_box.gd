extends StaticBody2D

func _on_top_body_entered(body):
	if body != null:
		body.no_bounce = true
		body.bounce_up()


func _on_bottom_body_entered(body):
	if body != null:
		body.no_bounce = true
		body.bounce_down()


func _on_right_body_entered(body):
	if body != null:
		body.no_bounce = true
		body.bounce_right()


func _on_left_body_entered(body):
	if body != null:
		body.no_bounce = true
		body.bounce_left()


func _on_top_body_exited(body):
	if body != null:
		body.no_bounce = false


func _on_bottom_body_exited(body):
	if body != null:
		body.no_bounce = false


func _on_right_body_exited(body):
	if body != null:
		body.no_bounce = false


func _on_left_body_exited(body):
	if body != null:
		body.no_bounce = false
