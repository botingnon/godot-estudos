extends Area2D

var color
var special = false
var sel = false
var x
var y
var dest_x
var dest_y
var pos_x
var pos_y

signal selected(obj, sel)

func _ready():
	randomize()
	
	color = int(rand_range(0, 6))
	
	if rand_range(0, 1) > 0.99:
		special = true

	if special:
		get_node("Sprite").set_animation("shine" + get_color(color))
	else:
		get_node("Sprite").set_animation("normal" + get_color(color))
		
	set_process(true)
	
func _process(delta):
	if dest_x == null or dest_y == null or (dest_x == x and dest_y == y):
		return
		
	var del_x = pos_x - get_pos().x
	var del_y = pos_y - get_pos().y
	
	var speed = Vector2(0, 0)
	
	if abs(del_x) > 20:
		speed.x = 300 * (dest_x - x)
	else:
		set_pos(Vector2(pos_x, get_pos().y))
		x = dest_x
	if abs(del_y) > 20:
		speed.y = 300 * (dest_y - y)
	else:
		set_pos(Vector2(get_pos().x, pos_y))
		y = dest_y
		
	set_pos(get_pos() + speed * delta)

func get_color(n):
	if n == 0:
		return "Blue"
	elif n == 1:
		return "Green"
	elif n == 2:
		return "Orange"
	elif n == 3:
		return "Pink"
	elif n == 4:
		return "Purple"
	elif n == 5:
		return "Yellow"

func _on_Candie_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed:
		if sel:
			desel()
			emit_signal("selected", self, false)
		else:
			sel()
			emit_signal("selected", self, true)

func desel():
	sel = false
	get_node("Sel").hide()
	
func sel():
	sel = true
	get_node("Sel").show()
	
func set_data(x, y):
	self.x = x
	self.y = y

	set_pos(Vector2(62 + x * 75 + 75/2, 290 + y * 75 + 75/2))
	
func move_to(go_x, go_y):
	dest_x = go_x
	dest_y = go_y
	
	pos_x = get_pos().x + (dest_x - x) * 75
	pos_y = get_pos().y + (dest_y - y) * 75
	