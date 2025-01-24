extends RigidBody2D

@export var InpulseForce:float = 10

var impulsionDone = false
var isInputInControllerMode = true

func doInpulse() -> void:
	apply_central_impulse(InputDir() * InpulseForce);
	
func InputDir() -> Vector2:
	if (isInputInControllerMode):
		return Input.get_vector("JoypadDirRight","JoypadDirLeft", "JoypadDirDown", "JoypadDirUp")
	else:
		return Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float)  -> void:
	if (Input.is_action_just_pressed("Inpulse")):
		doInpulse()
