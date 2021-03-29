extends Node

class_name RxDebounce

var is_async = true

var _iteration = 0

func run(value):
	_iteration += 1
	var current = _iteration
	yield(TimingUtil.wait_frame(), "completed")
	return RxOperatorResult.new(value, current == _iteration)
