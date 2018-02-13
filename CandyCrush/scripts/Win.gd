extends Node2D

export(String,FILE) var starOn

var stars

func _ready():
	stars = Global.stars

	var level = Global.curlevel
	Global.save_level(level, stars)
	
	if Global.savedata["level" + str(level + 1)] == -1:
		Global.save_level(level + 1, 0)
		
	if stars >= 2:
		get_node("Star2").set_texture(load(starOn))
	
	if stars >= 3:
		get_node("Star3").set_texture(load(starOn))

func _on_Home_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	
	Transition.fade_to("res://scenes/MainScreen.tscn")
	Transition.clear_above()


func _on_Replay_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	Transition.fade_to("res://scenes/Level.tscn")
	Transition.clear_above()


func _on_Next_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	
	Global.curlevel += 1
	if Global.curlevel > 6:
		Transition.fade_to("res://scenes/MainScreen.tscn")
	else:
		Transition.fade_to("res://scenes/Level.tscn")
	Transition.clear_above()
