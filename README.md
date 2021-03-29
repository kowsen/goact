# goact
A janky but good enough (for my purposes) reactive library for Godot. You can see a demo of it working in the Root scene, or in the gif below!

Also adds some really iffy lambda functions and array helpers like map and filter that use them.

![demo](https://github.com/kowsen/goact/blob/main/demo.gif?raw=true)

## Example

The below code makes a button grow 100 pixels wider every time it's clicked, and smoothly transitions to the new width over a half second transition like in the gif above.

```GDScript
var counter := Rx.new(0)

func _ready():
    $Counter.connect("pressed", self, "_on_increment")

    var button_size = counter.pipe([
        RxMap.new("counter => Vector2(counter * 100, 50)")
    ])

    button_size.attach($Counter, "rect_size", RxTransition.new(0.5))

func _on_increment():
    counter.value += 1
```