class_name RxAttach

class RxConnection:
	var _node: Node
	var _prop: String
	var _transition: RxTransition
	var _tween: Tween

	func _init(node: Node, prop: String, transition: RxTransition = null):
		_node = node
		_prop = prop
		_transition = transition
		if _transition:
			_tween = TweenUtil.get_tween()

	func destroy():
		if _tween:
			_tween.queue_free()

	func update(value):
		if _transition:
			_tween.stop_all()
			_tween.interpolate_property(
					_node, _prop,
					_node.get(_prop), value, _transition.time,
					_transition.transition_type, _transition.ease_type)
			_tween.start()
		else:
			print("SETTING DIRECTLY: ", _prop, " - ", value)
			_node.set_indexed(_prop, value)


var _attached_values = []
var _last_value

func _init(start_value = null):
	_last_value = start_value

func update(value):
	_last_value = value
	for connection in _attached_values:
		connection.update(value)

func attach(node: Node, prop: String, transition: RxTransition = null):
	var connection = RxConnection.new(node, prop, transition)
	_attached_values.append(connection)
	_combine_binds(node, "tree_exiting", self, "_disconnect_value", [connection])
	connection.update(_last_value)

func _disconnect_value(connections: Array):
	for connection in connections:
		_attached_values.erase(connection)
		connection.destroy()

func _combine_binds(source: Node, signal_name: String, target: Reference, func_name: String, binds: Array):
	var connections = source.get_signal_connection_list(signal_name)
	for connection in connections:
		if connection.target == target:
			source.disconnect(signal_name, target, func_name)
			source.connect(signal_name, target, func_name, [connection.binds[0] + binds])
			return
	source.connect(signal_name, target, func_name, [binds])
