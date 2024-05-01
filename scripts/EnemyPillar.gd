extends CharacterBody2D


var move_velocity: Vector2 = Vector2()
var move_speed: float = 0
var startpos: Vector2 = Vector2()

@onready var player = $"../Player"

@export var base_moveSpeed: float = 400
@export var bounce_force_min: int = 500
@export var bounce_force_max: int = 650

func _ready():
	startpos = position

func _physics_process(delta):
	move_speed = random_range(0, base_moveSpeed)
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
	body.velocity.x = move_velocity.x * 2 + random_range(-75, 75)
	body.velocity.y = random_speed(bounce_force_min, bounce_force_max)
