extends CharacterBody2D

# sprites and animation
@onready var animation_player = $PlayerAnimationPlayer
@onready var sprite = $Sprite2D

# Direction and Gameplay
@export var speed: float = 200
@onready var death_particles = $PlayerParticles2D
var moving: bool = false
var stop_velocity: bool = false


func _physics_process(delta):
	if !stop_velocity:
		if !moving:
			velocity.y = speed
		move_and_slide()


func die():
		get_tree().paused = true
		AudioPlayer.play_sfx("shatter_sfx")
		death_particles.emitting = true
		sprite.visible = false
		GameController.my_log("Died!!")
		await get_tree().create_timer(0.5).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_area_2d_body_entered(_body):
	die()
	
	
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


