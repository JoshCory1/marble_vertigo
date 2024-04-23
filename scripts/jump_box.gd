extends StaticBody2D

func _on_top_body_entered(body):
	body.bounce_up()


func _on_bottom_body_entered(body):
	body.bounce_down()


func _on_right_body_entered(body):
	body.bounce_right()


func _on_left_body_entered(body):
	body.bounce_left()
