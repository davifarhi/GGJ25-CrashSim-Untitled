extends Bone2D

@export var raycaster: RayCast2D

var target_offset = Vector2(0, 0)
var current_offset = Vector2(0, 0)

# thanks Freya
func expDecay(a: Vector2, b: Vector2, decay: float, dt: float) -> Vector2:
	return b + (a-b)*exp(-decay*dt);

func _process(delta: float) -> void:
	current_offset = expDecay(current_offset, target_offset, 16, delta)
	
	var pos = current_offset + global_position
	global_position = pos
	pass

func _physics_process(_delta: float) -> void:
	var computedPosition: Vector2
	if raycaster.is_colliding():
		var position = raycaster.get_collision_point()
		computedPosition = position;
	else:
		var pos = raycaster.global_transform * raycaster.target_position
		computedPosition = pos;
	target_offset = computedPosition - global_position;
