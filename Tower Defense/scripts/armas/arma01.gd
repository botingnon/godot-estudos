extends Area2D

const ROTATION_SPEED = 20

var forca = 40
var intervalo_tiro = .5
var ultimo_disparo = 0
var dirTiro = 1

onready var pre_tiro = preload("res://scenes/missel02.tscn")


func _ready():
	randomize()
	set_process(true)
	get_node("sprite2").rotate(rand_range(0, 360))

func _process(delta):
	if ultimo_disparo > 0:
		ultimo_disparo -= delta
	elif ultimo_disparo <= 1:
		get_node("sprite2").get_node("sprite3").show()
		get_node("sprite2").get_node("sprite4").show()
		
	var areas = get_overlapping_bodies()
	if areas.size() > 0:
		var inimigo = areas[0].get_parent()
		if inimigo.is_in_group(game.GRUPO_CEU):
			var mpos = inimigo.get_global_pos()
			var ang = get_node("sprite2").get_angle_to(mpos)
			var s = sign(ang)
			ang = abs(ang)
			get_node("sprite2").rotate(min(ang, ROTATION_SPEED * delta) * s)
			
			dispara(inimigo)

func dispara(inimigo):
	if ultimo_disparo <= 0 and inimigo.Vida > 0:
		ultimo_disparo = intervalo_tiro
		
		if dirTiro == 1:
			get_node("sprite2").get_node("sprite3").hide()
			get_node("sprite2").get_node("sprite4").show()
			dirTiro = -1
		else:
			get_node("sprite2").get_node("sprite4").hide()
			get_node("sprite2").get_node("sprite3").show()
			dirTiro = 1
		
		var tiro = pre_tiro.instance()
		get_tree().get_root().add_child(tiro)
		tiro.set_global_pos(get_global_pos())

		tiro.ser_target(inimigo, forca)