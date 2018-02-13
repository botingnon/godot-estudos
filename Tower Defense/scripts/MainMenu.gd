extends MarginContainer

var click = false


func _on_TextureButton_pressed():
	if click:
		return
		
	get_tree().change_scene("res://scenes/main.tscn")