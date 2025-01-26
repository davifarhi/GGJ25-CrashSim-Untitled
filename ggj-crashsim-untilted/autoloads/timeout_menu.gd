extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	
	process_mode = PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func open_timeout_menu():
	global_position = UiManager.Camera.global_position - get_viewport_rect().size / 2
	show()
	get_tree().paused = true
	GameManager.is_scene_pausable = false


func is_opened():
	return is_visible()


func _on_restart_level_pressed() -> void:
	GameManager.PreviousLevel.emit()
	hide()
	get_tree().paused = false


func _on_back_to_main_menu_pressed() -> void:
	GameManager.GoToMainMenu.emit()
	hide()
	get_tree().paused = false
