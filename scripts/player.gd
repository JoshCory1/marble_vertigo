extends CharacterBody2D


@export var speed_var: float = 300

@export var gravity: float = 8.0
@export var max_fall_velocity: float = 300.0
@export var bounceing_time_delay: float = 0.5

@onready var death_particles = $PlayerParticles2D
@onready var sprite = $Sprite2D
@onready var animation_player = $PlayerAnimationPlayer

var no_bounce: bool = false
var debug_mode = false
var stop_velocity: bool = false 
var debug: bool = false
var accelerometer_speed: float = 130.0
var use_accelerometer: bool = false
var speed: float = 0.0



func _ready():
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true
		
func _input(_event):
	if debug_mode == true:
		if Input.is_action_just_pressed("debug"):
			debug = !debug
			
func _process(_delta):
	_on_no_bounce()
	if GameController.debug:
		debug_mode = true
	else:
		debug_mode = false

func _physics_process(_delta):
	if debug == false && stop_velocity == false:
		if use_accelerometer == true:
			var mobile_input = Input.get_accelerometer()
			var direction = mobile_input.x
			if direction > 3:
				direction = 3
			if direction < -3:
				direction = -3
			if direction:
				velocity.x = direction * accelerometer_speed
			else:
				velocity.x = move_toward(velocity.x, 0, accelerometer_speed / 200)
		else:
			var direction = Input.get_axis("move_left", "move_right")
			if direction > 0:
				speed = speed_var
				velocity.x = speed / 2
			elif direction < 0:
				speed = -speed_var
				velocity.x = speed / 2
			elif Input.is_action_just_pressed("stop_move"):
				velocity.x = 0 
			

		velocity.y += gravity
		if velocity.y > max_fall_velocity:
			velocity.y = max_fall_velocity
	else:
		velocity = Vector2(0,0)
		if Input.is_action_pressed("move_up"):
			velocity.y -= speed_var * 10
		if Input.is_action_pressed("move_down"):
			velocity.y += speed_var * 10
		if Input.is_action_pressed("move_left"):
			velocity.x -= speed_var * 10
		if Input.is_action_pressed("move_right"):
			velocity.x += speed_var * 10
	move_and_slide()


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
	

func bounce_right(min_b: int, max_b: int):
	AudioPlayer.play_sfx("bounce_sfx_2")
	velocity.x = random_bounce(min_b, max_b)
	

func random_bounce(min_boune: int, max_boune: int):
	var new_bounce_velocity
	new_bounce_velocity = randi_range(min_boune,max_boune)
	return new_bounce_velocity

func random_bounce_sound():
	randf()
	pass

func _on_area_2d_body_entered(_body):
	die()

func die():
	no_bounce = false
	if debug == false:
		get_tree().paused = true
		AudioPlayer.play_sfx("shatter_sfx")
		death_particles.emitting = true
		sprite.visible = false
		GameController.my_log("Died!!")
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/start.tscn")
		
func _on_no_bounce():
	if no_bounce == true:
		await get_tree().create_timer(.2).timeout
		if no_bounce == true:
			die()
	else:
		pass
		
		
	
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


