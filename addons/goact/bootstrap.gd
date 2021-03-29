tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton(
		"RxLifecycle",
		"res://addons/goact/scripts/rx/lifecycle.gd"
	)
	add_autoload_singleton(
		"TimingUtil",
		"res://addons/goact/scripts/util/timing_util.gd"
	)
	add_autoload_singleton(
		"TweenUtil",
		"res://addons/goact/scripts/util/tween_util.gd"
	)

func _exit_tree():
	remove_autoload_singleton("RxLifecycle")
	remove_autoload_singleton("TimingUtil")
	remove_autoload_singleton("TweenUtil")
