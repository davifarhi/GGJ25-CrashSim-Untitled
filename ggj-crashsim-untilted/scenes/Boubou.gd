extends RigidBody2D

class_name Boubou
signal BoubouDie(player: Boubou)
signal BoubouFinishedDying(player: Boubou)
signal JuiceOnInpulse(dir: Vector2)

@export var InpulseForce:float = 10
@export var maxSpeed:float = 1
@export var bounceDecay:float = 16.0

@export var ghostTime:float = 0.5 #sec
var ghostIsSpawned:bool = false
var ghostremainingTime:float = 0
@onready var ghost:Sprite2D = $BoubouGhost
var ghostGlobalPos:Vector2

@export_category("Indicator")
@export var Indicator:Node2D
@export var IndicatorDistance:float = 32;
var latestDir = Vector2(1,0)

signal BoubouBumperContact
@onready var bumper_contact_sfx_collection = SoundCollection.new($BumperContactSFX)
@onready var boubou_death_sfx_group = SoundCollection.new($DeathSFX)
@onready var boubou_bounce_sfx_collection = SoundCollection.new($BounceSFX)
@onready var boubou_bounce_vo_sfx_collection = SoundCollection.new($BounceVOSFX)
@onready var boubou_inpulse_sfx_collection = SoundCollection.new($InpulseSFX)
@onready var boubou_inpulse_vo_sfx_collection = SoundCollection.new($InpulseVOSFX)

@onready var dir_indicator = $Visual/DirIndicator
@onready var camera = get_parent().get_node("Camera2D") as Camera2D

var impulsionDone = false
var dead = false
enum InputType { Mouse, Gamepad }
var currentInputType = InputType.Mouse

func doInpulse() -> void:
	linear_velocity = Vector2()
	var dir = InputDir()
	apply_central_impulse(- dir * InpulseForce);
	JuiceOnInpulse.emit(dir)
	boubou_inpulse_sfx_collection.play_random()
	boubou_inpulse_vo_sfx_collection.play_random()

func SpawnGhost():
	ghost.show()
	ghostGlobalPos = global_position
	ghostremainingTime = ghostTime

# input handling
func _input(event: InputEvent) -> void:
	# check if currently using controller or mouse
	if event is InputEventMouseMotion:
		currentInputType = InputType.Mouse
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		currentInputType = InputType.Gamepad

func InputDir() -> Vector2:
	var dir = Vector2(0, 0)
	if currentInputType == InputType.Mouse:
		var screen_pos = global_position
		if camera != null:
			screen_pos = global_position - camera.global_position + Vector2(get_viewport().size)/2
		dir = get_viewport().get_mouse_position() - screen_pos
	elif currentInputType == InputType.Gamepad:
		dir = Input.get_vector("JoypadDirLeft", "JoypadDirRight", "JoypadDirUp", "JoypadDirDown")
	
	if dir.length_squared() == 0:
		dir = latestDir
	
	latestDir = dir.normalized()
	return latestDir

func UpdateIndicatorPos():
	Indicator.position = Vector2()
	Indicator.rotation = -rotation
	var dir = InputDir()
	Indicator.global_translate(IndicatorDistance * dir)
	Indicator.rotate(dir.angle())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $DeformationSkel/Root.get_children():
		child.bounce_decay = bounceDecay
		
	BoubouBumperContact.connect(_on_bumper_contact)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float)  -> void:
	if dead:
		return;
	if GameManager.are_game_animations_active():
		return
		
	UpdateIndicatorPos()
	
	if (ghostremainingTime > 0):
		ghostremainingTime -= delta
		ghost.global_position = ghostGlobalPos
	elif (ghost.is_visible_in_tree()):
		ghost.hide()
	
	# TODO: debug code, to remove :)
	if Input.is_key_pressed(KEY_DELETE):
		linear_velocity = Vector2(0, 0)
		global_position = get_viewport().get_mouse_position()
		

func _physics_process(_delta: float) -> void:
	if PopIt.is_active():
		return
	if (Input.is_action_just_pressed("Inpulse")):
		doInpulse()
	if linear_velocity.length_squared() > maxSpeed * maxSpeed:
		linear_velocity = linear_velocity.normalized() * maxSpeed
		
		
func Die() -> void:
	$Visual.hide()
	$DeathParticles.restart()
	linear_velocity = Vector2(0, 0)
	set_physics_process(false)
	dead = true
	BoubouDie.emit(self)
	boubou_death_sfx_group.play_all()


func _on_death_particles_finished() -> void:
	BoubouFinishedDying.emit(self)
	if GameManager.is_last_scene():
		GameManager.EndGame.emit()
	else:
		GameManager.NextLevel.emit()


func _on_juice_on_inpulse(_dir: Vector2) -> void:
	SpawnGhost()

func _on_bumper_contact():
	bumper_contact_sfx_collection.play_random()
	
func _on_level_begin():
	pass
	#boubou_born_sfx_group.play_all()
	# dfarhi todo later on scene init play born sfx sound,
	# doesn't work here as the sound is emitted right before scene change
