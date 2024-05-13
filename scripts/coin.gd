extends Area2D

signal coin_pickup

func _on_body_entered(_body):
	coin_pickup.emit()
	queue_free()
