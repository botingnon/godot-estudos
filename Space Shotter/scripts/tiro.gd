extends Area2D

var vel = 500

func _ready():
	set_process(true)
	get_node("sample").play("tiro")


func _process(delta):
	set_pos(get_pos() + Vector2(0, -1) * vel * delta)
	
	if get_pos().y < -30:
		queue_free()

func _on_tiro_area_enter( area ):
	if area.is_in_group(game.GRUPO_INIMIGO):
		queue_free()
		if area.has_method("aplica_dano"):
			area.aplica_dano(1)
		else:
			area.queue_free()