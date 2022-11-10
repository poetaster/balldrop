extends Node2D

export(String, "bell", "kick", "snare", "laser") var sound

onready var label = $Label
onready var label2 = $Label2

var angle = 0
var scl = 0

func _ready():
	var world = get_parent()
	world.connect("scalechange", self, "_on_scalechanged")
	
func _on_scalechanged():
	scl = scl + 1
	if scl > 2:
		scl = 0
	pass
	
func _on_timer_timeout():
	
	var ball = preload("res://ball.tscn").instance()
	ball.position = position
	ball.sound = sound
	ball.vel = Vector2(4, 0).rotated(deg2rad(angle+45))
	ball.notes = gen_notes()

	
	var ball_container = get_tree().get_nodes_in_group("ball_container")[0]
	ball_container.add_child(ball)
	
	angle += 90
	angle %= 360


func gen_notes():
	
	var notes = []
	var base_pitch = 0.06 #rand_range(0.05, 0.2)
	# print(base_pitch)
		
	var sc = gen_scale(scl)
	
	#notes.push_back(2 * base_pitch)
	notes.push_back(pow(2, sc[0]/12.0) * base_pitch)
	notes.push_back(pow(2, sc[1]/12.0) * base_pitch)
	notes.push_back(pow(2, sc[2]/12.0) * base_pitch)
	notes.push_back(pow(2, sc[3]/12.0) * base_pitch)
	#notes.push_back(pow(2, 1 + note5/12.0) * base_pitch)
	# print(notes[0])
	for i in 100:
		var n1 = notes[-1]
		var n2 = notes[-2]
		var n3 = notes[-3]
		var n4 = notes[-4]
		#var n5 = notes[-5]
		#var n6 = notes[-6]
		notes.push_back(n1 * 2)
		notes.push_back(n2 * 2)
		notes.push_back(n3 * 2)
		notes.push_back(n4 * 2)
		#notes.push_back(n5 * 2)
		#notes.push_back(n6 * 2)
		
	randomize()
	#print(notes)
	return notes

func gen_scale(scl):
	#seed(hash(angle+1))
	seed(3) # seed = 2 is nice
	randomize()
	randi()
	var n1 = 1 + scl #randi() % 12
	var n2 = 3 + scl #randi() % 12
	var n3 = 5 + scl #randi() % 12
	var n4 = int(rand_range(7+scl,10))

	var scale = [n1,n2,n3,n4]
	print(scale)
	return scale




