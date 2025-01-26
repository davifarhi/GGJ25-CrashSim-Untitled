extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiManager.Pause.connect(_on_game_pause)
	UiManager.Unpause.connect(_on_game_unpause)
	hide()


func _process(_delta: float) -> void:
	pass



@onready var buttons = $PauseButtons
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
	if not get_tree().paused or TimeoutMenu.is_opened():
		return
	if event is InputEventMouseMotion:
		if not mouse_navigation:
			release_all_focus()
			mouse_navigation = true
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if mouse_navigation:
			release_all_focus()
			mouse_navigation = !select_first_button()
	

func _on_game_pause() -> void:
	global_position = UiManager.Camera.global_position - get_viewport_rect().size / 2
	show()

	
func _on_game_unpause() -> void:
	release_all_focus()
	hide()


func _on_resume_button_click() -> void:
	UiManager.Unpause.emit()


func _on_main_menu_button_click() -> void:
	GameManager.GoToMainMenu.emit()
	UiManager.Unpause.emit()


func _on_restart_button_click() -> void:
	GameManager.PreviousLevel.emit()
	UiManager.Unpause.emit()
