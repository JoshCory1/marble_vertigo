extends Area2D

@export var time_till_exit = 0.8
@export var current_lvl = 1


func _on_body_entered(body):
	if GameController.current_lvl <= current_lvl:
		GameController.current_lvl = GameController.current_lvl + 1

	AudioPlayer.play_sfx("portal_sfx")

	body.stop_velocity = true
	body.velocity = Vector2(0,0)
	body.sprite.visible = false
	await get_tree().create_timer(time_till_exit).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	print("Player entered")
