extends Area2D

const ROTATION_SPEED = 5
var forca = 5
var intervalo_tiro = .2
var ultimo_disparo = 0
var dirTiro = 1


func _ready():
	set_process(true)
	
	randomize()
	get_node("sprite2").rotate(rand_range(0, 360))

func _process(delta):
	if ultimo_disparo > 0:
		ultimo_disparo -= delta
		
	var areas = get_overlapping_bodies()
	if areas.size() > 0:
		var inimigo = areas[0].get_parent()
		if inimigo.is_in_group(game.GRUPO_TERRA_PESADO):
			var mpos = inimigo.get_global_pos()
			var ang = get_node("sprite2").get_angle_to(mpos)
			var s = sign(ang)
			ang = abs(ang)
			get_node("sprite2").rotate(min(ang, ROTATION_SPEED * delta) * s)
			
			dispara(inimigo)

func dispara(inimigo):
	if ultimo_disparo <= 0 and inimigo.Vida > 0:
		ultimo_disparo = intervalo_tiro
		
		inimigo.aplica_dano(forca)
