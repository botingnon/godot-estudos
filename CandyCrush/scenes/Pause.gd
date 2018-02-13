extends Node2D


func _on_ReturnButton_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	Transition.clear_above()

func _on_HomeButton_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	
	Transition.fade_to("res://scenes/MainScreen.tscn")
	Transition.clear_above()

func _on_ReplayButton_pressed():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
	Transition.fade_to("res://scenes/Level.tscn")
	Transition.clear_above()