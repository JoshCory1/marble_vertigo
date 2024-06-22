extends StaticBody2D

## position of bullet relative to cannon
@export var bullet_position_offset: float = -75.0
## speed of the bullet
@export var bullet_speed: float = -125.0
## min rate of bullet fire
@export var min_rate_of_fire: float = 2.0
## max rate of bullet fire
@export var max_rate_of_fire: float = 10.0
# refrence to bullet scene
var bullet_scene = preload("res://scenes/bullet.tscn")

func _process(_delta):
	$Timer.wait_time = randf_range(min_rate_of_fire,max_rate_of_fire)

func shoot():
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.speed = bullet_speed
	bullet_instance.global_position.x += bullet_position_offset
	add_child(bullet_instance)
	


func _on_timer_timeout():
	shoot()


