tool
extends Control

# Signals
signal typing_start
signal typing_end

# Exports
export var text := "" setget _set_text
export var font: Font = null
export var show_cursor := true setget _set_show_cursor
export var persist_cursor := true setget _set_persist_cursor
export var auto_start := true
export var speed := 0.05 setget _set_speed

# Constants
var CURSOR_SHRINK = 3
var CURSOR_PAD = 5
var LONG_PAUSE_CHARS = [".", "?", "!"]
var LONG_PAUSE_TICKS = 5
var SHORT_PAUSE_CHARS = [","]
var SHORT_PAUSE_TICKS = 3
var SHOW_CURSOR_MS = 30

# Ready variables
onready var _timer := $Timer
onready var _label := $Label
onready var _cursor := $Label/Cursor
var _cursor_position := Rx.new(Vector2.ZERO)
var _last_type_time := Rx.new(-1)

# Backing variables
var _rx_text = Rx.new("")
var _rx_show_cursor := Rx.new(true)
var _rx_persist_cursor := Rx.new(true)
var _rx_speed := Rx.new(0.05)

# Temporary storage
var _current_line = 1
var _last_line_break = 0
var _pause_ticks = 0

func _ready():
	_timer.connect("timeout", self, "_show_next_char")
	
	yield(get_tree(), "idle_frame")
	var is_cursor_active = CursorTimer.is_cursor_active if !Engine.editor_hint else Rx.new(false).keep_alive(self)
	Rx.combine([is_cursor_active, _last_type_time, _rx_show_cursor, _rx_persist_cursor, _rx_text], [
		RxMap.new(funcref(self, "_should_show_cursor"))
	]).keep_alive(self).attach(_cursor, "visible")
	
	_rx_speed.connect("update", self, "_on_speed_change")
	_on_speed_change(speed)
	
	_rx_text.connect("update", self, "_on_text_update")
	_on_text_update()

func start():
	_timer.start()
	emit_signal("typing_start")
		
func _on_text_update(_arg = null):
	_timer.stop()
	_label.bbcode_text = text
	if font:
		_label.add_font_override("normal_font", font)
	else:
		font = _label.get_font("normal_font")
	_label.visible_characters = 0
	
	yield(get_tree(), "idle_frame")
	
	if Engine.editor_hint:
		while _show_next_char():
			yield(get_tree(), "idle_frame")
	elif text.length() > 0:
		_enable_cursor()
		if auto_start:
			start()

func _enable_cursor():
	_cursor.visible = true
	var base_size = font.get_string_size("A").y - (CURSOR_SHRINK * 2)
	_cursor.rect_size = Vector2(base_size / 2, base_size)
	_cursor_position.attach(_cursor, "rect_position")
	_cursor_position.value = Vector2(0, CURSOR_SHRINK)
	_cursor.color = Color.white

func _update_cursor():
	if Engine.editor_hint:
		return
	
	var line_str = _label.text.substr(_last_line_break, _label.visible_characters - _last_line_break)
	var line_size = font.get_string_size(line_str)

	var cursor_line = _current_line - 1
	var cursor_x = line_size.x + CURSOR_PAD
	if (cursor_x + _cursor.rect_size.x) > rect_size.x:
		cursor_x = 0
		cursor_line += 1
	var cursor_y = line_size.y * cursor_line + CURSOR_SHRINK
	_cursor_position.value = Vector2(cursor_x, cursor_y)
	_cursor.color = Color.white
	
func _should_show_cursor(args):
	var blink_enabled = args[0]
	var last_typed_time = args[1]
	var is_show_cursor = args[2]
	var is_persist_cursor = args[3]
	var text = args[4]
	
	if text.length() == 0:
		return false
	
	if !is_show_cursor:
		return false
		
	if !is_persist_cursor && last_typed_time == -1:
		return false
	
	if blink_enabled:
		return true
	
	if last_typed_time != -1 && ((OS.get_ticks_msec() - last_typed_time) < SHOW_CURSOR_MS):
		return true
		
	return false
	
func _update_pause():
	var last_char = _label.text.substr(_label.visible_characters - 1, 1)
	if LONG_PAUSE_CHARS.has(last_char):
		_pause_ticks = LONG_PAUSE_TICKS
	if SHORT_PAUSE_CHARS.has(last_char):
		_pause_ticks = SHORT_PAUSE_TICKS

func _show_next_char():
	if _pause_ticks > 0:
		_pause_ticks -= 1
		return true
	
	if _label.visible_characters >= _label.get_total_character_count():
		_last_type_time.value = -1
		_timer.stop()
		emit_signal("typing_end")
		return false
	
	_label.visible_characters += 1
	yield(get_tree(), "idle_frame")
	var visible_line = _label.get_visible_line_count()
	if visible_line > _current_line:
		_current_line = visible_line
		_last_line_break = _label.visible_characters - 1
	
	_last_type_time.value = OS.get_ticks_msec()
	_update_pause()
	_update_cursor()
	return true
	
func _on_speed_change(new_speed):
	if !Engine.editor_hint:
		_timer.wait_time = new_speed

func _set_text(new_text):
	text = new_text
	_rx_text.value = new_text
	
func _set_show_cursor(new_show_cursor):
	show_cursor = new_show_cursor
	_rx_show_cursor.value = new_show_cursor
	
func _set_persist_cursor(new_persist_cursor):
	persist_cursor = new_persist_cursor
	_rx_persist_cursor.value = new_persist_cursor
	
func _set_speed(new_speed):
	speed = new_speed
	_rx_speed.value = new_speed
