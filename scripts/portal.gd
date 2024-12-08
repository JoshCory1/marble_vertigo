extends Area2D

## portal that this portal exits to
@export var exit_point: Node = null
## bool that controles sprite Visibility
@export var visible_sprite: bool = true
#onready vars
@onready var sprite = $Sprite2D


var not_active: bool = false

func _ready():
	if !visible_sprite:
		sprite.visible = false

func _process(_delta):
	if not_active == true:
		await get_tree().create_timer(1.0).timeout
		not_active = false
	


func _on_body_entered(body):
	if !not_active:
		if exit_point:
			AudioPlayer.play_sfx("portal_sfx")
			body.sprite.visible = false
			exit_point.not_active = true
			body.ghost = true
			body.global_position = exit_point.global_position
			body.ghost = false
			body.velocity = Vector2(0,0)
			body.sprite.visible = true
