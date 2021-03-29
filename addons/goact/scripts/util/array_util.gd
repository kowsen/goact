class_name ArrayUtil

static func map(array: Array, lambda) -> Array:
	if lambda is String:
		lambda = Lambda.new(lambda)
	var new_array = []
	for item in array:
		new_array.push_back(lambda.run([item]))
	return new_array

static func filter(array: Array, lambda) -> Array:
	if lambda is String:
		lambda = Lambda.new(lambda)
	var new_array = []
	for item in array:
		if lambda.run([item]):
			new_array.push_back(item)
	return new_array
