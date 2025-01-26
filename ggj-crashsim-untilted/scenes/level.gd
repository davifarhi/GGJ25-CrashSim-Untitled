extends Node2D

class_name Level
@export var timeout_in_secs: float = 20

@onready var boubou = $Boubou as Boubou
@onready var level_timer = Timer.new()


func _ready():
	boubou.dir_indicator.hide()
	PopIt.POPItDone.connect(_on_popit_done)
	
	add_child(level_timer)
	level_timer.wait_time = timeout_in_secs
	level_timer.one_shot = true
	level_timer.timeout.connect(_on_level_timer_end)
	
	boubou.BoubouDie.connect(_on_boubou_die)
	
	#timer_text.show()
	#timer_text.set_timer(timeout_in_secs)
	
	
func _process(delta: float):
	if GameManager.are_game_animations_active():
		return
	
	#timer_text.global_position 
	#timer_text.set_text(level_timer.time_left)
	
	
func _on_popit_done():
	boubou.dir_indicator.show()
	level_timer.start()

	
func _on_level_timer_end():
	if GameManager.are_game_animations_active():
		return
	TimeoutMenu.open_timeout_menu()
	# dfarhi todo here level failed screen
	# back to main menu / restart


func _on_boubou_die():
	level_timer.stop()
