extends Node2D


@onready var tex_normal = $BG/Normal
@onready var tex_hovered = $BG/Hovered

@export var texture: Texture2D
@export var bg_scale = Vector2(2., 0.8)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tex_normal.show()
	tex_hovered.hide()
	$TextureButton.texture_normal = texture
	$BG.scale = bg_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_focus_entered() -> void:
	tex_normal.hide()
	tex_hovered.show()


func _on_texture_button_mouse_entered() -> void:
	tex_normal.hide()
	tex_hovered.show()


func _on_texture_button_focus_exited() -> void:
	tex_normal.show()
	tex_hovered.hide()


func _on_texture_button_mouse_exited() -> void:
	tex_normal.show()
	tex_hovered.hide()
