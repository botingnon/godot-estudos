extends Node2D

onready var fruits = get_node("Fruits")

var pineapple = preload("res://scenes/pineapple.tscn")
var banana = preload("res://scenes/banana.tscn")
var pear = preload("res://scenes/pear.tscn")
var orange = preload("res://scenes/orange.tscn")
var watermelon = preload("res://scenes/watermelon.tscn")
var bomb = preload("res://scenes/Bomb.tscn")

var score = 0
var lifes = 3

func _ready():
	randomize()

func _on_Generator_timeout():
	if lifes <= 0:
		return
		
	for i in range(0, rand_range(1, 4)):
		var type = int(rand_range(0, 6))

		var obj
		if type == 0:
			obj = pineapple.instance()
		elif type == 1:
			obj = banana.instance()
		elif type == 2:
			obj = pear.instance()
		elif type == 3:
			obj = orange.instance()
		elif type == 4:
			obj = watermelon.instance()
		elif type == 5:
			obj = bomb.instance()
		
		obj.born(Vector2(rand_range(200, 1080), 800))
		obj.connect("life", self, "dec_life")
		
		if type != 5:
			obj.connect("score", self, "inc_score")
		
		fruits.add_child(obj)
		
func dec_life():
	lifes -= 1
	if lifes == 0:
		get_node("Control/bomb1").set_modulate(Color(1, 0, 0))
		get_node("InputProc").acabou = true
		get_node("GameOverScreen").start()
		
	if lifes == 2:
		get_node("Control/bomb3").set_modulate(Color(1, 0, 0))
	
	if lifes == 1:
		get_node("Control/bomb2").set_modulate(Color(1, 0, 0))
		
	
func inc_score():
	if lifes == 0:
		return
		
	score += 1
	get_node("Control/Label").set_text(str(score))