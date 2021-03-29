extends Object

class_name RxDebug

func _init(rx: Rx):
	rx.connect("update_attempt", self, "_on_update_attempt")
	rx.connect("update", self, "_on_update")
	print("INITIAL VALUE: ", rx.value)

func _on_update_attempt(value):
	print("ATTEMPTING UPDATE: ", value)

func _on_update(value):
	print("UPDATED: ", value)
