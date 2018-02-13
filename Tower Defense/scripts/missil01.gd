extends KinematicBody2D

var target
const speed = 200
var motion = Vector2()
var dano = 30
var pausa_queue = .1
var die = 0
	
func ser_target(alvo, _dano):
	target = alvo
	dano = _dano
	target.connect("die", self, "on_target_die")
	set_process(true)
	
func on_target_die():
	target = false
	queue_free()

func _process(delta):
	if die:
		if pausa_queue > 0:
			pausa_queue -= delta
			return
		elif pausa_queue <= 0:
			queue_free()

	if !target:
		return
		
	var wr = weakref(target);
	if  !wr.get_ref() or die:
		queue_free()
		return
	
	var targetPosition = target.get_global_pos()
	var target_direction = (targetPosition - get_global_pos()).normalized()
	move(target_direction * speed * delta)
	rotate(get_angle_to(targetPosition) * delta * 20)
	
	if is_colliding():
		target.aplica_dano(dano)
		get_node("Explosion").show()
		die = 1
	