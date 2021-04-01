extends Object

class_name RxDebug

var _name: String
var _rx: Rx

func _init(rx: Rx = null, name: String = "UNTITLED"):
	_rx = rx
	_name = name
	rx.connect("update_attempt", self, "_on_update_attempt")
	rx.connect("update", self, "_on_update")
	print("[" + _name + "] INITIAL: ", rx.value)

func _on_update_attempt(value):
	print("[" + _name + "] INPUT: ", value)

func _on_update(value):
	print("[" + _name + "] OUTPUT: ", value)
	
func get_listeners(signal_name):
	return _rx.get_signal_connection_list(signal_name)
