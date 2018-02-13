extends "res://scripts/inimigos/inimigos.gd"

var textura1 = preload("res://assets/tiles/towerDefense_tile245.png")
var textura2 = preload("res://assets/tiles/towerDefense_tile246.png")
var textura3 = preload("res://assets/tiles/towerDefense_tile247.png")
var textura4 = preload("res://assets/tiles/towerDefense_tile248.png")

var texturas = [
	textura1,
	textura2,
	textura3,
	textura4
]

var vivo = true
var max_vida

func on_init():
	add_to_group(game.GRUPO_TERRA_LEVE)
	
	Velocidade = 90
	Vida = 100
	max_vida = Vida
	
func on_process(delta):
	get_node("area/pb").set_value(Vida * 100 / max_vida)

func on_ready():
	randomize()

	var idx = randi() % texturas.size()
	
	get_node("corpo").set_texture(texturas[idx])

func on_die():
	if vivo:
		vivo = false
		get_node("area/pb").hide()
		get_node("area").set_layer_mask(0)
		get_node("area").set_collision_mask(0)
		remover()