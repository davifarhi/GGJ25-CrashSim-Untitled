extends Node

signal StartGame
signal StartTransition
signal EndGame
signal NextLevel
signal PreviousLevel
signal GoToMainMenu

signal OnLevelBegin

const LAST_SCENE = 2
const SCENE_FILES_BASE = "res://scenes/dummy-flow/"

var next_scene: int = 1
var is_scene_pausable: bool = true

var scene_transition_countdown: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StartGame.connect(_start_game)
	StartTransition.connect(_start_transition)
	NextLevel.connect(_launch_next_level)
	PreviousLevel.connect(_launch_previous_level)
	EndGame.connect(_launch_end_game)
	GoToMainMenu.connect(_launch_main_menu)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if scene_transition_countdown > 0:
		scene_transition_countdown -= 1
	
	
func _start_game() -> void:
	load_next_scene()
	
	
func _start_transition() -> void:
	load_transition()


func _launch_next_level() -> void:
	assert(!is_last_scene())
	load_next_scene()
	

func _launch_previous_level() -> void:
	next_scene -= 1
	load_next_scene()
	
	
func _launch_end_game() -> void:
	load_bye()
	

func _launch_main_menu() -> void:
	load_menu()
	

func is_in_transition() -> bool:
	var current = get_tree().get_current_scene()
	return current != null and current.get_name() != "Transition"
	
	
func is_last_scene() -> bool:
	return next_scene > LAST_SCENE
	
	
func load_transition() -> void:
	is_scene_pausable = false
	get_tree().change_scene_to_file(SCENE_FILES_BASE + "transition.tscn")
	

func load_bye() -> void:
	is_scene_pausable = false
	get_tree().change_scene_to_file(SCENE_FILES_BASE + "bye.tscn")


func load_menu() -> void:
	is_scene_pausable = false
	get_tree().change_scene_to_file(SCENE_FILES_BASE + "hello.tscn")
	next_scene = 1 


func load_next_scene():
	is_scene_pausable = true
	var next_scene_formatted = SCENE_FILES_BASE + "scene"+ str(next_scene) + ".tscn"
	get_tree().change_scene_to_file(next_scene_formatted)
	next_scene += 1
	
	OnLevelBegin.emit()
	#SEB hack (dfarhi)
	scene_transition_countdown = 3


func load_test_scene():
	is_scene_pausable = true
	get_tree().change_scene_to_file("res://scenes/TestPhysique.tscn")
