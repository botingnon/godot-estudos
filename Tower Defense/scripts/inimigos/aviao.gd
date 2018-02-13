extends "res://scripts/inimigos/inimigos.gd"

var textura1 = preload("res://assets/tiles/towerDefense_tile270.png")
var sombra1 = preload("res://assets/tiles/towerDefense_tile293.png")

var textura2 = preload("res://assets/tiles/towerDefense_tile271.png")
var sombra2 = preload("res://assets/tiles/towerDefense_tile294.png")

var texturas = [
	[textura1, sombra1],
	[textura2, sombra2]
]

var vivo = true
var max_vida

func on_init():
	add_to_group(game.GRUPO_CEU)
	
	Velocidade = 120
	Vida = 200
	max_vida = Vida

func on_process(delta):
	get_node("area/pb").set_value(Vida * 100 / max_vida)
	
func on_ready():
	randomize()

	var idx = randi() % texturas.size()
	
	get_node("conjunto/corpo").set_texture(texturas[idx][0])
	get_node("conjunto/sombra").set_texture(texturas[idx][1])
	
func getInitAnimationList():
	return ["voar"]

func on_die():
	if vivo:
		vivo = false
		get_node("area/pb").hide()
		get_node("area").set_layer_mask(0)
		get_node("area").set_collision_mask(0)
		get_node("anim").play("die")
		