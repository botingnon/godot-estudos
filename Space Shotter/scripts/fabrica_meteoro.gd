extends Node


func geraMeteoro(val):
	return get_children()[val].duplicate()
	
func geraMeteoroRandomico():
	randomize()
	return get_children()[randi() % get_child_count()].duplicate()