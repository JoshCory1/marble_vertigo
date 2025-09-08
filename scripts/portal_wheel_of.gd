extends Sprite2D

#onready vars
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	var vewport = get_viewport_rect().size
	position = vewport / 2
	
func animation_start():
	animation_player.play("wheel")
	
func animation_stop():
	animation_player.play("RESET")

func full_marble():
	animation_player.play("full")
