class_name RxTransition

var time: float
var transition_type: int
var ease_type: int

func _init(_time: float, _transition_type: int = Tween.TRANS_QUAD, _ease_type: int = Tween.EASE_IN_OUT):
	time = _time
	transition_type = _transition_type
	ease_type = _ease_type
