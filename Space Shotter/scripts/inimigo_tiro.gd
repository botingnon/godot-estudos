extends Area2D

const GIRO = 720
const VEL = 200
const DIR = Vector2(0, 1)

func _ready():
	set_process(true)
	add_to_group(game.GRUPO_TIRO_INIMIGO)
	
func _process(delta):
	rotate(deg2rad(GIRO) * delta)
	translate(DIR * VEL * delta)
	
	if get_pos().y > 520:
		destroi()
	
func destroi():
	queue_free()