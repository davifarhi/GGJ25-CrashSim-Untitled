extends Node2D

@onready var animation = $AnimationPlayer

signal FadeInFinished
signal FadeOutFinished


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func is_active():
	return animation.is_playing()


func fade_in():
	if (UiManager.Camera == null):
		global_position = Vector2()
	else:
		global_position = UiManager.Camera.global_position - get_viewport_rect().size / 2
	show()
	animation.play("FadeFromBlack")
	
	
func fade_out():
	if (UiManager.Camera == null):
		global_position = Vector2()
	else:
		global_position = UiManager.Camera.global_position - get_viewport_rect().size / 2
	show()
	animation.play("FadeToBlack")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"FadeFromBlack":
			FadeInFinished.emit()
			hide()
		"FadeToBlack":
			FadeOutFinished.emit()
		_:
			assert(false)
