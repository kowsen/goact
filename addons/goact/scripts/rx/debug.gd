extends Object

class_name RxDebug

var _name: String

func _init(rx: Rx, name: String = "UNTITLED"):
	_name = name
	rx.connect("update_attempt", self, "_on_update_attempt")
	rx.connect("update", self, "_on_update")
	print("[" + _name + "] INITIAL: ", rx.value)

func _on_update_attempt(value):
	print("[" + _name + "] INPUT: ", value)

func _on_update(value):
	print("[" + _name + "] OUTPUT: ", value)
