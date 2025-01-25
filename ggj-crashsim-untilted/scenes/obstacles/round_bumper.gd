extends RigidBody2D

@onready var sprite = $AnimationPlayer

@export var bump_impulse_multiplier: float = 300.
@export var debug_draw_impulse_arrow = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _draw() -> void:
	pass


func _on_impulse_zone_body_entered(body: Node2D) -> void:
	if not body is Boubou:
		return
	
	var boubou:Boubou = body as Boubou
	var normal = (body.global_position - self.global_position).normalized()
	var bump_v = normal * bump_impulse_multiplier
	body.apply_impulse(bump_v)
	
	boubou.JuiceOnInpulse.emit(normal)

func _on_activation_zone_body_entered(body: Node2D) -> void:
	if not body is Boubou:
		return
		
	sprite.stop()
	sprite.play("Bump")
