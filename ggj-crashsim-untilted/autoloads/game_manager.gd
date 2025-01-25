extends Node

signal StartGame
signal EndGame
signal NextLevel
signal PreviousLevel
signal GoToMainMenu

const LAST_SCENE = 2
const SCENE_FILES_BASE = "res://scenes/dummy-flow/"

var next_scene: int = 1
var is_scene_pausable: bool = true

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
	
func _start_game() -> void:
	load_next_scene()
	
	
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
	

func is_last_scene() -> bool:
	return next_scene > LAST_SCENE
	
	
func load_bye() -> void:
	is_scene_pausable = false
	get_tree().change_scene_to_file(SCENE_FILES_BASE + "bye.tscn")


func load_menu() -> void:
	is_scene_pausable = false
	get_tree().change_scene_to_file(SCENE_FILES_BASE + "hello.tscn")
	next_scene = 1 


func load_next_scene():
	is_scene_pausable = false
	Fade.fade_out()


func load_test_scene():
	is_scene_pausable = true
	get_tree().change_scene_to_file("res://scenes/TestPhysique.tscn")


func are_game_animations_active():
	return PopIt.is_active() or Fade.is_active()


func _on_fadein_finished():
	is_scene_pausable = true
	PopIt.StartPOPIt.emit()


func _on_fadeout_finished():
	var next_scene_formatted = SCENE_FILES_BASE + "scene"+ str(next_scene) + ".tscn"
	get_tree().change_scene_to_file(next_scene_formatted)
	next_scene += 1
	
	Fade.fade_in()
