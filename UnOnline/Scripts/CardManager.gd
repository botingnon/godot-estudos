extends Node

var pre_card = preload("res://Scripts/CardData.gd")

var deck = []
var stack = []

func buy_cards(hand, number = 1):
	for i in range(number):
		hand.append(get_random_card())
	
func get_random_card(first = false):
	if deck.size() == 0:
		shuffle()
		
	randomize()
	
	var r = int(rand_range(0, deck.size()))
	var card = deck[r]
	
	if first:
		if card.type == "jokey" or card.type == "plus4":
			card.color = int(rand_range(1, 5))
	
	deck.remove(r)
	
	return card


func gen_deck():
	for n in range(10):
		for c in range(1, 5):
			for i in range(2):
				var card = pre_card.new(str(n), c)
				deck.append(card)
				if n == 0:
					break
					
	for n in ["block", "reverse", "plus2"]:
		for c in range(1, 5):
			for i in range(2):
				var card = pre_card.new(n, c)
				deck.append(card)
				
	for n in ["plus4", "jokey"]:
		for i in range(4):
			var card = pre_card.new(n, -1)
			deck.append(card)
			
	return deck

func array_to_dic(arr):
	var dic = {}
	var j = 0
	for c in arr:
		dic[j] = c.to_string()
		j += 1
	return dic
	
func update_deck(dic):
	deck.clear()
	for k in dic:
		deck.append(to_card_data(dic[k]))
		
	if deck.size() == 0:
		shuffle()

func to_card_data(s):
	var args = s.split("|")
	return pre_card.new(args[0], int(args[1]), int(args[2]))

func update_stack(dic):
	stack.clear()
	for k in dic:
		 stack.append(to_card_data(dic[k]))
	

func shuffle():
	while stack.size() != 0:
		var i = int(rand_range(0, stack.size()))
		var card = stack[i]
		stack.remove(card)
		card.used = 0
		
		if card.type == "plus4" or card.type == "jokey":
			card.color = -1
			
		deck.append(card)
