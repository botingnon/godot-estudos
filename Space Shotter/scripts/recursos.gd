extends Node

const PATHS_DIR = "res://paths/"
const PATHS_INIMIGOS_DIR = "res://sprites/Enemies/"

var paths = []
var paths_inimigos = []

func _ready():
	randomize()
	carrega_paths()
	carrega_inimigos_paths()
	
func random_paths():
	return paths[randi() % paths.size()]
	
func random_inimigos_paths():
	return paths_inimigos[randi() % paths_inimigos.size()]

func carrega_paths():
	var dir = Directory.new()
	dir.change_dir(PATHS_DIR)
	dir.list_dir_begin()
	
	var path_file = dir.get_next()

	while path_file != "":
		if !dir.current_is_dir():
			var path = load(PATHS_DIR + path_file)
			if path and path extends Curve2D:
				paths.append(path)

		path_file = dir.get_next()
	
	#print("Caminhos carregados " + str(paths.size()))
	

func carrega_inimigos_paths():
	var dir = Directory.new()
	dir.change_dir(PATHS_INIMIGOS_DIR)
	dir.list_dir_begin()
	
	var path_file = dir.get_next()

	while path_file != "":
		if !dir.current_is_dir():
			var path = load(PATHS_INIMIGOS_DIR + path_file)
			if path and path extends Texture:
				paths_inimigos.append(path)

		path_file = dir.get_next()
	
	print("Inimigos carregados " + str(paths_inimigos.size()))