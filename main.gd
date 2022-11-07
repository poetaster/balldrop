extends Node

onready var label = $Label
onready var label2 = $Label2

var current_line = null
var p1 = Vector2()
var p2 = p1

# this is a hack for mobile
onready var dim = $cam.get_viewport_rect().size

var last_mouse_pos = Vector2()

func _ready():
	
	yield(get_tree().create_timer(5), "timeout")
	
	spawn_emitter("bell", Vector2(0.3, 0.2))
	spawn_emitter("kick", Vector2(0.3, 0.6))
	spawn_emitter("snare", Vector2(0.7, 0.2))
	spawn_emitter("laser", Vector2(0.7, 0.6))
	
	
func spawn_emitter(name, pos):
	var emitter = preload("res://emitter.tscn").instance()
	emitter.sound = name
	emitter.position = pos * OS.window_size
	add_child(emitter)


func _process(delta):
	
	last_mouse_pos = $cam.get_global_mouse_position()
	
	# target = get_canvas_transform().affine_inverse().xform(event.position)
	# p2 = last_mouse_pos
	
	#p2 = last_mouse_pos
	
	#if current_line != null:
	#	current_line.set_ends(p1, p2)
		
		
func _input(event):
	
	if (event.is_action_released("ui_cancel")):
		get_tree().quit()
		
	if (event is InputEventMultiScreenDrag or
		event is InputEventMultiScreenSwipe or
		event is InputEventSingleScreenSwipe):
			label.text = event.as_text().replace('|','\n')
	if event is InputEventMultiScreenDrag:
		label2.text = "Multiple finger drag"
	elif event is InputEventMultiScreenSwipe:
		label2.text = "Multiple finger swipe"
	elif event is InputEventSingleScreenSwipe:
		label2.text = "Single finger swipe"
	elif event is InputEventSingleScreenTouch:
		label2.text = "Single finger touch"

	# the initial point for our line
	if event is InputEventSingleScreenTap:
		if not event.pressed: 
			#var center = get_main_node().get_node("ball_container")
			# this is the same as event.position, sadly.
			#p1 = $cam.get_canvas_transform().affine_inverse().xform(event.position)
			p1 = event.position
			if p1[0] < 1:
				# old mobile solution, see var above
				var p3 = event.position * dim
				# new solution
				# p1 = $cam.to_global(event.position)
				p1 = p3
				
	# the end point of our line created here
	if event is InputEventSingleScreenLongPress:
		if not event.pressed:
			#var center = get_main_node().get_node("ball_container")
			#p2 = $cam.get_canvas_transform().affine_inverse().xform(event.position)
			p2 = event.position
			if p2[0] < 1:
				var p3 = event.position * dim
				# p2 = $cam.to_global(event.position)
				p2 = p3
				
			current_line = preload("res://line.tscn").instance()
			current_line.set_ends(p1, p2)
			add_child(current_line)
			
	# bit of a hack, but allows us to clear all lines at once 
	if event is InputEventSingleScreenSwipe:
		if not event.pressed:
			label2.text = "Single finger swipe"
			for _i in self.get_children ():
				if _i.get_class() == 'StaticBody2D':
					_i._remove()
					
	if event is InputEventMultiScreenDrag:
			label2.text = "Multi finger swipe"
			for _i in self.get_children ():
				if _i.get_class() == 'StaticBody2D':
					_i._remove()
				
#	if event is InputEventMouseButton:
#		if event.pressed and event.button_index == BUTTON_LEFT:
#			p1 = last_mouse_pos
#			p2 = p1
#			current_line = preload("res://line.tscn").instance()
#			current_line.set_ends(p1, p2)
#			add_child(current_line)
#		else:
#			current_line = null

func get_main_node():
		var root_node = get_tree().get_root()
		return root_node.get_child(root_node.get_child_count()-1)
