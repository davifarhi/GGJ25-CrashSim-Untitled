extends GPUParticles2D

@export var emitDuring:float = 1 #sec

var remainingTime:float = 0

func start() -> void:
	remainingTime = emitDuring
	emitting = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (emitting and remainingTime > 0):
		remainingTime -= delta
		amount_ratio = (remainingTime / emitDuring) ** 3
	elif (emitting):
		emitting = false


func _on_bubble_juice_on_inpulse(dir: Vector2) -> void:
	start()
