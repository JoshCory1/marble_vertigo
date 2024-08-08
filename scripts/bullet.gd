extends AnimatableBody2D

@export var speed: float = 125.0

func _physics_process(delta):
	global_position.x += speed * delta
	

func _on_timer_timeout():
	queue_free()
