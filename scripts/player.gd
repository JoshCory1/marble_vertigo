extends CharacterBody2D


@export var speed_var: float = 10.0
@export var bounce_force_min: int = 300
@export var bounce_force_max: int = 450
@export var gravity: float = 8.0
@export var max_fall_velocity: float = 300.0
@export var bounceing_time_delay: float = 0.5
@export var debug_mode = false

@onready var death_particles = $CPUParticles2D
@onready var sprite = $Sprite2D

var stop_velocity: bool = false 
var debug: bool = false
var accelerometer_speed: float = 130.0
var use_accelerometer: bool = false
var speed: float = 0.0
var is_bounceing: bool = false

func _ready():
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true
		
func _input(_event):
	if debug_mode == true:
		if Input.is_action_just_pressed("debug"):
			debug = !debug

func _process(_delta):
	if is_bounceing == true:
		await get_tree().create_timer(bounceing_time_delay).timeout
		is_bounceing = false


func _physics_process(_delta):
	if debug == false && stop_velocity == false:
		if use_accelerometer == true:
			var mobile_input = Input.get_accelerometer()
			if mobile_input.x > 0:
				speed += speed_var / 10
			if mobile_input.x < 0:
				speed -= speed_var / 10
		else:
			if Input.is_action_pressed("move_left"):
				speed -= speed_var
			if Input.is_action_pressed("move_right"):
				speed += speed_var
		if is_bounceing == false:
				velocity.x = speed

		velocity.y += gravity
		if velocity.y > max_fall_velocity:
			velocity.y = max_fall_velocity
	else:
		velocity = Vector2(0,0)
		if Input.is_action_pressed("move_up"):
			velocity.y = -speed_var * 300
		if Input.is_action_pressed("move_down"):
			velocity.y = speed_var * 300
		if Input.is_action_pressed("move_left"):
			velocity.x = -speed_var * 300
		if Input.is_action_pressed("move_right"):
			velocity.x = speed_var * 300
	move_and_slide()


func bounce_up():
	if debug == false:
		AudioPlayer.play_sfx("bounce_sfx_1")
		velocity.y = -random_bounce(bounce_force_min, bounce_force_max)

func bounce_down():
	AudioPlayer.play_sfx("bounce_sfx_1")
	velocity.y = random_bounce(bounce_force_min, bounce_force_max)

func bounce_left():
	AudioPlayer.play_sfx("bounce_sfx_2")
	velocity.x = -random_bounce(bounce_force_min, bounce_force_max)

func bounce_right():
	AudioPlayer.play_sfx("bounce_sfx_2")
	velocity.x = random_bounce(bounce_force_min, bounce_force_max)

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
	if debug == false:
		get_tree().paused = true
		AudioPlayer.play_sfx("shatter_sfx")
		death_particles.emitting = true
		sprite.visible = false
		print("dead")
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

