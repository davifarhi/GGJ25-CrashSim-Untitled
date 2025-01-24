extends RigidBody2D

var impulsionDone = false

func doInpulse() -> void:
	apply_central_impulse(Vector2(100, 0));

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Inpulse")):
		doInpulse()
		print("Flash")
