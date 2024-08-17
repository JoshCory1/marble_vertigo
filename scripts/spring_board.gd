extends Area2D

##min bounce force amount of player bounce
@export var bounce_force_min: int = 750
##max bounce force amount of player bounce
@export var bounce_force_max: int = 850
#sprite rfrence
@onready var sprite = $AnimatedSprite2D

func _on_body_entered(body):
	if body != null:
		sprite.play("default")
		if body.gravity > 0:
			body.bounce_up(bounce_force_min, bounce_force_max)
			if body.pause_y:
				body.pause_y = false
			if body.stop_contorls:
				body.stop_contorls = false
		elif body.gravity < 0:
			body.bounce_down(bounce_force_min, bounce_force_max)
			if body.pause_y:
				body.pause_y = false
			if body.stop_contorls:
				body.stop_contorls = false
