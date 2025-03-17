extends Node2D

signal start_level

#onredy vars
@onready var mobile_directions = $CanvasLayerDirections/MobileDirections
@onready var directions_lable = $CanvasLayerDirections/DirectionLable
@onready var ok_button = $CanvasLayerDirections/Button
@onready var canvas_layer_directions = $CanvasLayerDirections

#system vars
var is_canvas_visible: bool = false

func _ready():
	mobile_directions.visible = false
	directions_lable.visible = false
	ok_button.visible = false
	var viewport = get_viewport_rect().size
	mobile_directions.position.x = viewport.x / 2
	#mobile_directions.position.y = 0 + viewport.y / 5 
	directions_lable.position.x = viewport.x / 2 - (directions_lable.size.x / 2)
	#directions_lable.position.y =  0 + viewport.y / 2
	ok_button.position.x = viewport.x / 2 - (ok_button.size.x)
	#ok_button.position.y = 0 + viewport.y / 1.5

func _process(_delta: float):
	if is_canvas_visible:
		mobile_directions.visible = true
		directions_lable.visible = true
		ok_button.visible = true
	else:
		canvas_layer_directions.visible = false

func _on_button_pressed():
	is_canvas_visible = false
	start_level.emit()
