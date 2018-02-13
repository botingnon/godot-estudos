extends Area2D

var vel = 250
var rot = 0
export var vida = 3
export var pontos = 10

func _ready():
	randomize()
	add_to_group(game.GRUPO_INIMIGO)
	set_process(true)
	rot = rand_range(-1, 1)

func _process(delta):
	set_pos(get_pos() + Vector2(0, 1) * vel * delta)
	rotate(rot * delta)

	if get_pos().y > 520:
		queue_free()
		
func aplica_dano(val):
	vida -= val
	get_node("anim").play("hit")
	if vida <= 0:
		get_node("sample").play("meteoro")
		vel = 350
		remove_from_group(game.GRUPO_INIMIGO)
		get_node("anim").play("die")
		set_z(2)
		set_process(false)
		game.getCamera().shake()
		game.score += pontos