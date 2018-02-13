extends Node

const GRUPO_INIMIGO = "inimigos"
const GRUPO_NAVE = "naves"
const GRUPO_TIRO_INIMIGO = "tiro_inimigo"

var score = 0 setget setScore
var vidas = 3 setget setVidas

signal score_change
signal vida_change

func _ready():
	randomize()

func getCamera():
	return get_tree().get_root().get_node("main").get_node("camera")
	
func setScore(val):
	if val > 0:
		score = val
		emit_signal("score_change")
		
func setVidas(val):
	vidas = val
	emit_signal("vida_change")