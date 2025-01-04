extends AnimatableBody2D

@export var speed: float = 125.0

func _physics_process(delta):
	global_position.x += speed * delta
	

func _on_timer_timeout():
	queue_free()

func explode():
	$GPUParticles2D.emitting = false
	$Sprite2D.visible = false
	$GPUParticles2D2.emitting = true
	await get_tree().create_timer(0.2).timeout
	queue_free()
