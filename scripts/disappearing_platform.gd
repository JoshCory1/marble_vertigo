extends StaticBody2D
##the amount of time until the platform disappears
@export var time_till_disabled: float = 4.0
##the amount of time until the platform reappears
@export var time_till_enabled: float = 10.0
##the min bounce of marble
@export var min_bounce: float = 300
##the max bounce of marble
@export var max_bounce: float = 450

#var that controls fade effect
var fade_out: bool = false

#on ready vars
@onready var sprite = $Sprite2D
@onready var timer_flash = $TimerFlash

func _process(_delta):
	
	if fade_out:
		sprite.modulate = Color(1,1,1,0.5)
	else:
		sprite.modulate = Color(1,1,1,1)

func _on_area_2d_up_body_entered(body):
	body.bounce_up(min_bounce, max_bounce)
	if body.pause_y:
			body.pause_y = false
	if body.stop_contorls:
		body.stop_contorls = false


func _on_area_2d_down_body_entered(body):
	body.bounce_down(min_bounce, max_bounce)
	if body.pause_y:
			body.pause_y = false
	if body.stop_contorls:
		body.stop_contorls = false

	
func _on_area_2d_disable_body_entered(_body):
	timer_flash.start()
	await get_tree().create_timer(time_till_disabled).timeout
	_on_disable()


func _on_timer_flash_timeout():
	fade_out = !fade_out

func _on_disable():
	timer_flash.stop()
	if fade_out:
		fade_out = false
	sprite.visible = false
	$CollisionShape2D.disabled = true
	$Area2DUp/CollisionShape2D.disabled = true
	$Area2DDown/CollisionShape2D.disabled = true
	$Area2DDisable/CollisionShape2D.disabled = true
	await get_tree().create_timer(time_till_enabled).timeout
	sprite.visible = true
	$CollisionShape2D.disabled = false
	$Area2DUp/CollisionShape2D.disabled = false
	$Area2DDown/CollisionShape2D.disabled = false
	$Area2DDisable/CollisionShape2D.disabled = false




