extends Area2D

const ROTATION_SPEED = 20

var forca = 5
var intervalo_tiro = .1
var ultimo_disparo = 0
var dirTiro = 1

func _ready():
	randomize()
	set_process(true)
	get_node("sprite2").rotate(rand_range(0, 360))

func _process(delta):
	if ultimo_disparo > 0:
		ultimo_disparo -= delta
		
	var inimigo = getInimigo(game.GRUPO_TERRA_LEVE)
	if inimigo:
		var mpos = inimigo.get_global_pos()
		var ang = get_node("sprite2").get_angle_to(mpos)
		var s = sign(ang)
		ang = abs(ang)
		get_node("sprite2").rotate(min(ang, ROTATION_SPEED * delta) * s)

		dispara(inimigo)
	else:
		get_node("sprite2/municao/D").hide()
		get_node("sprite2/municao/E").hide()

func getInimigo(valid_group):
	var areas = get_overlapping_bodies()
	if not areas.size() > 0:
		return false
	
	for e in areas:
		var inimigo = e.get_parent()
		if inimigo.is_in_group(valid_group):
			return inimigo
			
	return false

func dispara(inimigo):
	if ultimo_disparo <= 0 and inimigo.Vida > 0:
		ultimo_disparo = intervalo_tiro
		get_node("sample").play("shoot3")
		if dirTiro == 1:
			get_node("sprite2/municao/D").show()
			get_node("sprite2/municao/E").hide()
			dirTiro = -1
		else:
			get_node("sprite2/municao/E").show()
			get_node("sprite2/municao/D").hide()
			dirTiro = 1
		
		inimigo.aplica_dano(forca)
