extends Area2D

##the end point of travel path
@export var destination: Vector2
##the amount  of time it takes to travel between beginning and end points
@export var duration: float = 1.0
##waite time at start point
@export var wait_time_1: float = 0.0
##waite time at end point
@export var wait_time_2: float = 0.0
##time untill player exits level
@export var time_till_exit = 0.5
##the current level before level += 1
@export var current_lvl = 1
##amount to increase current level
@export var amount_to_increase: int = 1
#onready vars
@onready var level = $".."
@onready var animaytion_player = $AnimationPlayer
#signels
signal player_exit

func _ready():
	animaytion_player.play("Start")
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_interval(wait_time_1)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_interval(wait_time_2)
	tween.tween_property(self, "global_position", global_position, duration)

func _on_body_entered(body):
	animaytion_player.play("vortex")
	if GameController.current_lvl <= current_lvl:
		GameController.current_lvl = GameController.current_lvl + amount_to_increase
	GameController.coins += level.coins_this_level
	body.stop_velocity = true
	body.velocity = Vector2(0,0)
	body.sprite.visible = false
	AudioPlayer.play_sfx("portal_sfx")
	GameController.save_game()
	GameController.my_log("Player enterd")
	await animaytion_player.animation_finished
	player_exit.emit()
	await get_tree().create_timer(time_till_exit).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
