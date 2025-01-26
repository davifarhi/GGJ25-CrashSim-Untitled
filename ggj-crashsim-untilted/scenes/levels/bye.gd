extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var time = GameManager.get_completion_time()
	var rounded = floor(time)
	var secs = int(rounded)
	var msecs = int((time - rounded)*1000)
	
	var str = TimerText.format_str % [secs, msecs]
	var text = $TimerText
	
	text.clear()
	text.push_context()
	text.push_color(TimerText.NORMAL_COLOR)
	text.append_text(str)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var boubou = $Boubou as Boubou
	if boubou.currentInputType == Boubou.InputType.Mouse:
		boubou.dir_indicator.hide()
	else:
		boubou.dir_indicator.show()
	pass


@onready var buttons = $ByeButtons
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
	

func _on_texture_button_button_click() -> void:
	GameManager.GoToMainMenu.emit()
