extends Area2D

signal coin_pickup

func _on_body_entered(_body):
	AudioPlayer.play_sfx("coin_sfx")
	coin_pickup.emit()
	#await get_tree().create_timer(.2).timeout
	queue_free()
