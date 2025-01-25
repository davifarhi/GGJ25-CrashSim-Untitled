extends RigidBody2D

@export var displacement:Vector2 #px
@export var displacementTime:float = 1 #sec
@export var idleTime:float = 0
@export var speed:Curve

@onready var initPos:Vector2 = position
@onready var finalPos = initPos + displacement

enum Step {
	Idle,
	Aller,
	Retour
}

var currentStep:Step = Step.Idle
var nextStep:Step = Step.Aller
var time:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:
	pass

func _physics_process(delta: float) -> void:
	time += delta
	match currentStep:
		Step.Idle:
			if time >= idleTime:
				currentStep = nextStep
				nextStep = Step.Idle
				time = 0
		
		Step.Aller:
			if time < displacementTime:
				var alpha = speed.sample(time / displacementTime)
				position = initPos + (finalPos - initPos) * alpha
			else:
				currentStep = nextStep
				nextStep = Step.Retour
				time = 0
		Step.Retour:
			if time < displacementTime:
				var alpha = speed.sample(time / displacementTime)
				position = finalPos + (initPos - finalPos) * alpha
			else:
				currentStep = nextStep
				nextStep = Step.Aller
				time = 0
