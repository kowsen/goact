tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton(
		"CursorTimer",
		"res://addons/type_text/CursorTimer.tscn"
	)

func _exit_tree():
	remove_autoload_singleton("CursorTimer")
