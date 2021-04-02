extends Control

func _ready():
	$Button.connect("pressed", self, "_on_click")
	yield(get_tree().create_timer(3), "timeout")
	$Terminal.start()

func _on_click():
	$Terminal.text = "AND NOW WE [color=blue]HAVE DIFFERENT[/color] TEXT!"
	$Terminal.start()
