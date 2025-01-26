extends Node2D

class_name Level
@export var timeout_in_secs: float = 20

@onready var boubou = $Boubou as Boubou
@onready var level_timer = Timer.new()


@onready var timer_widget = UiManager.Camera.timer_widget

var timed_out = false


func _ready():
	boubou.dir_indicator.hide()
	PopIt.POPItDone.connect(_on_popit_done)
	
	add_child(level_timer)
	level_timer.wait_time = timeout_in_secs
	level_timer.one_shot = true
	level_timer.timeout.connect(_on_level_timer_end)
	
	boubou.BoubouDie.connect(_on_boubou_die)
	
	timer_widget.show()
	timer_widget.set_timer(timeout_in_secs)
	
	
func _process(delta: float):
	if GameManager.are_game_animations_active():
		return
	if boubou.dead:
		return
	
	if level_timer.time_left < 8.:
		timer_widget.set_danger(not timed_out)
	timer_widget.set_timer(level_timer.time_left)
	
	
func _on_popit_done():
	boubou.dir_indicator.show()
	level_timer.start()

	
func _on_level_timer_end():
	if GameManager.are_game_animations_active():
		return
	TimeoutMenu.open_timeout_menu()
	timer_widget.reset()
	timer_widget.set_danger(false)
	timer_widget.timer_end()
	timed_out = true


func _on_boubou_die(boubou):
	GameManager.add_level_time(timeout_in_secs - level_timer.time_left)
	level_timer.stop()
	timer_widget.stop_sfx()
	timer_widget.set_normal()
