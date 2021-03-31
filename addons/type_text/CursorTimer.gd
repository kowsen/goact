extends Timer

signal cursor_active

var is_cursor_active := Rx.new(true)

func _ready():
	connect("timeout", self, "_tick")
	_tick()
	start()
	
func _tick():
	is_cursor_active.value = !is_cursor_active.value
	emit_signal("cursor_active", is_cursor_active.value)
