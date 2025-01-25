extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.is_scene_pausable = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	GameManager.StartGame.emit()


func _on_load_test_level_pressed() -> void:
	GameManager.load_test_scene()
