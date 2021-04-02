class_name ColorParser

class ColorInfo:
	var color: Color
	# Inclusive
	var start: int
	# Exclusive
	var end: int

var DEFAULT_COLOR := Color8(0xff, 0xff, 0xff, 0)
var REGEX := RegEx.new()

var _color_info := []

func _init():
	REGEX.compile("\\[([^\\]]*)\\]")

func parse(text: String):
	_color_info = []
	var results = REGEX.search_all(text)
	var stack = []
	for result in results:
		var parsed = _parse_tag(result.get_string(1))
		if parsed is ColorInfo:
			parsed.start = _reverse_index(result.get_end(), results)
			stack.push_back(parsed)
		elif parsed == "close":
			var finished = stack.pop_back()
			finished.end = _reverse_index(result.get_start(), results)
			_color_info.push_back(finished)

func get_color(index: int, default := DEFAULT_COLOR):
	for color in _color_info:
		if color.start <= index && color.end > index:
			return color.color
	return default

func _reverse_index(raw_index: int, matches: Array):
	var reversed_index = raw_index
	for val in matches:
		if val.get_end() <= raw_index:
			reversed_index -= (val.get_end() - val.get_start())
	return reversed_index

# Returns ColorInfo if start, close if end, null if other tag
func _parse_tag(tag: String):
	var split_tag = tag.split("=")
	
	if split_tag[0] != "color" && split_tag[0] != "/color":
		return null
	
	if split_tag.size() == 1:
		return "close"
	
	var str_color = split_tag[1]
	var color = Color(str_color) if str_color.substr(0, 1) == "#" else ColorN(str_color)

	var info = ColorInfo.new()
	info.color = color
	return info
