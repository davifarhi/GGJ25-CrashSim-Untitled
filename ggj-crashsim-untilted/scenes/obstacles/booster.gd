extends Area2D

@export var boosterPower:float = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if not body is Boubou:
		return
	
	var boubou = body as Boubou
	
	boubou.apply_central_impulse(Vector2(1,0).rotated(rotation) * boosterPower * 1000)
