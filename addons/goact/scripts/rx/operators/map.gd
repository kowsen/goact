class_name RxMap

var is_async = false

var _mapper: Lambda

func _init(mapper = "", context = null):
	_mapper = Lambda.new(mapper, context)

func run(value):
	return RxOperatorResult.new(_mapper.run([value]), true)

static func string():
	return load("res://addons/goact/scripts/rx/operators/map.gd").new("x => String(x)")
