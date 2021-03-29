class_name Rx

signal update_attempt
signal update

var value = null setget _value_set
var _attach_manager: RxAttach
var _operators: Array
var _source_reference

func _init(start_value, operators: Array = []):
	_operators = operators
	_value_set(start_value)
	_attach_manager = RxAttach.new(value)
	connect("update", _attach_manager, "update")

func _value_set(new_value):
	emit_signal("update_attempt", new_value)
	for operator in _operators:
		var result = yield(operator.run(new_value), "completed") if operator.is_async else operator.run(new_value)
		if result.is_valid:
			new_value = result.value
		else:
			return
	value = new_value
	emit_signal("update", value)

func attach(node: Node, prop: String, transition: RxTransition = null):
	_attach_manager.attach(node, prop, transition)

func pipe(operators: Array = []):
	var derived = get_script().new(value, operators)
	connect("update", derived, "_value_set")
	return derived
