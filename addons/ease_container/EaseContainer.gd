tool
extends Control

export var transition: float

onready var _projected_container := Rx.new(null)
onready var _child_size := Rx.new(rect_size)
onready var _child_position := Rx.new(Vector2.ZERO)
onready var _last_transform = get_global_transform()

func _ready():
	set_notify_transform(true)
	var children = get_children()
	assert(children.size() == 1, "EaseContainers must have a single child")

	var rx_transition = RxTransition.new(transition) if transition else null

	Rx.combine([_child_size, _projected_container], [
		RxMap.new(funcref(self, "_get_size"))
	]).keep_alive(self).attach(children[0], "rect_size", rx_transition)

	Rx.combine([_child_position, _projected_container], [
		RxMap.new(funcref(self, "_get_position"))
	]).keep_alive(self).attach(children[0], "rect_position", rx_transition)

	connect("item_rect_changed", self, "_on_resize")

func project(other, skip_transition = false):
	_projected_container.set_value(other, skip_transition)

func unproject(skip_transition = false):
	_projected_container.set_value(null, skip_transition)

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_last_transform = get_global_transform()

func _on_resize():
	var position_offset = _last_transform.xform(Vector2.ZERO) - get_global_transform().xform(Vector2.ZERO)
	_child_position.set_value(position_offset, true)
	_child_position.value = Vector2(0, 0)
	_child_size.value = rect_size

func _get_size(args):
	var child_size = args[0]
	var projected_container = args[1]
	if projected_container:
		return projected_container._child_size.value
	else:
		return child_size

func _get_position(args):
	var child_position = args[0]
	var projected_container = args[1]
	if projected_container:
		return projected_container.get_global_transform().xform(Vector2.ZERO) - get_global_transform().xform(Vector2.ZERO)
	else:
		return child_position

func _get_configuration_warning() -> String:
	if get_children().size() > 1:
		return "EaseContainers only function correctly with a single child."
	else:
		return ""
