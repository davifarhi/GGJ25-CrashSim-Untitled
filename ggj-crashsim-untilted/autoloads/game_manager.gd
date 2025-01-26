extends Node

signal StartGame
signal EndGame
signal NextLevel
signal PreviousLevel
signal GoToMainMenu

const LEVEL_FILES_BASE = "res://scenes/levels/"
#const LEVEL_FILES = ["scene1", "scene2"]

# !! be careful about case, wrong case will not work in exports!!
const LEVEL_FILES = ["level1", "Level2"]
var LAST_LEVEL = LEVEL_FILES.size()

var next_level_idx: int = 0
var is_scene_pausable: bool = true

enum FADE_TO { BYE, LEVEL, MENU }

var next_fade_out_to: FADE_TO = FADE_TO.LEVEL

var time_to_completion: float = 0.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StartGame.connect(_start_game)
	NextLevel.connect(_launch_next_level)
	PreviousLevel.connect(_launch_previous_level)
	EndGame.connect(_launch_end_game)
	GoToMainMenu.connect(_launch_main_menu)
	
	Fade.FadeInFinished.connect(_on_fadein_finished)
	Fade.FadeOutFinished.connect(_on_fadeout_finished)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func add_level_time(time: float):
	time_to_completion += time
	

func get_completion_time() -> float:
	return time_to_completion
	
	
func _start_game() -> void:
	load_next_scene()
	
	
func _launch_next_level() -> void:
	assert(!is_last_scene())
	load_next_scene()
	

func _launch_previous_level() -> void:
	next_level_idx -= 1
	load_next_scene()
	
	
func _launch_end_game() -> void:
	load_bye()
	

func _launch_main_menu() -> void:
	load_menu()
	

func is_last_scene() -> bool:
	return next_level_idx >= LAST_LEVEL
	
	
func load_bye() -> void:
	is_scene_pausable = false
	Fade.fade_out()
	next_fade_out_to = FADE_TO.BYE


func load_menu() -> void:
	is_scene_pausable = false
	Fade.fade_out()
	PopIt.hide()
	next_fade_out_to = FADE_TO.MENU
	time_to_completion = 0.


func load_next_scene():
	is_scene_pausable = false
	Fade.fade_out()
	next_fade_out_to = FADE_TO.LEVEL


func load_test_scene():
	is_scene_pausable = true
	get_tree().change_scene_to_file("res://scenes/TestPhysique.tscn")


func are_game_animations_active():
	return PopIt.is_active() or Fade.is_active()


func _on_fadein_finished():
	match next_fade_out_to:
		FADE_TO.LEVEL:
			is_scene_pausable = true
			PopIt.StartPOPIt.emit()


func _on_fadeout_finished():
	match next_fade_out_to:
		FADE_TO.LEVEL:
			var next_scene_formatted = LEVEL_FILES_BASE + LEVEL_FILES[next_level_idx] + ".tscn"
			get_tree().change_scene_to_file(next_scene_formatted)
			next_level_idx += 1
		FADE_TO.BYE:
			get_tree().change_scene_to_file(LEVEL_FILES_BASE + "bye.tscn")
		FADE_TO.MENU:
			get_tree().change_scene_to_file(LEVEL_FILES_BASE + "hello.tscn")
			next_level_idx = 0
	
	Fade.fade_in()
