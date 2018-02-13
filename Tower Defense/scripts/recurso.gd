extends Node

func _ready():
	pass
	
	
func recurso_aleatorio_dir(dir):
	var list = carrega_dir(dir)
	if list.size() == 0:
		return null
	
	randomize()
	return list[randi() % list.size()]

func carrega_dir(diretorio):
	var dir = Directory.new()
	var list = []
	if !dir.dir_exists(diretorio):
		return list
	
	dir.change_dir(diretorio)
	
	dir.list_dir_begin()
	
	var path_file = dir.get_next()
	while path_file != "":
		if !dir.current_is_dir():
			var path = load(diretorio + path_file)
			if path:
				list.append(path)

		path_file = dir.get_next()
	
	return list
