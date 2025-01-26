extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	
	process_mode = PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func open_timeout_menu():
	show()
	get_tree().paused = true


func _on_restart_level_pressed() -> void:
	pass # Replace with function body.


func _on_back_to_main_menu_pressed() -> void:
	pass # Replace with function body.
