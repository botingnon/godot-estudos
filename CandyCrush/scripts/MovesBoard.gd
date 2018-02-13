extends Sprite

var moves = 50

func _ready():
	update_num()

func set_moves(m):
	moves = m
	update_num()
	
func update_num():
	get_node("Number1").set_texture(load("res://Shary the fairy/files/png/gui/Group_" + str(moves / 10) + ".png"))
	get_node("Number2").set_texture(load("res://Shary the fairy/files/png/gui/Group_" + str(moves % 10) + ".png"))

func _on_Candies_played():
	moves -= 1
	update_num()