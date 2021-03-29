extends Node

var _containers := []
var _rx_values := {}

func manage(rx, container: Object):
	var ref = _get_container_weakref(container)
	var values = _get_values_for_weakref(ref)
	values.push_back(rx)
	
func _get_container_weakref(container: Object):
	for other in _containers:
		if other.get_ref() == container:
			return other
	var new_ref = weakref(container)
	_containers.push_back(new_ref)
	return new_ref

func _get_values_for_weakref(ref: WeakRef):
	var values = _rx_values.get(ref)
	if !values:
		values = []
		_rx_values[ref] = values
	return values

func _process(_delta):
	var to_free
	for container in _containers:
		if !container.get_ref():
			if !to_free:
				to_free = []
			to_free.push_back(container)

	if to_free:
		for container in to_free:
			_containers.erase(container)
			_rx_values.erase(container)
