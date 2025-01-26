extends Node2D

class_name TimerText
@onready var text = $Text


const DANGER_COLOR = Vector4(1., 1., 1., 1.)
const NORMAL_COLOR = Vector4(1., 0., 0., 1.)


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func set_timer(time: float):
	var secs = int(round(time))
	var msecs = int(round((time - secs)*1000))
	text.add_text("[center]" + str(secs) + ":" + str(msecs) + "[/center]")


func set_color(color: Vector4):
	text.push_color(color)
