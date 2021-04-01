class_name RxFilter

var is_async = false

var _filter: Lambda

func _init(filter = "", context = null):
	_filter = Lambda.new(filter, context)

func run(value):
	return RxOperatorResult.new(value, !!_filter.run([value]))

static func is_defined():
	return load("res://addons/goact/scripts/rx/operators/filter.gd").new("x => !!x")
