extends Node

signal Pause
signal Unpause

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Pause.connect(_pause_game)
	Unpause.connect(_unpause_game)	
	
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	if Input.is_action_just_released("TogglePause"):
		toggle_pause()
	if get_tree().paused and Input.is_action_just_released("Unpause"):
		toggle_pause()


func _pause_game() -> void:
	get_tree().paused = true


func _unpause_game() -> void:
	get_tree().paused = false
	

func toggle_pause() -> void:
	# dfarhi todo disable pause in main-menu / end-menu
	if get_tree().paused:
		Unpause.emit()
	elif GameManager.is_scene_pausable:
		Pause.emit()
