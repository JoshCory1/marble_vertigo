extends RayCast2D

# player reference
@onready var player = $".."

# bool to stop bounce
var dont_bounce: bool = false

## time untill player can bounce again
@export var bounce_timer: float = .2

## min bounce
@export var min_bounce: float = 300
## max bounce
@export var max_bounce: float = 450

func _process(_delta):
	if player:
		if !dont_bounce:
			if is_colliding():
				dont_bounce = true
				player.bounce_up(min_bounce,max_bounce)
				if player.pause_y:
					player.pause_y = false
				if player.stop_contorls:
					player.stop_contorls = false
				await get_tree().create_timer(bounce_timer).timeout
				dont_bounce = false
