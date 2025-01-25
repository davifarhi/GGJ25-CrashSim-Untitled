extends RigidBody2D

class_name Boubou

@export var InpulseForce:float = 10
@export var maxSpeed:float = 1

@export_category("Indicator")
@export var Indicator:Node2D
@export var IndicatorDistance:float = 32;

var impulsionDone = false
enum InputType { Mouse, Gamepad }
@export var currentInputType = InputType.Mouse

func doInpulse() -> void:
	apply_central_impulse(- InputDir() * InpulseForce);

# input handling
func _input(event: InputEvent) -> void:
	# check if currently using controller or mouse
	if event is InputEventMouseMotion:
		currentInputType = InputType.Mouse
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		currentInputType = InputType.Gamepad
	pass

func InputDir() -> Vector2:
	var dir = Vector2(0, 0)
	if currentInputType == InputType.Mouse:
		dir = get_viewport().get_mouse_position() - global_position
	elif currentInputType == InputType.Gamepad:
		dir = Input.get_vector("JoypadDirLeft", "JoypadDirRight", "JoypadDirUp", "JoypadDirDown")
		
	if dir.length_squared() == 0:
		dir = Vector2(-1, 0) # set a default value to avoid 0 div
	
	return dir.normalized()

func UpdateIndicatorPos():
	Indicator.position = Vector2()
	Indicator.rotation = -rotation
	Indicator.global_translate(IndicatorDistance * InputDir())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float)  -> void:
	UpdateIndicatorPos()
	#if linear_velocity.length_squared() > maxSpeed * maxSpeed:
	#	linear_velocity = linear_velocity.normalized() * maxSpeed
	print(linear_velocity.length())
		

func _physics_process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Inpulse")):
		doInpulse()
	if linear_velocity.length_squared() > maxSpeed * maxSpeed:
		linear_velocity = linear_velocity.normalized() * maxSpeed
