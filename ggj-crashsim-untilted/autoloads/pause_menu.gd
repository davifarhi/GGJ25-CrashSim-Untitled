extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiManager.Pause.connect(_on_game_pause)
	UiManager.Unpause.connect(_on_game_unpause)
	hide()


func _process(_delta: float) -> void:
	pass


func _on_game_pause() -> void:
	global_position = UiManager.Camera.global_position - get_viewport_rect().size / 2
	show()

	
func _on_game_unpause() -> void:
	hide()


func _on_resume_button_click() -> void:
	UiManager.Unpause.emit()


func _on_main_menu_button_click() -> void:
	GameManager.GoToMainMenu.emit()
	UiManager.Unpause.emit()


func _on_restart_button_click() -> void:
	GameManager.PreviousLevel.emit()
	UiManager.Unpause.emit()
