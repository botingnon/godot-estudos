extends Node2D

var FaseClass = load("res://scripts/fases/FaseClass.gd")

var ondas = [
	{game.SOLDADO: 10, game.TANQUE: 2, game.AVIAO: 10},
	{game.SOLDADO: 15, game.TANQUE: 7, game.AVIAO: 3},
	{game.SOLDADO: 20, game.TANQUE: 7, game.AVIAO: 4},
	{game.SOLDADO: 20, game.TANQUE: 10, game.AVIAO: 4},
	{game.SOLDADO: 20, game.TANQUE: 10, game.AVIAO: 6}
]

func _ready():
	var config = {
		"inimigo_intervalo": 1,
		"inimigo_por_onda": ondas
	}
	
	var Fase = FaseClass.new()
	Fase.setup(config, self)
	Fase.proximaOnda()
	