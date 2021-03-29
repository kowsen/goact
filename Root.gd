extends Node2D

# These are the base Rx values. We trigger changes in the derived
# values below by modifying these values.
var toggle := Rx.new(false)
var counter := Rx.new(0)

# You can map values using a funcref. In this case we have to
# because ternary operators don't work in my janky lambdas.
var title = toggle.pipe([
	RxMap.new(funcref(self, "_get_title"))
])

# You can also combine these values to react to a change in any of them.
var button_text = RxCombine.new([title, counter]).pipe([
	# This only lets the value emit once every frame. This is helpful
	# if something were to update title and counter at the same time,
	# but we didn't want to consider the state where one's been updated
	# but the other hasn't.
	RxDebounce.new(),
	# This is the closest thing GDScript's gonna get to a lambda function!
	# They work well enough for simple, pure mapping or filtering functions.
	RxMap.new("x => x[0] + ': ' + String(x[1])")
])

# This maps the counter to a Vector2 to use as the size of our button.
var button_size = counter.pipe([
	RxMap.new("counter => counter * 40 + 120"),
	RxMap.new("width => Vector2(width, 50)")
])

# This is to show that even though we update title and counter on every click,
# we won't get two emissions per click thanks to RxDebounce.
var num_emissions := Rx.new(0)
var str_emissions = num_emissions.pipe([
	RxMap.string(),
	RxMap.new("count => 'Emission count: ' + count")
])

func _ready():
	$IncrementCounter.connect("pressed", self, "_on_increment_counter")

	# Rx values expose an "update" signal that you can listen to like any Godot node.
	button_text.connect("update", self, "_on_text_update")

	# They also have an "attach" method. Whenever "update" is fired, the Rx value will
	# update the "text" property of $IncrementCounter automatically.
	button_text.attach($IncrementCounter, "text")
	str_emissions.attach($NumEmissions, "text")

	# This is where the real magic is. When button_size updates, IncrementCounter will
	# automatically transition to the newly emitted rect_size over 0.5 seconds.
	button_size.attach($IncrementCounter, "rect_size", RxTransition.new(0.5))

	# This is a little utility class that prints whenever the passed in Rx value gets
	# a new input or output value. The one thing that I don't like about this setup
	# is that it can get complicated to debug, but this makes it a little easier.
	RxDebug.new(num_emissions, "NUM EMISSIONS")

func _on_text_update(_text):
	num_emissions.value += 1

func _on_increment_counter():
	toggle.value = !toggle.value
	counter.value += 1

func _get_title(_toggle):
	return "Toggle ON" if _toggle else "Toggle OFF"
