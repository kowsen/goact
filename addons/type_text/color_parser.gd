class_name ColorParser

class TagSkipInfo:
	var min_index: int
	var amount: int

class ColorInfo:
	var color: Color
	var chars: Array

var DEFAULT_COLOR := Color8(0xff, 0xff, 0xff, 0)
var REGEX := RegEx.new()

var _color_info := []
var _skip_info := []

func _init():
	REGEX.compile("\\[([^\\]]*)\\]")
	parse("Test [color=red]Test2[/color] Test3")

func parse(text: String):
	var results = REGEX.search_all(text)
	print(_reverse_index(16, results))
	print(_reverse_index(15, results))
	print(_reverse_index(4, results))
	print(_reverse_index(5, results))
	# print(ArrayUtil.map(results, "x => x.get_start()"))
	# print(ArrayUtil.map(results, "x => x.get_end()"))
	# print(ArrayUtil.map(results, "x => x.get_string()"))
	pass
	# populate _skip_info
	# populate _color_info

func get_color(index: int):
	var translated_index = _translate_index(index)
	for color in _color_info:
		if color.chars.has(translated_index):
			return color.color
	return DEFAULT_COLOR

func _reverse_index(raw_index: int, matches: Array):
	var reversed_index = raw_index
	for val in matches:
		if val.get_end() <= raw_index:
			reversed_index -= (val.get_end() - val.get_start())
	return reversed_index

func _translate_index(index: int):
	var translated_index = index
	for skip in _skip_info:
		if index >= skip.min_index:
			translated_index += skip.amount
	return translated_index
