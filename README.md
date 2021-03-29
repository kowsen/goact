# goact
A janky but good enough (for my purposes) reactive library for Godot. You can check out a simple example of it working below, or a more complete example in the BigDemo scene.

Also adds some really iffy lambda functions and array helpers like map and filter that use them.

## Example

This code modifies a button's size and color based on a base counter variable, and smoothly transitions to the new values with very little code needed.

![demo](https://github.com/kowsen/goact/blob/main/demo.gif?raw=true)

```GDScript
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
```