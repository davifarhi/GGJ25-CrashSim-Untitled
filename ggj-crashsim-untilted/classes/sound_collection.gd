extends Node

class_name SoundCollection

var node: Node = null

func _init(collection_node: Node) -> void:
	node = collection_node
	assert(node.get_child_count() > 0)


func select_random() -> AudioStreamPlayer:
	var children = node.get_children()
	var random = children[randi() % children.size()]
	
	return random


func play_random() -> void:
	select_random().play()
	
	
func play_all() -> void:
	for child in node.get_children():
		child.play()
