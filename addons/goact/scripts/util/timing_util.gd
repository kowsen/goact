extends Node

var _is_ready = false

func _ready():
	_is_ready = true

func wait_frame():
	if !_is_ready:
		yield(self, "ready")
	yield(get_tree(), "idle_frame")

func wait_time(time):
	if !_is_ready:
		yield(self, "ready")
	yield(get_tree().create_timer(time), "timeout")
