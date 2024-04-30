extends CharacterBody2D


var move_velocity: Vector2 = Vector2()
var run_speed = 25
var enamy_velocity = Vector2.ZERO
@onready var player = $"../Player"

@export var bounce_force_min: int = 300
@export var bounce_force_max: int = 450

func _physics_process(delta):
	var current_x = global_position.x - get_viewport_rect().size.x / 2
	move_velocity.x = current_x + 22
	enamy_velocity = Vector2.ZERO
	if player:
		enamy_velocity = position.direction_to(player.position) * run_speed
		enamy_velocity = null
	

func random_speed(min_val, max_val):
	var y = randf_range(min_val, max_val)
	return y
	
func random_x_range(min_val, max_val):
	var x = randf_range(min_val, max_val)
	return x

func _on_area_2d_body_entered(body):
	if !body.moving:
		body.moving = true
	body.velocity.x = move_velocity.x * 2 + random_x_range(-150, 150)
	body.velocity.y = random_speed(bounce_force_min, bounce_force_max)
