class_name Rx

signal update_attempt
signal update_internal
signal update

var value = null setget set_value
var _raw_value
var _attach_manager: RxAttach
var _operators: Array

func _init(start_value, operators: Array = []):
	_operators = operators
	set_value(start_value)
	_attach_manager = RxAttach.new(value)
	connect("update_internal", _attach_manager, "update")

func set_value(new_value, skip_transition = false):
	emit_signal("update_attempt", new_value)
	_raw_value = new_value
	for operator in _operators:
		var result = yield(operator.run(new_value), "completed") if operator.is_async else operator.run(new_value)
		if result.is_valid:
			new_value = result.value
		else:
			return
	value = new_value
	emit_signal("update_internal", value, skip_transition)
	emit_signal("update", value)

func attach(node: Node, prop: String, transition: RxTransition = null):
	_attach_manager.attach(node, prop, transition)

func pipe(operators: Array = []):
	var derived = get_script().new(value, operators)
	connect("update_internal", derived, "set_value")
	return derived

func keep_alive(container: Object):
	RxLifecycle.manage(self, container)
	return self

func _combined_value_set(partial_value, skip_transition, index):
	var new_value = _raw_value.duplicate()
	new_value[index] = partial_value
	set_value(new_value, skip_transition)

static func combine(source_values: Array, operators: Array = []):
	var self_script = load("res://addons/goact/scripts/rx/rx.gd")
	var start_value = ArrayUtil.map(source_values, Lambda.new("x => x.value"))
	var combined = self_script.new(start_value, operators)
	for index in range(0, source_values.size()):
		source_values[index].connect("update_internal", combined, "_combined_value_set", [index])
	return combined
