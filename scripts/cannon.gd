extends StaticBody2D

## position of bullet relative to cannon
@export var bullet_position_offset: float = -75.0
## speed of the bullet
@export var bullet_speed: float = -125.0
## min rate of bullet fire
@export var min_rate_of_fire: float = 2.0
## max rate of bullet fire
@export var max_rate_of_fire: float = 10.0
## value to mach with sgnal of cannon_triggers
@export var cannon_emit_selection: String = "text here"
# refrence to bullet scene
var bullet_scene = preload("res://scenes/bullet.tscn")
# bool that controles when cannon is active of null
var active: bool = false
# refrence to cannon trigger
@onready var cannon_triggers = get_tree().get_nodes_in_group("CannonTrigger")


func _ready():
	for trigger in cannon_triggers:
		trigger.cannon_active.connect(_on_cannon_active)

func _process(_delta):
	$Timer.wait_time = randf_range(min_rate_of_fire,max_rate_of_fire)

func shoot():
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.speed = bullet_speed
	bullet_instance.global_position.x += bullet_position_offset
	add_child(bullet_instance)
	AudioPlayer.play_sfx("bullet_sfx")
	


func _on_timer_timeout():
	print(cannon_emit_selection + " is: " + str(active))
	if active:
		shoot()

func _on_cannon_active(trigger_string: String, flag: bool):
	if trigger_string == cannon_emit_selection && flag:
		active = true
	elif trigger_string == cannon_emit_selection && !flag:
		active = false
