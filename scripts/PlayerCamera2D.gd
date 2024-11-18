extends Camera2D
##max that the camera can zoom in or out
@export var zoom_clamp: Vector2 = Vector2(0.40,0.40)
#camer start zoom val
var start_camera_zoom: Vector2 = Vector2.ZERO
#bool for if has need to be reset
var can_reset_zoom: bool = false 


func _ready():
	if zoom != Vector2.ZERO:
		start_camera_zoom = zoom

func camera_zoom_out(zoom_out_amount: Vector2, zoom_duration: float):
	if zoom_out_amount > zoom_clamp:
		zoom_out_amount = zoom_clamp
	can_reset_zoom = true
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "zoom", start_camera_zoom - zoom_out_amount, zoom_duration)
	
func  camera_zoom_in(zoom_in_amount: Vector2, zoom_duration: float):
	if zoom_in_amount > zoom_clamp:
		zoom_in_amount = zoom_clamp
	can_reset_zoom = true
	var tween = create_tween()
	tween.set_trans(tween.TRANS_LINEAR)
	tween.tween_property(self, "zoom", start_camera_zoom + zoom_in_amount, zoom_duration)
	
func zoom_reset(zoom_duration: float):
	if can_reset_zoom:
		var tween = create_tween()
		tween.set_trans(tween.TRANS_LINEAR)
		tween.tween_property(self, "zoom" , start_camera_zoom, zoom_duration)
		can_reset_zoom = false
