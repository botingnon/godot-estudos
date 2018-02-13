extends Node

var firebase

signal user_connected(user)
signal user_disconnected()
signal sign_in(success)
signal create_account(succes)
signal document_added(success)
signal snapshot_data(data)

var user_data
var host
var me_n
var room_name
var romm_data

var ad_loaded = false
var ad_video_loaded = false

func _ready():
	if OS.get_name() == "Android":
		firebase = Engine.get_singleton("FireBase")
		firebase.initWithFile("res://godot-firebase-config.json", get_instance_id())
		
		#firebase.show_banner_ad(true)

func show_interstitial_ad():
	return false
	if ad_loaded:
		firebase.show_interstitial_ad()
		ad_loaded = false
		
func show_video_ad():
	return false
	if ad_video_loaded:
		firebase.show_rewarded_video()
		ad_video_loaded = false

func create_account(email, password):
	firebase.email_create_account(email, password)
	
func login(email, password):
	firebase.email_sign_in(email, password)
	
func sign_out():
	firebase.email_sign_out()
	
func _receive_message(tag, from, key, data):
	if tag == "FireBase":
		if from == "E&P":
			if key == "SignIn":
				emit_signal("sign_in", data)
			elif key == "CreateAccount":
				emit_signal("sign_in", data)
		elif from == "Auth":
			if key == "EmailLogin":
				if data:
					user_data = parse_json(firebase.get_email_user())
					user_data["name"] = user_data["email"].split("@")[0]
					emit_signal("user_connected", user_data)
				else:
					user_data = null
					emit_signal("user_disconnected")
		elif from == "Firestore":
			if key == "DocumentAdded":
				emit_signal("document_added", data)
			elif key == "SnapshotData":
				emit_signal("snapshot_data", parse_json(data))
		elif from == "AdMob":
			if key == "AdMod_Banner":
				if data == "load_failed":
					print("Banner nao carregado")
			if key == "AdMob_Interstitial":
				if data == "loaded":
					print("Banner ad carregado")
					ad_loaded = true
			if key == "AdMob_Video":
				var status = data["status"]
				if status == "loaded":
					print("Banner av carregado")
					ad_video_loaded = true
			elif key == "AdMobReward":
				print("VIDEO ASSISTIDO ->>>> ", data)

func is_connected():
	return user_data != null
	
func set_listener(collecion, document):
	firebase.set_listener(collecion, document)

func remove_listener(collecion, document):
	firebase.remove_listener(collecion, document)	

func set_document(collection, document, data):
	firebase.set_document(collection, document, data)
	











