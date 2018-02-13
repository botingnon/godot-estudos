extends Area2D

onready var pre_tiro = preload("res://scenes/inimigos/inimigo_tiro.tscn")

func _ready():
	get_node("sprite").set_texture(recursos.random_inimigos_paths())

func destroi():
	queue_free()

func _on_tiro_timer_timeout():
	var tiro = pre_tiro.instance()
	tiro.set_global_pos(get_node("posCanhao").get_global_pos())
	game.getCamera().add_child(tiro)