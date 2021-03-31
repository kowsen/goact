tool
extends Control

# Exports
export var text: String = ""

# Constants
var CURSOR_SHRINK = 3
var CURSOR_PAD = 5
var LONG_PAUSE_CHARS = [".", "?", "!"]
var LONG_PAUSE_TICKS = 5
var SHORT_PAUSE_CHARS = [","]
var SHORT_PAUSE_TICKS = 3
var SHOW_CURSOR_MS = 20

# Ready variables
onready var _timer := $Timer
onready var _label := $Label
onready var _cursor := $Label/Cursor
var _font: Font
var _cursor_position := Rx.new(Vector2.ZERO)
var _text_monitor := RichTextMonitor.new("")
var _last_type_time := Rx.new(-1)

# Temporary storage
var _current_line = 1
var _last_line_break = 0
var _pause_ticks = 0

func _ready():
	_label.bbcode_text = "[monitor]" + text + '[/monitor]'
	_font = _label.get_font("normal_font")
	_timer.connect("timeout", self, "_show_next_char")
	_label.visible_characters = 0
	_label.install_effect(_text_monitor)
	
	yield(get_tree(), "idle_frame")
	_enable_cursor()
	
	if Engine.editor_hint:
		while _show_next_char():
			yield(get_tree(), "idle_frame")
	else:
		Rx.combine([CursorTimer.is_cursor_active, _last_type_time], [
			RxMap.new(funcref(self, "_should_show_cursor"))
		]).keep_alive(self).attach(_cursor, "visible")
		yield(get_tree().create_timer(2), "timeout")
		_timer.start()

func _enable_cursor():
	_cursor.visible = true
	var base_size = _font.get_string_size("A").y - (CURSOR_SHRINK * 2)
	_cursor.rect_size = Vector2(base_size / 2, base_size)
	_cursor_position.attach(_cursor, "rect_position")
	_cursor_position.value = Vector2(0, CURSOR_SHRINK)
	_cursor.color = _text_monitor.color_map.get(0)

func _update_cursor():
	var line_str = _label.text.substr(_last_line_break, _label.visible_characters - _last_line_break)
	var line_size = _font.get_string_size(line_str)

	var cursor_line = _current_line - 1
	var cursor_x = line_size.x + CURSOR_PAD
	if (cursor_x + _cursor.rect_size.x) > rect_size.x:
		cursor_x = 0
		cursor_line += 1
	var cursor_y = line_size.y * cursor_line + CURSOR_SHRINK
	_cursor_position.value = Vector2(cursor_x, cursor_y)
	_cursor.color = _text_monitor.color_map.get(_label.visible_characters - 1)
	
func _should_show_cursor(args):
	var blink_enabled = args[0]
	var last_typed_time = args[1]
	
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
