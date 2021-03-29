class_name RxDistinct

var is_async = false

var DEFAULT_COMPARATOR = Lambda.new("(x, y) => typeof(x) == typeof(y) && x == y")

var _comparator: Lambda
var _first_value = true
var _last_value = null

func _init(comparator: Lambda = DEFAULT_COMPARATOR):
	_comparator = comparator

func run(value):
	var is_valid = _first_value || !_comparator.run([_last_value, value])
	_last_value = value
	_first_value = false
	return RxOperatorResult.new(value, is_valid)
