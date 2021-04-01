extends Control

func _ready():
	$Button.connect("pressed", self, "_on_click")

func _on_click():
	print("CHANGING TEXT")
	$Terminal.text = "AND NOW WE [color=blue]HAVE DIFFERENT[/color] TEXT!"
