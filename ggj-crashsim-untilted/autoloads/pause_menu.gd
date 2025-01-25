extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiManager.Pause.connect(_on_game_pause)
	UiManager.Unpause.connect(_on_game_unpause)
	hide()


func _process(delta: float) -> void:
	pass


func _on_game_pause() -> void:
	show()

	
func _on_game_unpause() -> void:
	hide()


func _on_resume_pressed() -> void:
	UiManager.Unpause.emit()


func _on_restart_level_pressed() -> void:
	GameManager.PreviousLevel.emit()
	UiManager.Unpause.emit()


func _on_back_to_main_menu_pressed() -> void:
	GameManager.GoToMainMenu.emit()
	UiManager.Unpause.emit()
