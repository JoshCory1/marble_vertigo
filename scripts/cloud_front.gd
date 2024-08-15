extends StaticBody2D

## sets time for next snowflake
@export var next_snowflake: float = 1.4

## sets time for snowflake timeout
@export var snowflake_timeout: float = 60.0

# refrnce to snowflake
var snowflake = preload("res://scenes/snow_flake.tscn")

#refrence to SpawnPositions node
@onready var spawn_positions = $SpawnPositions

# refrence to timer
@onready var timer = $Timer

func _ready():
	timer.wait_time = next_snowflake

func spawn_snowflake():
	var spawn_positions_array = spawn_positions.get_children()
	var random_spawn_positions = spawn_positions_array.pick_random()
	var snowflake_instance = snowflake.instantiate()
	
	snowflake_instance.position = random_spawn_positions.position
	snowflake_instance.timer_set_point = snowflake_timeout
	add_child(snowflake_instance)


func _on_timer_timeout():
	spawn_snowflake()
