extends StaticBody2D

## Time uintill object gos active as deth zone
@export var time_till_active: int = 3

## Time that object remains active as death zone
@export var active_time: float = 1.5 
## Time untill timer starts
@export var time_till_start: float = 2
#  bounce force min and max
@export var bounce_force_min = 300
@export var bounce_force_max = 450

# animation reference
@onready var animation_player = $AnimationPlayer
# timer reference
@onready var timer = $Timer
# jump box reference
@onready var jump_box = $JumpBox

func _ready():
	$FireParticles2D.visible = false
	$FireParticles2D2.visible = false
	$FireParticles2D3.visible = false
	$FireParticles2D4.visible = false
	$FireParticles2D5.visible = false
	jump_box.bounce_force_min = bounce_force_min
	jump_box.bounce_force_max = bounce_force_max
	timer.wait_time = time_till_active
	await get_tree().create_timer(time_till_start).timeout
	timer.start()
	SetNotActive()

func _process(_delta):
	SetActive()


func SetActive():
	if timer.time_left <= 0:
		$FireParticles2D.visible = true
		$FireParticles2D2.visible = true
		$FireParticles2D3.visible = true
		$FireParticles2D4.visible = true
		$FireParticles2D5.visible = true
		if animation_player.current_animation != "RedActive":
			animation_player.play("RedActive")
		set_collision_layer_value(3, true)
		set_collision_layer_value(2, false)
		await get_tree().create_timer(active_time).timeout
		SetNotActive()

func SetNotActive():
	$FireParticles2D.visible = false
	$FireParticles2D2.visible = false
	$FireParticles2D3.visible = false
	$FireParticles2D4.visible = false
	$FireParticles2D5.visible = false
	timer.start()
	if animation_player.current_animation != "Default":
		animation_player.play("Default")
	set_collision_layer_value(3, false)
	set_collision_layer_value(2, true)
	
