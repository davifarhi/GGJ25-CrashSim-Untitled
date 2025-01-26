extends Area2D

@export var acceleration_amount: float = 1.0
@export var pull: bool = false
var shape:CollisionShape2D = null;
var player:Boubou = null
var currentEnvSound: AudioStreamPlayer = null
@onready var contact_sfx_collection = SoundCollection.new($ContactSFX)
@onready var contact_vo_collection = SoundCollection.new($ContactVO)
@onready var animPlayer: AnimationPlayer = $StaticPart/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer.play("ventilateur_animation")
	for child in get_children():
		if child is CollisionShape2D:
			shape = child as CollisionShape2D
			
	var ratio:float = shape.shape.get_rect().size.y / 200
	var particles:GPUParticles2D = $GPUParticles2D
	particles.lifetime *= ratio
	particles.amount *= sqrt(ratio)
	particles.preprocess = particles.lifetime
	particles.speed_scale *= acceleration_amount
	if ratio > 1:
		var oldSize = particles.visibility_rect.size.y
		var newSize = oldSize * ratio
		particles.visibility_rect.size.y *= ratio * ratio

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if player:
		var direction_factor: float = -1 if pull else 1;
		var direction = Vector2(0, 1).rotated(global_rotation)
		player.apply_central_force(direction_factor * acceleration_amount * direction * 1000)

func _on_body_entered(body: Node2D) -> void:
	if body is Boubou:
		player = body as Boubou
		if currentEnvSound == null or !currentEnvSound.playing:
			currentEnvSound = contact_sfx_collection.select_random()
			currentEnvSound.play()
		contact_vo_collection.play_random()


func _on_body_exited(body: Node2D) -> void:
	if body is Boubou:
		player = null
		if currentEnvSound != null:
			currentEnvSound.stop()
