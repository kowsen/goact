class_name RxCombine

signal update

var value = [] setget _value_set

func _init(source_values: Array):
	_value_set(ArrayUtil.map(source_values, Lambda.new("x => x.value")))
	for index in range(0, source_values.size()):
		source_values[index].connect("update", self, "_source_update", [index])

func _source_update(source_value, index):
	var new_value = value.duplicate()
	new_value[index] = source_value
	_value_set(new_value)

func _value_set(new_value):
	value = new_value
	emit_signal("update", value)

func pipe(operators: Array = []):
	var derived = Rx.new(value, operators)
	derived._source_reference = self
	connect("update", derived, "_value_set")
	return derived
