extends Node2D

onready var felpudo = get_node("Felpudo")
onready var timerReplay = get_node("TimerToReplay")
onready var label = get_node("Control/Control/Label")

var pontos = 0
var estado = 1

const JOGANDO = 1
const PERDENDO = 2

func _ready():
	label.set_text(str(0))
	
func pontuar():
	pontos += 1
	label.set_text(str(pontos))
	get_node("SomScore").play()

func kill():
	felpudo.apply_impulse(Vector2(0, 0), Vector2(-1500, 0))
	get_node("BackAnim").stop()
	estado = PERDENDO
	timerReplay.start()
	pontos = 0
	get_node("SomHit").play()

func _on_TimerToReplay_timeout():
	get_tree().reload_current_scene()