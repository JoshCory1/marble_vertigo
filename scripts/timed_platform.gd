extends StaticBody2D

## Time uintill object gos active as deth zone
@export var time_till_active: int = 3

## Time that object remains active as death zone
@export var active_time: float = 1.5 
## Time untill timer starts
@export var time_till_start: float = 2

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer


func _ready():
	timer.wait_time = time_till_active
	await get_tree().create_timer(time_till_start).timeout
	timer.start()
	SetNotActive()
	

func _process(_delta):
	$Sprite2D/Label.text = str(snappedi(timer.time_left, 0))
	$Sprite2D/Label2.text = str(snappedi(timer.time_left, 0))
	$Sprite2D/Label3.text = str(snappedi(timer.time_left, 0))
	$Sprite2D/Label4.text = str(snappedi(timer.time_left, 0))
	$Sprite2D/Label5.text = str(snappedi(timer.time_left, 0))
	SetActive()
	

func SetActive():
	if timer.time_left <= 0:
		$Sprite2D/Label/ActiveFireWave.emitting = true
		$Sprite2D/Label2/ActiveFireWave2.emitting = true
		$Sprite2D/Label3/ActiveFireWave2.emitting = true
		$Sprite2D/Label4/ActiveFireWave2.emitting = true
		$Sprite2D/Label5/ActiveFireWave2.emitting = true
		if animation_player.current_animation != "RedActive":
			animation_player.play("RedActive")
		set_collision_layer_value(3, true)
		set_collision_layer_value(2, false)
		await get_tree().create_timer(active_time).timeout
		SetNotActive()

func SetNotActive():
	$Sprite2D/Label/ActiveFireWave.emitting = false
	$Sprite2D/Label2/ActiveFireWave2.emitting = false
	$Sprite2D/Label3/ActiveFireWave2.emitting = false
	$Sprite2D/Label4/ActiveFireWave2.emitting = false
	$Sprite2D/Label5/ActiveFireWave2.emitting = false
	timer.start()
	if animation_player.current_animation != "Default":
		animation_player.play("Default")
	set_collision_layer_value(3, false)
	set_collision_layer_value(2, true)
	
