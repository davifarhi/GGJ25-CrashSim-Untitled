extends Node2D

@export var acceleration_amount: float = 1.0
@export var pull: bool = false
@export var windbox_shape: Sprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WindBox.acceleration_amount = acceleration_amount
	$WindBox.pull = pull
	
	# TODO: particles
	#windbox_shape.hide()
	$WindBox/WindBoxShape.global_transform = windbox_shape.global_transform

func _process(_delta: float) -> void:
	pass
