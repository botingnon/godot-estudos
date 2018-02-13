extends "res://scripts/inimigos/inimigos.gd"

var textura1 = preload("res://assets/tiles/towerDefense_tile269.png")
var canhao1 = preload("res://assets/tiles/towerDefense_tile292.png")

var textura2 = preload("res://assets/tiles/towerDefense_tile268.png")
var canhao2 = preload("res://assets/tiles/towerDefense_tile291.png")

var texturas = [
	[textura1, canhao1],
	[textura2, canhao2]
]

var vivo = true
var max_vida

func on_init():
	add_to_group(game.GRUPO_TERRA_PESADO)
	Velocidade = 60
	Vida = 250
	max_vida = Vida

func on_process(delta):
	get_node("body/pb").set_value(Vida * 100 / max_vida)
	
func on_ready():
	randomize()

	var idx = randi() % texturas.size()
	
	get_node("corpo").set_texture(texturas[idx][0])
	get_node("canhao").set_texture(texturas[idx][1])


func getInitAnimationList():
	return ["run", "run2"]
	
func on_die():
	if vivo:
		vivo = false
		get_node("body/pb").hide()
		get_node("body").set_layer_mask(0)
		get_node("body").set_collision_mask(0)
		get_node("anim").play("die")
		