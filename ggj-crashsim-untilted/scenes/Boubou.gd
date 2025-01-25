extends RigidBody2D

class_name Boubou

@export var InpulseForce:float = 10

@export_category("Indicator")
@export var Indicator:Node2D
@export var IndicatorDistance:float = 32;

var impulsionDone = false

func doInpulse() -> void:
	apply_central_impulse(- InputDir() * InpulseForce);
	
func InputDir() -> Vector2:
	var dir = Input.get_vector("JoypadDirLeft", "JoypadDirRight", "JoypadDirUp", "JoypadDirDown")
	
	if dir.length_squared() == 0:
		dir = Vector2(-1, 0) # set a default value to avoid 0 div
	
	return dir.normalized()

func UpdateIndicatorPos():
	Indicator.position = InputDir() * IndicatorDistance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float)  -> void:
	UpdateIndicatorPos()
	if (Input.is_action_just_pressed("Inpulse")):
		doInpulse()
