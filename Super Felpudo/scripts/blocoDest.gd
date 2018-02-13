extends StaticBody2D


func destruir():
	get_node("sprite").queue_free()
	get_node("shape").queue_free()
	get_node("Particles2D").set_emitting(true)
