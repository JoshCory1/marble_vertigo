extends CanvasLayer

@onready var console = $Debug/ConsoleLog
@onready var log_lable = $Debug/ConsoleLog/ScrollContainer/VBoxContainer/LogLabel


func _ready():
	console.visible = false	


func _on_toggle_console_pressed():
	console.visible = !console.visible
	
