extends Camera2D

@export var movetospeed=600
@export var reternSpeed: float = 0

@onready var n_marker = $"../NegativeMarker"
@onready var p_marker = $"../PositiveMarker"
@onready var buttons = get_tree().get_nodes_in_group("LevelButtons")
@onready var main = $".."

var touchpos = Vector2(0,0)
var deltax: float
var deltay: float
var newdeltax:float
var newdeltay: float
var dragging: bool
var startpos: Vector2 = Vector2(0,0)
var screenClamp: Vector2 = Vector2(9000, 9000)
var areaEnt: bool
var stop_camera: bool = false

func _ready():
	for button in buttons:
		button.camera_scroll_off.connect(_on_buttons_camera_scroll_off)
	main.freeze_camera.connect(_on_freeze_camera)
	main.unfreeze_camera.connect(_on_unfreeze_camera)

func _input(event):
	if stop_camera == false:
		if event is InputEventScreenTouch and event.is_pressed:
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
		global_position = global_position.move_toward(Vector2(newdeltax,newdeltay), delta * -movetospeed)
		global_position = global_position.clamp(startpos + n_marker.global_position, startpos + p_marker.global_position)
	if areaEnt == false:
		dragging=false
		position = position.move_toward(Vector2(startpos.x, startpos.y), delta * reternSpeed)
		
		
func _on_buttons_camera_scroll_off():
	stop_camera = true
		
func _on_freeze_camera():
	stop_camera = true
	
func _on_unfreeze_camera():
	stop_camera = false
