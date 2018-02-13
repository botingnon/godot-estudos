extends Control

func _ready():
	GameState.connect("user_connected", self, "_on_user_connected")
	GameState.connect("sign_in", self, "_on_sign_in")
	GameState.connect("create_account", self, "_on_create_account")

func _on_user_connected(user):
	$Panel/LabInfo.text = "Conectado"
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func _on_sign_in(success):
	if not success:
		$Panel/LabInfo.text = "Falha ao entrar"
		set_all(true)
	
func _on_create_account(success):
	if not success:
		$Panel/LabInfo.text = "Falha ao criar"
		set_all(true)

func _on_BtnSignIn_pressed():
	var username = $Panel/Username.text
	var password = $Panel/Password.text
	
	if username.empty() or password.empty():
		$Panel/LabInfo.text = "Preencha os campos"
		return
	
	set_all(false)
	
	$Panel/LabInfo.text = "Conectando..."
	
	GameState.login(username + "@unonline.com", password)


func _on_BtnSignUp_pressed():
	var username = $Panel/Username.text
	var password = $Panel/Password.text
	
	if username.empty() or password.empty():
		$Panel/LabInfo.text = "Preencha os campos"
		return
	
	set_all(false)
	
	$Panel/LabInfo.text = "Criando..."
	
	GameState.create_account(username + "@unonline.com", password)

func set_all(state):
	$Panel/Username.editable = state
	$Panel/Password.editable = state
	$Panel/BtnSignUp.disabled = !state
	$Panel/BtnSignIn.disabled = !state

