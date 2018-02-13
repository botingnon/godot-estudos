extends Node2D

onready var pre_inimigo = preload("res://scenes/inimigos/paths_inimigo.tscn")

func _ready():
	randomize()
	randozime_time()
	
func randozime_time():
	get_node("timer").set_wait_time(rand_range(3, 10))

func _on_timer_timeout():
	var inimigo = pre_inimigo.instance()
	get_parent().add_child(inimigo)
	randozime_time()