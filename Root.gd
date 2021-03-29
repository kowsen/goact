extends Node2D

var toggle := Rx.new(false)
var counter := Rx.new(0)

var title = toggle.pipe([
	RxMap.new(Lambda.new(funcref(self, "_get_title")))
])

var button_text = RxCombine.new([title, counter]).pipe([
	RxDebounce.new(),
	RxMap.new(Lambda.new("x => x[0] + ': ' + String(x[1])"))
])

var button_size = counter.pipe([
	RxMap.new(Lambda.new("counter => counter * 10 + 120")),
	RxMap.new(Lambda.new("width => Vector2(width, 50)"))
])

var num_emissions := Rx.new(0)
var str_emissions = num_emissions.pipe([
	RxMap.string(),
	RxMap.new(Lambda.new("count => 'Emission count: ' + count"))
])

# Called when the node enters the scene tree for the first time.
func _ready():
	$IncrementCounter.connect("pressed", self, "_on_increment_counter")

	button_size.attach($IncrementCounter, "rect_size", RxTransition.new(0.5))
	button_text.attach($IncrementCounter, "text")
	button_text.connect("update", self, "_on_text_update")

	str_emissions.attach($NumEmissions, "text")

	RxDebug.new(num_emissions)

func _on_text_update(text):
	num_emissions.value += 1

func _on_increment_counter():
	toggle.value = !toggle.value
	counter.value += 1

func _get_title(_toggle):
	return "Toggle ON" if _toggle else "Toggle OFF"
