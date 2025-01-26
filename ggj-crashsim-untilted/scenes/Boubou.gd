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

@export_category("Eyes")
@export var eyesNormal: Texture2D
@export var eyesBlink: Texture2D
@export var eyesBounce: Texture2D
@export var eyesFast: Texture2D
@export var blinkPeriod: float = 1.0
@export var blinkDuration: float = 0.2
@export var eyesBounceTextureDuration: float = 1
@onready var eyesSprite = $Visual/BodyPolygon/Eyes
var blinking: bool = false
var timeBeforeBlinkChange: float = 0
var eyesTextureLockTime: float = 0

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
@onready var mouseAimHelper = camera.get_node("MouseAimHelper") as Node2D

var impulsionDone = false
var dead = false
enum InputType { Mouse, Gamepad }
var currentInputType = InputType.Mouse

func doInpulse() -> void:
	var currentSpeed = linear_velocity.length()/3000
	var speedFactor = exp(currentSpeed * 1.01)
	linear_velocity = Vector2(0, 0)
	var dir = InputDir()
	apply_central_impulse(- dir * InpulseForce * speedFactor);
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

func GetMousePosInWorld() -> Vector2:
	return get_global_mouse_position()

func InputDir() -> Vector2:
	var dir = Vector2(0, 0)
	if currentInputType == InputType.Mouse:
		dir = Vector2(DisplayServer.mouse_get_position()-DisplayServer.window_get_position()) - Vector2(DisplayServer.window_get_size())/2 + Vector2(0.5, 0.5)
	elif currentInputType == InputType.Gamepad:
		dir = Input.get_vector("JoypadDirLeft", "JoypadDirRight", "JoypadDirUp", "JoypadDirDown")
	
	if dir.length_squared() == 0:
		dir = latestDir
	
	latestDir = dir.normalized()
	return latestDir

func UpdateIndicatorPos():
	Indicator.global_position = global_position
	Indicator.rotation = -rotation
	var dir = InputDir()
	var distScale = 1.0
	if currentInputType == InputType.Mouse:
		Indicator.global_position = mouseAimHelper.global_position
		distScale = 0.5
	Indicator.global_translate(distScale * IndicatorDistance * dir)
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
	if currentInputType == InputType.Mouse and not freeze:
		Indicator.z_index = mouseAimHelper.z_index
		
		mouseAimHelper.show()
	else:
		Indicator.z_index = z_index
		mouseAimHelper.hide()
	
	UpdateEyes(delta)
	UpdateIndicatorPos()
	
	if (ghostremainingTime > 0):
		ghostremainingTime -= delta
		ghost.global_position = ghostGlobalPos
	elif (ghost.is_visible_in_tree()):
		ghost.hide()
	
	# TODO: debug code, to remove :)
	if Input.is_key_pressed(KEY_DELETE):
		linear_velocity = Vector2(0, 0)
		global_position = GetMousePosInWorld()
		

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
	eyesTextureLockTime = eyesBounceTextureDuration
	eyesSprite.texture = eyesBounce
	bumper_contact_sfx_collection.play_random()
	
func _on_level_begin():
	pass
	#boubou_born_sfx_group.play_all()
	# dfarhi todo later on scene init play born sfx sound,
	# doesn't work here as the sound is emitted right before scene change
	
func UpdateEyes(delta: float):
	if eyesTextureLockTime > 0:
		eyesTextureLockTime -= delta
		if eyesTextureLockTime < 0:
			timeBeforeBlinkChange = 0
		else:
			return

	var wantedEyeTexture = eyesNormal
	if linear_velocity.length() > 1000:
		wantedEyeTexture = eyesFast
	
	# blink
	if timeBeforeBlinkChange >= 0:
		timeBeforeBlinkChange -= delta
		if timeBeforeBlinkChange < 0:
			if blinking:
				timeBeforeBlinkChange = blinkPeriod
				blinking = false
				eyesSprite.texture = wantedEyeTexture
			else:
				timeBeforeBlinkChange = blinkDuration
				blinking = true
				eyesSprite.texture = eyesBlink
