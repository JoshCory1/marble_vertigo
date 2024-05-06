extends StaticBody2D

var move_velocity: Vector2 = Vector2()

#@export var bounce_force_min: int = 300
#@export var bounce_force_max: int = 450

#@onready var player = $"../Player"

#func random_speed(min_val, max_val):
#	var x = randf_range(min_val, max_val)
#	return x
#
#func random_y_range(min_val, max_val):
#	var y = randf_range(min_val, max_val)
#	return y

#func _physics_process(delta):
#	if player:
#		if player.stuck_left:
#			player.velocity.y = random_y_range(-100,100)
#			player.velocity.x += 300 * delta
				


func _on_area_2d_body_entered(body):
	AudioPlayer.play_sfx("bounce_sfx_2")
#	if body.moving:
#		body.moving = false
#	body.stuck_left = true
#	body.velocity.y = random_y_range(-100,100)
	body.velocity.x += 100
	#body.position.x += 10

#func _on_area_2d_body_exited(body):
	#body.stuck_left = false
