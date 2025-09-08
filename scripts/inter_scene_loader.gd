extends Control

@onready var portal_wheel_of: Sprite2D = $PortalWheelOf
@onready var progress_bar: ProgressBar = $ProgressBar

signal scene_loaded(path: String)

var path: String
var progress_value := 0.0

func load(path_to_string: String):
	path = path_to_string
	ResourceLoader.load_threaded_request(path)
	
func _process(delta: float) -> void:
	if not path:
		print("no path found")
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(path, progress)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_value = progress[0] * 100
		progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		progress_value = progress[0] * 100
		progress_bar.value = move_toward(progress_bar.value, 100.0, delta * 150) 
		
	if progress_bar.value >= 99:
		scene_loaded.emit(path)
