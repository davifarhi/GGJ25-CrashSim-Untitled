extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.is_scene_pausable = false
	$ZenModeToggle.button_pressed = GameManager.zen_mode_on


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@onready var buttons = $MenuButtons
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
	if event is InputEventMouseMotion:
		if not mouse_navigation:
			release_all_focus()
			mouse_navigation = true
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if mouse_navigation:
			release_all_focus()
			mouse_navigation = !select_first_button()
	

func _on_start_button_click() -> void:
	GameManager.StartGame.emit()


func _on_exit_button_click() -> void:
	get_tree().quit()


func _on_zen_mode_toggled(toggled_on: bool) -> void:
	GameManager.zen_mode_on = toggled_on
