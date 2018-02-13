extends TextureRect

var back_pre = preload("res://Scenes/BackCard.tscn")

func get_drag_data(position):
	var back = back_pre.instance()
	set_drag_preview(back)
	back.set_name("deck")
	return back