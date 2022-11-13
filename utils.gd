extends Node

func _ready():
	pass # Replace with function body.

func get_main_node():
	var root_node = get_tree().get_root()
	
	return root_node.get_child(root_node.get_child_count()-1)

func get_digits(number):
	var str_number = str(number)
	var digits = []
	for i in range(str_number.length()):
		digits.append(str_number[i].to_int())
	return digits
	pass
	
func create_timer(wait_time):
		var timer = Timer.new()
		timer.set_wait_time(wait_time)
		timer.set_one_shot(true)
		timer.connect("timeout", timer, "queue_free")
		add_child(timer)
		timer.start()
		return timer
		pass

