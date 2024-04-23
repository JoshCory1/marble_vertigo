extends ScrollContainer

@onready var scrollbar = self.get_v_scroll_bar()
@onready var log_lable = $VBoxContainer/LogLabel
var max_scroll_length = 0

func _ready():
	# auto scrolling
	scrollbar.changed.connect(handle_scrollbar_changed)
	max_scroll_length = scrollbar.max_value


func handle_scrollbar_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
		self.scroll_vertical = max_scroll_length
		
#		if log_lable.get_line_count() > log_lable.get_line_height(100):
#			log_lable.remove_line(0)
#
