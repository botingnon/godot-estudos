extends TextureRect

var card_data
var card_color

func set_top(card_data):
	self.card_data = card_data
	
	texture = load("res://Assets/Cards/" + card_data.to_text() + ".png")
	
func can_drop_data(position, data):	
	if not get_parent().is_my_turn():
		return false
	
	if data.get_name() == "deck":
		return false
		
	data = data.card_data
	
	if card_data.type == "plus2" and card_data.used != -1:
		if data.type == "plus2":
			data.used = card_data.used + 2
			return true
		else:
			return false
	
	if data.type == "plus4" or data.type == "jokey":
		return true
	
	return data.color == card_data.color or data.type == card_data.type

func drop_data(position, card):
	set_top(card.card_data)
	if card.card_data.type == "plus4" or card.card_data.type == "jokey":
		$Red.show()
		$Blue.show()
		$Green.show()
		$Yellow.show()
		card_color = card
	else:
		get_node("../HandScroll/Hand").play_card(card)

func _on_Red_gui_input( ev ):
	color_selected(1)

func _on_Blue_gui_input( ev ):
	color_selected(4)

func _on_Green_gui_input( ev ):
	color_selected(3)

func _on_Yellow_gui_input( ev ):
	color_selected(2)

func color_selected(color):
	card_color.card_data.color = color
	set_top(card_color.card_data)
	$Red.hide()
	$Blue.hide()
	$Green.hide()
	$Yellow.hide()
	get_node("../HandScroll/Hand").play_card(card_color)


