extends StaticBody2D

@export var time_till_free: float = 3.0
@export var min_bounce: float = 300
@export var max_bounce: float = 450

var fade_out: bool = false

@onready var sprite = $Sprite2D
@onready var timer_flash = $TimerFlash

func _process(_delta):
	if fade_out:
		sprite.modulate = Color(1,1,1,0.5)
	else:
		sprite.modulate = Color(1,1,1,1)

func _on_area_2d_up_body_entered(body):
	body.bounce_up(min_bounce, max_bounce)


func _on_area_2d_down_body_entered(body):
	body.bounce_down(min_bounce, max_bounce)


func _on_area_2d_que_free_body_entered(_body):
	timer_flash.start()
	await get_tree().create_timer(time_till_free).timeout
	queue_free()


func _on_timer_flash_timeout():
	fade_out = !fade_out


