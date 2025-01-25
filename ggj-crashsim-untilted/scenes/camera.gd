extends Camera2D

@onready var boubou:Boubou = $"../Boubou" # bof
@export var l_back = 2./3
@export var l_forw = 1./4 # limit of movement

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var d = boubou.position.x - position.x
	var ratio = d / get_window().get_size().x * 2
	if boubou.linear_velocity.x < 0:
		if ratio < -l_back:
			translate(Vector2(boubou.linear_velocity.x * delta, 0))
	elif boubou.linear_velocity.x > 0:
		if ratio > l_forw:
			translate(Vector2(boubou.linear_velocity.x * delta, 0))
