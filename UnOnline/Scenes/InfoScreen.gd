extends Control

var scene

func init(title, message, time, scene):
	$Panel/Title.text = title
	$Panel/Message.text = message
	
	self.scene = scene
	
	$Timer.wait_time = time
	$Timer.start()

func _on_Timer_timeout():
	if scene != null:
		get_tree().change_scene(scene)
	else:
		queue_free()