extends Control

func _ready():
	$Button.connect("pressed", self, "_on_toggle")
	$Button2.connect("pressed", self, "_on_toggle2")
	$Button3.connect("pressed", self, "_on_move")
	$Button4.connect("pressed", self, "_on_attach")
	$Button5.connect("pressed", self, "_on_detach")

func _on_toggle():
	$VBoxContainer/HBoxContainer/EaseContainer2.visible = ! $VBoxContainer/HBoxContainer/EaseContainer2.visible

func _on_toggle2():
	$VBoxContainer/ColorRect.visible = ! $VBoxContainer/ColorRect.visible

func _on_move():
	$VBoxContainer.rect_position.y = 10 if $VBoxContainer.rect_position.y == 115 else 115

func _on_attach():
	$VBoxContainer/HBoxContainer/EaseContainer3.project($EaseContainer, true)

func _on_detach():
	$VBoxContainer/HBoxContainer/EaseContainer3.unproject()
