extends Node2D

class_name TimerText
@onready var text = $Text


const NORMAL_COLOR = Color(1., 1., 1., 1.)
const DANGER_COLOR = Color(1., 0., 0., 1.)
const format_str = "[center]%02d:%03d[/center]"


var color = NORMAL_COLOR

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func set_timer(time: float):
	var rounded = floor(time)
	var secs = int(rounded)
	var msecs = int((time - rounded)*1000)
	
	var str = format_str % [secs, msecs]
	
	text.clear()
	text.push_context()
	text.push_color(color)
	text.append_text(str)


func set_color(color: Color):
	self.color = color
