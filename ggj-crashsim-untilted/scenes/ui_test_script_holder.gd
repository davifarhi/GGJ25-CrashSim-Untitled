extends Node2D

@export var speech_bubble_template: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_click"):
		var mousePos = get_viewport().get_mouse_position();
		var sb = speech_bubble_template.instantiate() as Node2D;
		sb.position = mousePos;
		get_parent().add_child(sb);
		sb.show_bubble();

	pass
