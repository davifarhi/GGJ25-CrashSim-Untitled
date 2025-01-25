extends Node2D

const MaxTimeToShow = 2; # in seconds
var time_to_show = 0.0;
@export var anim_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_to_show = MaxTimeToShow;
	anim_player = $AnimationPlayer

func show_bubble() -> void:
	anim_player.play("appear");
	
func hideBubble() -> void:
	queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# keep bubble visible X seconds
	if time_to_show > 0:
		time_to_show -= delta;
		if time_to_show < 0:
			hideBubble();
