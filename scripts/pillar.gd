extends CharacterBody2D

var deltax: float
var deltay: float
var touchpos = Vector2()
var areaEnt = false
var newdeltax: float
var newdeltay: float
var startpos: Vector2 = Vector2(0, 0)
var dragging = false

@export var reternSpeed: float = 300
@export var movetospeed: float = 600
@export var screenClamp: Vector2 = Vector2(600, 0)

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	startpos=self.global_position
	
	
func _input(event):
		if areaEnt == true:
			if event is InputEventScreenTouch and event.is_pressed():
				AudioPlayer.play_sfx("pillar_move_sfx")
				touchpos = get_global_mouse_position()
				deltax = touchpos.x - position.x
				deltay = touchpos.y - position.y
				
			elif event is InputEventScreenDrag:
				touchpos = get_global_mouse_position()
				newdeltax = touchpos.x - deltax
				newdeltay = touchpos.y - deltay
				dragging = true
func _physics_process(delta):
	if dragging == true:
		global_position = global_position.move_toward(Vector2(newdeltax,newdeltay), delta * movetospeed)
		global_position = global_position.clamp(startpos - screenClamp, startpos + screenClamp)
	if areaEnt == false:
		dragging=false
		position = position.move_toward(Vector2(startpos.x, startpos.y), delta * reternSpeed)
		
	
		#self.global_position=startpos

func _on_touch_screen_button_pressed():
	areaEnt = true

func _on_touch_screen_button_released():
	areaEnt = false


func _on_area_bounce_up_body_entered(body):
	if body != null:
		body.bounce_up()
		body.is_bounceing = true
		


func _on_area_bounce_down_body_entered(body):
	if body != null:
		body.bounce_down()
		body.is_bounceing = true


func _on_area_bounce_left_body_entered(body):
	if body != null:
		body.bounce_left()
		body.is_bounceing = true

func _on_area_bounce_right_body_entered(body):
	if body != null:
		body.bounce_right()
		body.is_bounceing = true
