extends CharacterBody2D

# sprites and animation
@onready var animation_player = $PlayerAnimationPlayer
@onready var sprite = $Sprite2D

# Direction and Gameplay
@export var speed: float = 7
@export var fall_speed: float = 100
@onready var death_particles = $PlayerParticles2D
var moving: bool = false
var stop_velocity: bool = false
var center: Vector2 = Vector2()
var use_accelerometer: bool = false
var accelerometer_speed: float = 130.0
var my_velocity: Vector2 = Vector2()

func _ready():
	center = get_viewport_rect().size / 2
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true
			
func _physics_process(delta):
	if !stop_velocity:
		if !moving:
			velocity.y = fall_speed
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
#		if velocity > Vector2(200,200):
#			velocity = Vector2(200,200)
#		if velocity < Vector2(-200,-200):
#			velocity = Vector2(-200,-200)
		move_and_slide()


func die():
		get_tree().paused = true
		AudioPlayer.play_sfx("shatter_sfx")
		death_particles.emitting = true
		sprite.visible = false
		GameController.my_log("Died!!")
		await get_tree().create_timer(0.05).timeout
		#get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_area_2d_body_entered(_body):
	die()
	
	
	

func _on_area_2d_2_body_entered(body):
	pass
	velocity.x =  (body.global_position.x * 3)  - (global_position.x * 3)
#	if body.current_vel != null:
#		velocity.x = body.current_vel
	if global_position.y > center.y:
		velocity.y = -200
	if global_position.y < center.y:
		velocity.y = 200


func _on_area_2d_3_body_entered(_body):
	if global_position.x > center.x:
		velocity.x -= 50
	if global_position.x < center.x:
		velocity.x += 50
	

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
