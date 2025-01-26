extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	
	process_mode = PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

@onready var buttons = $TimeoutButtons
var mouse_navigation = true

func release_all_focus():
	if buttons == null: return
	
	for butt in buttons.get_children():
		if butt != null:
			butt.release_focus()
		

func select_first_button() -> bool:
	if buttons == null or buttons.get_child_count() == 0:
		return false
	
	if buttons.get_child(0) != null:
		buttons.get_child(0).grab_focus()
		return true
	return false
	
	
func _unhandled_input(event: InputEvent) -> void:
	if not is_opened():
		return
	if event is InputEventMouseMotion:
		if not mouse_navigation:
			release_all_focus()
			mouse_navigation = true
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if mouse_navigation:
			release_all_focus()
			mouse_navigation = !select_first_button()
	
	
func open_timeout_menu():
	global_position = UiManager.Camera.global_position - get_viewport_rect().size / 2
	show()
	get_tree().paused = true
	GameManager.is_scene_pausable = false


func is_opened():
	return is_visible()


func _on_restart_level_button_click() -> void:
	GameManager.PreviousLevel.emit()
	hide()
	release_all_focus()
	get_tree().paused = false


func _on_main_menu_button_click() -> void:
	GameManager.GoToMainMenu.emit()
	hide()
	release_all_focus()
	get_tree().paused = false
