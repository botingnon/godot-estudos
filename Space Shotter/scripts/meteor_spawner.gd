extends Node

onready var pre_fabrica = preload("res://scenes/fabrica_meteoro.tscn")
var fabrica

func _ready():
	fabrica = pre_fabrica.instance()	

func _on_timer_timeout():
	get_node("timer").set_wait_time(rand_range(1.5, 2))

	var meteoro = fabrica.geraMeteoroRandomico()
	meteoro.set_pos(Vector2(rand_range(30, 610), -50))
	get_owner().add_child(meteoro)
