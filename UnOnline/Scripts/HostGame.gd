extends Control

enum {CREATE, WAIT, START}

var state = CREATE
var user_data
var romm_data

func _ready():
	GameState.host = true
	GameState.me_n = 0
	GameState.room_name = GameState.user_data["name"]
		
	user_data = GameState.user_data
	
	GameState.connect("document_added", self, "_on_document_added")
	GameState.connect("snapshot_data", self, "_on_snapshot_data")
	
	$Panel/LbInfo.text = "Criando sala..."
	
	GameState.set_document("rooms", GameState.room_name, {"players": {"0": user_data["name"]}, "state": "open"})

func _on_document_added(success):
	if state == CREATE:
		if success:
			state = WAIT
			$Panel/LbInfo.text = "Seus amigos devem dar join em \"" + user_data["name"] + "\"!"
			GameState.set_listener("rooms", GameState.room_name)
		else:
			get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_snapshot_data(data):
	romm_data = data
	if state == WAIT:
		var nplayers = romm_data["players"].size()
		for i in range(4):
			if romm_data["players"].has(str(i)):
				get_node("Panel/LabPlayer" + str(i)).text = romm_data["players"][str(i)]
			else:
				get_node("Panel/LabPlayer" + str(i)).text = "-"

		$Panel/LabNumPlayers.text = "Players (" + str(nplayers) + "/4)"	
		$Panel/BtnStart.disabled = (nplayers <= 1)
	elif state == START:
		GameState.romm_data = romm_data
		get_tree().change_scene("res://Scenes/Game.tscn")

func _on_BtnStart_pressed():
	state = START
	romm_data.state = "start"
	GameState.set_document("rooms", GameState.room_name, romm_data)


func _on_BtnCancelar_pressed():
	romm_data.state = "cancel"
	GameState.remove_listener("rooms", GameState.room_name)
	GameState.set_document("rooms", GameState.room_name, romm_data)	
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

