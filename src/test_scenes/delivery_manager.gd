extends Node2D


var delivery_points
onready var timer = $Timer

var current_delivery_point


func _ready():
	yield(owner, "ready")
	delivery_points = get_children()
	delivery_points.erase(timer)
	
	# Connect the delivered signal
	for point in delivery_points:
		point.connect("delivered", self, "activate_new_delivery_point")
	
	# Activate the initial delivery point
	activate_new_delivery_point()


func activate_new_delivery_point():
	randomize()
	# Ignore current delivery point from new choice
	var eligible_delivery_points = delivery_points.duplicate()
	
	# Remove existing delivery point
	if current_delivery_point:
		current_delivery_point.set_active(false)
		current_delivery_point.set_can_deliver(false)
		eligible_delivery_points.erase(current_delivery_point)
	
	# Pick a random delivery point to activate
	var rand_index = floor(rand_range(0, eligible_delivery_points.size()))
	var new_delivery_point = eligible_delivery_points[rand_index]
	new_delivery_point.set_active(true)
	current_delivery_point = new_delivery_point


#func _on_Timer_timeout():
#	activate_new_delivery_point()
