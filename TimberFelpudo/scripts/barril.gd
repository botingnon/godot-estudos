extends Node2D

func _ready():
	pass

func dest(sentido):
	if sentido == -1:
		get_node("Anim").play("direita")
	else:
		get_node("Anim").play("esquerda")