extends Node2D

@onready var bounceSFXCollection = SoundCollection.new($BounceCollection)
@onready var bounceVOCollection = SoundCollection.new($BounceVOCollection)

func _on_body_entered(body: Node) -> void:
	if body is Boubou:
		bounceSFXCollection.play_random()
		bounceVOCollection.play_random()
