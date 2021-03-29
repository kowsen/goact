extends Node

var _is_ready = false
var _tweens_to_add = []

func _ready():
	_is_ready = true
	for tween in _tweens_to_add:
		add_child(tween)

func get_tween():
	var tween = Tween.new()
	if !_is_ready:
		_tweens_to_add.push_back(tween)
	else:
		add_child(tween)
	return tween