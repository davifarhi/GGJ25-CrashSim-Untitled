extends Node2D

class_name TimerText
@onready var text = $Text


const NORMAL_COLOR = Color(1., 1., 1., 1.)
const DANGER_COLOR = Color(1., 0., 0., 1.)
const format_str = "[center]%02d:%03d[/center]"


var is_in_danger = false

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
	text.push_color(DANGER_COLOR if is_in_danger else NORMAL_COLOR)
	text.append_text(str)


func set_danger():
	is_in_danger = true
	
	
func set_normal():
	is_in_danger = false
	

func reset():
	is_in_danger = false
	set_timer(0)
