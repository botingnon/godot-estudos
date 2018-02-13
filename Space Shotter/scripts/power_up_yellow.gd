extends Area2D

var arma = 1

func _on_power_up_yellow_area_enter( area ):
	if area.is_in_group(game.GRUPO_NAVE):
		queue_free()
		if area.has_method("set_arma"):
			area.set_arma(arma)
