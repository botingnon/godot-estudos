extends Control

var pre_card = preload("res://Scenes/Card.tscn")
var card_data

func set_data(data):
	card_data = data
	
	$Texture.texture = load("res://Assets/Cards/" + card_data.to_text() + ".png")


func get_drag_data(position):
	var card = pre_card.instance()
	card.set_data(card_data)
	card.get_node("Texture").set_position(Vector2(-111/2, -169/2))
	set_drag_preview(card)
	return self
	
func can_drop_data(position, data):
	return data.get_name() == "deck"
	
func drop_data(position, data):
	get_parent().buy_card()