extends Control

func _ready():
	pass


func _on_btnout_pressed():
	GameState.sign_out()
	get_tree().change_scene("res://Scenes/Login.tscn")


func _on_btnHost_pressed():
	GameState.show_interstitial_ad()
	get_tree().change_scene("res://Scenes/HostGame.tscn")


func _on_btnJoin_pressed():
	GameState.show_interstitial_ad()
	get_tree().change_scene("res://Scenes/JoinGame.tscn")

func _on_btnVideo_pressed():
	GameState.show_video_ad()
