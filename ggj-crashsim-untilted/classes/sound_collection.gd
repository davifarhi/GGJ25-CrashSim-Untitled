extends Node

class_name SoundCollection

var node: Node = null

func _init(collection_node: Node) -> void:
	node = collection_node
	assert(node.get_child_count() > 0)

func select_random() -> AudioStreamPlayer2D:
	var children = node.get_children()
	var random = children[randi() % children.size()]
	
	print("Selected random SFX: ", random.name)
	return random

func play_random() -> void:
	select_random().play()
