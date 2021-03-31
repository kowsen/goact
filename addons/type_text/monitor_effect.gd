extends RichTextEffect
class_name RichTextMonitor

var bbcode = "monitor"

var color_map = {}

func _init(_arg):
	pass

func _process_custom_fx(char_fx):
	if char_fx.elapsed_time == 0:
		color_map[char_fx.absolute_index] = char_fx.color
		return true
	return false
