extends Node2D

@onready var animation = $AnimationPlayer
signal POPItDone
signal StartPOPIt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StartPOPIt.connect(_start_popit)
	hide()
	
	process_mode = Node.PROCESS_MODE_PAUSABLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func is_active() -> bool:
	return animation.is_playing()
	

func _start_popit() -> void:
	global_position = UiManager.Camera.global_position - get_viewport_rect().size / 2
	show()
	animation.play("popit!!")
	$SFX.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hide()
	POPItDone.emit()
