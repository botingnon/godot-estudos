extends Node

export var QtdInimigos = 10
var inimigos_criados = 0

onready var aviao = preload("res://scenes/inimigos/aviao.tscn")
onready var tanque = preload("res://scenes/inimigos/tanque.tscn")
onready var soldado = preload("res://scenes/inimigos/soldado.tscn")

var inimigos

func _ready():

	inimigos = [
		aviao,
		tanque,
		soldado
	]
	
	print("Criando " + str(QtdInimigos) + " inimigos")

func _on_timer_timeout():
	if inimigos_criados < QtdInimigos:
		var inimigo = geraRandomico()
		if (inimigo.is_in_group(game.GRUPO_INIMIGO)):
			var group = getGroup(inimigo)
			var Path2d = getPath2d(group)
			
			Path2d.add_child(inimigo)
			
			get_parent().get_node("inimigos").add_child(Path2d)
	

		get_node("timer").set_wait_time(rand_range(.7, 1.2))
		
		inimigos_criados += 1
		print("Inimigo " + str(inimigos_criados) + " criado [VEL=" + str(inimigo.getVelocidade()) + "][VID=" + str(inimigo.getVida()) + "]")

func getGroup(inimigo):
	var group = "terra"
	if (inimigo.is_in_group(game.GRUPO_CEU)):
		group = "ceu"

	return group
	
func getPath2d(group):
	var Path2d = Path2D.new()
	var path = recurso.recurso_aleatorio_dir("res://paths/inimigos/fase01/" + group + "/")
	if Path2d.has_method("set_curve") and path:
		Path2d.set_curve(path)
	
	return Path2d

func gera(val):
	return get_children()[val].duplicate()
	
func geraRandomico():
	randomize()
	return inimigos[randi() % inimigos.size()].instance()