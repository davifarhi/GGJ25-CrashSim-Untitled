extends Area2D

var acceleration_amount: float = 1.0
var pull: bool = false

# TODO: change visual depending on 'pull'

var player: Boubou = null
@export var animPlayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	animPlayer.play("ventilateur_animation")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	var direction_factor: float = -1 if pull else 1;
	var direction = Vector2(0, 1).rotated(global_rotation)
	player.apply_central_force(direction_factor * acceleration_amount * direction * 1000)

func _on_windbox_entered(body: Node2D) -> void:
	if body is Boubou:
		player = body as Boubou

func _on_windbox_exited(body: Node2D) -> void:
	if body is Boubou:
		player = null
