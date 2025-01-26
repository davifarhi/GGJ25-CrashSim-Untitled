extends Camera2D

@onready var boubou:Boubou = $"../Boubou" # bof
@export var lockCam:bool = false
@export var l_back = 2./3
@export var l_forw = 1./4 # limit of movement
@export var leftLimite:float = 0
@export var rightLimite:float = 3960


@onready var timer_widget = $TimerText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_widget.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if lockCam:
		return
	
	var d = boubou.position.x - position.x
	var ratio = d / get_window().get_size().x * 2
	if boubou.linear_velocity.x < 0:
		if ratio < -l_back:
			translate(Vector2(boubou.linear_velocity.x * delta, 0))
	elif boubou.linear_velocity.x > 0:
		if ratio > l_forw:
			translate(Vector2(boubou.linear_velocity.x * delta, 0))
			
	if position.x < leftLimite:
		position.x = leftLimite
	elif position.x > rightLimite:
		position.x = rightLimite
