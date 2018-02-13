extends HBoxContainer

var pre_card = preload("res://Scenes/Card.tscn")
var cards_data = []
var game

func _ready():
	game = get_parent().get_parent()

func reload():
	for c in get_children():
		c.queue_free()
		
	for c in cards_data:
		var card = pre_card.instance()
		card.set_data(c)
		add_child(card)

func play_card(card):
	cards_data.remove(cards_data.find(card.card_data))
	remove_child(card)
	
	if card.card_data.type == "block" and card.card_data.used != -1:
		card.card_data.used = -1
		game.calc_next()
	
	game.card_manager.stack.append(card.card_data)
	game.go_to_next()
	
func can_drop_data(position, data):
	return data.get_name() == "deck"
	
func drop_data(position, data):
	game.buy_card()
	
func buy_card():
	game.buy_card()