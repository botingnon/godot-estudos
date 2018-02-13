extends PathFollow2D

var Velocidade = 150 setget setVelocidade , getVelocidade
var Vida = 150 setget setVida , getVida

signal die

func _init():
	add_to_group(game.GRUPO_INIMIGO)
	on_init()

func _ready():
	set_process(true)
	
	on_ready()
		
	randomize()
	var anim = getInitAnimationList()
	get_node("anim").play(anim[randi() % anim.size()])

func getInitAnimationList():
	return get_node("anim").get_animation_list()
	
func _process(delta):
	on_process(delta)
	set_offset(get_offset() + Velocidade * delta)
	if get_unit_offset()  >= 1:
		remover()
	
func on_ready():
	pass

func on_init():
	pass
	
func on_process(delta):
	pass

func on_die():
	pass
	
func setVida(val):
	Vida = val
	
func getVida():
	return Vida
	
func setVelocidade(val):
	Velocidade = val
	
func getVelocidade():
	return Velocidade
	
func aplica_dano(valor):
	Vida -= valor
	if Vida <= 0:
		emit_signal("die")
		on_die()
		
func remover():
	get_parent().queue_free()