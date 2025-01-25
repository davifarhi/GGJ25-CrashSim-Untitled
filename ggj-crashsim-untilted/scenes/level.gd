extends Node2D

class_name Level
@export var timeout_in_secs: float = 20

@onready var boubou = $Boubou as Boubou

func _ready():
	boubou.dir_indicator.hide()
	PopIt.POPItDone.connect(_on_popit_done)
	
	
func _process(delta: float):
	pass
	# if run anything here check that no popit/fade anim is running
	
	
func _on_popit_done():
	boubou.dir_indicator.show()
