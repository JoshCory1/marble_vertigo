extends CharacterBody2D

var area_ent = false
var touchpos = Vector2()
var newdeltax: float
var newdeltay: float
var startpos: Vector2 = Vector2(0, 0)
var dragging = false
var deltax: float
var deltay: float
var move_velocity: Vector2 = Vector2()
var current_vel: float = 0


@export var bounce_force_min: int = 100
@export var bounce_force_max: int = 500
@export var reternSpeed: float = 300
@export var movetospeed: float = 600
@export var screen_clamp: Vector2 = Vector2(600, 0)

func _ready():
	startpos.x = get_viewport_rect().size.x / 2
	startpos.y = get_viewport_rect().size.y - 30
	screen_clamp.x = (get_viewport_rect().size.x / 2) - 190

func _process(_delta):
	var old_x: float = 0
	if global_position.x != old_x:
		current_vel = global_position.x - old_x
		old_x = global_position.x
#	if old_x == global_position.x:
#		current_vel = 0
	print("pillar x velocity is : " + str(current_vel))

func _input(event):
		if area_ent == true:
			if event is InputEventScreenTouch and event.is_pressed():
				#AudioPlayer.play_sfx("pillar_move_sfx")
				touchpos = get_global_mouse_position()
				deltax = touchpos.x - position.x
				deltay = touchpos.y - position.y
				
			elif event is InputEventScreenDrag:
				touchpos = get_global_mouse_position()
				newdeltax = touchpos.x - deltax
				newdeltay = touchpos.y - deltay
				dragging = true

func _physics_process(delta):
	var current_x = global_position.x - get_viewport_rect().size.x / 2
	if dragging == true:
		move_velocity.x = current_x + 22
		global_position = global_position.move_toward(Vector2(newdeltax,newdeltay), delta * movetospeed)
		global_position = global_position.clamp(startpos - screen_clamp, startpos + screen_clamp)
	if area_ent == false:
		dragging=false
		position = position.move_toward(Vector2(startpos.x, startpos.y), delta * reternSpeed)
		#move_velocity.x = 0
	

#func random_speed(min_val, max_val):
#	var n = randf_range(min_val, max_val)
#	return n
#
#func random_x_range(min_val, max_val):
#	var x = randf_range(min_val, max_val)
#	return x

func _on_touch_screen_button_pressed():
	area_ent = true


func _on_touch_screen_button_released():
	area_ent = false


func _on_area_2d_body_entered(body):
	AudioPlayer.play_sfx("bounce_sfx_1")
	if !body.moving:
		body.moving = true
	
#	body.velocity.x = move_velocity.x * 2 + random_x_range(-75, 75)
#	body.velocity.y -= 300
	
