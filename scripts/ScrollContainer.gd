extends ScrollContainer
#onready vars
@onready var scrollbar = self.get_v_scroll_bar()
@onready var log_lable = $VBoxContainer/LogLabel
#system vars
var max_scroll_length = 0

func _ready():
	#Auto scrolling
	scrollbar.changed.connect(handle_scrollbar_changed)
	max_scroll_length = scrollbar.max_value


func handle_scrollbar_changed():
	if max_scroll_length != scrollbar.max_value:
		max_scroll_length = scrollbar.max_value
		self.scroll_vertical = max_scroll_length
