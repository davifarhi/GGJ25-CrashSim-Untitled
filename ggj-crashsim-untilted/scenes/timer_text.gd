extends Node2D

class_name TimerText
@onready var text = $Text


const NORMAL_COLOR = Color(1., 1., 1., 1.)
const DANGER_COLOR = Color(1., 0., 0., 1.)
const format_str = "[center]%02d:%03d[/center]"


@onready var sfx_warning = $SFX/EndWarning
@onready var sfx_end = $SFX/EndRing


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


func set_danger(play_sfx: bool = false):
	is_in_danger = true
	if play_sfx and not sfx_warning.playing:
		sfx_warning.play()
	
	
func set_normal():
	is_in_danger = false
	stop_sfx()
	

func reset():
	is_in_danger = false
	set_timer(0)
	stop_sfx()
	
	
func stop_sfx():
	sfx_warning.stop()
	sfx_end.stop()


func timer_end():
	if not sfx_end.playing:
		sfx_end.play()
