extends Node2D

@export var acceleration_amount: float = 1.0
@export var pull: bool = false
@export var windbox_shape: Sprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WindBox.acceleration_amount = acceleration_amount
	$WindBox.pull = pull
	
	windbox_shape.hide()
	var size = windbox_shape.global_scale
	var particleMat = $WindBox/WindBoxShape/Particles.process_material as ParticleProcessMaterial
	particleMat.gravity = Vector3(0, 98, 0).rotated(Vector3(0,0,1), global_rotation)
	$WindBox/WindBoxShape/Particles.amount *= size.x*size.y
	$WindBox/WindBoxShape.global_transform = windbox_shape.global_transform

func _process(_delta: float) -> void:
	var topLeftCorner = windbox_shape.global_position
	var size = windbox_shape.global_scale
	var particleMat = $WindBox/WindBoxShape/Particles.process_material as ParticleProcessMaterial
	particleMat.emission_box_extents = Vector3(size.x*32, size.y*8, 0)

	pass
