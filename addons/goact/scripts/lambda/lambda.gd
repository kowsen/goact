class_name Lambda

var type = ""
var _ref: FuncRef
var _expression: Expression
var _context: Object

func _init(lambda, context = null):
	if lambda is FuncRef:
		_ref = lambda
		type = "funcref"
	else:
		_expression = Expression.new()

		var split_lambda = lambda.split("=>")
		var padded_arguments = split_lambda[0].split(",")
		var arguments = []
		for argument in padded_arguments:
			arguments.push_back(argument.strip_edges().replace("(", "").replace(")", ""))
		var function = split_lambda[1].strip_edges()

		if context is Dictionary:
			for key in context.keys():
				function = function.replace(key, context.get(key))
		else:
			_context = context

		_expression.parse(function, arguments)
		type = "expression"

func run(values: Array = []):
	if type == "funcref":
		return _ref.call_funcv(values)
	elif type == "expression":
		return _expression.execute(values, _context)
