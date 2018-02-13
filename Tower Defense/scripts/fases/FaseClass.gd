extends Node

var onda = 0
var config = {}
var inimigos = {}
var mapa_inimigos = []
var fase
var timer
var objInimigos = []

func setup(_config, _fase):
	fase = _fase
	config = _config
	
	inimigos = {
		game.SOLDADO: load("res://scenes/inimigos/soldado.tscn"),
		game.TANQUE: load("res://scenes/inimigos/tanque.tscn"),
		game.AVIAO: load("res://scenes/inimigos/aviao.tscn")
	}

func proximaOnda():
	onda += 1
	if onda >= config.inimigo_por_onda.size():
		return
	
	prepararOnda()
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout") 
	timer.set_wait_time(config.inimigo_intervalo)
	timer.start()
	
	fase.add_child(timer)

	
func _on_timer_timeout():
	if mapa_inimigos.size() == 0:
		timer.stop()
		timer = null
		return;
	
	var idx = mapa_inimigos[0]
	var inimigo = inimigos[idx].instance()

	mapa_inimigos.pop_front()
	
	if (inimigo.is_in_group(game.GRUPO_INIMIGO)):
		var vida = inimigo.getVida();
		inimigo.setVida(vida + (vida * (onda - 1) / 2))
		
		var group = getGroup(inimigo)
		var Path2d = getPath2d(group)
		
		Path2d.add_child(inimigo)
		
		fase.get_node("inimigos").add_child(Path2d)


func prepararOnda():
	var onda_mapa = config.inimigo_por_onda[onda - 1]
	var mapa = []
	for key in onda_mapa:
		var qtd = onda_mapa[key]
		for i in range(0, qtd):
			mapa.append(key)
		
	mapa_inimigos = shuffleList(mapa)
		
func shuffleList(list):
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        randomize()
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList

func getGroup(inimigo):
	var group = "terra"
	if (inimigo.is_in_group(game.GRUPO_CEU)):
		group = "ceu"

	return group
	
func getPath2d(group):
	var Path2d = Path2D.new()
	var path = recurso.recurso_aleatorio_dir("res://paths/inimigos/fase01/" + group + "/")
	if Path2d.has_method("set_curve") and path:
		Path2d.set_curve(path)
	
	return Path2d