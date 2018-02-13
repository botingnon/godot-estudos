extends Area2D

var arma = 0

func _on_power_up_red_area_enter( area ):
	if area.is_in_group(game.GRUPO_NAVE):
		queue_free()
		if area.has_method("set_arma"):
			area.set_arma(arma)
