extends Node

onready var perc = get_node("personagem")
onready var dead_camera = get_node("dead_camera")

var moedas = 0
var time = 30
var vidas = 3

func change_camera():
	dead_camera.set_global_pos(perc.get_node("Camera2D").get_camera_pos())
	dead_camera.make_current()

func _on_personagem_morreu():
	change_camera()
	get_node("spawTimer").set_wait_time(2)
	get_node("spawTimer").start()
	get_node("TimerGame").stop()
	
	vidas -= 1
	
	if vidas == 2:
		get_node("canvasLayer/Panel/heart1").set_texture(load("res://assets/hud_heartEmpty.png"))
	if vidas == 1:
		get_node("canvasLayer/Panel/heart2").set_texture(load("res://assets/hud_heartEmpty.png"))
	if vidas <= 0:
		get_node("canvasLayer/Panel/heart3").set_texture(load("res://assets/hud_heartEmpty.png"))

func _on_spawTimer_timeout():
	if vidas > 0:
		reviver()
	else:
		Transicao.fade_to("res://scenes/mainMenu.tscn")

func reviver():
	perc.set_pos(get_node("spaw_point").get_pos())
	perc.reviver()
	moedas = 0
	time = 30

	get_node("canvasLayer/Panel/moedas").set_text(str(moedas))
	get_node("canvasLayer/Panel/time").set_text(str(time))
	get_node("TimerGame").start()

func _on_personagem_fim():
	change_camera()
	get_node("spawTimer").set_wait_time(3)
	get_node("spawTimer").start()
	get_node("TimerGame").stop()
	

func _on_personagem_moeda():
	moedas += 1
	get_node("canvasLayer/Panel/moedas").set_text(str(moedas))


func _on_TimerGame_timeout():
	time -= 1
	get_node("canvasLayer/Panel/time").set_text(str(time))
	if time <= 0:
		perc.morrer()
