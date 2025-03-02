extends CharacterBody2D
##var that contoles speed
@export var speed_var: float = 6000
##var that contoles gravity
@export var gravity: float = 8.0
##the max speed for gravity var
@export var max_fall_velocity: float = 300.0
##a time delay for bounce effect
@export var bounceing_time_delay: float = 0.5
##duration for camera zoom efect how long it takes to get to max zoom effect
@export var camera_zoom_duration: float = 1.5
##amount that camera zooms in or out
@export var zoom_velocity: Vector2 = Vector2(0.10, 0.10)
#onready vars
@onready var death_particles = $PlayerParticles2D
@onready var sprite = $Sprite2D
@onready var animation_player = $PlayerAnimationPlayer
@onready var boosts = get_tree().get_nodes_in_group("boost_x")
@onready var camera = $PlayerCamera2D
@onready var control_timer = $ControlTimer
#bounce vars
var no_bounce_x: int = 0
var no_bounce_y: int = 0
#debug mode
var debug_mode = false
var debug: bool = false
#velocity vars
var stop_velocity: bool = false 
var use_accelerometer: bool = false
var accelerometer_speed: float = 130.0
var speed: float = 0.0
#control vars
var pause_y: bool = false
var stop_contorls: bool = false
var ghost: bool = false

func _ready():
	for boost in boosts:
		boost.y_lock_releasing.connect(_on_y_lock_releasing)
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true
		
func _input(_event):
	if debug_mode == true:
		if Input.is_action_just_pressed("debug"):
			debug = !debug
			
func _process(_delta):
	if ghost:
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
	if !ghost:
		$CollisionShape2D.disabled = false
		$Area2D/CollisionShape2D.disabled = false
			
	if GameController.debug:
		debug_mode = true
	else:
		debug_mode = false

func _physics_process(delta):
	if !stop_velocity:
		if debug == false:
			if use_accelerometer:
				var mobile_input = Input.get_accelerometer()
				if !stop_contorls:
					var direction = mobile_input.x
					if direction > 1:
						direction = 1
					if direction < -1:
						direction = -1
					if direction:
						velocity.x = direction * accelerometer_speed
					else:
						velocity.x = move_toward(velocity.x, 0, accelerometer_speed / 200)
			else:
				if !stop_contorls:
					var direction = Input.get_axis("move_left", "move_right")
					if direction > 0:
						speed = speed_var
						velocity.x = speed * delta
					elif direction < 0:
						speed = -speed_var
						velocity.x = speed * delta
					elif Input.is_action_just_pressed("stop_move"):
						velocity.x = 0
			if !pause_y:
				velocity.y += gravity
				if velocity.y > max_fall_velocity:
					velocity.y = max_fall_velocity
		else:
			velocity = Vector2(0,0)
			if Input.is_action_pressed("move_up"):
				velocity.y -= speed_var * 10 * delta
			if Input.is_action_pressed("move_down"):
				velocity.y += speed_var * 10 * delta
			if Input.is_action_pressed("move_left"):
				velocity.x -= speed_var * 10 * delta
			if Input.is_action_pressed("move_right"):
				velocity.x += speed_var * 10 * delta
		camera_zoom()
		move_and_slide()
	

func camera_zoom():
	if velocity.x > 80.0 && velocity.x < 300.0:
		camera.camera_zoom_out(zoom_velocity, camera_zoom_duration)
	elif velocity.x < -80.0 && velocity.x > -300.0:
		camera.camera_zoom_out(zoom_velocity, camera_zoom_duration)
	elif velocity.x > 300 && velocity.x < 600:
		camera.camera_zoom_out(zoom_velocity + Vector2(0.15,0.15),camera_zoom_duration - 0.5)
	elif velocity.x < -300 && velocity.x > -600.0:
		camera.camera_zoom_out(zoom_velocity + Vector2(0.15,0.15),camera_zoom_duration - 0.5)
	elif velocity.x > 600:
		camera.camera_zoom_out(zoom_velocity + Vector2(0.25,0.25),camera_zoom_duration - 1.0)
	elif velocity.x < -600:
		camera.camera_zoom_out(zoom_velocity + Vector2(0.25,0.25),camera_zoom_duration - 1.0)
	elif velocity.x < 80.0 || velocity.x > -80.0:
		camera.zoom_reset(camera_zoom_duration)

func bounce_up(min_b: int, max_b: int):
	if debug == false:
		AudioPlayer.play_sfx("bounce_sfx_1")
		velocity.y = -random_bounce(min_b, max_b)

func bounce_down(min_b: int, max_b: int):
	AudioPlayer.play_sfx("bounce_sfx_1")
	velocity.y = random_bounce(min_b, max_b)
	
	
func bounce_left(min_b: int, max_b: int):
	AudioPlayer.play_sfx("bounce_sfx_2")
	velocity.x = -random_bounce(min_b, max_b)
	if stop_contorls:
		control_timer.start()

func bounce_right(min_b: int, max_b: int):
	AudioPlayer.play_sfx("bounce_sfx_2")
	velocity.x = random_bounce(min_b, max_b)
	if stop_contorls:
		control_timer.start()

func random_bounce(min_boune: int, max_boune: int):
	var new_bounce_velocity
	new_bounce_velocity = randi_range(min_boune,max_boune)
	return new_bounce_velocity

func _on_y_lock_releasing():
	if pause_y:
		pause_y = false
	if stop_contorls:
		stop_contorls = false

func _on_control_timer_timeout() -> void:
	if stop_contorls:
		stop_contorls = false

func _on_area_2d_body_entered(_body):
	if !debug_mode:
		die()
	elif debug_mode:
		if gravity > 0:
			bounce_up(300, 450)
		elif gravity < 0:
			bounce_down(300,450)

func die():
	if !debug:
		get_tree().paused = true
		AudioPlayer.play_sfx("shatter_sfx")
		death_particles.emitting = true
		sprite.visible = false
		GameController.my_log("Died!!")
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
#		get_tree().reload_current_scene()

	# Skins

func use_default_skin():
	if animation_player.current_animation != "default":
		animation_player.play("default")
	
	if sprite:
		sprite.texture = preload("res://assets/ball/ball_blue_large_alt.png")

func use_cube_skin():
	if animation_player.current_animation != "cube":
		animation_player.play("cube")
	
	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v3.png")

func use_spin_skin():
	if animation_player.current_animation != "spin":
		animation_player.play("spin")

	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v19.png")

func  use_puzzle_skin():
	if animation_player.current_animation != "Puzzle":
		animation_player.play("Puzzle")
		
	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v4.png")

func use_infinty_skin():
	if animation_player.current_animation != "Infinty":
		animation_player.play("Infinity")
		
	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v5.png")

func  use_circle_skin():
	if animation_player.current_animation != "circle":
		animation_player.play("circle")
		
	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v2.png")

func  use_star_skin():
	if animation_player.current_animation != "star":
		animation_player.play("star")
		
	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v6.png")

func use_crystel_skin():
	if animation_player.current_animation != "crystel":
		animation_player.play("crystel")
	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v7.png")

func use_billiards_skin():
	if animation_player.current_animation != "billiards":
		animation_player.play("billiards")
		
	if sprite:
		sprite.texture = preload("res://assets/ball/marble_v8.png")
