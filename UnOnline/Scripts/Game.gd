extends Node

var card_manager
var room_data
var me_n

func _ready():
	room_data = GameState.romm_data
	me_n = GameState.me_n
	
	GameState.connect("snapshot_data", self, "_on_snapshot_data")
	
	card_manager = load("res://Scripts/CardManager.gd").new()
	
	if GameState.host:
		$PanelExit.show()
		
		room_data["game"] = {}
		room_data["game"]["way"] = 1
		room_data["game"]["turn"] = 0
		room_data["game"]["ncards"] = {}
		room_data["game"]["state"] = "init"
		room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.gen_deck())
		room_data["game"]["stack"] = {}
		
		GameState.set_document("rooms", GameState.room_name, room_data)
	
	show_profiles()
	
func _on_snapshot_data(data):
	room_data = data
	
	if room_data["game"]["state"] == 'normal':
		$Stack.set_top(card_manager.to_card_data(room_data["game"]["top_card"]))
		show_ncards()
		
	if room_data["game"]["state"] == 'over':
		GameState.remove_listener("rooms", GameState.room_name)
		GameState.romm_data = room_data
		get_tree().change_scene("res://Scenes/WinScreen.tscn")
		return

	if room_data["game"]["state"] == 'cancel':
		GameState.remove_listener("rooms", GameState.room_name)
		var info = load("res://Scenes/InfoScreen.tscn").instance()
		info.init("Atenção", "Host encerrou a sessão", 3, "res://Scenes/MainMenu.tscn")
		add_child(info)
		return
		
	if is_my_turn():
		if room_data["game"]["state"] == 'init':
			card_manager.update_deck(room_data["game"]["deck"])
			if $HandScroll/Hand.cards_data.size() != 0:
				room_data["game"]["state"] = 'normal'
				var first_card = card_manager.get_random_card(true)
				
				card_manager.stack.append(first_card)
				
				room_data["game"]["top_card"] = first_card.to_string()
				room_data["game"]["stack"] = card_manager.array_to_dic(card_manager.stack)
				room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.deck)
				GameState.set_document("rooms", GameState.room_name, room_data)
			else:
				card_manager.buy_cards($HandScroll/Hand.cards_data, 7)
				$HandScroll/Hand.reload()
				calc_next()
				room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.deck)
				GameState.set_document("rooms", GameState.room_name, room_data)
		elif room_data["game"]["state"] == 'normal':
			card_manager.update_deck(room_data["game"]["deck"])
			card_manager.update_stack(room_data["game"]["stack"])

			if $Stack.card_data.type == "plus4" and $Stack.card_data.used != -1:
				$LabInfo.text = "Comprou 4!"
				card_manager.buy_cards($HandScroll/Hand.cards_data, 4)
				$Stack.card_data.used = -1
				
				$HandScroll/Hand.reload()
			elif $Stack.card_data.type == "plus2" and $Stack.card_data.used != -1:
				$LabInfo.text = "Compre " + str($Stack.card_data.used + 2) + "!"
			else:
				$LabInfo.text = "Sua vez!"
			
			$TurnAudio.play()
			highlight()
	else:
		$LabInfo.text = "Aguarde sua vez!"
		highlight()
	
func go_to_next():
	calc_next()
	
	if $HandScroll/Hand.cards_data.size() == 0:
		room_data["game"]["state"] = "over"
		room_data["game"]["winner"] = GameState.user_data["name"]
		room_data["state"] = "close"
	
	room_data["game"]["ncards"][str(me_n)] = $HandScroll/Hand.cards_data.size()
	room_data["game"]["deck"] = card_manager.array_to_dic(card_manager.deck)
	room_data["game"]["stack"] = card_manager.array_to_dic(card_manager.stack)
	room_data["game"]["top_card"] = $Stack.card_data.to_string()
	
	GameState.set_document("rooms", GameState.room_name, room_data)

func calc_next():
	if $Stack.card_data != null and $Stack.card_data.type == "reverse" and $Stack.card_data.used != -1:
		room_data["game"]["way"] *= -1
		$Stack.card_data.used = -1

	var way = room_data["game"]["way"]
	var next = room_data["game"]["turn"]
	for i in range(4):
		next = next + way
		if next == 4:
			next = 0
		if next == -1:
			next = 3
		if room_data["players"].has(str(next)):
			room_data["game"]["turn"] = next
			return

func is_my_turn():
	return room_data["game"]["turn"] == me_n
	
func show_profiles():
	var player = me_n
	for i in range(4):
		if room_data["players"].has(str(i)):
			get_node("Player" + str( calc_num_player(i) )).show()
			get_node("Player" + str( calc_num_player(i) ) + "/Name").text = room_data["players"][str(i)]
			player = (player + 1) % 4
			

func highlight():
	for i in range(4):
		if i == room_data["game"]["turn"]:
			get_node("Player" + str(calc_num_player(i))).self_modulate = Color(1, 0, 0)
		else:
			get_node("Player" + str(calc_num_player(i))).self_modulate = Color(1, 1, 1)
	
func calc_num_player(p):
	return p - me_n if p - me_n >= 0 else 4 + p - me_n

func buy_card():
	if not is_my_turn():
		return
	
	if $Stack.card_data.type == "plus2" and $Stack.card_data.used != -1:
		card_manager.buy_cards($HandScroll/Hand.cards_data, $Stack.card_data.used + 2)
		$Stack.card_data.used = -1
	else:
		card_manager.buy_cards($HandScroll/Hand.cards_data)
	
	$HandScroll/Hand.reload()
	go_to_next()

func show_ncards():
	for i in range(4):
		if room_data["game"]["ncards"].has(str(i)):
			if calc_num_player(i) != 0:
				get_node("Player" + str(calc_num_player(i)) + "/Number").text = str(room_data["game"]["ncards"][str(i)])
			if int(room_data["game"]["ncards"][str(i)]) == 1:
				get_node("Player" + str(calc_num_player(i)) + "/Uno").show()
			else:
				get_node("Player" + str(calc_num_player(i)) + "/Uno").hide()

func _on_BtnExit_pressed():
	room_data["game"]["state"] = "cancel"
	room_data["state"] = "close"
	
	GameState.remove_listener("rooms", GameState.room_name)
	GameState.set_document("rooms", GameState.room_name, room_data)
	
	get_tree().change_scene("res://Scenes/MainMenu.tscn")




