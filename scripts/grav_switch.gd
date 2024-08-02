extends Area2D

# refrence to Animated Sprite
@onready var animation_player = $AnimatedSprite2D

#switch to control time un till it can be activated again
var switch_off: bool = false

## float to control amount of time untill can be active agian
@export var time_till_active: float = 5.0

## bool to contal sprite visability
@export var visibile_sprite: bool = true

func _ready():
	if !visibile_sprite:
		animation_player.visible = false
	if animation_player.animation != "standby":
		animation_player.play("standby")

func _on_body_entered(body):
	if switch_off == false:
		if animation_player.animation != "clicked":
			animation_player.play("clicked")
		switch_off = true
		if visibile_sprite:
			AudioPlayer.play_sfx("grav_switch_sfx")
		body.gravity = -body.gravity
func _process(_delta):
	if switch_off:
		await get_tree().create_timer(time_till_active).timeout
		if animation_player.animation != "standby":
			animation_player.play("standby")
		switch_off = false
