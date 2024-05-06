extends CharacterBody2D


var move_velocity: Vector2 = Vector2()
var move_speed: float = 0
var startpos: Vector2 = Vector2()
var current_vel: float = 0


@onready var player = $"../Player"

@export var base_moveSpeed: float = 2000
@export var bounce_force_min: int = 100
@export var bounce_force_max: int = 500

func _ready():
	startpos = position

func _process(delta):
	var old_x: float = 0
	if global_position.x != old_x:
		current_vel = global_position.x - old_x
		old_x = global_position.x
#	if old_x == global_position.x:
#		current_vel = 0

func _physics_process(delta):
	move_speed = random_range(500, base_moveSpeed)
	position = position.move_toward(Vector2(player.position.x,position.y), delta * move_speed)
	var clamp_var_x = get_viewport_rect().size.x / 2 - 195
	position = position.clamp(startpos - Vector2(clamp_var_x, 0), startpos + Vector2(clamp_var_x, 0))
	
	

func random_speed(min_val, max_val):
	var y = randf_range(min_val, max_val)
	return y
	
func random_range(min_val, max_val):
	var x = randf_range(min_val, max_val)
	return x

func _on_area_2d_body_entered(body):
	AudioPlayer.play_sfx("bounce_sfx_1")
	if !body.moving:
		body.moving = true
#	body.velocity.x = move_velocity.x * 2 + random_range(-75, 75)
#	body.velocity.y = random_speed(bounce_force_min, bounce_force_max)
