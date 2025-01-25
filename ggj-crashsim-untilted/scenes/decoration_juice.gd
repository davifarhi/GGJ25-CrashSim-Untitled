extends Node2D

@export var ForgroundInpulseMoveAmplitude:float = 32
@export var ForgroundInpulseTime:float = 0.5 #seconds 

@onready var Foreground = $Foreground
@onready var FGInitPos = Foreground.position

var forgroundMoveDir:Vector2
var forgroundMoving:bool = false
var forgroundMoveSince:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (forgroundMoveSince < ForgroundInpulseTime):
		forgroundMoveSince += delta
		Foreground.position = - forgroundMoveDir * ForgroundInpulseMoveAmplitude * (ForgroundInpulseTime - forgroundMoveSince)
	else:
		Foreground.position = Vector2()

func _on_boubou_juice_on_inpulse(dir: Vector2) -> void:
	forgroundMoveDir = dir
	forgroundMoveSince = 0
	forgroundMoving = true
