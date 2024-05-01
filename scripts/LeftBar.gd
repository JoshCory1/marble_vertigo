extends StaticBody2D

var move_velocity: Vector2 = Vector2()

@export var bounce_force_min: int = 300
@export var bounce_force_max: int = 450


func random_speed(min_val, max_val):
	var x = randf_range(min_val, max_val)
	return x
	
func random_y_range(min_val, max_val):
	var y = randf_range(min_val, max_val)
	return y




func _on_area_2d_body_entered(body):
	AudioPlayer.play_sfx("bounce_sfx_2")
	if !body.moving:
		body.moving = true
	body.velocity.x = random_speed(bounce_force_min, bounce_force_max)
