var intervalo_tiro = .2
var ultimo_disparo = 0
var pre_tiro = preload("res://scenes/tiro_vermelho.tscn")
var nave

func _init(nave):
	self.nave = nave

func dispara():
	if ultimo_disparo <= 0:
		ultimo_disparo = intervalo_tiro
		
		criaTiro(nave.get_node("posCanhaoE").get_global_pos())
		criaTiro(nave.get_node("posCanhaoD").get_global_pos())
		
func criaTiro(pos):
	var tiro = pre_tiro.instance()
	tiro.set_global_pos(pos)
	nave.get_parent().add_child(tiro)

		
func atualiza(delta):
	if ultimo_disparo > 0:
		ultimo_disparo -= delta