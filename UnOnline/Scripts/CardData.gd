extends Node

var type
var color
var used

func _init(type, color, used = 0):
	self.type = type
	self.color = color
	self.used = used

func to_text():
	return type + "|" + str(color)

func to_string():
	return to_text() + "|" + str(used)