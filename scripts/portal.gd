extends Area2D

@export var exit_point: Node = null

var not_active: bool = false

func _process(_delta):
	if not_active == true:
		await get_tree().create_timer(1.0).timeout
		not_active = false
	


func _on_body_entered(body):
	if not_active == false:
		AudioPlayer.play_sfx("portal_sfx")
		body.sprite.visible = false
		body.stop_velocity = true
		body.velocity = Vector2(0,0)
		exit_point.not_active = true
		body.global_position = exit_point.global_position
		await get_tree().create_timer(.02).timeout
		body.stop_velocity = false
		body.sprite.visible = true
