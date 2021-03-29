extends Node2D

var COLOR_MAP = [Color.red, Color.green, Color.blue]

var counter := Rx.new(0)

func _ready():
	$Counter.connect("pressed", self, "_on_increment")

	var button_size = counter.pipe([
		RxMap.new("value => Vector2(value * 100, 50)")
	]).keep_alive(self)

	var button_color = counter.pipe([
		RxMap.new("value => COLOR_MAP[value]", self)
	]).keep_alive(self)

	button_size.attach($Counter, "rect_size", RxTransition.new(0.5))
	button_color.attach($Counter, "modulate", RxTransition.new(0.5))

func _on_increment():
	counter.value = (counter.value + 1) % 3
