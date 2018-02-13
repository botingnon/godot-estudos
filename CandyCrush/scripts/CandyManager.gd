extends Node

var level = 1
var matrix = []
var candy_sel1 = null
var candy_sel2 = null
var can_play = true

onready var moves_board = get_parent().get_node("MovesBoard")
onready var bar = get_parent().get_node("Bar")
onready var pre_candy = preload("res://scenes/Candie.tscn")
onready var pre_box = preload("res://scenes/Box.tscn")

signal played
signal add_points(pts)

func _ready():
	level = Global.curlevel
	clear_matrix()
	read_level()
	rand_matrix()
	find_pattern()

func read_level():
	var file = File.new()
	file.open("res://LevelData/level" + str(level) + ".txt", File.READ)
	var text = file.get_as_text()
	var lines = text.split("\n")
	file.close()
	
	for x in range(9):
		for y in range(12):
			if lines[y][x] == "1":
				matrix[x][y] = gen_box(x, y)
				
	moves_board.set_moves(int(lines[12]))
	bar.set_max(int(lines[13]))

func clear_matrix():
	for x in range(9):
		matrix.append([])
		matrix[x] = []
		
		for y in range(12):
			matrix[x].append([])
			matrix[x][y] = null
			
func rand_matrix():
	for x in range(9):
		for y in range(12):
			if matrix[x][y] == null:
				matrix[x][y] = gen_candy(x, y)

func gen_candy(x, y):
	var new_candy = pre_candy.instance()
	new_candy.set_data(x, y)
	new_candy.connect("selected", self, "candy_sel")
	new_candy.add_to_group("candy")
	add_child(new_candy)
	
	return new_candy
	
func gen_box(x, y):
	var new_box = pre_box.instance()
	new_box.set_data(x, y)
	new_box.add_to_group("box")
	add_child(new_box)
	
	return new_box

func is_candy(obj):
	if obj != null and obj.is_in_group("candy"):
		return true
		
	return false

func candy_sel(candy, selected):
	if not can_play:
		candy.desel()
		return
	
	if selected:
		if candy_sel1 == null:
			candy_sel1 = candy
		else:
			candy_sel2 = candy
			
			if test_proximo():
				can_play = false
				jogar()
			else:
				candy_sel1.desel()
				candy_sel2.desel()
				candy_sel1 = null
				candy_sel2 = null
	
func test_proximo():
	if (candy_sel1.x == candy_sel2.x and abs(candy_sel1.y - candy_sel2.y) == 1) or (candy_sel1.y == candy_sel2.y and abs(candy_sel1.x - candy_sel2.x) == 1):
		return true
		
	return false
	
func jogar():
	emit_signal("played")
	
	candy_sel1.move_to(candy_sel2.x, candy_sel2.y)
	candy_sel2.move_to(candy_sel1.x, candy_sel1.y)
	
	matrix[candy_sel1.x][candy_sel1.y] = candy_sel2
	matrix[candy_sel2.x][candy_sel2.y] = candy_sel1
	
	get_node("Timer").start()

func _on_Timer_timeout():
	if find_pattern():
		pass
	else:
		candy_sel1.move_to(candy_sel2.x, candy_sel2.y)
		candy_sel2.move_to(candy_sel1.x, candy_sel1.y)
		
		matrix[candy_sel1.x][candy_sel1.y] = candy_sel2
		matrix[candy_sel2.x][candy_sel2.y] = candy_sel1
		can_play = true
	
	candy_sel1.desel()
	candy_sel2.desel()
	candy_sel1 = null
	candy_sel2 = null

func find_pattern():
	var to_remove = []
	var valid = false
	
	for y in range(12):
		for x in range(1, 8): 
			var c0 = matrix[x - 1][y].color if is_candy(matrix[x - 1][y]) else null
			var c1 = matrix[x][y].color if is_candy(matrix[x][y]) else null
			var c2 = matrix[x + 1][y].color if is_candy(matrix[x + 1][y]) else null
			
			if c0 == c1 and c1 == c2 and c0 != null:
				add_to_remove(to_remove, matrix[x - 1][y])
				add_to_remove(to_remove, matrix[x][y])
				add_to_remove(to_remove, matrix[x + 1][y])
				valid = true
				
	for x in range(9):
		for y in range(1, 11):
			var c0 = matrix[x][y - 1].color if is_candy(matrix[x][y - 1]) else null
			var c1 = matrix[x][y].color if is_candy(matrix[x][y]) else null
			var c2 = matrix[x][y + 1].color if is_candy(matrix[x][y + 1]) else null
			 
			if c0 == c1 and c1 == c2 and c0 != null:
				add_to_remove(to_remove, matrix[x][y - 1])
				add_to_remove(to_remove, matrix[x][y])
				add_to_remove(to_remove, matrix[x][y + 1])
				valid = true
	
	for t in to_remove:
		if t.special:
			emit_signal("add_points", 5)
		else:
			emit_signal("add_points", 1)

		remove_child(t)
		matrix[t.x][t.y] = null
	
	move_down()
	get_node("Inter").start()
	
	return valid


func move_down():
	for y in range(11, -1, -1):
		var x = 0
		while x <= 8:
			if y == 0:
				if matrix[x][y] == null:
					matrix[x][y] = gen_candy(x, y)
			
			if is_candy(matrix[x][y]):
				var move = false
				var to_y
				for i in range(y + 1, 12):
					if matrix[x][i] == null:
						to_y = i
						move = true
					elif matrix[x][i].is_in_group("box"):
						continue
					else:
						break

				if move:
					matrix[x][y].move_to(x, to_y)
					matrix[x][to_y] = matrix[x][y]
					matrix[x][y] = null
			if y == 0 and matrix[x][y] == null:
				pass
			else:
				x += 1
	
func add_to_remove(list, candy):
	if not list.has(candy):
		list.append(candy)

func _on_Inter_timeout():
	if not find_pattern():
		get_node("Inter").stop()
		can_play = true
		if moves_board.moves == 0:
			if bar.win():
				Transition.put_above("res://scenes/Win.tscn")
			else:
				Transition.put_above("res://scenes/Lose.tscn")
		if bar.rmax():
			Transition.put_above("res://scenes/Win.tscn")
			