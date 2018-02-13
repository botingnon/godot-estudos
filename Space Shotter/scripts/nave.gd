extends Area2D

export var vel = 300

var TiroSimples = preload("res://scripts/classes/tiro/TiroSimples.gd")
var TiroDuplo = preload("res://scripts/classes/tiro/TiroDuplo.gd")

var arma
var armas = [
	TiroSimples.new(self),
	TiroDuplo.new(self)
]

func _ready():
	arma = TiroSimples.new(self)
	set_process(true)
	add_to_group(game.GRUPO_NAVE)

func _process(delta):
	var d = 0
	var e = 0
	
	if Input.is_action_pressed("direita"):
		d = 1
		
	if Input.is_action_pressed("esquerda"): 
		e = -1
	
	if get_pos().x > (640 - 50):
		d = 0
		
	if get_pos().x < 50:
		e = 0
	
	set_pos(get_pos() + Vector2(1, 0) * vel * delta * (d + e))
	
	if Input.is_action_pressed("tiro"):
		arma.dispara()
	
	arma.atualiza(delta)
	
func set_arma(indice):
	arma = armas[indice]
	

func _on_nave_area_enter( area ):
	if area.is_in_group(game.GRUPO_INIMIGO):
		if area.has_method("aplica_dano"):
			area.aplica_dano(200)
			retiraVida()
	elif area.is_in_group(game.GRUPO_TIRO_INIMIGO):
		if area.has_method("destroi"):
			area.destroi()
			retiraVida()
			
func retiraVida():
	game.vidas -= 1